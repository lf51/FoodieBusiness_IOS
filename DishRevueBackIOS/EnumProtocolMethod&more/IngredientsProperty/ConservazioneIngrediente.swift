//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ConservazioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {

    static var allCases: [ConservazioneIngrediente] = [.congelato,.surgelato]
    static var defaultValue: ConservazioneIngrediente = .altro // deprecato in futuro togliere dal protocollo
    
    var id: String {self.createId()}

    case congelato
    case surgelato
    case altro
 
    func simpleDescription() -> String {
        
        switch self {

        case .surgelato: return "Surgelato"
        case .congelato: return "Congelato"
        case .altro: return ""
            
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
            return "💚" //heart
   
        }
     
    }
    
    func orderValue() -> Int {
        
        switch self {
        
        case .congelato:
            return 1
        case .surgelato:
            return 2
        case .altro:
            return 0
      
        }
    }
    
}
