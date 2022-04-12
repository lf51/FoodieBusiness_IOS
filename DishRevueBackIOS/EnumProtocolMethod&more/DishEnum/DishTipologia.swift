//
//  DishCategory.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishTipologia: MyEnumProtocol,MyEnumProtocolMapConform {
    
    static var allCases: [DishTipologia] = [.standard,.vegetariano,.vegariano,.vegano]
    static var defaultValue: DishTipologia = DishTipologia.noValue

    case standard // contiene di tutto
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // non contiene latte animale e prodotti derivati
    case vegano // può contenere solo vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId()}
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .standard: return "Standard"
        case .vegetariano: return "Vegetariano"
        case .vegariano: return "Vegariano"
        case .vegano: return "Vegano"
        case .noValue: return "Nessun Valore"
        
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func extendedDescription() -> String? {
        
        switch self {
            
        case .standard: return "Contiene ingredienti di origine animale e suoi derivati"
        case .vegetariano: return "Esclude la carne e il pesce"
        case .vegariano: return "Esclude il Latte Animale e i suoi derivati"
        case .vegano: return "Contiene SOLO ingredienti di origine vegetale"
        case .noValue: return nil
        
        }
        
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .standard:
            return nil
        case .vegetariano:
            return nil
        case .vegariano:
            return nil
        case .vegano:
            return nil
        case .noValue:
            return nil
        }
    }
    
    func returnTypeCase() -> DishTipologia {
        print("dentro DishTipologia ReturnType")
        return self
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .standard:
            return 4
        case .vegetariano:
            return 1
        case .vegariano:
            return 2
        case .vegano:
            return 3
        case .noValue:
            return 0
        }
    }
    
}
