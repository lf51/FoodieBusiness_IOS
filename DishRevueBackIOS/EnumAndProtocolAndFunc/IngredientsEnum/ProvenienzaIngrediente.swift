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
        case .Europa: return "Comunità Europea"
        case .RestoDelMondo: return "Resto del Mondo"
        case .custom(let località): return località.capitalized
            
            }
        }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
        }
    
    func returnTypeCase() -> ProvenienzaIngrediente {
        
        switch self {
        case .HomeMade:
            return .HomeMade
        case .Italia:
            return .Italia
        case .Europa:
            return .Europa
        case .RestoDelMondo:
            return .RestoDelMondo
        case .custom( _):
            return .custom("")
        }
   
    }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .HomeMade:
            return "house.circle"
        case .Italia:
            return "leaf"
        case .Europa:
            return "bus.fill"
        case .RestoDelMondo:
           return "globe.europe.africa"
        case .custom( _):
            return "globe.europe.africa"
        }
    }
    
    
    
}
