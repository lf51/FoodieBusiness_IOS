//
//  EditDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/02/22.
//

import SwiftUI

struct EditDishView: View {
    
    private var staticDish: DishModel
    @State private var editableDish: DishModel
    
    init(currentDish: DishModel) {
        
        self.staticDish = currentDish
        self.editableDish = currentDish
        
    }
    
    
    var body: some View {
        
        VStack{
            
            Text("Edit -> \(staticDish.name)")
            
            TextField("Add Main Ingredient", text: $editableDish.ingredientiPrincipali[0])
            
            
            Button {
               
                // Abbiamo passato Un DishModel, lo abbiamo attribuito a due variabili, una statica e una State nell'idea di modificare la State e passare poi le modifiche alla Static.
                // Tentativo da Abortire
                
            } label: {
                Text("Salva Modifiche")
            }

        }
 
    }
}

struct EditDishView_Previews: PreviewProvider {
    static var previews: some View {
        EditDishView(currentDish: DishModel())
    }
}
