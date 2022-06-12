//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct NewDishMainView: View {
    
   // @ObservedObject var propertyVM: PropertyVM
    @EnvironmentObject var viewModel: AccounterVM // ATTUALMENTE NON UTILIZZATO
    let backgroundColorView: Color
    
    @State var newDish: DishModel = DishModel() // ogni volta che parte la view viene creato un piatto vuoto, lo modifichiamo e lo aggiungiamo alla dishlist.
    @State var wannaDeleteIngredient: Bool? = false // attiva l'eliminazione degli ingredienti
    @State var wannaAddIngredient: Bool? = false // apre per tuttiGliIngredienti
 //   @State var openAddingIngredienteSecondario: Bool? = false // in disuso // da eliminare
    @State var wannaCreateIngredient: Bool? = false
    @State var wannaProgramAndPublishNewDish: Bool = false 
    
    private var isThereAReasonToDisabled: Bool {
        
       wannaAddIngredient! || wannaCreateIngredient! || wannaDeleteIngredient!
        
    }
    
    var body: some View {
       
        CSZStackVB(title: "Nuovo Piatto", backgroundColorView: backgroundColorView) {
            
         //   backgroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack {
                
           /*    TopBar_3BoolPlusDismiss(title: newDish.intestazione != "" ? newDish.intestazione : "New Dish", enableEnvironmentDismiss: true, doneButton: $wannaAddIngredient, exitButton: $wannaCreateIngredient, cancelButton: $wannaDeleteIngredient)
                    .padding()
                    .background(Color.cyan)
        
                
                Spacer() */
                
            //    ZStack {
                CSDivider()
                    
                    ScrollView { // La View Mobile

                    VStack(alignment:.leading) {
                             
                    IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Piatto", imageLabel: "doc.badge.plus", coloreContainer: Color.green, itemModel: $newDish)
                        
                    PannelloIngredienti_NewDishSubView(newDish: $newDish, wannaDeleteIngredient: $wannaDeleteIngredient, wannaAddIngredient: $wannaAddIngredient, wannaCreateIngredient: $wannaCreateIngredient)

                    SelectionPropertyDish_NewDishSubView(newDish: $newDish)
                    DishSpecific_NewDishSubView(newDish: $newDish)
           
                        }
                    .padding(.horizontal)
                    .opacity(isThereAReasonToDisabled ? 0.4 : 1.0)
                    .disabled(isThereAReasonToDisabled)
                        
                        
                        Spacer()
                        
                        BottomBar_NewDishSubView(newDish: $newDish, wannaProgramAndPublishNewDish: $wannaProgramAndPublishNewDish)
                            .padding()
                          //  .background(Color.cyan)
                            .opacity(isThereAReasonToDisabled ? 0.4 : 1.0)
                            .disabled(isThereAReasonToDisabled || self.newDish.intestazione == "")
                        
                        
                    }
                    .zIndex(0)
                    .onTapGesture {
                        print("TAP ON Entire SCROLL VIEW") // funziona su tutto tranne che sui menu orizzontali che abbiamo disabilitato ad hoc.
                        self.wannaDeleteIngredient = false
                     //   self.wannaAddIngredient = false
                      // self.openAddingIngredienteSecondario = false
                    }
        
                    ConditionalZStackView_NewDishSubView(newDish: $newDish, wannaAddIngredient: $wannaAddIngredient, wannaCreateIngredient: $wannaCreateIngredient, wannaProgramAndPublishNewDish: $wannaProgramAndPublishNewDish, backgroundColorView: backgroundColorView)
                    
                   
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
}

/*struct NewDishMAINView_Previews: PreviewProvider {
    static var previews: some View {
        NewDishMAINView()
    }
} */


