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
    
    @State private var openDishList: Bool? = false
  
    init(nuovoMenu: MenuModel, backgroundColorView: Color, destinationPath:DestinationPath) {
        
        _nuovoMenu = State(wrappedValue: nuovoMenu)
        self.backgroundColorView = backgroundColorView
        
        self.menuArchiviato = nuovoMenu
        self.destinationPath = destinationPath

    }
    
    var isThereAReasonToDisable: (tipologia:Bool, programmazione: Bool, bottom: Bool) {

      let disableTipologia = self.nuovoMenu.intestazione == ""
      let disableProgrammazione = self.nuovoMenu.tipologia == nil
      let dissableBottom = self.nuovoMenu == self.menuArchiviato
        
      return (disableTipologia,disableProgrammazione,dissableBottom)
    }
 
    var body: some View {
        
        CSZStackVB(title: self.nuovoMenu.intestazione == "" ? "Nuovo Menu" : self.nuovoMenu.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider()
                
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            
                            IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Menu (\(self.nuovoMenu.status.simpleDescription().capitalized))", imageLabel: self.nuovoMenu.status.imageAssociated(),imageColor: self.nuovoMenu.status.transitionStateColor(), coloreContainer: Color("SeaTurtlePalette_2"), itemModel: $nuovoMenu)
                                            
                          
                            BoxDescriptionModel_Generic(itemModel: $nuovoMenu, labelString: "Descrizione (Optional)", disabledCondition: isThereAReasonToDisable.tipologia)
                                
                                CSLabel_1Button(placeHolder: "Tipologia", imageNameOrEmojy: "dollarsign.circle", backgroundColor: Color.black)
                                
                                SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                                    .opacity(isThereAReasonToDisable.tipologia ? 0.6 : 1.0)
                                    .disabled(isThereAReasonToDisable.tipologia)
                                                                   
                            CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen, conditionToDisablePicker: isThereAReasonToDisable.programmazione)

                            if !isThereAReasonToDisable.programmazione {
                                
                                Text(self.nuovoMenu.isAvaibleWhen?.extendedDescription() ?? "Seleziona il tipo di intervallo temporale")
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .italic()
                            }
                            
                            if self.nuovoMenu.isAvaibleWhen != nil {
                      
                                CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)
                            }
                    //  Spacer()
                            
                            CSLabel_2Button(placeHolder: "Piatti", imageName: "fork.knife.circle", backgroundColor: Color.black, toggleBottoneTEXT: $openDishList, testoBottoneTEXT: "Vedi", disabledCondition: self.nuovoMenu.isAvaibleWhen == nil)
                               
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                                        
                                        ForEach(nuovoMenu.dishIn) { dish in
                                            
                                            DishModel_RowView(item: dish) // Rendere Cliccabile
                                        }
                                        
                                    }
                                }
             
                            BottomViewGeneric_NewModelSubView(
                                wannaDisableSaveButton: self.nuovoMenu.isAvaibleWhen == nil) {
                                    self.menuDescription()
                                } resetAction: {
                                    resetModel(modelAttivo: &self.nuovoMenu, modelArchiviato: self.menuArchiviato)
                                   // self.resetMenu()
                                } saveButtonDialogView: {
                                    self.scheduleANewMenu()
                                }
                                .opacity(isThereAReasonToDisable.bottom ? 0.6 : 1.0)
                                .disabled(isThereAReasonToDisable.bottom)

                            
                         /*   BottomNuovoMenu_SubView(
                                nuovoMenu: $nuovoMenu) {
                                    self.resetMenu()
                                } dialogView: {
                                    self.scheduleANewMenu()
                                }
                                .opacity(isThereAReasonToDisable.bottom ? 0.6 : 1.0)
                                .disabled(isThereAReasonToDisable.bottom) */

                            
                        }.padding(.horizontal)
                        
                        
                    } // Chiusa ScrollView
                    .disabled(openDishList!)
                    
                    if openDishList! {
                        
                        SelettoreMyModel<_,DishModel>(
                            itemModel: $nuovoMenu,
                            allModelList:ModelList.menuDishList ,
                            closeButton: $openDishList)
                        .zIndex(1)
                        
                    }

                CSDivider()

            }

        }
        
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

    }
    
    // Method
    
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
              return Text("Il menu \(nome) sarà attivo il giorno \(dataInizio), dalle ore \(oraInizio) alle ore \(oraFine)")
          case .intervalloAperto:
              return Text("Il menu \(nome) sarà attivo a partire dal giorno \(dataInizio), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
          case .intervalloChiuso:
              return Text("Il menu \(nome) sarà attivo dal \(dataInizio) al \(dataFine), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")

          case nil:
              return Text("Nessuna Info")
              
          }
              
       }
    
   @ViewBuilder private func scheduleANewMenu() -> some View {
 
        if self.menuArchiviato.intestazione == "" {
            // crea un Nuovo Oggettp
            Group {
                
                Button("Salva Nuovo Menu", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoMenu,destinationPath: destinationPath)
                }
       
            }
        }
        
        else if self.menuArchiviato.intestazione == self.nuovoMenu.intestazione {
            // modifica l'oggetto corrente
            
            Group {
                
                Button("Salva Modifiche", role: .none) {
                    
                self.viewModel.updateItemModel(itemModel: self.nuovoMenu, destinationPath: destinationPath)
                }
            }
        }
        
        else {
            
            Group {
                
                Button("Salva Modifiche", role: .none) {
                    
                self.viewModel.updateItemModel(itemModel: self.nuovoMenu, destinationPath: destinationPath)
                }
                
                Button("Salva come Nuovo Menu", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoMenu,destinationPath: destinationPath)
                }
                
            }
            
            
        }
 
    }
    
    
}




