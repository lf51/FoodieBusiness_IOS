//
//  EditingPropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI
import MapKit
import MyPackView_L0
import MyFoodiePackage

struct EditingPropertyModel: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var itemModel: PropertyModel
    let backgroundColorView: Color
    
    @State private var itemModelChanged: Bool = false
    @State private var modelSize: RowSize = .sintetico
  
    init(itemModel: PropertyModel, backgroundColorView: Color) {
        _itemModel = State(wrappedValue: itemModel)
        self.backgroundColorView = backgroundColorView
        
    }
    
    // 17.02.23 Focus State
    @FocusState private var modelField:ModelField?
    
    var body: some View {
        
        CSZStackVB(title: itemModel.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
              //  CSDivider()
                Text("admin: username")
                    
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {
                    
                    BoxDescriptionModel_Generic(
                        itemModel: $itemModel,
                        labelString: "Descrizione Attività",
                        disabledCondition: false,
                        modelField: $modelField)
                    .focused($modelField, equals: .descrizione)
                    
                    VStack(spacing:10) {
                        let allMenuActive = self.viewModel.cloudData.allMyMenu.filter({$0.status.checkStatusTransition(check: .disponibile)})
                        
                        let allMenuDeActive = self.viewModel.cloudData.allMyMenu.filter({
                            $0.status.checkStatusTransition(check: .inPausa) ||
                            $0.status.checkStatusTransition(check: .archiviato)
                        })
                        
                        DynamicScrollSizeMM(
                            label: "Menu Disponibli",
                            menuCollection: allMenuActive)
                        
                        DynamicScrollSizeMM(
                            label: "in-Pausa & Archiviati",
                            menuCollection: allMenuDeActive)
                    }
                    
                    VStack(alignment:.leading) {
                        
                        CSLabel_conVB(
                            placeHolder: "Schedule Servizio",
                            imageNameOrEmojy: "info.circle",
                            backgroundColor: Color.black) {
                                
                                HStack {
                                    
                                    /* let todayClose = self.viewModel.allMyMenu.filter({$0.isOnAir(checkTimeRange: false)}).isEmpty */ // deprecata 03.07.23
                                    let todayClose = self.viewModel.cloudData.allMyMenu.filter({$0.isOnAirValue().today}).isEmpty
                                    
                                    Text("Oggi")
                                    
                                    Text(todayClose ? "Chiuso" : "Aperto")
                                        .fontWeight(.semibold)
                                    
                                }
                                .italic()
                                .foregroundColor(Color.seaTurtle_2)
                            }
                        
                        
                        ScheduleServizio()
                        
                        //  estrapolaGiorniChiusura()
                        
                    }
                        
                     /*   VStack(alignment:.leading) {
                            //Nota 24.11 - Collaboratori
                            let currentUserUID = self.authProcess.currentUser?.userUID
                            
                            CSLabel_conVB(
                              placeHolder: "Collaboratori:",
                              imageNameOrEmojy: "person.crop.rectangle.stack",
                              backgroundColor:Color.seaTurtle_2) {
                                  
                                  Button {
                                      
                                      if let adminUID = currentUserUID {
                                          self.collaborator = CollaboratorModel(uidAmministratore:adminUID)
                                      } /*else {
                                         self.collaborator = CollaboratorModel(uidAmministratore:"NoUID")
                                         }*/ // else è da togliere
                                      
                                  } label: {
                                      Image(systemName: "plus.circle")
                                          .imageScale(.large)
                                          .foregroundColor(Color.seaTurtle_3)
                                  }
                                  .disabled(currentUserUID == nil)
                                  .opacity(currentUserUID == nil ? 0.3 : 1.0)
                              }
                            
                            if let collabs = self.viewModel.profiloUtente.allMyCollabs {
                                
                                //   ScrollView(showsIndicators:false) {
                                VStack {
                                    ForEach(collabs,id:\.self) { collab in
                                        collabsRow(collab)
                                    }
                                }
                                
                            }
                            
                        } */
                    
                    }
                } // Chiusa Scroll View
                
             CSDivider()
                
            } // Chiusa VStack Madre
            .padding(.horizontal)
            
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

        self.viewModel.updateItemModel(itemModel: itemModel, showAlert: true, messaggio: "Salva Modifiche della proprietà \(itemModel.intestazione)")
        self.itemModelChanged = false
    }
 
   
    
    
    /*
    private func estrapolaGiorniChiusura() -> some View {
        
        var giorniServizio:[GiorniDelServizio] = []
        
      /*  for menu in itemModel.menuIn {
            
            giorniServizio.append(contentsOf: menu.giorniDelServizio)
           
        } */
        
        for menu in viewModel.allMyMenu {
              
            if menu.status == .completo(.disponibile) {giorniServizio.append(contentsOf: menu.giorniDelServizio)} else { continue }
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
    } */ // Deprecata 28.10
    
    /*
    /// Gestisce il cambio di Status delle rowMask dei Menu In EditingPropertyModel
    @ViewBuilder private func vbCambioStatusMenuIn(myMenu: Binding<MenuModel>) -> some View {
        
        let currentMenu = myMenu.wrappedValue
        
        if currentMenu.status == .completo(.disponibile) {
            
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
                        myMenu.wrappedValue.status = .completo(.disponibile)
                        
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
    } */ // Deprecato 28.10
    
}




