//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage

struct ConservazioneScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel
    let generalErrorCheck: Bool
    
  //  @Binding var isConservazioneOk: Bool
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(
                placeHolder: "Conservazione",
                imageNameOrEmojy: "thermometer",
                backgroundColor: Color.black) {
                    
                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: self.nuovoIngrediente.conservazione == .defaultValue)
                    
                   /* Toggle(isOn: self.$isConservazioneOk) {
                        
                        HStack {
                            Spacer()
                            Text(self.isConservazioneOk ? "Confermato" : "Da Confermare")
                                .font(.system(.callout, design: .monospaced)) */
                            
                         /*   CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.isConservazioneOk) */
   
                    //    }
                  //  }
                
                    
                }
                
            PropertyScrollCases(cases: ConservazioneIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.conservazione, colorSelection: Color.cyan)
             
                
        }/*.onChange(of: self.nuovoIngrediente.conservazione) { _ in
            self.isConservazioneOk = false
        } */
        
    }
}
