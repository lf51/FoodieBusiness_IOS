//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct ProduzioneScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1Button(placeHolder: "Etichetta di Produzione", imageNameOrEmojy: "gearshape.2.fill", backgroundColor: Color.black)
            
            PropertyScrollCases(cases: ProduzioneIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.produzione, colorSelection: Color.green)
                
            
        }
    }
}
