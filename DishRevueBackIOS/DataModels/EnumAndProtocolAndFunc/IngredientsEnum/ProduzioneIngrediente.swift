//
//  ProduzioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ProduzioneIngrediente: MyEnumProtocol {

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
}
