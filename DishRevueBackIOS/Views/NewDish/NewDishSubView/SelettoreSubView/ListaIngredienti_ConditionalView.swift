//
//  ListaIngredienti_ConditionalView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct ListaIngredienti_ConditionalView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @Binding var newDish: DishModel
    @Binding var listaDaMostrare: ElencoListeIngredienti
    
    @Binding var temporarySelectionIngredients: [String:[IngredientModel]]
    
    var body: some View {

        List {
            
         //   VStack(alignment:.leading) { // -> non lo inseriamo in un Vstack perchè non fa funzionare l'onMove e l'onDelete

            if listaDaMostrare == .allFromCommunity {
                    
                    MostraESelezionaIngredienti(listaAttiva:propertyVM.listoneFromListaBaseModelloIngrediente) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColorUsed
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
                    
                }
                
                else if listaDaMostrare == .allMyIngredients {
                    
                    MostraESelezionaIngredienti(listaAttiva: propertyVM.listaMyIngredients) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColorUsed
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
 
                }
                
                else if listaDaMostrare == .ingredientiPrincipali {
                    
                   MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiPrincipali)
                    
          
                }
                
                else if listaDaMostrare == .ingredientiSecondari {
                    
                    MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiSecondari)
                    
                }
        }
        .listStyle(.plain)
        
    }
    
 //Method

    
    private func addIngredientsTemporary(ingredient: IngredientModel) {

        let((_,_,_),ingredientKey) = discoverIngredientAttribute(ingredient: ingredient)
    
            if ingredientKey == "" {
                
                temporarySelectionIngredients["IngredientiPrincipali"]!.append(ingredient)
                
            }
            
           else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionIngredients["IngredientiPrincipali"]!.firstIndex(of: ingredient)
                
                temporarySelectionIngredients["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionIngredients["IngredientiSecondari"]!.append(ingredient)
                
            }
            
            else if ingredientKey == "IngredientiSecondari"{
                
                let index = temporarySelectionIngredients["IngredientiSecondari"]!.firstIndex(of: ingredient)
                temporarySelectionIngredients["IngredientiSecondari"]!.remove(at: index!)
                
            }
        

    }
    
    
    private func discoverIngredientAttribute(ingredient: IngredientModel) -> (imageColorUsed:(Color,String,Bool), key: String) {
         
        // Guard per controllo di unicità
        guard !self.newDish.ingredientiPrincipali.contains(ingredient) else {
            
            return ((Color.mint, "circle.slash", true),"")
            
        }
        
        guard !self.newDish.ingredientiSecondari.contains(ingredient) else {
            
            return ((Color.orange, "circle.slash", true),"")
        }
  
            if temporarySelectionIngredients["IngredientiPrincipali"]!.contains(ingredient) {return ((Color.mint, "circle.fill",false),"IngredientiPrincipali")}
            
            else if temporarySelectionIngredients["IngredientiSecondari"]!.contains(ingredient) {return ((Color.orange, "circle.fill",false),"IngredientiSecondari")}
            
            else {return ((Color.black, "circle",false),"")}
  
    
    }

    
}

/*struct ListaIngredienti_ConditionalView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredienti_ConditionalView()
    }
}
*/
