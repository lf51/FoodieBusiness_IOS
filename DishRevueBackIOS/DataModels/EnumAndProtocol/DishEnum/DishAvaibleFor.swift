//
//  DishAvaibleFor.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishAvaibleFor: MyEnumProtocol {
    
    // E' la possibilità di un piatto in Categoria standard di essere disponibile con modifiche per un'altra categoria
    static var allCases: [DishAvaibleFor] = [.vegetariano,.vegano,.vegariano,.glutenFree]
    static var defaultValue: DishAvaibleFor = DishAvaibleFor.noValue

    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // può contenere carne o pesce - Non può contenere latte&derivati
    case vegano // può contenere solo vegetali
    case glutenFree // non contiene glutine
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId()}
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .vegetariano: return "Vegetariana"
        case .vegariano: return "Vegariana" // Milk Free
        case .vegano: return "Vegana"
        case .glutenFree: return "Senza Glutine"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
}
