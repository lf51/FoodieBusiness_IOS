//
//  ConditionalZStack_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct ConditionalZStackView_NewDishSubView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @ObservedObject var accounterVM: AccounterVM
    
    @Binding var newDish: DishModel
    @Binding var wannaAddIngredient: Bool?
   // @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var wannaCreateIngredient: Bool?
    @Binding var wannaProgramAndPublishNewDish: Bool
    
    var backGroundColorView: Color
    
    var body: some View {
        
        if wannaCreateIngredient! {
                    
            NuovoIngredienteMainView(propertyVM: propertyVM, accounterVM: accounterVM, backGroundColorView: backGroundColorView, dismissButton: $wannaCreateIngredient)

                }
        
        if wannaProgramAndPublishNewDish {
                    
           Text("Scheda Pubblicazione e Programmazione Piatto")

                }
   
        if wannaAddIngredient! {
            
            SelettoreIngrediente_NewDishSubView(propertyVM: propertyVM, accounterVM: accounterVM, newDish: $newDish)
         
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
