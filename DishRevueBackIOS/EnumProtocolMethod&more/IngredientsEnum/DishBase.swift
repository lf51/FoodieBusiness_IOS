//
//  DishBase.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishBase: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [DishBase] = [.carne,.pesce,.latteAnimale,.vegetali] // Non essendoci valori Associati, la allCases potrebbe essere implicita, ma la esplicitiamo per omettere il caso NoValue, di modo che non appaia fra le opzioni di scelta
    static var defaultValue: DishBase = DishBase.noValue
    
    // Potremmo Associare un icona ad ogni Tipo
    
    case carne // a base di carne
    case latteAnimale
    case pesce // a base di pesce
    case vegetali // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .carne: return "Carne"
        case .latteAnimale: return "Latte Animale"
        case .pesce: return "Pesce"
        case .vegetali: return "Vegetali"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func extendedDescription() -> String? {
        switch self {
        case .carne:
            return "Origine Animale"
        case .latteAnimale:
            return "Origine Latte Animale"
        case .pesce:
            return "Origine Animale"
        case .vegetali:
            return "Origine Vegetale"
        case .noValue:
            return nil
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func returnTypeCase() -> DishBase {
        
        return self
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .carne:
            return "🐂"
        case .latteAnimale:
            return "🥛"
        case .pesce:
            return "🐟"
        case .vegetali:
            return "🌱"
        case .noValue:
            return nil
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .carne:
            return 1
        case .latteAnimale:
            return 3
        case .pesce:
            return 2
        case .vegetali:
            return 4
        case .noValue:
            return 0
        }
    }
}
