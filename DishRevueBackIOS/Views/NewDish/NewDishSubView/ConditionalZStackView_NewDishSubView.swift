//
//  ConditionalZStack_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct ConditionalZStackView_NewDishSubView: View {
    
   // @ObservedObject var propertyVM: PropertyVM
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var newDish: DishModel
    @Binding var wannaAddIngredient: Bool?
   // @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var wannaCreateIngredient: Bool?
    @Binding var wannaProgramAndPublishNewDish: Bool
    
    var backGroundColorView: Color
    
    var body: some View {
        
        if wannaCreateIngredient! {
                    
            NuovoIngredienteMainView(backGroundColorView: backGroundColorView, dismissButton: $wannaCreateIngredient)

                }
        
        if wannaProgramAndPublishNewDish {
                    
           Text("Scheda Pubblicazione e Programmazione Piatto")

                }
   
        if wannaAddIngredient! {
            
            SelettoreIngrediente_NewDishSubView(newDish: $newDish)
         
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
