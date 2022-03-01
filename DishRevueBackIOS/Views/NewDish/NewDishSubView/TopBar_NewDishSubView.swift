//
//  TopBar_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/02/22.
//

import SwiftUI

struct TopBar_NewDishSubView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var newDish: DishModel
    @Binding var openAddingIngredientePrincipale: Bool?
    @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var openCreaNuovoIngrediente: Bool?
    @Binding var activeDelection: Bool
    
    var body: some View {
        HStack { // una Sorta di NavigationBar
            
            Text(newDish.name != "" ? newDish.name : "New Dish")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.black)
            
            Spacer()
            
            // Done Button
            
            if openAddingIngredientePrincipale! || openAddingIngredienteSecondario! {
                
                CSButton_tight(title: "Done", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                    self.openAddingIngredientePrincipale = false
                    self.openAddingIngredienteSecondario = false
                }
                
            }
            
            // Exit NuovoIngrediente
            
            else if openCreaNuovoIngrediente!  {
                
                CSButton_tight(title: "Exit", fontWeight: .semibold, titleColor: Color.red, fillColor: Color.clear) {
                    self.openCreaNuovoIngrediente = false
                }
                
                
            }
            
            // Delete Button
            
            else if activeDelection {
                
                CSButton_tight(title: "Annulla", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.red) {
                    self.activeDelection = false
                }
                
            }
            
            // Default Button
            
            else {
                
                CSButton_tight(title: "Dismiss", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.clear) { dismiss() }
            }
            
        }
        
    }
}

/*struct TopBar_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        TopBar_NewDishSubView()
    }
} */
