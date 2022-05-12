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
    
    var backgroundColorView: Color
    
    var body: some View {
        
        if wannaCreateIngredient! {
                    
            NuovoIngredienteMainView(backgroundColorView: backgroundColorView, dismissButton: $wannaCreateIngredient)

                }
        
        if wannaProgramAndPublishNewDish {
                    
           Text("Scheda Pubblicazione e Programmazione Piatto")

                }
   
        if wannaAddIngredient! {
            
          //  SelettoreIngrediente_NewDishSubView(newDish: $newDish)
           /* SelettoreIngrediente_NewDishSubView<_,IngredientModel>(itemModel: $newDish, elencoModelList: [.itemModelContainer("IngredientiPrincipali"),.itemModelContainer("IngredientiSecondari"),.viewModelContainer("allMyIngredients",\.allMyIngredients),.viewModelContainer("allFromCommunity",\.allTheCommunityIngredients)]) */
         
         /*   SelettoreIngrediente_NewDishSubView<_, IngredientModel>(
                itemModel: $newDish,
                elencoModelList: [
                    ElencoModelList<DishModel, IngredientModel>.itemModelContainer(\.ingredientiPrincipali),
                    .viewModelContainer(\.allMyIngredients),
                    .itemModelContainer(\.ingredientiSecondari)
                                 ]) */
             
            SelettoreIngrediente_NewDishSubView<_,IngredientModel>(
                itemModel: $newDish,
                elencoModelList: ModelList.dishIngredientsList)
            
          
            
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
