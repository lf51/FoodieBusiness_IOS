//
//  ProduzioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProduzioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {

    func returnTypeCase() -> ProduzioneIngrediente {
        print("dentro produzione ingrediente returnType")
        switch self {
        case .convenzionale:
            return .convenzionale
        case .biologico:
            return .biologico
        case .naturale:
            return .naturale
        case .selvatico:
            return .selvatico
        case .custom( _):
            return .custom("")
        }
    }
    
    static var defaultValue: ProduzioneIngrediente = ProduzioneIngrediente.custom("")
    static var allCases: [ProduzioneIngrediente] = [.convenzionale,.biologico,.naturale,.selvatico]
    
    var id: String { self.createId()}

    case convenzionale
    case biologico
    case naturale
    case selvatico
   
    case custom(_ metodoDiProduzione:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .convenzionale: return "Convenzionale"
        case .biologico: return "Biologico"
        case .naturale: return "Naturale"
        case .selvatico: return "Selvatico"
        case .custom(let metodoDiProduzione): return metodoDiProduzione.capitalized
            
        }
        
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
    }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .convenzionale:
            return "hammer.circle"
        case .biologico:
            return "leaf"
        case .naturale:
            return "leaf"
        case .selvatico:
            return "leaf"
        case .custom(_):
            return "leaf"
        }
    }
}
