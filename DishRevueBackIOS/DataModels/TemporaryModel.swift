//
//  TemporaryModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/08/22.
//

import Foundation

/// Utile nel modulo di importazione Veloce, al fine di portare in un unico oggetto sia il piatto che gli ingredienti. Creato dopo aver trasformato gli ingredienti nel piatto in Riferimenti
struct TemporaryModel:Identifiable {
    
    // Creato 28.08
    let id:String = UUID().uuidString
    
    var dish: DishModel
    var ingredients: [IngredientModel]
    var rifIngredientiSecondari: [String] = []
    
}
