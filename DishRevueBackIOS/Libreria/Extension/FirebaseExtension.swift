//
//  FirebaseExtension.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/10/23.
//

import Foundation
import FirebaseFirestore
import MyFilterPackage
import MyFoodiePackage

extension Query {
    
    /// ritorna la query precedente nel caso il valore per cui filtrare è nil
    func csWhereField<F:RawRepresentable & Codable>(isEqualTo:F?,in key:IngredientModel.CodingKeys) -> Query {
        
        guard let isEqualTo else { return self }
        
        return self.whereField(key.rawValue, isEqualTo: isEqualTo.rawValue)
    }
    
    /// ritorna la query precedente nel caso il valore per cui filtrare è nil
    func csWhereField<F:RawRepresentable & Codable>(contain values:[F]?,in key:IngredientModel.CodingKeys) -> Query {
        
        guard let values else { return self }
        
        let rawValue = values.map({$0.rawValue})
        
        return self.whereField(key.rawValue, arrayContainsAny: rawValue)
    }
    
    func csStartAfter(document:DocumentSnapshot?) -> Query {
        
        guard let document else { return self }
        
       return self.start(afterDocument: document)
        
    }
    
    
    
}
