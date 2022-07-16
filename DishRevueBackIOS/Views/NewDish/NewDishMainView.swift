//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct NewDishMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @State private var newDish: DishModel
    let backgroundColorView: Color
    
    let piattoArchiviato: DishModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    @State private var wannaAddIngredient: Bool? = false
    
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
 
                                PannelloIngredienti_NewDishSubView(newDish: newDish, generalErrorCheck: generalErrorCheck, wannaAddIngredient: $wannaAddIngredient)
                                
                                SelectionPropertyDish_NewDishSubView(newDish: $newDish, generalErrorCheck:generalErrorCheck)
 
                                DishSpecific_NewDishSubView(allDishFormats: $newDish.pricingPiatto, generalErrorCheck: generalErrorCheck)
 
                            
                            Spacer()
                                    
                            BottomViewGeneric_NewModelSubView(generalErrorCheck:$generalErrorCheck, wannaDisableButtonBar:(newDish == piattoArchiviato)) {
                                infoPiatto()
                            } resetAction: {
                                resetModel(modelAttivo: &self.newDish, modelArchiviato: self.piattoArchiviato)
                            } checkPreliminare: {
                                checkPreliminare()
                            } saveButtonDialogView: {
                                vbScheduleANewDish()
                            }
                            
                        }
                    .padding(.horizontal)
     
                    }
                    .zIndex(0)
                    .opacity(wannaAddIngredient! ? 0.6 : 1.0)
                    .disabled(wannaAddIngredient!)
    
                if wannaAddIngredient! {
           
                    SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient)
                    
                }
            
                CSDivider() // risolve il problema del cambio colore della tabView
            //    } // end ZStack Interno

            }
      
        } // end ZStack Esterno
    }
    
    // Method
    
    private func infoPiatto() -> Text {
        
        Text("Da Implementare")
    }
    
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
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else { return false }
      
        guard checkIngredienti() else { return false }
       
        guard checkAllergeni() else { return false }
        
        guard checkCategoria() else { return false }
       
        guard checkFormats() else { return false }
       
        return true
        
    }
    
    private func checkAllergeni() -> Bool {

        return self.newDish.areAllergeniOk
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
    
    
}




/*struct NewDishMAINView_Previews: PreviewProvider {
    static var previews: some View {
        NewDishMAINView()
    }
} */


