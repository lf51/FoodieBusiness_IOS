//
//  EditingPropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI

struct EditingPropertyModel: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var itemModel: PropertyModel
    let backgroundColorView: Color
    
   // @State private var openMenuList: Bool? = false
  //  @State private var wannaAddDescription: Bool? = false
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

                    BoxDescriptionModel_Generic(itemModel: $itemModel, labelString: "Descrizione Attività")
  
                   VStack(alignment:.leading) {
                        
                       CSLabel_1Button(
                        placeHolder: "Menu Attivi",
                        imageNameOrEmojy: "scroll",
                        backgroundColor: Color.black)
                       /* CSLabel_2Button(
                          placeHolder: "Menu In",
                          imageName: "scroll",
                          backgroundColor: Color.black,
                          toggleBottoneTEXT: $openMenuList,
                          testoBottoneTEXT: "Edit")
                            .disabled(wannaAddDescription!) */

                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack {
                                    
                                    ForEach($viewModel.allMyMenu.sorted{$0.wrappedValue.intestazione < $1.wrappedValue.intestazione}) { $myMenu in
                                        
                                        vbCambioStatusMenuIn(myMenu: $myMenu)
                                        
                                      /*  GenericItemModel_RowViewMask(
                                            model: $myMenu.wrappedValue,
                                            backgroundColorView: backgroundColorView) {
                                                vbStatusButton(model: $myMenu)
                                            } */
                                        
                                        
                                         
                                       }
                                    
                                    
                                 /*   ForEach(itemModel.menuIn) { myMenu in
                                     
                                        GenericItemModel_RowViewMask(
                                            model: myMenu,
                                            backgroundColorView: backgroundColorView) {
                                               
                                                Text("Archivia")
                                                Text("In Pausa")
                                            }
                                      
                                    } */
                                }
                            }
                    }
                    
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
            
          /* if openMenuList! {
                
                SelettoreMyModel<_,MenuModel>(
                    itemModel: $itemModel,
                    allModelList: ModelList.propertyMenuList,
                    closeButton: $openMenuList)
                
            } */
            
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
   
        self.itemModelChanged = false
    }
 
    private func estrapolaGiorniChiusura() -> some View {
        
        var giorniServizio:[GiorniDelServizio] = []
        
      /*  for menu in itemModel.menuIn {
            
            giorniServizio.append(contentsOf: menu.giorniDelServizio)
           
        } */
        
        for menu in viewModel.allMyMenu {
              
            if menu.status == .completo(.pubblico) {giorniServizio.append(contentsOf: menu.giorniDelServizio)} else { continue }
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
    
    /// Gestisce il cambio di Status delle rowMask dei Menu In EditingPropertyModel
    @ViewBuilder private func vbCambioStatusMenuIn(myMenu: Binding<MenuModel>) -> some View {
        
        let currentMenu = myMenu.wrappedValue
        
        if currentMenu.status == .completo(.pubblico) {
            
            GenericItemModel_RowViewMask(
                model: currentMenu) {
                    
                    Button {
                        myMenu.wrappedValue.status = .completo(.inPausa)
                        
                    } label: {
                        HStack{
                            Text("Metti in Pausa")
                            Image(systemName: "pause.circle")
                        }
                    }
                    
                    Button {
                        myMenu.wrappedValue.status = .completo(.archiviato)
                        
                    } label: {
                        HStack{
                            Text("Archivia")
                            Image(systemName: "archivebox")
                        }
                    }
                    
                }
            
        } else if currentMenu.status == .completo(.inPausa) {
            
            GenericItemModel_RowViewMask(
                model: currentMenu) {
                    
                    Button {
                        myMenu.wrappedValue.status = .completo(.pubblico)
                        
                    } label: {
                        HStack{
                            Text("Pubblica")
                            Image(systemName: "play.circle")
                        }
                    }
                    
                    Button {
                        myMenu.wrappedValue.status = .completo(.archiviato)
                        
                    } label: {
                        HStack{
                            Text("Archivia")
                            Image(systemName: "archivebox")
                        }
                    }
                }
        }
                else {EmptyView()}
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




