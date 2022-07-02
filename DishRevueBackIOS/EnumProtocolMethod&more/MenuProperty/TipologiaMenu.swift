//
//  TipologiaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

enum PaxMenuFisso:MyEnumProtocolMapConform  {

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
    
    func imageAssociated() -> String? {
        
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
    static var defaultValue: TipologiaMenu = .allaCarta // deprecato 01.07 -> Togliere dal Protocollo
    
    var id:String {self.createId()}
    
    case fisso(persone:PaxMenuFisso,costo: String)
    case allaCarta
 //   case noValue
    
    func simpleDescription() -> String {
        
        switch self {
        case .fisso:
            return "Fisso"
        case .allaCarta:
            return "Alla Carta"
     //   case .noValue:
       //     return ""
        }
    }
    
    func extendedDescription() -> String? {
        print("Dentro Tipologia Menu. DescrizioneEstesa non sviluppata")
        return nil
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
      //  case .noValue:
       //     return false
        }
        
    }
    
    func returnTypeCase() -> Self {
        
        switch self {
            
        case .fisso(_, _):
            return .fisso(persone: .uno, costo: "n/d")
        default: return self
            
        }
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .fisso(_, _):
            return "dollarsign.circle"
        case .allaCarta:
            return "cart"
      //  case .noValue:
        //    return nil
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .fisso(_, _):
            return 1
        case .allaCarta:
            return 2
    //    case .noValue:
      //      return 0
        }
    }
    
}
