//
//  DishType.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishCategoria: MyEnumProtocol,MyEnumProtocolMapConform {
    func returnTypeCase() -> DishCategoria {
        print("dentro DishCategoria return type")
        return .antipasto
    }
    
    
    // quando scarichiamo i dati dal server, dobbiamo iterate tutte le tipologie salvate e inserirle nella static allCases. Insieme ai casi "standard" avremo così anche i casi custom.
    
    static var allCases: [DishCategoria] = [.antipasto,.primo,.secondo,.contorno,.pizza,.bevanda,.dessert]
    static var defaultValue: DishCategoria = DishCategoria.tipologiaCustom("")
    
    // Potremmo associare l'icona standard ad ogni categoria
    case antipasto
    case primo
    case secondo
    case contorno
    
    case pizza
    
    case bevanda
    case dessert

    case tipologiaCustom(_ customName:String)  // creare la possibilità per il ristoratore di specificare qualunque cosa voglia
    
    var id: String { self.createId() }
    
    func mantieniUltimaScelta() {
        
        guard let index = DishCategoria.allCases.firstIndex(of: self) else { return }
        DishCategoria.defaultValue = self
        DishCategoria.allCases.remove(at: index)
        DishCategoria.allCases.insert(self, at: 0)
        
        // Impostiamo l'ultima scelta come default e la mettiamo per prima nell'array. In questo modo, in caso di piatti creati in consecutio, la scelta del tipo persiste e può essere comodo. Ovviamente può semore essere cambiata
    }
    
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
        
    }
    
    func simpleDescription() -> String {
   
        switch self {
            
        case .antipasto: return "Antipasti"
        case .primo: return "Primi"
        case .secondo: return "Secondi"
        case .contorno: return "Contorni"
        case .pizza: return "Pizze"
        case .bevanda: return "Bevande"
        case .dessert: return "Dolci"
        case .tipologiaCustom(let customName): return customName.capitalized
        
        }
    }
    
    func imageAssociated() -> String {
        
        switch self {
        case .antipasto:
            return "fork.knife.circle"
        case .primo:
            return "fork.knife.circle"
        case .secondo:
            return "fork.knife.circle"
        case .contorno:
            return "fork.knife.circle"
        case .pizza:
            return "fork.knife.circle"
        case .bevanda:
            return "fork.knife.circle"
        case .dessert:
            return "fork.knife.circle"
        case .tipologiaCustom( _):
            return "fork.knife.circle"
        }
    }
    
}
