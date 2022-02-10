//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

/* STIAMO LAVORANDO AI TEXTFIELD - OCCORRE AGGANCIARE IL BINDING */


struct NewDishSheetView: View {
    
    @ObservedObject var dishVM: DishVM
    var backGroundColorView: Color
    
    @State var newDish: DishModel = DishModel() // ogni volta che parte la view viene creato un piatto vuoto, lo modifichiamo e lo aggiungiamo alla dishlist.
    @Binding var openNewDish: Bool
    
// State per stoppare il delete degli ingredienti
    
    @State var activeDeletion: Bool = false
    
    var body: some View {
        
        ZStack {
            
          //  backGroundColorView.edgesIgnoringSafeArea(.top)
            backGroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack { // VStack Madre
                
                HStack { // una Sorta di NavigationBar
                    
                    Text("New Dish")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    if !activeDeletion {
                        
                        Button {
                            self.openNewDish.toggle()
                        } label: {
                            Text("Dismiss")//.padding()
                        }
                    } else {
                        
                        Button {
                            self.activeDeletion = false
                        } label: {
                            Text("ANNULLA")
                                .fontWeight(.heavy)
                                ._tightPadding()
                                .foregroundColor(Color.white)
                                .background(RoundedRectangle(cornerRadius: 5.0).fill(Color.red))
                        }

                        
                    }
                    
                                        
                }
                .padding()
                .background(Color.cyan) // questo background riguarda la parte alta della View occupata dall'HStack
                Spacer()
                
                ScrollView { // La View Mobile
                    
                 //   VStack(alignment: .trailing) { // il vstack Madre della ViewMobile

                        VStack(alignment:.leading) { // info Dish
                         //   Text(dishVM.newDish.images) // ICONA STANDARD PIATTO
                            
                            InfoGeneraliNewDish_Sub(newDish: $newDish, activeDeletion: $activeDeletion)
                                .padding()
                                
                         //   Spacer()

                  
                            ScrollSelectionMenuView(newDish: $newDish)
                                .disabled(self.activeDeletion)

                            
                        }
                  
                      //  Spacer()
                
                   // }
                }.onTapGesture {
                    print("TAP ON Entire SCROLL VIEW") // funziona su tutto tranne che sui menu orizzontali che abbiamo disabilitato ad hoc.
                    self.activeDeletion = false
                }
                
                Spacer()
                
                VStack {
                    CSButton_2(title: "Create Dish", accentColor: .white, backgroundColor: .cyan, cornerRadius: 5.0) {
                        
                        print("CREARE PIATTO SU FIREBASE")
                      // dishVM.saveDish(dish: self.newDish)
                        self.newDish = DishModel()
                        
                    }
                }.background(Color.cyan) // questo back permette di amalgamare il bottone con il suo Vstack, altrimenti il bottone si vede come una striscia
                
            } // End VSTACK MADRE

            
        } // end ZStack
    
    }
    
}

struct NewDishView_Previews: PreviewProvider {
    static var previews: some View {
        
       /* NewDishSheetView(dishVM: DishVM(), backGroundColorView: Color.cyan, openNewDish: .constant(true)) */
        DishInfoDeleteRow(data: "Guanciale", baseColor: Color.gray)
    }
}


struct ScrollSelectionMenuView: View {
    
