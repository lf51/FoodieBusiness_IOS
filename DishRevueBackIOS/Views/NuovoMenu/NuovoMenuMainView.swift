//
//  NuovoMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct NuovoMenuMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @State private var nuovoMenu: MenuModel
    let backgroundColorView: Color
    
    @State private var menuArchiviato: MenuModel // per il reset
    let destinationPath: DestinationPath
   // let saveDialogType:SaveDialogType
    
    @State private var openDishList: Bool = false
    @State private var generalErrorCheck: Bool = false
  
    init(
        nuovoMenu: MenuModel,
        backgroundColorView: Color,
        destinationPath:DestinationPath,
        saveDialogType:SaveDialogType) {
        
        _nuovoMenu = State(wrappedValue: nuovoMenu)
        self.backgroundColorView = backgroundColorView
        
        _menuArchiviato = State(wrappedValue: nuovoMenu)
        self.destinationPath = destinationPath
       // self.saveDialogType = saveDialogType
       
    }
    
    // 17.02.23 Focus State
    @FocusState private var modelField:ModelField?

    var body: some View {
        
        CSZStackVB(title: self.nuovoMenu.intestazione == "" ? "Nuovo Menu" : self.nuovoMenu.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                
              //  CSDivider()
                ProgressView(value: self.nuovoMenu.countProgress) {
                    Text("Completo al: \(self.nuovoMenu.countProgress,format: .percent)")
                        .font(.caption)
                }
                
                ScrollView(showsIndicators:false) {
                        
                        VStack(alignment: .leading,spacing: .vStackBoxSpacing) {

                            IntestazioneNuovoOggetto_Generic(
                                itemModel: $nuovoMenu,
                                generalErrorCheck: generalErrorCheck,
                                minLenght: 3,
                                coloreContainer: .seaTurtle_2)
                                .focused($modelField, equals: .intestazione)
                          
                            BoxDescriptionModel_Generic(
                                itemModel: $nuovoMenu,
                                labelString: "Descrizione (Optional)",
                                disabledCondition: openDishList,
                                modelField: $modelField)
                                .focused($modelField, equals: .descrizione)

                            VStack(alignment: .leading, spacing: .vStackLabelBodySpacing){
                                
                                CSLabel_1Button(
                                  placeHolder: "Tipologia Menu",
                                  imageNameOrEmojy: "dollarsign.circle",
                                  backgroundColor: Color.black)
                                
                               /* CSLabel_conVB(
                                 placeHolder: "Tipologia Menu",
                                 imageNameOrEmojy: "dollarsign.circle",
                                 backgroundColor: Color.black) {
                                     
                                     CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoMenu.tipologia == .defaultValue)
                                 }*/
                                 
                                 SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                                
                            }

                            VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                                
                                CSLabel_1Picker(
                                    placeHolder: "Programmazione",
                                    imageName: "calendar.badge.clock",
                                    backgroundColor: Color.black,
                                    availabilityMenu: self.$nuovoMenu.availability)

                                HStack {
                                    
                                    Text(self.nuovoMenu.availability.extendedDescription())
                                        .font(.caption)
                                        .fontWeight(.light)
                                        .italic()
                                        .foregroundStyle(Color.black)
                                    
                                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoMenu.giorniDelServizio.isEmpty)
                                    
                                }

                                //if self.nuovoMenu.availability != .noValue {
                          
                                    CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)
                                //}
                            }
 
                               
                            VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                                
                                let dishIn = self.nuovoMenu.rifDishIn.count
                                
                                CSLabel_conVB(
                                    placeHolder: "Prodotti in Menu (\(dishIn))",
                                    imageNameOrEmojy: "fork.knife.circle",
                                    backgroundColor: Color.black) {
                                        
                                            CSButton_image(
                                                frontImage: "plus.circle",
                                                imageScale: .large,
                                                frontColor: .seaTurtle_3) {
                                                    withAnimation(.default) {
                                                        self.openDishList.toggle()
                                                    }
                                                }

                                        }
                                
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        HStack {
                                            
                                            ForEach(self.nuovoMenu.rifDishIn, id:\.self) { dishId in
                                                
                                                vbShowDishIn(id: dishId)
     
                                            }
                                            
                                        }
                                    }
                            }
             
                          /*  BottomViewGeneric_NewModelSubView(
                                itemModel: $nuovoMenu,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: menuArchiviato,
                                destinationPath: destinationPath,
                                dialogType: self.saveDialogType) {
                                    self.menuDescription()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }*/
                            
                            BottomDialogView {
                                self.menuDescription()
                            } disableConditions: {
                                self.disableCondition()
                            } secondaryAction: {
                                self.resetAction()
                            } preDialogCheck: {
                                self.checkPreliminare()
                               /* let check = self.checkPreliminare()
                                if check { return check }
                                else {
                                    self.generalErrorCheck = true
                                    return false
                                }*/
                            } primaryDialogAction: {
                                self.saveButtonDialogView()
                            }

   
                        }
                        //.padding(.horizontal)
                          //  .zIndex(0)
 
                    } // Chiusa ScrollView
                .scrollDismissesKeyboard(.immediately)

                CSDivider()

            }
            .csHpadding()

        } // Chiusa ZStack MAdre
        .popover(isPresented: $openDishList,attachmentAnchor: .point(.top),arrowEdge: .bottom) {
            
            PreCallVistaPiattiEspansa(
                currentMenu: $nuovoMenu,
                rowViewSize: .normale(700),
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath)
            .presentationDetents([.fraction(0.8)])
            
        }

     //   .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

    }
    
    // Method
    
    @ViewBuilder private func vbShowDishIn(id:String) -> some View {
        
        if let ProductModel = self.viewModel.modelFromId(id: id, modelPath: \.db.allMyDish) {
            
            GenericItemModel_RowViewMask(
                model: ProductModel,
                rowSize: .sintetico) {
 
                    Button {
                        self.nuovoMenu.rifDishIn.removeAll(where: {$0 == id})
                    } label: {
                        Text("Rimuovi")
                    }

                }
        }
        
    }
    
    private func disableCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
        
        let general = self.nuovoMenu == self.menuArchiviato
        return(general,false,false)
    }
    
    private func resetAction() {
        
        self.nuovoMenu = self.menuArchiviato
        self.generalErrorCheck = false
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        
        let new = MenuModel()
        self.nuovoMenu = new
        self.menuArchiviato = new
        
    }
    
    private func menuDescription() -> (breve:Text,estesa:Text) {
           
            var giorniServizio: [String] = []
           
           for day in self.nuovoMenu.giorniDelServizio {
               
               giorniServizio.append(day.simpleDescription())
           }
           
              let nome = self.nuovoMenu.intestazione
              let dataInizio = csTimeFormatter().data.string(from:self.nuovoMenu.giornoInizio)
             
              let oraInizio = csTimeFormatter().ora.string(from: self.nuovoMenu.oraInizio)
              let oraFine = csTimeFormatter().ora.string(from: self.nuovoMenu.oraFine)

        switch self.nuovoMenu.availability {
              
          case .dataEsatta:
              let descr = Text("Il menu <\(nome)> sarà attivo \(giorniServizio,format: .list(type: .and)) il \(dataInizio), dalle ore \(oraInizio) alle ore \(oraFine)")
            return (descr,descr)
            
          case .intervalloAperto:
              let descri = Text("Il menu \(nome) sarà attivo a partire dal giorno \(dataInizio), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
            return (descri,descri)
            
          case .intervalloChiuso:
            
            if let dataFine = self.nuovoMenu.giornoFine {
                let endDay = csTimeFormatter().data.string(from:dataFine)
                
                let descrip = Text("Il menu \(nome) sarà attivo dal \(dataInizio) al \(endDay), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
                
                return (descrip,descrip)
                
            } else {
                let error = Text("[Errore]")
                return (error,error)
            }
              
          }
              
       }
    
    private func checkPreliminare() -> Bool {
        
        do {
           // try checkDishes()
            try checkServiceDays()
            try checkIntestazione()
           // try checkNotExistSimilar()
            return true
            
        } catch let error {
            
            withAnimation {
                
                self.generalErrorCheck = true
                self.viewModel.logMessage = error.localizedDescription
            }
            
            return false
        }
        
        }
    
    private func checkIntestazione() throws /*-> Bool*/ {
        
        let intestazione = self.nuovoMenu.intestazione
        
        guard !intestazione.isEmpty else {
            self.modelField = .intestazione
            throw CS_NewModelCheckError.intestazioneMancante
        }
        
    }
    
   /* private func checkDishes() throws {
        
        let dishCount = self.nuovoMenu.rifDishIn.count
        
        guard dishCount > 0 else {
            throw CS_NewModelCheckError.elencoProdottiVuoto
        }
    } */
    
    /*private func checkNotExistSimilar() throws /*-> Bool*/ {
        
        let NotExist = self.viewModel.checkModelNotInVM(itemModel: nuovoMenu)
            
        guard NotExist else {
            
            throw CS_NewModelCheckError.modelloEsistente
        }
        
    }*/
    
    private func checkServiceDays() throws {
        
        guard !self.nuovoMenu.giorniDelServizio.isEmpty else {
            
            throw CS_NewModelCheckError.noServiceDays
        }
        
    }
    
   /* private func checkProgrammazione() -> Bool {
        
        return self.nuovoMenu.isAvaibleWhen != .defaultValue
    }*/
    
   /* private func checkTipologiaMenu() throws /*-> Bool*/ {
        
        let tipologia = self.nuovoMenu.tipologia
        
        guard tipologia != .defaultValue else {
            
        }
        
        return self.nuovoMenu.tipologia != .defaultValue
    }*/
    
    
 
    
    
   
    
   
    
    // viewBuilder
    
    @ViewBuilder private func saveButtonDialogView() -> some View {

        csBuilderDialogButton {
            
            // nuovo Menu
            DialogButtonElement(
                label: .saveNew) {
                    self.menuArchiviato.intestazione == ""
                } action: {
                    
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoMenu)
                    self.salvaECreaPostAction()
                    
                }

            DialogButtonElement(
                label: .saveEsc) {
                    self.menuArchiviato.intestazione == ""
                } action: {
                    
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoMenu,
                        refreshPath: self.destinationPath)
                   
                }
            
           // modifica menu
            
            DialogButtonElement(
                label: .saveModNew) {
                    self.menuArchiviato.intestazione != ""
                } action: {
                    
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoMenu)

                    self.salvaECreaPostAction()// BUG -> deve partire se dall'update non torna un errore - Da sistemare
                   
                }
            
            DialogButtonElement(
                label: .saveModEsc) {
                    self.menuArchiviato.intestazione != ""
                } action: {
                    
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: self.nuovoMenu,
                        refreshPath: self.destinationPath)
                   
                }

           // salva come nuovo
            
            DialogButtonElement(
                label: .saveAsNew,
                extraLabel: "Menu") {
                    self.menuArchiviato.intestazione != "" &&
                    self.menuArchiviato.intestazione != self.nuovoMenu.intestazione
                    
                } action: {
                    
                    var new = self.nuovoMenu
                    new.id = UUID().uuidString
                   
                    self.viewModel.createOrUpdateModelOnSub(
                        itemModel: new,
                        refreshPath: self.destinationPath)
                   
                }
            
        } // chiusa result builder

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
        NuovoMenuMainView(nuovoMenu: menuItem, backgroundColorView: Color.seaTurtle_1, destinationPath: .menuList ,saveDialogType: .completo)
    }
}


