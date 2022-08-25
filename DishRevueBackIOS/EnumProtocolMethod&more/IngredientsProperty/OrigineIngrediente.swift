//
//  DishBase.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum OrigineIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [OrigineIngrediente] = [.vegetale,.animale]
    static var defaultValue: OrigineIngrediente = .noValue

    case animale // a base di carne
    case vegetale // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .animale: return "Animale"
        case .vegetale: return "Vegetale"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func extendedDescription() -> String {
        switch self {
        case .animale:
            return "Ingrediente di Origine Animale: Carne/Pesce/Uova/Latte/ecc"
        case .vegetale:
            return "Ingrediente di Origine Vegetale"
        case .noValue:
            return ""
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func returnTypeCase() -> OrigineIngrediente { self }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .animale:
            return "🐂"
        case .vegetale:
            return "🌱"
        case .noValue:
            return ""
        }
    }

    
    func orderValue() -> Int {
        
        switch self {
            
        case .animale:
            return 2
        case .vegetale:
            return 1
        case .noValue:
            return 0
        }
    }
}

/*
enum OrigineIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [OrigineIngrediente] = [.vegetale,.carneAnimale,.pesce,.latteAnimale]
    static var defaultValue: OrigineIngrediente = .noValue

    case carneAnimale // a base di carne
    case latteAnimale
    case pesce // a base di pesce
    case vegetale // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .carneAnimale: return "Carne"
        case .latteAnimale: return "Latte"
        case .pesce: return "Pesce"
        case .vegetale: return "Vegetale"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func extendedDescription() -> String {
        switch self {
        case .carneAnimale:
            return "Ingrediente di Origine Animale: Carne/Uova/Interiora"
        case .latteAnimale:
            return "Ingrediente di Origine Animale: Latte & Derivati"
        case .pesce:
            return "Ingrediente di Origine Animale: Pesce/Uova"
        case .vegetale:
            return "Ingrediente di Origine Vegetale"
        case .noValue:
            return ""
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func returnTypeCase() -> OrigineIngrediente { self }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .carneAnimale:
            return "🐂"
        case .latteAnimale:
            return "🥛"
        case .pesce:
            return "🐟"
        case .vegetale:
            return "🌱"
        case .noValue:
            return "⚙️"
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .carneAnimale:
            return 2
        case .latteAnimale:
            return 4
        case .pesce:
            return 3
        case .vegetale:
            return 1
        case .noValue:
            return 0
        }
    }
} */ // Deprecata 24.08 --> Passaggio a due macro categorie: Vegetale / Animale
