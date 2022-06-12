//
//  DishBase.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum OrigineIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [OrigineIngrediente] = [.carneAnimale,.pesce,.latteAnimale,.vegetale] // Non essendoci valori Associati, la allCases potrebbe essere implicita, ma la esplicitiamo per omettere il caso NoValue, di modo che non appaia fra le opzioni di scelta
    static var defaultValue: OrigineIngrediente = OrigineIngrediente.noValue
    
    // Potremmo Associare un icona ad ogni Tipo
    
    case carneAnimale // a base di carne
    case latteAnimale
    case pesce // a base di pesce
    case vegetale // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .carneAnimale: return "Carne Animale"
        case .latteAnimale: return "Latte Animale"
        case .pesce: return "Pesce"
        case .vegetale: return "Vegetale"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func extendedDescription() -> String? {
        switch self {
        case .carneAnimale:
            return "Origine Animale"
        case .latteAnimale:
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
            return 1
        case .latteAnimale:
            return 3
        case .pesce:
            return 2
        case .vegetale:
            return 4
        case .noValue:
            return 0
        }
    }
}
