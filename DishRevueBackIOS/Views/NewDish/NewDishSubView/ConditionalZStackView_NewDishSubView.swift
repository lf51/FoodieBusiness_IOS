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
  //  @Binding var wannaMakeDietAvaible: Bool?
    
    var backgroundColorView: Color
    
    var body: some View {
        
        if wannaCreateIngredient! {
                    
           // NuovoIngredienteMainView(backgroundColorView: backgroundColorView, dismissButton: $wannaCreateIngredient)

                } // Deprecata in futuro - Sostituire con un NavLink
        
        if wannaProgramAndPublishNewDish {
                    
           Text("Scheda Pubblicazione e Programmazione Piatto")

                }
   
        if wannaAddIngredient! {
   
            SelettoreMyModel<_,IngredientModel>(
                itemModel: $newDish,
                allModelList: ModelList.dishIngredientsList,
                closeButton: $wannaAddIngredient)
            
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
