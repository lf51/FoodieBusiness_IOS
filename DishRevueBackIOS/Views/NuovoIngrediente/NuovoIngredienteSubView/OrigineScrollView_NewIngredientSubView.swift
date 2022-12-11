//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct OrigineScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel
    let generalErrorCheck: Bool

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(
                placeHolder: "Origine",
                imageNameOrEmojy: "arrow.3.trianglepath",
                backgroundColor: Color.black) {
                    
                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoIngrediente.origine == .defaultValue)
                }
            
            PropertyScrollCases(cases: OrigineIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.origine, colorSelection: Color.indigo)

        }
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
