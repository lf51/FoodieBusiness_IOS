//
//  SwitchListeIngredienti_SelettoreIngredienteSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct SwitchViewModelContainer: View {
        
        let viewModelList: [ModelList]
        @Binding var listaDaMostrare: String
        
        var body: some View {
            
            HStack {
                
                vbShowContainerPlainRow()
                
                Spacer()
 
            }
           
        }
    
    // Method
    
    @ViewBuilder func vbShowContainerPlainRow() -> some View {
        
        ForEach(viewModelList, id: \.self) { list in
            
            Spacer()
            
            ContainerRowLabel_Plain(viewModelList: list, listaDaMostrare: $listaDaMostrare)
            
            }
        }
    
    }

///Label Container semplice. Testo con Tap per vedere contenuto
struct ContainerRowLabel_Plain:View {
    
    let viewModelList: ModelList
    @Binding var listaDaMostrare: String
    
    var body: some View {
        
        Text(viewModelList.returnAssociatedValue().0)
            .fontWeight(listaDaMostrare == viewModelList.returnAssociatedValue().0 ? .bold : .light)
            .onTapGesture {
                
                withAnimation(.easeOut) {
                    self.listaDaMostrare = viewModelList.returnAssociatedValue().0
                }
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
