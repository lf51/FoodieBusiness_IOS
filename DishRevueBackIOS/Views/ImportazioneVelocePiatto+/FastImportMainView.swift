//
//  ImportazioneVeloceDishIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/05/22.
//

import SwiftUI

struct FastImportMainView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
   // @State private var fastDish: DishModel = DishModel()
    @State private var allFastDish: [DishModel] = []
    
    let backgroundColorView: Color
    @State private var text: String = ""
    
    @State private var isUpdateDisable: Bool = true
    @State private var showSubString: Bool = false
    
    @State private var ingredientiEstratti: Int = 0
    @State private var ingredientiAlreadyEsistenti: Int = 0
   /* var isCreationDisabled:Bool {
        
       // self.fastDish.categoria == .defaultValue
        
    } */
    
    var body: some View {
        
        CSZStackVB(title: "Importazione Rapida", backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider(isVisible: true)
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {

                        CSDivider(isVisible: true) // senza il testo del texeditor va su e si disallinea
                      
                        TextEditor(text: $text)
                            .font(.system(.body,design:.rounded))
                            .foregroundColor(Color.black)
                            .autocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                            .csTextEditorBackground {
                                Color.white.opacity(0.2)
                            }
                            .cornerRadius(5.0)
                            .frame(height: 150)
                            .onChange(of: text) { _ in
                             self.isUpdateDisable = false
                            }
                
                        HStack {
                            
                            CSButton_tight(title: "Estrai", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.mint) {
                                estrapolaStringhe()
                                csHideKeyboard()
                                self.isUpdateDisable = true
                                withAnimation {
                                    showSubString = true
                                }
                            }
                            .opacity(self.isUpdateDisable ? 0.6 : 1.0)
                            .disabled(self.isUpdateDisable)
 
                            Spacer()
                            
                            
                            
                            Text("N° Piatti: \(allFastDish.count)")
                            
                            Text("N° Ingredienti: \(ingredientiEstratti) (\(ingredientiAlreadyEsistenti))")
                            
                            
                         /*   CSButton_tight(title: "Salva", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                              //  fastImport()
                            } */
                          //  .opacity(self.isCreationDisabled ? 0.6 : 1.0)
                          //  .disabled(self.isCreationDisabled)
                            
                        } // Barra dei Bottoni
                        
                        if showSubString {
                            
                            ScrollView(.horizontal,showsIndicators: false) {
                                
                                HStack {
                                    
                                    ForEach($allFastDish) { $fastDish in
                                        
                                        CSZStackVB_Framed(frameWidth: 380, rateWH: 1.5) {
                                            
                                            VStack {
                                                CorpoImportazioneVeloce(fastDish: $fastDish) { newDish in
                                                    withAnimation(.spring()) {
                                                        fastSave(item: newDish)
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            
                                            
                                        }
                            
                                           
                                        
                                            
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                            }
    
                        } // Chiusa ifshoSubstring
                       
                        
                Spacer()
                       // Text("\(manipolaStringa())")
                    }.padding(.horizontal)
                    
                }
                
              //  Spacer()
                
                
                
            }
            
           
            
            
        }
        
   
        
        
    }
    
    // Method
    
    private func fastSave(item: DishModel) { // SOLO PER TEST -> Deprecata -> Da Spostare nel ViewModel
        
        viewModel.allMyDish.append(item)
        
        var newIngredient:[IngredientModel] = []
        
        for ingredient in item.ingredientiPrincipali {
            
            if !viewModel.checkExistingIngredient(item: ingredient).0 {
                
                newIngredient.append(ingredient)
            }
            
        }
        viewModel.allMyIngredients.append(contentsOf: newIngredient)
        // Deprecata in futuro, il check di unicità andrà fatto nel viewModel.
        
        let localIndex = self.allFastDish.firstIndex(of: item)
        self.allFastDish.remove(at: localIndex!)
        
        self.reBuildIngredientContainer()
    }
    
    private func reBuildIngredientContainer() {
        
        var newDishContainer:[DishModel] = []
        var newDish:DishModel = DishModel()
        
        for dish in self.allFastDish {
            
            newDish = dish
            newDish.ingredientiPrincipali = []
            
            for ingredient in dish.ingredientiPrincipali {
                
                if let oldIngredient = viewModel.checkExistingIngredient(item: ingredient).1 { newDish.ingredientiPrincipali.append(oldIngredient) } else {newDish.ingredientiPrincipali.append(ingredient) }
       
            }
            
            newDishContainer.append(newDish)
            
        }
        
        self.allFastDish = newDishContainer
   
    }
    
    private func estrapolaStringhe() {
         
     self.allFastDish = []
     self.ingredientiEstratti = 0
        
     let containerDish = self.text.split(separator: ".")
        
        for dish in containerDish {
            
            let step_1 = dish.replacingOccurrences(of: "  ", with: " ")
            let step_2 = step_1.replacingOccurrences(of: ", ", with: ",")
            let step_3 = step_2.replacingOccurrences(of: " ,", with: ",")
            let step_3b = step_3.replacingOccurrences(of: "*", with: "")
            
            var step_4 = step_3b.split(separator: ",")
            
            let dishTitle = String(step_4[0]).lowercased()
            step_4.remove(at: 0)
            var step_5:[IngredientModel] = []
            
            for subString in step_4 {
             
                let string = String(subString).lowercased()
                let ingredient = IngredientModel(nome: string.capitalized)
                
                if let oldIngredient = viewModel.checkExistingIngredient(item: ingredient).1 {
                    
                    step_5.append(oldIngredient)
                    self.ingredientiAlreadyEsistenti += 1 // info Inutile - Deprecated in futuro
                    
                } else {step_5.append(ingredient)}
         
             }
            
            let fastDish:DishModel = {
                
                var dish = DishModel()
                dish.intestazione = dishTitle.capitalized
                dish.ingredientiPrincipali = step_5
                return dish
                
            }()

            self.allFastDish.append(fastDish)
            self.ingredientiEstratti += step_5.count
            print("Dentro Estrapola/Fine Ciclo piatto: \(dishTitle)")
        }
     
    }
    
    
    
}

struct FastImportMainView_Previews: PreviewProvider {
    static var previews: some View {
    
        NavigationView {
            FastImportMainView(backgroundColorView: Color.cyan)
                
        }
         //   Color.cyan
    
    }
}



struct CorpoImportazioneVeloce:View {
    
    //@EnvironmentObject var viewModel: AccounterVM
    
    @Binding var fastDish: DishModel
    let saveAction: (_ :DishModel) -> Void
    
    @State private var wannaAddAllergeni: Bool = false
    
    var isSavingAvaible: Bool {
        true
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {

               /* CSLabel_1Button(placeHolder: "Nome Piatto", imageNameOrEmojy: "fork.knife.circle", backgroundColor: Color.black) */
            
            CSLabel_conVB(placeHolder: "Nome Piatto", imageNameOrEmojy: "fork.knife.circle", backgroundColor: Color.black) {
                
                CSButton_image(activationBool: isSavingAvaible, frontImage: "doc.fill.badge.plus", backImage: "doc.badge.plus", imageScale: .large, backColor: Color.blue, frontColor: Color.gray) {
                    saveAction(fastDish)
                }.disabled(!isSavingAvaible)
                
            }
  
                VStack(alignment:.leading) {
                           
                    HStack {
                        
                        CSText_tightRectangle(testo: fastDish.intestazione, fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.yellow)
                        
                        Spacer()
                        
                        CS_Picker(selection: $fastDish.categoria, dataContainer: DishCategoria.allCases)
         
                        }

                    HStack {
                        
                        csVbSwitchImageText(string: fastDish.categoria.imageAssociated())
                            .font(.subheadline)
                        
                        Text(fastDish.categoria.simpleDescriptionSingolare())
                            .font(.system(.subheadline, design: .monospaced))
                            
                        
                            }
                           
                       }

            CSLabel_conVB(placeHolder: "Ingredienti:",imageNameOrEmojy: "leaf", backgroundColor: Color.black) {
               
                Toggle(isOn: $wannaAddAllergeni) {
                    Text("Allergeni")
                }
               
            }
            
            ScrollView {
                
                ForEach($fastDish.ingredientiPrincipali) { $ingredient in
                         
                        RapidEntryRow(ingredient: $ingredient, wannaAddAllergeni: wannaAddAllergeni)
                        Divider()
                         
                        }
                
                }
                
            
         
        }
    

    }
    
    // Method
    
 
    
    
}

struct RapidEntryRow: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var ingredient: IngredientModel
    let wannaAddAllergeni: Bool
    @State private var openAllergeni: Bool? = false
    
    var body: some View {
        
        ZStack {
                
                VStack(alignment:.leading) {
                    
                    HStack {
                        
                       vbIngredientRow()
             
                        Spacer()
                        
                        Text("Open")
                            .onTapGesture {
                                self.openAllergeni?.toggle()
                            }.disabled(!wannaAddAllergeni)
                        
                    }
                    
                    HStack(alignment:.bottom) {
                        
                        Image(systemName: "allergens")
                            .imageScale(.small)
                        
                       vbAllergeneRow()
                        
                    }
                    
                }
                .padding(.top) // o .Vertical

            
            if self.openAllergeni! {
                
                SelettoreMyModel<_,Allergeni>(
                    itemModel: $ingredient,
                    allModelList: [
                        .viewModelContainer("Elenco Allergeni", \.allergeni,.fonte),
                        .itemModelContainer("Allergeni \(ingredient.intestazione)", \IngredientModel.allergeni, .destinazione(Color.red, grado: .principale))
                    
                    ],
                    closeButton: $openAllergeni)
                
            }
            
            
            
        }
            
    }
    
    // Method

    @ViewBuilder private func vbAllergeneRow() -> some View {
        
        if ingredient.allergeni.isEmpty {
             Text("No Allergeni")
                .bold()
                .font(.caption2)
        } else {
            
            ForEach(ingredient.allergeni) { allergene in
                
                Text(allergene.simpleDescription())
                    .font(.caption2)
                
            }
            
        }
        
    }
    
    
    @ViewBuilder private func vbIngredientRow() -> some View {
        
        let isIngredientOld = viewModel.checkExistingIngredient(item: ingredient).0
       
        if isIngredientOld {

            Text(ingredient.intestazione)
                .fontWeight(.light)
                .foregroundColor(Color.black)
                .opacity(0.5)
           /* CSText_tightRectangle(testo: ingredient.intestazione, fontWeight: .light, textColor: Color.black, strokeColor: Color.clear, fillColor: Color.clear)
                    .opacity(0.5) */
              
        } else {
            
            Text(ingredient.intestazione)
                .fontWeight(.light)
                .foregroundColor(Color.black)
                .overlay(alignment:.topTrailing) {
                    Text("New")
                        .font(.caption2)
                        .foregroundColor(Color.white)
                        .offset(x: 10, y: -10)
                      
                        
                }
            
              /*  CSText_tightRectangle(testo: ingredient.intestazione, fontWeight: .light, textColor: Color.black, strokeColor: Color.clear, fillColor: Color.clear)
                    .overlay(alignment:.topTrailing) {
                        Text("New")
                            .font(.caption2)
                            .foregroundColor(Color.white)
                            
                    }*/
       
        }
    }
    
    
}
