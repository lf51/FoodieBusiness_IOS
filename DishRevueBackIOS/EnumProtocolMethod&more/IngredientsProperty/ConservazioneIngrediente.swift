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
    
    func extendedDescription() -> String? {
        
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
    
    func returnTypeCase() -> ConservazioneIngrediente {
        
        .altro
        
    }
    
    func imageAssociated() -> String? {
       
        switch self {
        
        case .congelato:
            return "🥶"
        case .surgelato:
            return "❄️"
        case .altro:
            return nil
   
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





/*
enum ConservazioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
    
    static var allCases: [ConservazioneIngrediente] = [.fresco,.congelato,.surgelato,.conserva]
    static var defaultValue: ConservazioneIngrediente = ConservazioneIngrediente.custom("")
    
    var id: String {self.createId()}
    
    case fresco
    case congelato
    case surgelato
    case conserva
    
    case custom(_ metodoDiConservazione:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .fresco: return "Fresco"
        case .conserva: return "Conserva"
        case .surgelato: return "Surgelato"
        case .congelato: return "Congelato"
        case .custom(let metodoDiConservazione): return metodoDiConservazione.capitalized
            
        }
    }
    
    func extendedDescription() -> String? {
        
        switch self {
        case .fresco:
            return "Prodotto Fresco"
        case .congelato:
            return "Potrebbe essere Congelato"
        case .surgelato:
            return "Potrebbe essere Surgelato"
        case .conserva:
            return "La conserva va estesa --> da Editare"
        case .custom(let metodoDiConservazione):
            let string = metodoDiConservazione == "" ? "Metodo di Conservazione non Specificato" : "Questo prodotto è \(metodoDiConservazione)"
            return string
        }

    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with: "").lowercased()
    }
    
    func returnTypeCase() -> ConservazioneIngrediente {
        
        switch self {
        
        case .custom( _):
            return .custom("")
        default: return self
        }
        
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .fresco:
            return "heart"
        case .congelato:
            return "thermometer.snowflake"
        case .surgelato:
            return "thermometer.snowflake"
        case .conserva:
            return "timer"
        case .custom( _):
            return nil
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
        case .fresco:
            return 1
        case .congelato:
            return 2
        case .surgelato:
            return 3
        case .conserva:
            return 4
        case .custom(_):
            return (ConservazioneIngrediente.allCases.count + 1)
        }
    }
    
} */ // BackUp - deprecato 19.07
