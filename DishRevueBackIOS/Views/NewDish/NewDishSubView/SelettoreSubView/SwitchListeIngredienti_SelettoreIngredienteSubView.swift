//
//  SwitchListeIngredienti_SelettoreIngredienteSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct SwitchListeIngredienti: View {
        
        @Binding var listaDaMostrare: ElencoListeIngredienti
        
        var body: some View {
            
            HStack {
                
                Spacer()
                
                Text("All My Ingredients")
                    .fontWeight(listaDaMostrare == .allMyIngredients ? .bold : .light)
                    .onTapGesture {
                        
                        withAnimation(.easeOut) {
                            self.listaDaMostrare = .allMyIngredients
                        }
                    }
                
                Spacer()
                
                Text("From Community")
                    .fontWeight(listaDaMostrare == .allFromCommunity ? .bold : .light)
                    .onTapGesture {
                    
                        withAnimation(.easeOut) {
                            self.listaDaMostrare = .allFromCommunity
                        }
                    }
                
                Spacer()
            }
           
        }
    }

/*
struct SwitchListeIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        SwitchListeIngredienti()
    }
}
*/
