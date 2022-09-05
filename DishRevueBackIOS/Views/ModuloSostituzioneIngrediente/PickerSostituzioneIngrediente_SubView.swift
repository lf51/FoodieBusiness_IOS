//
//  SostituzioneIngredienteView_NewIngredientSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/07/22.
//

import SwiftUI

struct PickerSostituzioneIngrediente_SubView: View {
    
    let mapArray:[IngredientModel]
    @Binding var modelSostitutoGlobale: IngredientModel?
  //  @Binding var idSostitutoGlobale: String?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_conVB(
                placeHolder: "Ovunque con:",
                imageNameOrEmojy: "arrow.left.arrow.right.circle",
                backgroundColor: Color.black) {
                    
                    Picker(selection: $modelSostitutoGlobale) {
                        
                     //   if nomeIngredienteSostituto == "" {
                        Text(modelSostitutoGlobale == nil ? "Scegli" : "Annulla Selezione")
                                .tag(nil as IngredientModel?)
                               // .tag("SCEGLI") // seza il tag non è selezionabile, ovvero il valore non viene passato e quindi lo possiamo usare come "segnaposto"
                     //   }
                        
                        ForEach(mapArray,id:\.self) { ingredient in
                            
                            Text(ingredient.intestazione)
                                .tag(ingredient as IngredientModel?)

                            }
                        
                    } label: {
                        Text("Pick")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(Color("SeaTurtlePalette_3"))
                    .padding(.horizontal)
                    .background(
                  
                  RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color("SeaTurtlePalette_2").opacity(0.4))
                      .shadow(radius: 1.0)
              )

                }
        }
    }
}
