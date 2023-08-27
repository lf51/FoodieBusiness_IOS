//
//  VistaAllergeni_Selectable.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/02/23.
//

import SwiftUI
import MyFilterPackage
import MyFoodiePackage
import MyPackView_L0

struct VistaAllergeni_Selectable: View {
    
    @Binding var allergeneIn:[AllergeniIngrediente]?
    let backgroundColorView:Color

    init(allergeneIn: Binding<[AllergeniIngrediente]?>,backgroundColor:Color) {
        
        _allergeneIn = allergeneIn
        self.backgroundColorView = backgroundColor
    }
    
    var body: some View {
       
     /* FilterAndSort_PopView(
        backgroundColorView: backgroundColorView,
        label: "Seleziona Allergeni") {
            self.allergeneIn = []
        } content: {
            
            let allCases = AllergeniIngrediente.allCases
        
            VStack(alignment:.leading) {
                
                MyFilterRow(
                    allCases: allCases,
                    filterCollection: $allergeneIn,
                    selectionColor: .red.opacity(0.7),
                    imageOrEmoji: "allergens",
                    label: "In: \(allergeneIn?.count ?? 0) su \(allCases.count)"
                ) { value in
                    let allergens = self.allergeneIn ?? []
                    if let index = allergens.firstIndex(of: value) {
                        return index + 1
                    } else {
                        return 0
                    }
                }
                Text("Il numero indica l'ordine di inserimento. Al cliente saranno comunque mostrati in ordine alfabetico.")
                    .italic()
                    .font(.caption2)
                    .foregroundStyle(Color.black)
                    .opacity(0.8)
            }
        } */

        CSZStackVB(
            title: "Seleziona Allergeni",
            titlePosition: .bodyEmbed([.top,.horizontal],15),
            backgroundColorView: backgroundColorView) {
                
                let allCases = AllergeniIngrediente.allCases
                
              //  VStack(alignment:.leading) {
                    
                    MyFilterRow(
                        allCases: allCases,
                        filterCollection: $allergeneIn,
                        selectionColor: .red.opacity(0.7),
                        imageOrEmoji: "allergens",
                        label: "In: \(allergeneIn?.count ?? 0) su \(allCases.count)"
                    ) { value in
                        let allergens = self.allergeneIn ?? []
                        if let index = allergens.firstIndex(of: value) {
                            return index + 1
                        } else {
                            return 0
                        }
                    }
                
                Spacer()
                
                    Text("Il numero indica l'ordine di inserimento. Al cliente saranno comunque mostrati in ordine alfabetico.")
                        .italic()
                        .font(.caption2)
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
               // }
                
                
            }
        
        
        
        
    }
}

/*
struct VistaAllergeni_Selectable_Previews: PreviewProvider {
    static var previews: some View {
        VistaAllergeni_Selectable()
    }
} */
