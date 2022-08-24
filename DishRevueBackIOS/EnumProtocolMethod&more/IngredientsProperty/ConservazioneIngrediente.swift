//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ConservazioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {

    static var allCases: [ConservazioneIngrediente] = [.congelato,.surgelato,.altro]
    static var defaultValue: ConservazioneIngrediente = .noValue // deprecato in futuro togliere dal protocollo
    
    var id: String {self.createId()}

    case congelato
    case surgelato
    case altro
    case noValue
 
    func simpleDescription() -> String {
        
        switch self {

        case .surgelato: return "Surgelato"
        case .congelato: return "Congelato"
        case .altro: return "Altro"
        case .noValue: return ""
            
        }
    }
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .congelato:
            return "potrebbe essere Congelato"
        case .surgelato:
            return "potrebbe essere Surgelato"
        case .altro:
            return "è conservato fresco o in altro modo"
        case .noValue: return ""

        }

    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with: "").lowercased()
    }
    
    func returnTypeCase() -> ConservazioneIngrediente { self }
    
    func imageAssociated() -> String {
       
        switch self {
        
        case .congelato:
            return "🥶"
        case .surgelato:
            return "❄️"
        case .altro:
            return "🌀" //heart
        case .noValue:
            return "⚙️"
   
        }
     
    }
    
    func orderValue() -> Int {
        
        switch self {
        
        case .congelato:
            return 3
        case .surgelato:
            return 2
        case .altro:
            return 1
        case .noValue:
            return 0
      
        }
    }
    
}
