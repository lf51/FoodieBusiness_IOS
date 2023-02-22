//
//  SwitchNewDishType.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/10/22.
//

import SwiftUI
import MyFoodiePackage

struct SwitchProductType: View {

    @Binding var type:DishModel.PercorsoProdotto
    let nascondiTesto:Bool
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Picker(selection: $type) {
              
                Text("Food")
                    .tag(DishModel.PercorsoProdotto.preparazioneFood)
                Text("Beverage")
                    .tag(DishModel.PercorsoProdotto.preparazioneBeverage)
                Text("Prodotto di Terzi")
                    .tag(DishModel.PercorsoProdotto.prodottoFinito)
                
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)

            if !nascondiTesto {
                Text(type.extendedDescription())
                    .italic()
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(0.75)
            }
        }
        

    }
}

/*
struct SwitchNewDishType_Previews: PreviewProvider {
    static var previews: some View {
        SwitchProductType(newDish: )
    }
}
*/
