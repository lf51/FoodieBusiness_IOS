//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct NewDishMainView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @ObservedObject var accounterVM: AccounterVM // ATTUALMENTE NON UTILIZZATO
    var backGroundColorView: Color
    
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
       
        ZStack {
            
            backGroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack {
                
               TopBar_3BoolPlusDismiss(title: newDish.intestazione != "" ? newDish.intestazione : "New Dish", enableEnvironmentDismiss: true, doneButton: $wannaAddIngredient, exitButton: $wannaCreateIngredient, cancelButton: $wannaDeleteIngredient)
                    .padding()
                    .background(Color.cyan)
        
                
                Spacer()
                
                ZStack {
                    
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
                        
                    }
                    .zIndex(0)
                    .onTapGesture {
                        print("TAP ON Entire SCROLL VIEW") // funziona su tutto tranne che sui menu orizzontali che abbiamo disabilitato ad hoc.
                        self.wannaDeleteIngredient = false
                     //   self.wannaAddIngredient = false
                      // self.openAddingIngredienteSecondario = false
                    }
        
                    ConditionalZStackView_NewDishSubView(propertyVM: propertyVM, accounterVM: accounterVM, newDish: $newDish, wannaAddIngredient: $wannaAddIngredient, wannaCreateIngredient: $wannaCreateIngredient, wannaProgramAndPublishNewDish: $wannaProgramAndPublishNewDish, backGroundColorView: backGroundColorView)
                    
                    
                } // end ZStack Interno
                
                Spacer()
                
                BottonBar_NewDishSubView(accounterVM: accounterVM, newDish: $newDish, wannaProgramAndPublishNewDish: $wannaProgramAndPublishNewDish)
                    .padding()
                    .background(Color.cyan)
                    .opacity(isThereAReasonToDisabled ? 0.4 : 1.0)
                    .disabled(isThereAReasonToDisabled || self.newDish.intestazione == "")
                
            }.zIndex(1)
          
        } // end ZStack Esterno
        .alert(item:$newDish.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         }
    }
}

/*struct NewDishMAINView_Previews: PreviewProvider {
    static var previews: some View {
        NewDishMAINView()
    }
} */


