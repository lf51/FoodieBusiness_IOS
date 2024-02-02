//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct ProduzioneScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientSubModel
  //  let generalErrorCheck: Bool
    
    var body: some View {
        
        VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
            
            CSLabel_1Button(
                placeHolder: "Produzione di qualità (Optional)",
                imageNameOrEmojy: "gearshape.2.fill",
                backgroundColor: Color.black)
            
          /*  CSLabel_conVB(
                placeHolder: "Metodo di Produzione (Optional)",
                imageNameOrEmojy: "gearshape.2.fill",
                backgroundColor: Color.black) {
                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoIngrediente.produzione == .defaultValue)
                } */
            
            PropertyScrollCases(cases: ProduzioneIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.produzione, colorSelection: Color.green)
        
        }
    }
}
