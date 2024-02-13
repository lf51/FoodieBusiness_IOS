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
    
    /// ritorna la query precedente nel caso il valore per cui filtrare è nil / IngredientModel
    func csWhereField<F:RawRepresentable & Codable>(isEqualTo:F?,in key:IngredientSubModel.CodingKeys) -> Query {
        
        guard let isEqualTo else { return self }
        
        return self.whereField(key.rawValue, isEqualTo: isEqualTo.rawValue)
    }
    
    /// ritorna la query precedente nel caso il valore per cui filtrare è un array optiona // IngredientModel / La chiave deve contenere almeno uno dei valori passati
    func csWhereField<F:RawRepresentable & Codable>(contain values:[F]?,in key:IngredientSubModel.CodingKeys) -> Query {
        
        guard let values else { return self }
        
        let rawValue = values.map({$0.rawValue})
        
        return self.whereField(key.rawValue, arrayContainsAny: rawValue)
    }
    
    /// La chiave deve contenere tutti ii valori passati, se il valore passato è Nil ritorna una query che contiene un valore nil in quel campo
    func csWhereField<F:RawRepresentable & Codable>(containAll values:[F]?,in key:IngredientModel.CodingKeys) -> Query {

        let rawValue = values?.map({$0.rawValue})
        return self.whereField(key.rawValue, isEqualTo: rawValue as Any)
    
    }
    
    func csStartAfter(document:DocumentSnapshot?) -> Query {
        
        guard let document else { return self }
        
       return self.start(afterDocument: document)
        
    }
    
    
    
}


// aglio 0314B37B-507E-4AB5-B615-9AEF43C42451
// basilico 6D3BA9C2-C674-47BE-BE0D-51E10C4460BE
// ragalmuto 96E4757B-8F87-41AA-979C-5FE93701AD39
