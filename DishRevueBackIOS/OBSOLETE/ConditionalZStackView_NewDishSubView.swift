//
//  ConditionalZStack_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI
import MyFoodiePackage

struct ConditionalZStackView_NewDishSubView: View {

  //  @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var newDish: DishModel
  //  var backgroundColorView: Color
    
    @Binding var conditionOne: Bool? 
    @Binding var conditionTwo: Bool?
    @Binding var conditionThree: Bool?
    
    var body: some View {
        
        if conditionOne ?? false {
   
         /*   SelettoreMyModel<_,IngredientModel>(
                itemModel: $newDish,
                allModelList: ModelList.dishIngredientsList,
                closeButton: $conditionOne) */
            
        }
        
       else if conditionTwo ?? false {
                    
           Text("Condizione DUE")

                }
        
       else if conditionThree ?? false {
                    
           Text("Condizione TRE")

                }
  
    }
    // Method

    
} // Deprecated 15.07

/*struct ConditionalZStackView_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionalZStackView_NewDishSubView()
    }
}
*/
