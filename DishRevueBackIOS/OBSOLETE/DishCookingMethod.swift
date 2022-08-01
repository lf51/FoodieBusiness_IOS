//
//  DishCookingMethod.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

/*
enum DishCookingMethod: MyEnumProtocol  { // Deprecata 03.06 -> Informazione che genera confusione, I singoli ingredienti possono essere cotti in modi diversi, tante volte non c'è modo di indicare la cottura esatta di un piatto. Info che potremmo forse spostare sul singolo ingrediente, ma che potrebbe variare da piatto in piatto. Per cui la mettiamo in STAND-BY
    
    // Valutare di mantenere l'ultima scelta o meno in stile DishType
    
    static var allCases: [DishCookingMethod] = [.crudo,.padella,.bollito,.vapore,.frittura,.forno,.forno_a_legna,.griglia]
    static var defaultValue: DishCookingMethod = DishCookingMethod.metodoCustom("")
    
    case padella
    case bollito
    case vapore
    case frittura
    case forno
    case forno_a_legna
    case griglia
    case crudo
    
    case metodoCustom(_ customMethod:String) // creare la possibilità per il ristoratore di specificare qualunque cosa voglia
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .padella: return "Padella"
        case .bollito: return "Bollito"
        case .vapore: return "Vapore"
        case .frittura: return "Frittura"
        case .forno: return "Forno"
        case .forno_a_legna: return "Forno a Legna"
        case .griglia: return "Griglia"
        case .crudo: return "Crudo"
        case .metodoCustom(let customMethod): return customMethod.capitalized
            
        }
    }
    func extendedDescription() -> String? {
        print("Dentro DishCookingMethod. DescrizioneEstesa non sviluppata")
        return nil
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    

} */ // Deprecata 21.07
