//
//  NuovoMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import SwiftUI

struct NuovoMenuMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @State private var nuovoMenu: MenuModel
    let backgroundColorView: Color
    
    let menuArchiviato: MenuModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var openDishList: Bool = false
    @State private var generalErrorCheck: Bool = false
  
    init(nuovoMenu: MenuModel, backgroundColorView: Color, destinationPath:DestinationPath) {
        
        _nuovoMenu = State(wrappedValue: nuovoMenu)
        self.backgroundColorView = backgroundColorView
        
        self.menuArchiviato = nuovoMenu
        self.destinationPath = destinationPath
       
    }
    
  /*  var isThereAReasonToDisable: (tipologia:Bool, programmazione: Bool, bottom: Bool) {

      let disableTipologia = self.nuovoMenu.intestazione == ""
      let disableProgrammazione = self.nuovoMenu.tipologia == nil
      let dissableBottom = self.nuovoMenu == self.menuArchiviato
        
      return (disableTipologia,disableProgrammazione,dissableBottom)
    } */
 
    var body: some View {
        
        CSZStackVB(title: self.nuovoMenu.intestazione == "" ? "Nuovo Menu" : self.nuovoMenu.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider()
                
                    ScrollView {
                        
                        VStack(alignment: .leading) {

                            IntestazioneNuovoOggetto_Generic(
                                itemModel: $nuovoMenu,
                                generalErrorCheck: generalErrorCheck,
                                minLenght: 3,
                                coloreContainer: Color("SeaTurtlePalette_2"))
                          
                            BoxDescriptionModel_Generic(itemModel: $nuovoMenu, labelString: "Descrizione (Optional)", disabledCondition: openDishList)
                                
                             /*   CSLabel_1Button(placeHolder: "Tipologia", imageNameOrEmojy: "dollarsign.circle", backgroundColor: Color.black) */
                            
                               CSLabel_conVB(
                                placeHolder: "Tipologia Menu",
                                imageNameOrEmojy: "dollarsign.circle",
                                backgroundColor: Color.black) {
                                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoMenu.tipologia == .defaultValue)
                                }
                                
                                SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)

                            CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen)

                        //    if !isThereAReasonToDisable.programmazione {
                        
                            HStack {
                                
                                Text(self.nuovoMenu.isAvaibleWhen.extendedDescription())
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .italic()
                                    .foregroundColor(Color.black)
                                
                                CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoMenu.isAvaibleWhen == .defaultValue)
                                
                            }
                            
                                
                       //     }
                            
                            if self.nuovoMenu.isAvaibleWhen != .defaultValue {
                      
                                CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)
                            }
                    //  Spacer()
                            
                          /*  CSLabel_2Button(placeHolder: "Piatti in Menu", imageName: "fork.knife.circle", backgroundColor: Color.black, toggleBottoneTEXT: $openDishList, testoBottoneTEXT: "Vedi", disabledCondition: self.nuovoMenu.isAvaibleWhen == nil) */
                               
                            CSLabel_conVB(
                                placeHolder: "Piatti in Menu",
                                imageNameOrEmojy: "fork.knife.circle",
                                backgroundColor: Color.black) {
                                    CSButton_image(
                                        frontImage: "plus.circle",
                                        imageScale: .large,
                                        frontColor: Color("SeaTurtlePalette_3")) {
                                            withAnimation(.default) {
                                                self.openDishList.toggle()
                                            }
                                        }
                                }
                            
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                                        
                                        ForEach(self.nuovoMenu.rifDishIn, id:\.self) { dishId in
                                            
                                            vbShowDishIn(id: dishId)
                                          //  DishModel_RowView(item: dish) // Rendere Cliccabile? non so
                                        }
                                        
                                    }
                                }
             
                            BottomViewGeneric_NewModelSubView(
                                itemModel: $nuovoMenu,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: menuArchiviato,
                                destinationPath: destinationPath) {
                                    self.menuDescription()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }

                            
                            /*
                            BottomViewGeneric_NewModelSubView(
                                generalErrorCheck: $generalErrorCheck,
                                wannaDisableButtonBar: (nuovoMenu == menuArchiviato)) {
                                    self.menuDescription()
                                } resetAction: {
                                    csResetModel(modelAttivo: &self.nuovoMenu, modelArchiviato: self.menuArchiviato)
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } saveButtonDialogView: {
                                    self.scheduleANewMenu()
                                } */

                            
                            
                          /*  BottomViewGeneric_NewModelSubView(
                                wannaDisableSaveButton: self.nuovoMenu.isAvaibleWhen == nil) {
                                    self.menuDescription()
                                } resetAction: {
                                    resetModel(modelAttivo: &self.nuovoMenu, modelArchiviato: self.menuArchiviato)
                                   // self.resetMenu()
                                } saveButtonDialogView: {
                                    self.scheduleANewMenu()
                                }
                                .opacity(isThereAReasonToDisable.bottom ? 0.6 : 1.0)
                                .disabled(isThereAReasonToDisable.bottom) */



                            
                        }.padding(.horizontal)
                            .zIndex(0)
                        
                        
                    } // Chiusa ScrollView
                    .disabled(openDishList)
                    
                    if openDishList {
                        
                        SelettoreMyModel<_,DishModel>(
                            itemModel: $nuovoMenu,
                            allModelList: ModelList.menuDishList,
                            closeButton: $openDishList,
                            backgroundColorView: backgroundColorView,
                            actionTitle: "[+] Piatto") {
                                viewModel.addToThePath(
                                    destinationPath: destinationPath,
                                    destinationView: .piatto(DishModel()))
                            }
                        
                    }

                CSDivider()

            }

        } // Chiusa ZStack MAdre
        
     //   .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

    }
    
    // Method
    
    @ViewBuilder private func vbShowDishIn(id:String) -> some View {
        
        if let dishModel = self.viewModel.modelFromId(id: id, modelPath: \.allMyDish) {
            
            DishModel_RowView(item: dishModel,rowSize: .ridotto)
        }
        
    }
    
    private func resetAction() {
        
        self.nuovoMenu = self.menuArchiviato
        self.generalErrorCheck = false
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        
        self.nuovoMenu = MenuModel()
        
    }
    
    private func menuDescription() -> Text {
           
              var giorniServizio: [String] = []
           
           for day in self.nuovoMenu.giorniDelServizio {
               
               giorniServizio.append(day.simpleDescription())
           }
           
              let nome = self.nuovoMenu.intestazione
              let dataInizio = csTimeFormatter().data.string(from:self.nuovoMenu.dataInizio)
              let dataFine = csTimeFormatter().data.string(from:self.nuovoMenu.dataFine)
              let oraInizio = csTimeFormatter().ora.string(from: self.nuovoMenu.oraInizio)
              let oraFine = csTimeFormatter().ora.string(from: self.nuovoMenu.oraFine)
              
          switch self.nuovoMenu.isAvaibleWhen {
              
          case .dataEsatta:
              return Text("Il menu \(nome) sarà attivo \(giorniServizio,format: .list(type: .and)) \(dataInizio), dalle ore \(oraInizio) alle ore \(oraFine)")
          case .intervalloAperto:
              return Text("Il menu \(nome) sarà attivo a partire dal giorno \(dataInizio), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
          case .intervalloChiuso:
              return Text("Il menu \(nome) sarà attivo dal \(dataInizio) al \(dataFine), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
          case .noValue:
              return Text("Nessuna Info")
              
          }
              
       }
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else { return false }
      
        guard checkTipologiaMenu() else { return false }
       
        guard checkProgrammazione() else { return false }
       
       /* if self.nuovoMenu.dishInDEPRECATO.isEmpty { self.nuovoMenu.status = .bozza()}
        else {  self.nuovoMenu.status = .completo(.archiviato) } */ // 16.09
      
        guard !self.nuovoMenu.rifDishIn.isEmpty else {
            self.nuovoMenu.status = .bozza(.archiviato)
            return true
        }
        
        if self.nuovoMenu.optionalComplete() {
            self.nuovoMenu.status = .completo(.disponibile)
        } else { self.nuovoMenu.status = .bozza(.disponibile)}
        
        return true
        
    }
    
    private func checkIntestazione() -> Bool {
        
        return self.nuovoMenu.intestazione != ""
    }
    
    private func checkTipologiaMenu() -> Bool {
        
        return self.nuovoMenu.tipologia != .defaultValue
    }
    
    private func checkProgrammazione() -> Bool {
        
        return self.nuovoMenu.isAvaibleWhen != .defaultValue
    }

  /*
   
   @ViewBuilder private func scheduleANewMenu() -> some View {
 
        if self.menuArchiviato.intestazione == "" {
            // crea un Nuovo Oggettp
            Group {
                
                Button("Salva e Crea Nuovo", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoMenu)
                self.nuovoMenu = MenuModel()
                }
                
                Button("Salva ed Esci", role: .none) {
                    
                self.viewModel.createItemModel(
                    itemModel: self.nuovoMenu,
                    destinationPath: destinationPath)
                }
                
       
            }
        }
        
        else if self.menuArchiviato.intestazione == self.nuovoMenu.intestazione {
            // modifica l'oggetto corrente
            
            Group {
                
                vbEditingSaveButton()
               /* Button("Salva Modifiche", role: .none) {
                    
                self.viewModel.updateItemModel(itemModel: self.nuovoMenu, destinationPath: destinationPath)
                } */
            }
        }
        
        else {
            
            Group {
                
                vbEditingSaveButton()
                
             /*   Button("Salva Modifiche", role: .none) {
                    
                self.viewModel.updateItemModel(itemModel: self.nuovoMenu, destinationPath: destinationPath)
                } */
                
                Button("Salva come Nuovo Menu", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoMenu,destinationPath: destinationPath)
                }
                
            }
            
            
        }
 
    }
    
    @ViewBuilder private func vbEditingSaveButton() -> some View {
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.nuovoMenu)
        self.nuovoMenu = MenuModel()
        }
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.nuovoMenu, destinationPath: destinationPath)
        }
        
        
    }
   */
}




struct NuovoMenuMainView_Previews: PreviewProvider {
    
    static var menuItem:MenuModel = {
       
        var menu = MenuModel()
        
        return menu
    }()
    
    static var previews: some View {
        NuovoMenuMainView(nuovoMenu: menuItem, backgroundColorView: Color("SeaTurtlePalette_1"), destinationPath: .menuList )
    }
}


