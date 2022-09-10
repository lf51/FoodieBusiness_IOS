//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct ProvenienzaScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel
  //  let generalErrorCheck: Bool

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1Button(
                placeHolder: "Luogo di Produzione (Optional)",
                imageNameOrEmojy: "globe",
                backgroundColor: Color.black)
            
          /*  CSLabel_conVB(
                placeHolder: "Luogo di Produzione",
                imageNameOrEmojy: "globe",
                backgroundColor: Color.black) {
                    
                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoIngrediente.provenienza == .defaultValue)
                } */
            
            PropertyScrollCases(cases: ProvenienzaIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.provenienza, colorSelection: Color.brown)

        }
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
