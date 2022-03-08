//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct NewDishMainView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @ObservedObject var dishVM: DishVM // ATTUALMENTE NON UTILIZZATO
    var backGroundColorView: Color
    
    @State var newDish: DishModel = DishModel() // ogni volta che parte la view viene creato un piatto vuoto, lo modifichiamo e lo aggiungiamo alla dishlist.
  //  @Binding var openNewDish: Bool // dismiss button
    @State var activeDelection: Bool = false // attiva l'eliminazione degli ingredienti
    @State var openAddingIngredientePrincipale: Bool? = false // apre per tuttiGliIngredienti
    @State var openAddingIngredienteSecondario: Bool? = false // in disuso // da eliminare
    @State var openCreaNuovoIngrediente: Bool? = false
    @State var openProgrammaEPubblica: Bool = false
    
    private var isThereAReasonToDisabled: Bool {
        
       openAddingIngredienteSecondario! || openAddingIngredientePrincipale! || openCreaNuovoIngrediente! || activeDelection
        
    }
    
    var body: some View {
       
        ZStack {
            
            backGroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack {
                
                TopBar_NewDishSubView(newDish: $newDish, openAddingIngredientePrincipale: $openAddingIngredientePrincipale, openAddingIngredienteSecondario: $openAddingIngredienteSecondario, openCreaNuovoIngrediente: $openCreaNuovoIngrediente, activeDelection: $activeDelection)
                    .padding()
                    .background(Color.cyan)
                
                Spacer()
                
                ZStack {
                    
                    ScrollView { // La View Mobile

                    VStack(alignment:.leading) {
                                    
                    InfoGenerali_NewDishSubView(newDish: $newDish, activeDelection: $activeDelection, openAddingIngredientePrincipale: $openAddingIngredientePrincipale, openAddingIngredienteSecondario: $openAddingIngredienteSecondario, openCreaNuovoIngrediente: $openCreaNuovoIngrediente)

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
                        self.activeDelection = false
                        self.openAddingIngredientePrincipale = false
                        self.openAddingIngredienteSecondario = false
                    }
                    
                   
                    ConditionalZStackView_NewDishSubView(propertyVM: propertyVM, newDish: $newDish, openAddingIngredientePrincipale: $openAddingIngredientePrincipale, openAddingIngredienteSecondario: $openAddingIngredienteSecondario, openCreaNuovoIngrediente: $openCreaNuovoIngrediente, openProgrammaEPubblica: $openProgrammaEPubblica, backGroundColorView: backGroundColorView)
                    
                    
                } // end ZStack Interno
                
                Spacer()
                
                BottonBar_NewDishSubView(dishVM: dishVM, newDish: $newDish, openProgrammaEPubblica: $openProgrammaEPubblica)
                    .padding()
                    .background(Color.cyan)
                    .opacity(isThereAReasonToDisabled ? 0.4 : 1.0)
                    .disabled(isThereAReasonToDisabled || self.newDish.name == "")
                
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


