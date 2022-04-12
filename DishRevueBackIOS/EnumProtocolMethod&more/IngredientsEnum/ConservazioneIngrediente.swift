//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

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
        print("Dentro ConservazioneIngrediente. DescrizioneEstesa non sviluppata")
        return nil
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
    
}
