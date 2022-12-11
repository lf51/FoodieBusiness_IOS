//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import MyFoodiePackage

enum ConservazioneIngrediente:MyProEnumPack_L2,MyProCloudPack_L0 /*: MyEnumProtocol, MyEnumProtocolMapConform */{
    
    static var allCases: [ConservazioneIngrediente] = [.altro,.congelato,.surgelato]
    static var defaultValue: ConservazioneIngrediente = .noValue // deprecato in futuro togliere dal protocollo
    
    var id: String {self.createId()}

    case congelato
    case surgelato
    case altro
    case noValue
 
    func simpleDescription() -> String {
      /*  print("Dentro Conservazione Ingrediente .simpleDescription() di \(self.hashValue)") */
        
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
            return "☀️"//"🌞"//"🌀" //heart"
        case .noValue:
            return "circle.slash"
   
        }
     
    }
    
    func orderAndStorageValue() -> Int { 
        
        switch self {
        
        case .congelato:
            return 2
        case .surgelato:
            return 1
        case .altro:
            return 3
        case .noValue:
            return 0
      
        }
    }
    
   static func convertiInCase(fromNumber: Int) -> ConservazioneIngrediente {
        
        switch fromNumber {
            
            case 0:
                return .noValue
            case 1:
              return .altro
            case 2:
                return .surgelato
            case 3:
                return .congelato
            default:
                return .noValue
            
        }
    }
    
}
