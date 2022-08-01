//
//  ProduzioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProduzioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {

    static var allCases: [ProduzioneIngrediente] = [.biologico]
    
    static var defaultValue: ProduzioneIngrediente = .convenzionale
    
    var id: String { self.createId()}

    case convenzionale
    case biologico
   
    func simpleDescription() -> String {
        
        switch self {
            
        case .convenzionale: return "Metodo Convenzionale"
        case .biologico: return "Metodo Biologico"
        
        }
        
    }
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .convenzionale:
            return "Prodotto con metodo Convenzionale: Possibile uso intensivo di prodotti di sintesi chimica."
        case .biologico:
            return "Prodotto con metodo Biologico: Esclude l'utilizzo di prodotti di sintesi, salvo deroghe limitate e regolate."
        }
     
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
    }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .convenzionale:
            return "square.and.arrow.up.trianglebadge.exclamationmark"
        case .biologico:
            return "🍀"
       
        }
    }
    
    func returnTypeCase() -> ProduzioneIngrediente { self }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .convenzionale:
            return 2
        case .biologico:
            return 1
   
        }
    }
    
}
