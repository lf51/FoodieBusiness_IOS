//
//  DishBase.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishBase: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [DishBase] = [.carne,.pesce,.vegetali] // Non essendoci valori Associati, la allCases potrebbe essere implicita, ma la esplicitiamo per omettere il caso NoValue, di modo che non appaia fra le opzioni di scelta
    static var defaultValue: DishBase = DishBase.noValue
    
    // Potremmo Associare un icona ad ogni Tipo
    
    case carne // a base di carne o derivati (latte e derivati)
    case pesce // a base di pesce
    case vegetali // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .carne: return "Carne"
        case .pesce: return "Pesce"
        case .vegetali: return "Vegetali"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func extendedDescription() -> String? {
        print("Dentro DishBase. DescrizioneEstesa non sviluppata")
        return nil
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
        case .pesce:
            return 2
        case .vegetali:
            return 3
        case .noValue:
            return 0
        }
    }
}
