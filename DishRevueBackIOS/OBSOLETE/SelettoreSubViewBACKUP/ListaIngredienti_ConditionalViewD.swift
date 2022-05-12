//
//  ListaIngredienti_ConditionalView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

/* // BACKUP 10.05
/// M1 è il modello da Modificare. M2 è il modello da listare. Ex: M1 è la proprietà, M2 è il MenuModel associato alla proprietà
struct ListaIngredienti_ConditionalViewD<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M1
    @Binding var listaDaMostrare: ModelList
    
    @Binding var temporarySelectionIngredients: [String:[M2]]
    
    var body: some View {

        List {
            
         //   VStack(alignment:.leading) { // -> non lo inseriamo in un Vstack perchè non fa funzionare l'onMove e l'onDelete

            if listaDaMostrare == .allFromCommunity {
                    
                    MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { model in
                        self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
                      
                    } action: { model in
                        self.addIngredientsTemporary(model: model as! M2)
                    }
                    
                }
                
                else if listaDaMostrare == .allMyIngredients {
                    
                    MostraESelezionaIngredienti(listaAttiva: viewModel.allMyIngredients) { model in
                        self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
                    } action: { model in
                        self.addIngredientsTemporary(model: model as! M2)
                    }
 
                }
                
                else if listaDaMostrare == .ingredientiPrincipali {
                    
                  // MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiPrincipali)
                  //  MostraEOrdinaIngredienti(listaAttiva:[])
                    
          
                }
                
                else if listaDaMostrare == .ingredientiSecondari {
                    
                  //  MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiSecondari)
                  //  MostraEOrdinaIngredienti(listaAttiva: [])
                    
                }
        }
        .listStyle(.plain)
        
    }
    
 //Method

    private func addIngredientsTemporary(model:M2) {

       let((_,_,_),(temporaryKey,principalKey,secondaryKey)) = discoverCaratteristicheModel(itemModel: itemModel, model: model)
    
            if temporaryKey == "" {
                
                temporarySelectionIngredients[principalKey]!.append(model)
                
            }
            
           else if temporaryKey == principalKey {
                
            let index = temporarySelectionIngredients[principalKey]!.firstIndex(of: model)
               temporarySelectionIngredients[principalKey]!.remove(at: index!)
               temporarySelectionIngredients[secondaryKey]!.append(model)
                
                
            }
        
            else if temporaryKey == secondaryKey {
            
            let index = temporarySelectionIngredients[temporaryKey]!.firstIndex(of: model)
            temporarySelectionIngredients[temporaryKey]!.remove(at: index!)
            
        }

    
    }
    
    /// Il secondo contenitore è optional.
    private func discoverCaratteristicheModel(itemModel:M1, model: M2) -> (imageColorUsed:(Color,String,Bool), keys: (temporary:String,principal:String,secondary:String)) {
         
        
        var storedContainer_1:[M2] = []
        var storedContainer_2:[M2] = []
        var principalKey: String = "NoName"
        var secondaryKey: String = "NoValue"
        
        switch itemModel {
            
        case is DishModel:
            let currentModel = itemModel as! DishModel
            storedContainer_1 = currentModel.ingredientiPrincipali as! [M2]
            storedContainer_2 = currentModel.ingredientiSecondari as! [M2]
            principalKey = "IngredientiPrincipali"
            secondaryKey = "IngredientiSecondari"
            
            
        default:
            storedContainer_1 = []
            storedContainer_2 = []
            
        }
  
        guard !storedContainer_1.contains(model) else {
            
            return ((Color.mint, "circle.slash", true),("",principalKey,secondaryKey))
        }
 
        
        guard !storedContainer_2.contains(model) else {
                
                return ((Color.orange, "circle.slash", true),("",principalKey,secondaryKey))
                
            }
            
        let temporarySelectionKey:[String] = [String](temporarySelectionIngredients.keys)
        
        for key in temporarySelectionKey {
            
            if temporarySelectionIngredients[key]!.contains(model) {
                
                let color = principalKey == key ? Color.mint : Color.orange
                
                return ((color,"circle.fill",false),(key,principalKey,secondaryKey))
                
            }
        }
        
        return ((Color.black, "circle",false),("",principalKey,secondaryKey))
        
    }
    

    
   /*
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
*/ // BACKUP 07.05 per trasformazione in Generics
    
    
    
} */



/* struct ListaIngredienti_ConditionalView: View {
    
  //  @ObservedObject var propertyVM: PropertyVM
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var newDish: DishModel
    @Binding var listaDaMostrare: ElencoListeIngredienti
    
    @Binding var temporarySelectionIngredients: [String:[IngredientModel]]
    
    var body: some View {

        List {
            
         //   VStack(alignment:.leading) { // -> non lo inseriamo in un Vstack perchè non fa funzionare l'onMove e l'onDelete

            if listaDaMostrare == .allFromCommunity {
                    
                    MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColorUsed
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
                    
                }
                
                else if listaDaMostrare == .allMyIngredients {
                    
                    MostraESelezionaIngredienti(listaAttiva: viewModel.allMyIngredients) { ingredient in
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

    
 } */// BaCKUP 07.05 tentivo di trasformazione in Genrica

/*struct ListaIngredienti_ConditionalView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredienti_ConditionalView()
    }
}
*/
