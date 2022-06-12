//
//  ProvenienzaIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProvenienzaIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
 
    static var defaultValue: ProvenienzaIngrediente = ProvenienzaIngrediente.custom("")
    static var allCases: [ProvenienzaIngrediente] = [.homeMade, .italia, .europa, .restoDelMondo]
    
    var id: String { self.createId() }
    
        case homeMade
        case italia
        case europa
        case restoDelMondo
        case custom(_ località:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .homeMade: return "Fatto in Casa"
        case .italia: return "Italia"
        case .europa: return "UE"
        case .restoDelMondo: return "Extra UE"
        case .custom(let località): return località.capitalized
            
            }
        }
    
    func extendedDescription() -> String? {
        print("Dentro ProvenienzaIngrediente. DescrizioneEstesa non sviluppata")
        return nil
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
        }
    
    func returnTypeCase() -> ProvenienzaIngrediente {
        
        switch self {
    
        case .custom( _):
            return .custom("")
            
        default: return self
            
        }
   
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .homeMade:
            return "house"
        case .italia:
            return "🇮🇹"
        case .europa:
            return "🇪🇺"
        case .restoDelMondo:
           return "globe.europe.africa"
        case .custom( _):
            return nil
        }
    }
    
    func orderValue() -> Int {
    
        switch self {
        case .homeMade:
            return 1
        case .italia:
            return 2
        case .europa:
            return 3
        case .restoDelMondo:
            return 4
        case .custom( _):
            return (ProvenienzaIngrediente.allCases.count + 1)
        }
    }

    
    
}
