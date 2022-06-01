//
//  DishType.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishCategoria: MyEnumProtocol,MyEnumProtocolMapConform { // Deprecata in Futuro. Da Sostituire con una Struct
 
    // quando scarichiamo i dati dal server, dobbiamo iterate tutte le tipologie salvate e inserirle nella static allCases. Insieme ai casi "standard" avremo così anche i casi custom.
    
    static var allCases: [DishCategoria] = [.antipasto,.primo,.secondo,.contorno,.pizza,.bevanda,.dessert,.frutta]
    static var defaultValue: DishCategoria = DishCategoria.tipologiaCustom("")
    
    // Potremmo associare l'icona standard ad ogni categoria
    case antipasto
    case primo
    case secondo
    case contorno
    
    case pizza
    
    case bevanda
    case dessert
    case frutta

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
        case .frutta: return "Frutta"
        case .tipologiaCustom(let customName): return customName.capitalized
        
        }
    }
    
    func simpleDescriptionSingolare() -> String {
   
        switch self {
            
        case .antipasto: return "Antipasto"
        case .primo: return "Primo"
        case .secondo: return "Secondo"
        case .contorno: return "Contorno"
        case .pizza: return "Pizza"
        case .bevanda: return "Bevanda"
        case .dessert: return "Dolce"
        case .frutta: return "Frutta"
        case .tipologiaCustom(let customName): return customName.capitalized
        
        }
    }

    
    func extendedDescription() -> String? {
        print("Dentro DishCategoria. DescrizioneEstesa non sviluppata")
        return nil
    }
    
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .antipasto:
            return "🫒"
        case .primo:
            return "🍝"
        case .secondo:
            return "🥩"
        case .contorno:
            return "🍟"
        case .pizza:
            return "🍕"
        case .bevanda:
            return "🍺"
        case .dessert:
            return "🍰"
        case .frutta:
            return "🍓"
        case .tipologiaCustom( _):
            return "🍽"
        }
    }
    
    func returnTypeCase() -> DishCategoria {
        
        switch self {
     
        case .tipologiaCustom( _):
            return .tipologiaCustom("")
        default: return self
            
        }
    }

    func orderValue() -> Int {
        
        switch self {
            
        case .antipasto:
            return 1
        case .primo:
            return 2
        case .secondo:
            return 3
        case .contorno:
            return 4
        case .pizza:
            return 5
        case .bevanda:
            return 8
        case .dessert:
            return 6
        case .frutta:
            return 7
        case .tipologiaCustom( _):
            return (DishCategoria.allCases.count + 1)
        }
    }
    
}

struct CategoriaMenu:MyEnumProtocol,MyEnumProtocolMapConform {

    static var allCases: [CategoriaMenu] = []
    static var defaultValue: CategoriaMenu = CategoriaMenu(nome: "", image: "🍽", listPositionOrder: 0)
    
    var id: String { self.nome.replacingOccurrences(of: " ", with: "").lowercased() }
    
    let nome: String
    let image: String
    var listPositionOrder: Int
    
   
    func createId() -> String { // Deprecata
        self.nome.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func simpleDescription() -> String { // Deprecata
        <#code#>
    }
    
   
    
    func extendedDescription() -> String? { // Deprecata
        <#code#>
    }
    
    func imageAssociated() -> String? { // Deprecata
        <#code#>
    }
    
    func returnTypeCase() -> CategoriaMenu { // Deprecata
        <#code#>
    }
    
    func orderValue() -> Int { // Deprecata
        <#code#>
    }
    
    
    
    
    
    
    
}
