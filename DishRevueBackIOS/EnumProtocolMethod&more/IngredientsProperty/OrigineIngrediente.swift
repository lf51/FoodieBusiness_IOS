//
//  DishBase.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

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
    
    func extendedDescription() -> String? {
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
            return nil
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func returnTypeCase() -> OrigineIngrediente {
        
        return self
    }
    
    func imageAssociated() -> String? {
        
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
            return nil
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
}


/*
enum SubOrigineIngrediente {
    
    case carne,latte,uova,interiora,noValue
    
}

enum Sub2OrigineIngrediente {
    
    case allevamento,selvatico, noValue
    
}

enum OrigineIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [OrigineIngrediente] = [.animale(),.pesce(),.vegetale] // Non essendoci valori Associati, la allCases potrebbe essere implicita, ma la esplicitiamo per omettere il caso NoValue, di modo che non appaia fra le opzioni di scelta
    static var defaultValue: OrigineIngrediente = OrigineIngrediente.noValue
    
    // Potremmo Associare un icona ad ogni Tipo
    
    case animale(sub:SubOrigineIngrediente = .noValue, sub2:Sub2OrigineIngrediente = .noValue) // a base di carne
    case pesce(sub:SubOrigineIngrediente = .noValue, sub2: Sub2OrigineIngrediente = .noValue)// a base di pesce
    case vegetale // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .animale: return "Animale"
        case .pesce: return "Pesce"
        case .vegetale: return "Vegetale"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func extendedDescription() -> String? {
        switch self {
        case .animale:
            return "Origine Animale"
        case .pesce:
            return "Origine Animale"
        case .vegetale:
            return "Origine Vegetale"
        case .noValue:
            return nil
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func returnTypeCase() -> OrigineIngrediente {
        
        return self
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .animale:
            return "🐂"
        case .pesce:
            return "🐟"
        case .vegetale:
            return "🌱"
        case .noValue:
            return nil
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .animale:
            return 1
        case .pesce:
            return 2
        case .vegetale:
            return 4
        case .noValue:
            return 0
        }
    }
} */ // Deprecata 20.07 -> Versione più avanzata che però richiede lavoro in più all'utente per cui torniamo alla versione precedente con poche macrocategorie senza SubCaegorie
