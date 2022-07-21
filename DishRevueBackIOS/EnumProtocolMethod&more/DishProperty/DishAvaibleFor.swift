//
//  DishAvaibleFor.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

struct DishAvaibleForDiet {
  
    

    var intestazione: String { get {self.diet.intestazione} set { } }
    var descrizione: String { get {self.diet.descrizione} set { } }
    var id: String {self.diet.id}
  //  var status: StatusModel = .bozza // Non serve a nulla || Da sistemare
    
    let diet: DishTipologia
    var ingredientOUT: [IngredientModel]
    var ingredientIN: [IngredientModel]
    
} // NON ANCORA USATA al 11.07



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
    
    func imageAssociated() -> String? {
        nil
    }
    
    func extendedDescription() -> String? {
        
        switch self {
            
     //   case .standard: return "Contiene ingredienti di origine animale e suoi derivati"
        case .vegetariano: return "Priva di ingredienti di origine animale (ad eccezione del latte e suoi derivati) e pesce.
        case .vegariano: return "Priva di latte animale e ingredienti derivati."
        case .vegano: return "Consente solo ingredienti di origine vegetale."
        case .glutenFree: return "Priva di Glutine."
        case .noValue: return nil
        }
        
    }
    
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
} // deprecata in futuro -> sostituita da una struct
