//
//  ProduzioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProduzioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {

    static var allCases: [ProduzioneIngrediente] = [.biologico,.convenzionale]
    
    static var defaultValue: ProduzioneIngrediente = .noValue
    
    var id: String { self.createId()}

    case convenzionale
    case biologico
    case noValue
   
    func simpleDescription() -> String {
        
        switch self {
            
        case .convenzionale: return "Metodo Convenzionale"
        case .biologico: return "Metodo Biologico"
        case .noValue: return ""
        
        }
        
    }
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .convenzionale:
            return "Prodotto con metodo Convenzionale: Possibile uso intensivo di prodotti di sintesi chimica."
        case .biologico:
            return "Prodotto con metodo Biologico: Esclude l'utilizzo di prodotti di sintesi, salvo deroghe limitate e regolate."
        case .noValue:
            return ""
        }
     
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
    }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .convenzionale:
            return "🚜"
        case .biologico:
            return "♻️"
        case .noValue:
            return "⚙️"
       
        }
    }
    
    func returnTypeCase() -> ProduzioneIngrediente { self }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .convenzionale:
            return 2
        case .biologico:
            return 1
        case .noValue:
            return 0
   
        }
    }
    
}
