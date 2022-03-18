//
//  ProvenienzaIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProvenienzaIngrediente: MyEnumProtocol {
    
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
    
    }