/*
 
 struct NuovoMenuMainView: View {

     @EnvironmentObject var viewModel: AccounterVM
     
     @State private var nuovoMenu: MenuModel
     let backgroundColorView: Color
     
     @State private var menuArchiviato: MenuModel // per il reset
     let destinationPath: DestinationPath
     let saveDialogType:SaveDialogType
     
     @State private var openDishList: Bool = false
     @State private var generalErrorCheck: Bool = false
   
     init(
         nuovoMenu: MenuModel,
         backgroundColorView: Color,
         destinationPath:DestinationPath,
         saveDialogType:SaveDialogType) {
         
         _nuovoMenu = State(wrappedValue: nuovoMenu)
         self.backgroundColorView = backgroundColorView
         
         _menuArchiviato = State(wrappedValue: nuovoMenu)
         self.destinationPath = destinationPath
         self.saveDialogType = saveDialogType
        
     }
     
     // 17.02.23 Focus State
     @FocusState private var modelField:ModelField?

     var body: some View {
         
         CSZStackVB(title: self.nuovoMenu.intestazione == "" ? "Nuovo Menu" : self.nuovoMenu.intestazione, backgroundColorView: backgroundColorView) {
             
             VStack {
                 
               //  CSDivider()
                 ProgressView(value: self.nuovoMenu.countProgress) {
                     Text("Completo al: \(self.nuovoMenu.countProgress,format: .percent)")
                         .font(.caption)
                 }
                 
                 ScrollView(showsIndicators:false) {
                         
                         VStack(alignment: .leading,spacing: .vStackBoxSpacing) {

                             IntestazioneNuovoOggetto_Generic(
                                 itemModel: $nuovoMenu,
                                 generalErrorCheck: generalErrorCheck,
                                 minLenght: 3,
                                 coloreContainer: .seaTurtle_2)
                                 .focused($modelField, equals: .intestazione)
                           
                             BoxDescriptionModel_Generic(
                                 itemModel: $nuovoMenu,
                                 labelString: "Descrizione (Optional)",
                                 disabledCondition: openDishList,
                                 modelField: $modelField)
                                 .focused($modelField, equals: .descrizione)

                             VStack(alignment: .leading, spacing: .vStackLabelBodySpacing){
                                 
                                 CSLabel_conVB(
                                  placeHolder: "Tipologia Menu",
                                  imageNameOrEmojy: "dollarsign.circle",
                                  backgroundColor: Color.black) {
                                      CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoMenu.tipologia == .defaultValue)
                                  }
                                  
                                  SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                                 
                             }

                             VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                                 
                                 CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen)

                                 HStack {
                                     
                                     Text(self.nuovoMenu.isAvaibleWhen.extendedDescription())
                                         .font(.caption)
                                         .fontWeight(.light)
                                         .italic()
                                         .foregroundStyle(Color.black)
                                     
                                     CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoMenu.isAvaibleWhen == .defaultValue)
                                     
                                 }

                                 if self.nuovoMenu.isAvaibleWhen != .defaultValue {
                           
                                     CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)
                                 }
                             }
  
                                
                             VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                                 
                                 CSLabel_conVB(
                                     placeHolder: "Piatti in Menu",
                                     imageNameOrEmojy: "fork.knife.circle",
                                     backgroundColor: Color.black) {
                                         
                                         CSButton_image(
                                             frontImage: "plus.circle",
                                             imageScale: .large,
                                             frontColor: .seaTurtle_3) {
                                                 withAnimation(.default) {
                                                     self.openDishList.toggle()
                                                 }
                                             }
                                     }
                                 
                                     ScrollView(.horizontal, showsIndicators: false) {
                                         
                                         HStack {
                                             
                                             ForEach(self.nuovoMenu.rifDishIn, id:\.self) { dishId in
                                                 
                                                 vbShowDishIn(id: dishId)
      
                                             }
                                             
                                         }
                                     }
                             }
              
                           /*  BottomViewGeneric_NewModelSubView(
                                 itemModel: $nuovoMenu,
                                 generalErrorCheck: $generalErrorCheck,
                                 itemModelArchiviato: menuArchiviato,
                                 destinationPath: destinationPath,
                                 dialogType: self.saveDialogType) {
                                     self.menuDescription()
                                 } resetAction: {
                                     self.resetAction()
                                 } checkPreliminare: {
                                     self.checkPreliminare()
                                 } salvaECreaPostAction: {
                                     self.salvaECreaPostAction()
                                 }*/
                             
                             BottomDialogView {
                                 self.menuDescription()
                             } disableConditions: {
                                 self.disableCondition()
                             } secondaryAction: {
                                 resetAction()
                             } preDialogCheck: {
                                 let check = self.checkPreliminare()
                                 if check { return check }
                                 else {
                                     self.generalErrorCheck = true
                                     return false
                                 }
                             } primaryDialogAction: {
                                 self.saveButtonDialogView()
                             }

    
                         }
                         //.padding(.horizontal)
                           //  .zIndex(0)
  
                     } // Chiusa ScrollView
                 .scrollDismissesKeyboard(.immediately)

                 CSDivider()

             }
             .csHpadding()

         } // Chiusa ZStack MAdre
         .popover(isPresented: $openDishList,attachmentAnchor: .point(.top),arrowEdge: .bottom) {
             
             PreCallVistaPiattiEspansa(
                 currentMenu: $nuovoMenu,
                 rowViewSize: .normale(700),
                 backgroundColorView: backgroundColorView,
                 destinationPath: destinationPath)
             .presentationDetents([.fraction(0.8)])
             
         }

      //   .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

     }
     
     // Method
     
     @ViewBuilder private func vbShowDishIn(id:String) -> some View {
         
         if let ProductModel = self.viewModel.modelFromId(id: id, modelPath: \.db.allMyDish) {
             
            // ProductModel_RowView(item: ProductModel,rowSize: .sintetico)
             GenericItemModel_RowViewMask(
                 model: ProductModel,
                 rowSize: .sintetico) {
  
                     Button {
                         self.nuovoMenu.rifDishIn.removeAll(where: {$0 == id})
                     } label: {
                         Text("Rimuovi")
                     }

                 }
         }
         
     }
     
     private func disableCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
         
         let general = self.nuovoMenu == self.menuArchiviato
         return(general,false,false)
     }
     
     private func resetAction() {
         
         self.nuovoMenu = self.menuArchiviato
         self.generalErrorCheck = false
     }
     
     private func salvaECreaPostAction() {
         
         self.generalErrorCheck = false
         
         let new = MenuModel()
         self.nuovoMenu = new
         self.menuArchiviato = new
         
     }
     
     private func menuDescription() -> (breve:Text,estesa:Text) {
            
             var giorniServizio: [String] = []
            
            for day in self.nuovoMenu.giorniDelServizio {
                
                giorniServizio.append(day.simpleDescription())
            }
            
               let nome = self.nuovoMenu.intestazione
               let dataInizio = csTimeFormatter().data.string(from:self.nuovoMenu.dataInizio)
               let dataFine = csTimeFormatter().data.string(from:self.nuovoMenu.dataFine)
               let oraInizio = csTimeFormatter().ora.string(from: self.nuovoMenu.oraInizio)
               let oraFine = csTimeFormatter().ora.string(from: self.nuovoMenu.oraFine)
               return(Text("bevre"),Text("estesa"))
          /* switch self.nuovoMenu.isAvaibleWhen {
               
           case .dataEsatta:
               return Text("Il menu \(nome) sarà attivo \(giorniServizio,format: .list(type: .and)) \(dataInizio), dalle ore \(oraInizio) alle ore \(oraFine)")
           case .intervalloAperto:
               return Text("Il menu \(nome) sarà attivo a partire dal giorno \(dataInizio), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
           case .intervalloChiuso:
               return Text("Il menu \(nome) sarà attivo dal \(dataInizio) al \(dataFine), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
           case .noValue:
               return Text("Nessuna Info")
               
           }*/// da riaprire e sistemare
               
        }
     
     private func checkPreliminare() -> Bool {
         
         guard checkIntestazione() else {
             self.modelField = .intestazione
             return false }
       
         guard checkTipologiaMenu() else { return false }
        
         guard checkProgrammazione() else { return false }
        
        /* if self.nuovoMenu.dishInDEPRECATO.isEmpty { self.nuovoMenu.status = .bozza()}
         else {  self.nuovoMenu.status = .completo(.archiviato) } */ // 16.09
       
         guard !self.nuovoMenu.rifDishIn.isEmpty else {
            /* self.nuovoMenu.status = .bozza(.inPausa)*/
             return true
         }
         
        /* if self.nuovoMenu.optionalComplete() {
             self.nuovoMenu.status = .completo(.disponibile)
         } else { self.nuovoMenu.status = .bozza(.disponibile)}*/
         self.viewModel.logMessage = "[ERRORE]_SVILUPPARE CAMBIO STATUS MENU in CHECK PRELIMINARE"
         // Innesto 16_11_23
         
        return checkNotExistSimilar()
         
         }
     
     private func checkNotExistSimilar() -> Bool {
         
         if self.viewModel.checkModelNotInVM(itemModel: nuovoMenu) { return true }
         else {
             self.viewModel.alertItem = AlertModel(
                  title: "Controllare",
                  message: "Hai già creato un Menu con questo nome e caratteristiche")
              
            return false
             }
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
     
     // viewBuilder
     
     @ViewBuilder private func saveButtonDialogView() -> some View {

         csBuilderDialogButton {
             
             // nuovo Menu
             DialogButtonElement(
                 label: .saveNew) {
                     self.menuArchiviato.intestazione == ""
                 } action: {
                     
                     self.viewModel.createOrUpdateModelOnSub(
                         itemModel: self.nuovoMenu)
                     self.salvaECreaPostAction()
                     
                 }

             DialogButtonElement(
                 label: .saveEsc) {
                     self.menuArchiviato.intestazione == ""
                 } action: {
                     
                     self.viewModel.createOrUpdateModelOnSub(
                         itemModel: self.nuovoMenu,
                         refreshPath: self.destinationPath)
                    
                 }
             
            // modifica menu
             
             DialogButtonElement(
                 label: .saveModNew) {
                     self.menuArchiviato.intestazione != ""
                 } action: {
                     
                     self.viewModel.createOrUpdateModelOnSub(
                         itemModel: self.nuovoMenu)

                     self.salvaECreaPostAction()// BUG -> deve partire se dall'update non torna un errore - Da sistemare
                    
                 }
             
             DialogButtonElement(
                 label: .saveModEsc) {
                     self.menuArchiviato.intestazione != ""
                 } action: {
                     
                     self.viewModel.createOrUpdateModelOnSub(
                         itemModel: self.nuovoMenu,
                         refreshPath: self.destinationPath)
                    
                 }

            // salva come nuovo
             
             DialogButtonElement(
                 label: .saveAsNew,
                 extraLabel: "Menu") {
                     self.menuArchiviato.intestazione != "" &&
                     self.menuArchiviato.intestazione != self.nuovoMenu.intestazione
                     
                 } action: {
                     
                     var new = self.nuovoMenu
                     new.id = UUID().uuidString
                    
                     self.viewModel.createOrUpdateModelOnSub(
                         itemModel: new,
                         refreshPath: self.destinationPath)
                    
                 }
             
         } // chiusa result builder

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
         NuovoMenuMainView(nuovoMenu: menuItem, backgroundColorView: Color.seaTurtle_1, destinationPath: .menuList ,saveDialogType: .completo)
     }
 }
 
 */ // backup 13.02.24
