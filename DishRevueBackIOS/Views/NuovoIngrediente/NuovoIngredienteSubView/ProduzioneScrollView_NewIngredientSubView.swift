//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct ProduzioneScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel
    let generalErrorCheck: Bool
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(
                placeHolder: "Etichetta di Produzione",
                imageNameOrEmojy: "gearshape.2.fill",
                backgroundColor: Color.black) {
                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoIngrediente.produzione == .defaultValue)
                }
            
            PropertyScrollCases(cases: ProduzioneIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.produzione, colorSelection: Color.green)
        
        }
    }
}
