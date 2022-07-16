//
//  BaseModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

// Modello base da caricare da un Json

struct CommunityIngredientModel {
    
    var id: String {self.nome.replacingOccurrences(of: " ", with: "").lowercased() }
    
    let nome: String
    
} // deprecata in futuro


