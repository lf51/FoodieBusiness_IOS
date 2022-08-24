//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//  Last deeper Modifing terminate 16.07

import SwiftUI

struct NewDishMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @State private var newDish: DishModel
    let backgroundColorView: Color
    
    let piattoArchiviato: DishModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    @State private var wannaAddIngredient: Bool = false
    
    @State private var areAllergeniOk: Bool = false
    @State private var confermaDiete: Bool = false
    
    init(newDish: DishModel,backgroundColorView: Color, destinationPath:DestinationPath) {
        
        _newDish = State(wrappedValue: newDish)
        self.backgroundColorView = backgroundColorView
        
        self.piattoArchiviato = newDish
        self.destinationPath = destinationPath
    }
    
    var body: some View {
       
        CSZStackVB(title: self.newDish.intestazione == "" ? "Nuovo Piatto" : self.newDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {

                CSDivider()
                    
                    ScrollView { // La View Mobile

                        VStack(alignment:.leading) {
                                
                            IntestazioneNuovoOggetto_Generic(
                                    itemModel: $newDish,
                                    generalErrorCheck: generalErrorCheck,
                                    minLenght: 3,
                                    coloreContainer: Color("SeaTurtlePalette_2"))
 
                            BoxDescriptionModel_Generic(itemModel: $newDish, labelString: "Descrizione (Optional)", disabledCondition: wannaAddIngredient)
                            
                            CategoriaScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck)
                            
                            PannelloIngredienti_NewDishSubView(newDish: newDish, generalErrorCheck: generalErrorCheck, wannaAddIngredient: $wannaAddIngredient)
                                
                            AllergeniScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck, areAllergeniOk: $areAllergeniOk)
 
                            DietScrollView_NewDishSub(newDish: $newDish, confermaDiete: $confermaDiete)
 
                            DishSpecific_NewDishSubView(allDishFormats: $newDish.pricingPiatto, generalErrorCheck: generalErrorCheck)
 
                         //   Spacer()
                            
                            BottomViewGeneric_NewModelSubView(
                                itemModel: $newDish,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: piattoArchiviato,
                                destinationPath: destinationPath) {
                                    self.infoPiatto()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }

                                    
                         /*   BottomViewGeneric_NewModelSubView(generalErrorCheck:$generalErrorCheck, wannaDisableButtonBar:(newDish == piattoArchiviato)) {
                                infoPiatto()
                            } resetAction: {
                                csResetModel(modelAttivo: &self.newDish, modelArchiviato: self.piattoArchiviato)
                            } checkPreliminare: {
                                checkPreliminare()
                            } saveButtonDialogView: {
                                vbScheduleANewDish()
                            } */
                            
                        }
                    .padding(.horizontal)
     
                    }
                    .zIndex(0)
                    .opacity(wannaAddIngredient ? 0.6 : 1.0)
                    .disabled(wannaAddIngredient)
    
                if wannaAddIngredient {
           
                   /* SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient, action: () -> Void) */
                    
                    SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient,
                        backgroundColorView: backgroundColorView,
                        actionTitle: "[+] Ingrediente") {
                            
                            viewModel.addToThePath(
                                destinationPath: destinationPath,
                                destinationView: .ingrediente(IngredientModel()))
                            
                        }
                    
                }
            
                CSDivider() // risolve il problema del cambio colore della tabView
            //    } // end ZStack Interno

            }
      
        } // end ZStack Esterno
    }
    
    // Method
    
    private func resetAction() {
        
        self.newDish = self.piattoArchiviato
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        self.confermaDiete = false

    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        self.newDish = DishModel()
    }
    
    private func infoPiatto() -> Text {
           
        var stringIngredientiPrincipali:[String] = []
        var stringIngredientiSecondari:[String] = []
        var stringAllergeni:[String] = []
        
        var stringValueAllergeni = "Nessun allergene indicato negli ingredienti."
        
        for ingredient in self.newDish.ingredientiPrincipali {
            
            let stringValue = ingredient.intestazione
            stringIngredientiPrincipali.append(stringValue)
            
        }
        
        for ingredient in self.newDish.ingredientiSecondari {
            
            let stringValue = ingredient.intestazione
            stringIngredientiSecondari.append(stringValue)
            
        }
        
        if !self.newDish.allergeni.isEmpty {
            
            for allergene in self.newDish.allergeni {
                
                let stringValue = allergene.simpleDescription()
                stringAllergeni.append(stringValue)
                
            }
            stringValueAllergeni = "Indicata la presenza degli allergeni:"
        }
        
        return Text("\(self.newDish.intestazione)\n\(stringIngredientiPrincipali,format: .list(type: .and))\n\(stringValueAllergeni) \(stringAllergeni,format: .list(type: .and))")
            
           
    }
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else { return false }
      
        guard checkIngredienti() else { return false }
       
        guard checkAllergeni() else { return false }
        
        guard checkCategoria() else { return false }
       
        guard checkFormats() else { return false }
       
        self.newDish.status = .completo(.archiviato) // vedi Nota Consegna 17.07
        return true
        
    }
    
    private func checkAllergeni() -> Bool {

        return self.areAllergeniOk
    }
    
    private func checkCategoria() -> Bool {
        
       return self.newDish.categoriaMenu != .defaultValue
    }
    
    private func checkIngredienti() -> Bool {
        
        return !self.newDish.ingredientiPrincipali.isEmpty
    }
    
    private func checkIntestazione() -> Bool {
    
        return self.newDish.intestazione != ""
        // i controlli sono già eseguiti all'interno sulla proprietà temporanea, se il valore è stato passato al newDish vuol dire che è buono. Per cui basta controllare se l'intestazione è diversa dal valore vuoto

    }
    
    private func checkFormats() -> Bool {
         
        guard self.newDish.pricingPiatto.count > 1 else {
            
            let price = self.newDish.pricingPiatto[0].price
            
            return csCheckDouble(testo: price)
            
        }
        
        for format in self.newDish.pricingPiatto {
            
            if !csCheckStringa(testo: format.label, minLenght: 3) { return false }
            else if !csCheckDouble(testo: format.price) { return false }
            
            }
        return true
      }
    
    /*
     @ViewBuilder private func vbScheduleANewDish() -> some View {
         
         if self.piattoArchiviato.intestazione == "" {
             // crea un Nuovo Oggetto
             Group {
                 
                 Button("Salva e Crea Nuovo", role: .none) {
                     
                 self.viewModel.createItemModel(itemModel: self.newDish)
                 self.newDish = DishModel()
                     
                 }
                 
                 Button("Salva ed Esci", role: .none) {
                     
                 self.viewModel.createItemModel(itemModel: self.newDish,destinationPath: destinationPath)
                 }

             }
         }
         
         else if self.piattoArchiviato.intestazione == self.newDish.intestazione {
             // modifica l'oggetto corrente
             
             Group { vbEditingSaveButton() }
         }
         
         else {
             
             Group {
                 
                 vbEditingSaveButton()
                 
                 Button("Salva come Nuovo Piatto", role: .none) {
                     
                 self.viewModel.createItemModel(itemModel: self.newDish,destinationPath: destinationPath)
                 }
             }
         }
     }
     
     @ViewBuilder private func vbEditingSaveButton() -> some View {
         
         Button("Salva Modifiche e Crea Nuovo", role: .none) {
             
         self.viewModel.updateItemModel(itemModel: self.newDish)
         self.newDish = DishModel()
         }
         
         Button("Salva Modifiche ed Esci", role: .none) {
             
         self.viewModel.updateItemModel(itemModel: self.newDish, destinationPath: destinationPath)
         }
         
         
     }
     */
}




struct NewDishMainView_Previews: PreviewProvider {

    static var previews: some View {
        
        NavigationStack {
            
            NewDishMainView(newDish: DishModel(), backgroundColorView: Color("SeaTurtlePalette_1"), destinationPath: .dishList)
            
        }.environmentObject(AccounterVM())
    }
}


