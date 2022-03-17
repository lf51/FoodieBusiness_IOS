//
//  InfoGenerali_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct PannelloIngredienti_NewDishSubView: View {
    
    @Binding var newDish: DishModel
  
    @Binding var wannaDeleteIngredient: Bool?
    @Binding var wannaAddIngredient: Bool?
  //  @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var wannaCreateIngredient: Bool?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
       //    IntestazioneNuovoOggetto_Generic(placeHolderLabel: "Nome del Piatto", imageLabel: "gear", itemModel: $newDish)
            
                      
            VStack {
                
                CSLabel_2Button(placeHolder: "Ingredienti Principali", imageName: "curlybraces", backgroundColor: Color.black, toggleBottonePLUS: $wannaCreateIngredient, toggleBottoneTEXT: $wannaAddIngredient, testoBottoneTEXT: "Edit")
                
                if !self.newDish.ingredientiPrincipali.isEmpty {
                    
                    CustomGrid_GenericsView(wannaDeleteItem: $wannaDeleteIngredient, genericDataToShow: self.$newDish.ingredientiPrincipali, baseColor: Color.mint)
                    
                }
            }
            
            VStack {
                
                CSLabel_1Button(placeHolder: "Ingredienti Secondari", imageName: "curlybraces", backgroundColor: Color.black)
                
             /*   CSLabel_2Button(placeHolder: "Ingredienti Secondari", imageName: "curlybraces", backgroundColor: Color.black, toggleBottonePLUS: nil, toggleBottoneTEXT: nil, testoBottoneTEXT: "") */
                
                if !self.newDish.ingredientiSecondari.isEmpty {
                    
                    CustomGrid_GenericsView(wannaDeleteItem: $wannaDeleteIngredient, genericDataToShow: self.$newDish.ingredientiSecondari, baseColor: Color.orange)
                    
                }
      
            }
        }
    }
    
    // function Space
    
   private func removeItem(array: inout [IngredientModel], item: IngredientModel) {
        
        let positionIndex = array.firstIndex(of: item)
        
        array.remove(at: positionIndex!)
        
    }
    
  
 
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/
