//
//  EditingPropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI

struct EditingPropertyModel: View {
    
    @EnvironmentObject var viewModel: AccounterVM
   // @Binding var itemModel: PropertyModel
   // @Binding var itemModel: PropertyModel
    @State private var itemModel: PropertyModel
    let backgroundColorView: Color
    
    @State private var openMenuList: Bool? = false
    @State private var wannaAddDescription: Bool? = false
    @State private var itemModelChanged: Bool = false
  
    init(itemModel: PropertyModel, backgroundColorView: Color) {
        _itemModel = State(wrappedValue: itemModel)
        self.backgroundColorView = backgroundColorView
        
    }

    var body: some View {
        
        CSZStackVB(title: itemModel.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                CSDivider()
                    
                ScrollView(showsIndicators:false) {

                    VStack(alignment:.leading) {
                        
                        CSLabel_1Button(
                            placeHolder: "Descrizione Pubblica",
                            imageNameOrEmojy: "scribble",
                            backgroundColor: Color.black,
                            toggleBottone: $wannaAddDescription)
                                                
                        if wannaAddDescription ?? false {
                            
                        //    CSTextEditor_ModelDescription(itemModel: $itemModel)
                            CSTextField_ExpandingBox(itemModel: $itemModel, maxDescriptionLenght: 300)
                            
                            
                        } else {
                            
                            Text(itemModel.descrizione == "" ? "Nessuna descrizione inserita. Press [+] " : itemModel.descrizione)
                                .italic()
                                .fontWeight(.light)
                            
                        }
                        
                    }.disabled(openMenuList!)
                    
                 /*   VStack(alignment:.leading) {
                        
                        CSLabel_2Button(
                          placeHolder: "Menu In",
                          imageName: "scroll",
                          backgroundColor: Color.black,
                          toggleBottoneTEXT: $openMenuList,
                          testoBottoneTEXT: "Edit")
                        .disabled(wannaAddDescription!)

                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack {
                                    
                                    ForEach($itemModel.menuIn) { $myMenu in
                                     
                                        GenericItemModel_RowViewMask(
                                            model: $myMenu,
                                            backgroundColorView: backgroundColorView) {
                                                Button("New Remove") {
                                                    
                                                    let index = itemModel.menuIn.firstIndex(of: myMenu)
                                                    itemModel.menuIn.remove(at: index!)
                                                    
                                                    
                                                }
                                            }

                                   
                                        
                                    }
                                }
                            }
                    } */
                    
                    VStack(alignment:.leading) {
                        
                        CSLabel_1Button(
                              placeHolder: "Servizio",
                              imageNameOrEmojy: "info.circle",
                              backgroundColor: Color.black )
                          
                         estrapolaGiorniChiusura()
              
                    }
                                       
                } // Chiusa Scroll View
                
             CSDivider()
                
            } // Chiusa VStack Madre
            .padding(.horizontal)
            
           if openMenuList! {
                
                SelettoreMyModel<_,MenuModel>(
                    itemModel: $itemModel,
                    allModelList: ModelList.propertyMenuList,
                    closeButton: $openMenuList)
                
            }
            
        } // Chiusa ZStack Madre
        .onChange(of: itemModel, perform: { _ in
            self.itemModelChanged = true
        })
        .onDisappear {
            
            if itemModelChanged {
                
                viewModel.alertItem = AlertModel(
                    title: "✋ Modifiche Non Salvate",
                    message: "",
                    actionPlus: ActionModel(title: .salva, action: {
                        self.saveEdit()
                    })
                )
                
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    
                  saveEdit()
                    
                } label: {
                    Text("Salva")
                        .bold(itemModelChanged)
                }.disabled(!itemModelChanged)

                
                
            }
        }
        
        
    }
    
    // Method
    
    private func saveEdit() {

        viewModel.updateItemModel(messaggio: "Salva Modifiche della proprietà \(itemModel.intestazione)", itemModel: itemModel)
   
    }
 
    private func estrapolaGiorniChiusura() -> some View {
        
        var giorniServizio:[GiorniDelServizio] = []
        
        for menu in itemModel.menuIn {
            
            giorniServizio.append(contentsOf: menu.giorniDelServizio)
           
        }
        
        let setGiorni = Set(giorniServizio)
        let setAllDay = Set(GiorniDelServizio.allCases)
        
        let dayOff = setAllDay.subtracting(setGiorni)
    
        if dayOff.isEmpty {
            
            return  HStack {
                Text("Sempre Aperto")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                
                Text("Se si intende impostare un giorno di chiusura occorre modificare i giorni di servizio dei menu.")
                    .italic()
                    .fontWeight(.light)
                    .font(.system(.caption, design: .default))
                    .foregroundColor(Color.black)
            }
            
        } else {
            
            let dayOffOrdered = dayOff.sorted{$0.orderValue() < $1.orderValue() }
            
            var corpoTesto:[String] = []
            
            for day in dayOffOrdered {
                
                let dayString = day.simpleDescription()
               // corpoTesto += "\(dayString) • "
                corpoTesto.append(dayString)
                
            }
            
            let incipit = dayOff.count < 2 ? "Giorno" : "Giorni"
          
            return HStack(alignment:.top) {
                
                Text("\(incipit) di chiusura:")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                
               Text("\(corpoTesto, format: .list(type: .and))")
                   .fontWeight(.heavy)
                   .font(.system(.body, design: .default))
                   .foregroundColor(Color.red.opacity(0.9))
                
            }
        }
    }
    
    
}
/*
struct EditingPropertyModel_Previews: PreviewProvider {
    
    @State static var testProperty: PropertyModel = PropertyModel(
        intestazione: "Osteria del Vicolo",
        cityName: "Sciacca",
        coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        webSite: "https://osteriadelcorso.com",
        phoneNumber: "3337213895",
        streetAdress: "via roma",
        numeroCivico: "21")
    
    static var previews: some View {

       NavigationView {
            EditingPropertyModel(itemModel: $testProperty, backgroundColorView: Color("SeaTurtlePalette_1"))
        }
      //  .navigationBarTitleDisplayMode(.large)
       // .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
*/