/* struct NuovoMenuMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @State private var nuovoMenu: MenuModel
    @Binding var dismissView:Bool?
    @State private var nuovaIntestazioneMenu: String = ""
    
    init(editMenu:MenuModel? = MenuModel(), dismissView: Binding<Bool?>? = nil) {
        
        _dismissView = dismissView ?? .constant(nil)
        _nuovoMenu = State(wrappedValue: editMenu!)
            
    }
    
    var isThereAReasonToDisable: (tipologia:Bool, programmazione: Bool) {

      let disableTipologia = self.nuovoMenu.intestazione == ""
      let disableProgrammazione = self.nuovoMenu.tipologia == .defaultValue
        
      return (disableTipologia,disableProgrammazione)
    }
 
    var body: some View {
        
        VStack {
            
            TopBar_3BoolPlusDismiss(title: nuovoMenu.intestazione != "" ? nuovoMenu.intestazione : "Crea Menu", exitButton: $dismissView, exitButtonTitle: "Chiudi")
                .padding(.horizontal)
 
            VStack(alignment: .leading) {
                
                IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Menu (Interno)", imageLabel: "doc.badge.plus", coloreContainer: Color.red, itemModel: $nuovoMenu)
                
                CSLabel_1Button(placeHolder: "Tipologia", imageName: "dollarsign.circle", backgroundColor: Color.black)
                
                SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                    .opacity(isThereAReasonToDisable.tipologia ? 0.6 : 1.0)
                    .disabled(isThereAReasonToDisable.tipologia)

                CSLabel_2Button(placeHolder: "Ristoranti", imageName: "circle", backgroundColor: Color.black, toggleBottoneTEXT: .constant(false), testoBottoneTEXT: "Scegli")
                    .opacity(0.4)
                    .disabled(true)
                
                CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen, conditionToDisablePicker: isThereAReasonToDisable.programmazione)
                    
                CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)

                BottomNuovoMenu_SubView(nuovoMenu: $nuovoMenu){self.scheduleANewMenu()}
 
            }.padding(.horizontal)
            
            
        }
        .padding(.top)
        .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.cyan.opacity(0.9)).shadow(radius: 5.0))
        .contrast(1.2)
        .brightness(0.08)
       // .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
       /*.alert(item:$viewModel.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         }*/ // non funziona
    }
    
    // Method
    
    private func scheduleANewMenu() {
            
        self.viewModel.createOrEditItemModel(itemModel: self.nuovoMenu)
        
        print("Nome Menu: \(self.nuovoMenu.intestazione)")
        print("data Inizio:\(self.nuovoMenu.dataInizio.ISO8601Format())")
        print("data Fine: \(self.nuovoMenu.dataFine.ISO8601Format())")
        print("nei giorni di: \(self.nuovoMenu.giorniDelServizio.description)")
        print("dalle \(self.nuovoMenu.oraInizio.ISO8601Format()) alle \(self.nuovoMenu.oraFine.ISO8601Format())")
        
        
       print("Salvare MenuModel nel firebase e/o nell'elenco dei Menu in un ViewModel")
    }
} */ // BAckUp 28.04


/*
struct NuovoMenuMainView_Previews: PreviewProvider {
    static var previews: some View {
        NuovoMenuMainView(dismissView: .constant(true), backgroundColorView: Color.cyan)
    }
}

*/