    @Binding var newDish: DishModel
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CustomLabelView(placeHolder: "Tipologia", imageName: "list.dash", backgroundColor: Color.brown)
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(DishType.allCases) { type in
                        
                        Text(type.rawValue)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                           // ._tightPadding()
                            .background (
                                
                            RoundedRectangle(cornerRadius: 5.0)
                                    .strokeBorder(self.newDish.type == type ? Color.clear : Color.blue)
                                    .background(RoundedRectangle(cornerRadius: 5.0)
                                                    .fill(self.newDish.type == type ? Color.green.opacity(0.8) : Color.clear))
                                    .shadow(radius: 3.0)
                                
                            )
                            .onTapGesture {
                                selectType(type: type)
                            }
                    }
                }
            }
            
            CustomLabelView(placeHolder: "Base", imageName: "lanyardcard", backgroundColor: Color.brown)
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(DishBase.allCases) { base in
                        
                        Text(base.rawValue)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                           // ._tightPadding()
                            .background (
                                
                                RoundedRectangle(cornerRadius: 5.0)
                                    .strokeBorder(self.newDish.aBaseDi == base ? Color.clear : Color.blue)
                                    .background(RoundedRectangle(cornerRadius: 5.0)
                                                    .fill(self.newDish.aBaseDi == base ? Color.brown.opacity(0.8) : Color.clear))
                                    .shadow(radius: 3.0)
                                
                            )
                            .onTapGesture {
                                selectBase(base: base)
                            }
                    }
                }
            }
            
            CustomLabelView(placeHolder: "Cottura", imageName: "flame", backgroundColor: Color.brown)
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(DishCookingMethod.allCases) { method in
                        
                        Text(method.rawValue)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                           // ._tightPadding()
                            .background (
                                
                                RoundedRectangle(cornerRadius: 5.0)
                                    .strokeBorder(self.newDish.metodoCottura == method ? Color.clear : Color.blue)
                                    .background(RoundedRectangle(cornerRadius: 5.0)
                                                    .fill(self.newDish.metodoCottura == method ? Color.blue.opacity(0.8) : Color.clear))
                                    .shadow(radius: 3.0)
                                
                            )
                            .onTapGesture {
                                selectCookingMethod(method: method)
                            }
                    }
                }
            }
            
            
            CustomLabelView(placeHolder: "Avaible for", imageName: "person.fill.checkmark", backgroundColor: Color.brown)
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(DishCategory.allCases) { category in
                        
                        Text(category.rawValue)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            //._tightPadding()
                            .background (
                                
                                RoundedRectangle(cornerRadius: 5.0)
                                    .strokeBorder(self.newDish.category.contains(category) ? Color.clear : Color.blue)
                                    .background(RoundedRectangle(cornerRadius: 5.0)
                                                    .fill(self.newDish.category.contains(category) ? Color.yellow.opacity(0.8) : Color.clear))
                                    .shadow(radius: 3.0)
                                
                            )
                            .onTapGesture {
                                selectCategory(category: category)
                            }
                    }
                }
            }
            
            CustomLabelView(placeHolder: "Presenza Allergeni", imageName: "exclamationmark.triangle", backgroundColor: Color.brown)
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(Allergeni.allCases) {allergene in
                        
                        Text(allergene.simpleDescription())
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            //._tightPadding()
                            .background (
                                
                                RoundedRectangle(cornerRadius: 5.0)
                                    .strokeBorder(self.newDish.allergeni.contains(allergene) ? Color.clear : Color.blue)
                                    .background(RoundedRectangle(cornerRadius: 5.0)
                                                    .fill(self.newDish.allergeni.contains(allergene) ? Color.red.opacity(0.8) : Color.clear))
                                    .shadow(radius: 3.0)
                                
                            )
                            .onTapGesture {
                                self.selectAllergene(allergene: allergene)
                            }
                    }
                }
            }
        }.padding(.horizontal)
    }
    
    func selectAllergene(allergene: Allergeni) {
        
        withAnimation(.default) {
            
            if !self.newDish.allergeni.contains(allergene) {
                
                self.newDish.allergeni.append(allergene)
                
            } else {
                
              let indexAllergene = self.newDish.allergeni.firstIndex(of: allergene)
                
                self.newDish.allergeni.remove(at: indexAllergene!)
                
            }
            
            print("Lista Allergeni: \(self.newDish.allergeni.description)")
        }
    }
    
    func selectBase(base: DishBase) {
        
        withAnimation(.default) {
            self.newDish.aBaseDi = base
        }
    }
    
    func selectType(type: DishType) {
        
        withAnimation(.default) {
            self.newDish.type = type
        }
    }
    
    func selectCookingMethod(method: DishCookingMethod) {
        
        withAnimation(.default) {
            self.newDish.metodoCottura = method
        }
    }
    
    
    func selectCategory (category: DishCategory) {
        
        withAnimation(.default) {
          
            if !self.newDish.category.contains(category) {
                
                self.newDish.category.append(category)
                
            } else {
                
                let index = self.newDish.category.firstIndex(of: category)
                self.newDish.category.remove(at: index!)
                
            }
            
            print("Lista GoodFor: \(self.newDish.category.description)")
       
        }
        
    }
}

struct CSTextField_3: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            Image(systemName: self.textFieldItem != "" ? "rectangle.and.pencil.and.ellipsis" : "square.and.pencil")
                .imageScale(.large)
                .foregroundColor(self.textFieldItem != "" ? Color.green : Color.black)
                .padding(.leading)
            
            TextField (self.placeHolder, text: $textFieldItem)
                .padding()
                .accentColor(Color.white)
                
            Button(action: self.action) {
                    
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(Color.white)
                        .padding(.trailing)
                }.disabled(self.textFieldItem == "")
        
        }.background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .strokeBorder(Color.blue)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.gray.opacity(self.textFieldItem != "" ? 0.6 : 0.2))
                    
                )
                .shadow(radius: 3.0)
        )
            .onSubmit(self.action)
            .animation(Animation.easeInOut, value: self.textFieldItem)
    }
}



struct CustomLabelView: View {
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    var body: some View {
        
        Label {
            Text(placeHolder)
                .fontWeight(.medium)
                .font(.system(.subheadline, design: .monospaced))
        } icon: {
            Image(systemName: imageName)
        }
        ._tightPadding()
        .background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.black.opacity(0.2))
        )
  
    }
}

struct ShowNewDishPropertyValue:View {
    
    @Binding var activeDelection: Bool
    @Binding var showArrayData: [String]
    let baseColor: Color
    let action: (_ data: String) -> Void
    
