//
//  MENU_TEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/05/22.
//

import SwiftUI


/// Semplice Menu multiSelezione. Funziona Step by Step (Aggiunge ed Esce). Se si vuole la persistenza usare il SelettoreMyModel
struct CSMenu_MultiSelection: View {
    
    @Binding var ingredient: IngredientModel

    var body: some View {
              
            Menu {
   
                ForEach(AllergeniIngrediente.allCases, id:\.self) { allergene in
 
                        Button {
                            buttonAction(allergene: allergene)
                        } label: {
                            buttonLabel(allergene: allergene)
    
                        }
                    }
     
            } label: {

                    Image(systemName: "allergens")
                        .imageScale(.medium)
                        .foregroundColor(Color.red.opacity(0.8))
    
             }
   
    }
    
    // Method
    
    private func buttonAction(allergene: AllergeniIngrediente) {
        
        if self.ingredient.allergeni.contains(allergene) {
            
            let index = self.ingredient.allergeni.firstIndex(of: allergene)
            self.ingredient.allergeni.remove(at: index!)
       
        } else {
            
            self.ingredient.allergeni.append(allergene)
        }
        
        
    }
        
   @ViewBuilder private func buttonLabel(allergene: AllergeniIngrediente) -> some View {
        
        if self.ingredient.allergeni.contains(allergene) {
            
            HStack {
                Text(allergene.simpleDescription())
                Image(systemName: "checkmark")
            }
      
        } else { Text(allergene.simpleDescription()) }
    }
    
}

/*
struct CSMenu_MultiSelection_Previews: PreviewProvider {
    static var previews: some View {
        CSMenu_MultiSelection()
    }
} */
