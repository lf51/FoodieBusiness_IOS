//
//  TemporaryModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/08/22.
//

import Foundation
import MyFoodiePackage

/// Utile nel modulo di importazione Veloce, al fine di portare in un unico oggetto sia il piatto che gli ingredienti. Creato dopo aver trasformato gli ingredienti nel piatto in Riferimenti
struct TemporaryModel:Identifiable {
    
    // Creato 28.08
    let id:String = UUID().uuidString
    
    var dish: ProductModel
    var ingredients: [IngredientModel]
    var categoriaMenu: CategoriaMenu = .defaultValue
    var rifIngredientiSecondari: [String] = []
    
    func generaProduct(from ingredients:[IngredientModel], and rif:[String]) -> ProductModel {
        
        var rifIngredientiPrincipali:[String] = []
        var rifIngredientiSecondari:[String] = []
        
        for ingredient in ingredients {

            if rif.contains(ingredient.id)  {
                rifIngredientiSecondari.append(ingredient.id)
            } else {
                rifIngredientiPrincipali.append(ingredient.id)
            }

        }

        let dish = {
            var new = self.dish
            new.categoriaMenu = self.categoriaMenu.id
            new.ingredientiPrincipali = rifIngredientiPrincipali
            new.ingredientiSecondari = rifIngredientiSecondari
            
            if rifIngredientiPrincipali.contains(self.dish.id) {
                new.percorsoProdotto = .finito
            }
            return new
            
        }()
        
       return dish
    }
}
