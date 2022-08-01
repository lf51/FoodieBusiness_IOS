//
//  ProvenienzaIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProvenienzaIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {
 
    static var allCases: [ProvenienzaIngrediente] = [.km0, .italia, .europa, .restoDelMondo]
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
        case .noValue: return "Luogo di Produzione non Indicato"
            
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
            return "square.and.arrow.up.trianglebadge.exclamationmark"
        }
    }
    
    func orderValue() -> Int {
    
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

}
