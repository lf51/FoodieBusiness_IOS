//
//  TipologiaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

enum PaxMenuFisso:MyEnumProtocolMapConform  {
    
    static var defaultValue: PaxMenuFisso = .uno
    static var allCases: [PaxMenuFisso] = [.uno,.due]
    
    case uno
    case due
    
    func simpleDescription() -> String {
        
        switch self {
        case .uno:
            return "1"
        case .due:
            return "2"
        }
    }
    
    func extendedDescription() -> String {
        
        switch self {
        case .uno:
            return "una persona"
        case .due:
            return "due persone"
        }
    }
    
    func imageAssociated() -> String {
        
        switch self {
        case .uno:
            return "person.fill"
        case .due:
            return "person.2.fill"
        }
    }
    
    func returnTypeCase() -> PaxMenuFisso {
        PaxMenuFisso.uno
    }
    
    func orderValue() -> Int {
        switch self {
        case .uno:
            return 1
        case .due:
            return 2
        }
    }
}


enum TipologiaMenu: MyEnumProtocol, MyEnumProtocolMapConform {
   
    static var allCases: [TipologiaMenu] = [.fisso(persone: .uno, costo: "n/d"),.allaCarta]
    static var defaultValue: TipologiaMenu = .noValue
    
    var id:String {self.createId()}
    
    case fisso(persone:PaxMenuFisso,costo: String)
    case allaCarta
    
    case noValue
    
    func returnMenuPriceValue() -> String {
        
        switch self {
        case .fisso(_, let costo):
            return costo
        default:
            return "0.00"
        }
    }
    
    func simpleDescription() -> String {
        
        switch self {
        case .fisso:
            return "Fisso"
        case .allaCarta:
            return "Alla Carta"
        case .noValue:
            return "Selezionare tipologia menu"

        }
    }
    
    func extendedDescription() -> String {
       
        switch self {
            
        case .fisso(let persone, let costo):
            return "Il costo del menu è di € \(costo) per \(persone.extendedDescription())."
        case .allaCarta:
            return "Il costo del menu non è predeterminato."
        case .noValue:
            return "Selezionare tipologia menu"
           
        }

    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func editingAvaible() -> Bool {
        
        switch self {
            
        case .fisso:
            return true
        case .allaCarta:
            return false
        case .noValue:
            return false
        }
        
    }
    
    func returnTypeCase() -> Self {
        
        switch self {
            
        case .fisso(_, _):
            return .fisso(persone: .uno, costo: "n/d")
        
        default:
            return self
            
        }
    }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .fisso(_, _):
            return "dollarsign.circle"
        case .allaCarta:
            return "cart"
        case .noValue:
            return "gear.badge.xmark"
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .fisso(_, _):
            return 1
        case .allaCarta:
            return 2
        case .noValue:
           return 0
        }
    }
    
}