    var body: some View {
        
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack {
                
                ForEach(showArrayData,id:\.self) { data in
                    
                    if !activeDelection {
                        
                        DishInfoRow(data:data,baseColor:baseColor)
                            .onLongPressGesture {
                                
                                withAnimation(.easeInOut) {
                                  //  action(data)
                                    self.activeDelection = true
                                    
                                }
                        }
                        
                    } else {
                        
                        DishInfoDeleteRow(data: data, baseColor: Color.gray)
                            .onTapGesture {
                                print("TAP TO DELETE")
                                withAnimation(.easeInOut) {
                                    self.action(data)
                                    self.activeDelection = false
                                }
                            }
                    }
                }
            }
        }
    }
}

struct DishInfoRow: View {
    
    let data: String
    let baseColor: Color
    
    var body: some View {
        
        Text(data)
            .bold()
            .lineLimit(1)
            .foregroundColor(.white)
            ._tightPadding()
            .background (
                
                RoundedRectangle(cornerRadius: 5.0)
                    .strokeBorder(Color.blue)
                    .background(RoundedRectangle(cornerRadius: 5.0)
                                    .fill(baseColor.opacity(0.8)))
                    .shadow(radius: 3.0)
            )
    }
}

struct DishInfoDeleteRow: View {
    
    let data: String
    let baseColor: Color
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var scaleDimension: CGFloat = 0.1
    @State var rotationAngle: Double = 0.0
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            Text(data)
                .bold()
                .lineLimit(1)
                .foregroundColor(Color.white)
                ._tightPadding()
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .strokeBorder(Color.blue)
                        .background(RoundedRectangle(cornerRadius: 5.0)
                                        .fill(baseColor.opacity(0.8)))
                        .shadow(radius: 3.0)
                
                )
            
            Image(systemName: "x.circle.fill")
                .frame(width:10, height: 10)
                .background(Color.white)
                .foregroundColor(Color.red)

        }
        .rotationEffect(.degrees(rotationAngle))
        .onReceive(timer) { _ in
            
            withAnimation(.easeInOut) {
  
                rotationAngle = rotationAngle == 2.5 ? -2.5 : (rotationAngle + 1.25)
          
            }
        }
    }
}


struct InfoGeneraliNewDish_Sub: View {
    
    @Binding var newDish: DishModel
    
    @State var nomePiatto: String = ""
    @State var nuovoIngredientePrincipale: String = ""
    @State var nuovoIngredienteSecondario: String = ""
    
    @Binding var activeDeletion: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CustomLabelView(placeHolder: "Info Generali", imageName: "info.circle", backgroundColor: Color.brown)
            
            
            CSTextField_3(textFieldItem: self.$nomePiatto, placeHolder: "Nome del Piatto") {
                
                self.newDish.name = self.nomePiatto
                self.nomePiatto = ""
            }
            
            if self.newDish.name != "" {DishInfoRow(data: self.newDish.name, baseColor: Color.green)}
            
            CSTextField_3(textFieldItem: self.$nuovoIngredientePrincipale, placeHolder: "Ingredienti Principali") {
                
                self.validateItem(array: &self.newDish.ingredientiPrincipali, item: &self.nuovoIngredientePrincipale)
   
            }
            
            if !self.newDish.ingredientiPrincipali.isEmpty {
                ShowNewDishPropertyValue(activeDelection: $activeDeletion, showArrayData: self.$newDish.ingredientiPrincipali, baseColor: Color.orange) { data in
                    
                    self.removeItem(array: &self.newDish.ingredientiPrincipali, item: data)
                    
                }
            }
            
            CSTextField_3(textFieldItem: self.$nuovoIngredienteSecondario, placeHolder: "Ingredienti Secondari (Optional)") {
                
                self.validateItem(array: &self.newDish.ingredientiSecondari, item: &self.nuovoIngredienteSecondario)
            }
            
            if !self.newDish.ingredientiSecondari.isEmpty {
                ShowNewDishPropertyValue(activeDelection: $activeDeletion, showArrayData: self.$newDish.ingredientiSecondari, baseColor: Color.mint) { data in
                    
                    self.removeItem(array: &self.newDish.ingredientiSecondari, item: data)
                }
            }
            
            
            //  CSTextField_3(newDishProperty: self.$newDish.name, placeHolder: "Quantità (Optional)", submitLabel: .done, showButton: false) */
            // Per la Quantità serve uno spazio più piccolo
            
        }
    }
    
    // function Space
    
    func removeItem(array: inout [String], item: String) {
        
        let positionIndex = array.firstIndex(of: item)
        
        array.remove(at: positionIndex!)
        
    }
    
    func validateItem(array: inout [String], item: inout String) {
        
        guard !array.contains(item) else {
            
            item = ""
            return
            
        }
        
        array.append(item)
        item = ""
        
    }
    
}
