//
//  ConditionalZStack_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct ConditionalZStackView_NewDishSubView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    
    @Binding var newDish: DishModel
    @Binding var openAddingIngredientePrincipale: Bool?
    @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var openCreaNuovoIngrediente: Bool?
    @Binding var openProgrammaEPubblica: Bool
    
    var backGroundColorView: Color
    
    var body: some View {
        
        if openCreaNuovoIngrediente! {
                    
        NuovoIngredienteMainView(propertyVM: propertyVM, backGroundColorView: backGroundColorView, dismissButton: $openCreaNuovoIngrediente)

                }
        
        if openProgrammaEPubblica {
                    
           Text("Scheda Pubblicazione e Programmazione Piatto")

                }
   
        if openAddingIngredientePrincipale! {
            
            SelettoreIngrediente_NewDishSubView(propertyVM: propertyVM, newDish: $newDish)
         
        }
        
    
    }
    // Method

    
}

/*struct ConditionalZStackView_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionalZStackView_NewDishSubView()
    }
}
*/