struct EditingPropertyModel_Previews: PreviewProvider {
    
   /* @State static var testProperty: PropertyModel = PropertyModel(
        intestazione: "Osteria del Vicolo",
        cityName: "Sciacca",
        coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        webSite: "https://osteriadelcorso.com",
        phoneNumber: "3337213895",
        streetAdress: "via roma",
        numeroCivico: "21") */
    
    static var testProperty =  PropertyModel(
        intestazione: "Osteria del Vicolo",
        cityName: "Sciacca",
        coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        webSite: "https://osteriadelcorso.com",
        phoneNumber: "3337213895",
        streetAdress: "via roma",
        numeroCivico: "21",
        admin: UserRoleModel(ruolo: .guest) )
    
    static var previews: some View {

       NavigationStack {
            EditingPropertyModel(itemModel: testProperty, backgroundColorView: Color.seaTurtle_1)
       }.environmentObject(testAccount)
      //  .navigationBarTitleDisplayMode(.large)
       // .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

private struct DynamicScrollSizeMM:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let label:String
    let menuCollection:[MenuModel]
   
    @State private var modelSize:RowSize = .sintetico
    
    var body: some View {
                    
            VStack(alignment:.leading) {
                
                let disableButton:Bool = menuCollection.isEmpty
                
                CSLabel_conVB(
                placeHolder: "\(label)(\(menuCollection.count))",
                imageNameOrEmojy: "scroll",
                backgroundColor: Color.black) {
                     
                        CSButton_image(
                            activationBool:self.modelSize.returnType() == .normale() ,
                            frontImage:  "arrow.down.and.line.horizontal.and.arrow.up",
                            backImage: "arrow.up.and.line.horizontal.and.arrow.down",
                            imageScale: .medium,
                            backColor: .seaTurtle_4,
                            frontColor: .seaTurtle_3){
                                withAnimation {
                                    self.changeRowSizeAction()
                                }
                            }
                            .opacity(disableButton ? 0.6 : 1.0)
                            .disabled(disableButton)

                }
                
                     ScrollView(.horizontal, showsIndicators: false) {
                         
                         HStack {

                             ForEach(menuCollection) { myMenu in

                                 GenericItemModel_RowViewMask(model: myMenu,rowSize: self.modelSize) {
                                     vbMenuInterattivoModuloCambioStatus(myModel: myMenu, viewModel: self.viewModel)                                          }

                                }

                         }
                     }
             }
    
    }
    
    // Method
    private func changeRowSizeAction() {
        
        self.modelSize = self.modelSize.returnType() == .normale() ? .sintetico : .normale()
    }
    
}
