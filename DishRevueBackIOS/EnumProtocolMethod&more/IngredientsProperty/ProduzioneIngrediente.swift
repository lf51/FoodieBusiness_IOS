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
    
    func extendedDescription() -> String? {
        
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
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .convenzionale:
            return nil
        case .biologico:
            return "🍀"
       
        }
    }
    
    func returnTypeCase() -> ProduzioneIngrediente {
        .convenzionale
            
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .convenzionale:
            return 2
        case .biologico:
            return 1
   
        }
    }
    
}


/*
enum ProduzioneIngrediente: MyEnumProtocol, MyEnumProtocolMapConform {

    static var defaultValue: ProduzioneIngrediente = ProduzioneIngrediente.custom("")
    static var allCases: [ProduzioneIngrediente] = [.convenzionale,.biologico,.naturale,.pastorale,.intensivo,.allevamentoPesce,.selvatico]
    
    var id: String { self.createId()}

    //agricoltura
    case convenzionale
    case biologico
    case naturale
    //animale
    case pastorale
    case intensivo
    //pesce
    case allevamentoPesce
    
    case selvatico // vale per animali/pesce/vegetali
   
    case custom(_ metodoDiProduzione:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .convenzionale: return "Agricoltura Convenzionale"
        case .biologico: return "Agricoltura Biologica"
        case .naturale: return "Agricoltura Naturale"
            
        case .pastorale: return "Allevamento Pastorale"
        case .intensivo: return "Allevamento Intensivo"
            
        case .allevamentoPesce: return "Pesce di allevamento"
            
        case .selvatico: return "Selvatico"
        case .custom(let metodoDiProduzione): return metodoDiProduzione.capitalized
            
        }
        
    }
    
    func extendedDescription() -> String? {
        
        switch self {
            
        case .convenzionale:
            return "Possibile uso intensivo di prodotti di sintesi chimica."
        case .biologico:
            return "Esclude l'utilizzo di prodotti di sintesi, salvo deroghe limitate e regolate."
        case .naturale:
            return "Esclude l'utilizzo di qualsiasi prodotto di sintesi."
        case .pastorale:
            return "Gli animali sono tenuti in libertà a pascolare."
        case .intensivo:
            return "Gli animali sono tenuti in stalle modello per ottenere soggetti specializzati."
        case .allevamentoPesce:
            return nil
        case .selvatico:
            return "Erbe spontanee/Animali allo stato brado/Pescato."
        case .custom( _):
            print("INSERIRE VALORE ASSOCIATO DESCRIZIONE CASE CUSTOM IN PRODUZIONE INGREDIENTE")
            return nil
        }
     
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .convenzionale:
            return "⚠️"
        case .biologico:
            return "🐞"
        case .naturale:
            return "🍀"
            
        case .pastorale:
            return nil
        case .intensivo:
            return nil
            
        case .allevamentoPesce:
            return nil
            
        case .selvatico:
            return "hare"
        case .custom(_):
            return nil
        }
    }
    
    func returnTypeCase() -> ProduzioneIngrediente {
        print("dentro produzione ingrediente returnType")
        switch self {
       
        case .custom( _):
            return .custom("")
        default: return self
            
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .convenzionale:
            return 3
        case .biologico:
            return 1
        case .naturale:
            return 2
            
        case .pastorale:
            return 4
        case .intensivo:
            return 5
            
        case .allevamentoPesce:
            return 6
            
        case .selvatico:
            return 7
        case .custom( _):
            return (ProduzioneIngrediente.allCases.count + 1)
        }
    }
    
} */ // Deprecata 19.07
