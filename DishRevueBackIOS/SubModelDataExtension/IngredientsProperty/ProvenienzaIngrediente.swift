//
//  ProvenienzaIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import MyFoodiePackage

enum ProvenienzaIngrediente:MyProEnumPack_L2,MyProCloudPack_L0 /*: MyEnumProtocol, MyEnumProtocolMapConform*/ {
 
    // Nota Vocale 18.10
    
    static var allCases: [ProvenienzaIngrediente] = [.km0, .italia/*, .europa, .restoDelMondo*/]
    static var defaultValue: ProvenienzaIngrediente = .noValue
    
    var id: String { self.createId() }
    
        case km0
        case italia
        case europa
        case restoDelMondo
    
        case noValue
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .km0: return "Km zero"
        case .italia: return "Italia"
        case .europa: return "UE"
        case .restoDelMondo: return "Extra UE"
        case .noValue: return "None"
            
            }
        }
    
    func extendedDescription() -> String {
        print("Dentro ProvenienzaIngrediente. DescrizioneEstesa non sviluppata")
        return ""
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
        }
    
    func returnTypeCase() -> ProvenienzaIngrediente { self }
   
    func imageAssociated() -> String {
        
        switch self {
            
        case .km0:
            return "🏠"//"house"
        case .italia:
            return "🇮🇹"
        case .europa:
            return "🇪🇺"
        case .restoDelMondo:
           return "🌍"//"globe.europe.africa"
        case .noValue:
            return "🌍"//"⁉️"
        }
    }
    
    func orderAndStorageValue() -> Int {
    
        switch self {
        case .km0:
            return 1
        case .italia:
            return 2
        case .europa:
            return 3
        case .restoDelMondo:
            return 4
        case .noValue:
            return 5
        }
    }
    
    static func convertiInCase(fromNumber: Int) -> ProvenienzaIngrediente {
    
        switch fromNumber {
            
        case 1:
            return .km0
        case 2:
            return .italia
        case 3:
            return .europa
        case 4:
            return .restoDelMondo
        default:
            return .defaultValue
        }
    }

}
