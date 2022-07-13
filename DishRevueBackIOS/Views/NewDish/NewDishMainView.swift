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
    
    @State private var wannaDeleteIngredient: Bool? = false // attiva l'eliminazione degli ingredienti
    @State private var wannaAddIngredient: Bool? = false // apre per tuttiGliIngredienti
 //   @State var openAddingIngredienteSecondario: Bool? = false // in disuso // da eliminare
    @State private var wannaCreateIngredient: Bool? = false
    @State private var wannaProgramAndPublishNewDish: Bool = false
    
    init(newDish: DishModel,backgroundColorView: Color, destinationPath:DestinationPath) {
        
        _newDish = State(wrappedValue: newDish)
        self.backgroundColorView = backgroundColorView
        
        self.piattoArchiviato = newDish
        self.destinationPath = destinationPath
    }
    
    private var isThereAReasonToDisabled: Bool {
        
       wannaAddIngredient! || wannaCreateIngredient! || wannaDeleteIngredient!
        
    }
    
    var body: some View {
       
        CSZStackVB(title: self.newDish.intestazione == "" ? "Nuovo Piatto" : self.newDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {

                CSDivider()
                    
                    ScrollView { // La View Mobile

                        VStack(alignment:.leading) {
                            
                            Group {
                                
                                IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Piatto (\(self.newDish.status.simpleDescription().capitalized))", imageLabel: self.newDish.status.imageAssociated(),imageColor: self.newDish.status.transitionStateColor(), coloreContainer: Color("SeaTurtlePalette_2"), itemModel: $newDish)
                                
                                PannelloIngredienti_NewDishSubView(newDish: newDish, wannaAddIngredient: $wannaAddIngredient)
                                
                                SelectionPropertyDish_NewDishSubView(newDish: $newDish)
                                
                                DishSpecific_NewDishSubView(newDish: $newDish)
                                
                                
                            }
                            .opacity(isThereAReasonToDisabled ? 0.4 : 1.0)
                            .disabled(isThereAReasonToDisabled)
                            
                            Spacer()
                            
                         
                            
                            
                            
                            BottomViewGeneric_NewModelSubView(
                                wannaDisableSaveButton: false) {
                                    infoPiatto()
                                } resetAction: {
                                    resetModel(modelAttivo: &self.newDish, modelArchiviato: self.piattoArchiviato)
                                } saveButtonDialogView: {
                                    scheduleANewDish()
                                }
                            
                            
                        }
                    .padding(.horizontal)
     
                    }
                    .zIndex(0)
                    .onTapGesture {
                        print("TAP ON Entire SCROLL VIEW") // funziona su tutto tranne che sui menu orizzontali che abbiamo disabilitato ad hoc.
                        self.wannaDeleteIngredient = false
                     //   self.wannaAddIngredient = false
                      // self.openAddingIngredienteSecondario = false
                    }
        
                ConditionalZStackView_NewDishSubView(newDish: $newDish, backgroundColorView: backgroundColorView, conditionOne: $wannaAddIngredient, conditionTwo: $wannaCreateIngredient, conditionThree: $wannaProgramAndPublishNewDish)
                    
                   
                CSDivider() // risolve il problema del cambio colore della tabView
            //    } // end ZStack Interno

                
            }
            .zIndex(1)
            
          
        } // end ZStack Esterno
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
      /*  .alert(item:$newDish.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         } */
    }
    
    // Method
    
    private func infoPiatto() -> Text {
        
        Text("No Description Yet")
    }
    
    @ViewBuilder private func scheduleANewDish() -> some View {
        
        //self.newDish.dieteCompatibili = [.glutenFree]
        
        
        if self.piattoArchiviato.intestazione == "" {
            // crea un Nuovo Oggettp
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
            
            Group {
                
                vbEditingSaveButton()

            }
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
    
}




/*struct NewDishMAINView_Previews: PreviewProvider {
    static var previews: some View {
        NewDishMAINView()
    }
} */


