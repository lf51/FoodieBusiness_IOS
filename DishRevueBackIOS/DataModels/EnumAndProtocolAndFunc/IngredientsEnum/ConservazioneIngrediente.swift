//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ConservazioneIngrediente: MyEnumProtocol {
    
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
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with: "").lowercased()
    }
    
    
}
