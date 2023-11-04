//
//  SwitchNewDishType.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/10/22.
//

import SwiftUI
import MyFoodiePackage

struct SwitchProductType: View {

    @Binding var percorsoItem: ProductModel.PercorsoProdotto
    let nascondiTesto:Bool
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Picker(selection: $percorsoItem) {
                
                ForEach(ProductModel.PercorsoProdotto.allCases,id:\.self) { percorso in
                    
                        Text(percorso.pickerDescription())
                        .tag(percorso)
                        
                }
                
                
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)

            if !nascondiTesto {
                Text(percorsoItem.extendedDescription())
                    .italic()
                    .font(.caption)
                    .foregroundStyle(Color.black)
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
