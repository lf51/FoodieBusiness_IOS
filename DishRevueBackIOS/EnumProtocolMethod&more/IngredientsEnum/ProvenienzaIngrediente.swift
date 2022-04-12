//
//  ProvenienzaIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProvenienzaIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
 
    static var defaultValue: ProvenienzaIngrediente = ProvenienzaIngrediente.custom("")
    static var allCases: [ProvenienzaIngrediente] = [.HomeMade, .Italia, .Europa, .RestoDelMondo]
    
    var id: String { self.createId() }
    
        case HomeMade
        case Italia
        case Europa
        case RestoDelMondo
        case custom(_ località:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .HomeMade: return "Fatto in Casa"
        case .Italia: return "Italia"
        case .Europa: return "UE"
        case .RestoDelMondo: return "Extra UE"
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
            
        case .HomeMade:
            return "house"
        case .Italia:
            return "🇮🇹"
        case .Europa:
            return "🇪🇺"
        case .RestoDelMondo:
           return "globe.europe.africa"
        case .custom( _):
            return nil
        }
    }
    
    func orderValue() -> Int {
    
        switch self {
        case .HomeMade:
            return 1
        case .Italia:
            return 2
        case .Europa:
            return 3
        case .RestoDelMondo:
            return 4
        case .custom( _):
            return (ProvenienzaIngrediente.allCases.count + 1)
        }
    }

    
    
}
