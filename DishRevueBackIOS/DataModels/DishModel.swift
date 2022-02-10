//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation

struct DishModel: Identifiable {
    
    var id:String = UUID().uuidString
    
    var name: String
    var ingredientiPrincipali: [String] // i macro ingredienti classici di una ricetta
    var ingredientiSecondari: [String] // un maggior dettaglio sugli ingredienti usanti in preparazione // Esempio cotoletta panata nel Burro piuttosto che nell'Olio di Oliva o Olio di Semi
    
    //var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    
    var quantità: Double?
   // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var aBaseDi: DishBase
    var type: DishType
    var allergeni: [Allergeni]
    var category: [DishCategory]
    var metodoCottura: DishCookingMethod
    
    var restaurantMenu: [PropertyModel] = []
    
    // una proprietà che lo inserisce in un menu, ovvero in un ristorante
    
    init() { // init di un piatto nuovo e "vuoto"
        
        self.name = ""
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.images = []
        self.aBaseDi = .vegetali // di dafault
        self.type = .altro // di default
        self.allergeni = []
        self.category = []
        self.metodoCottura = .altro
    }
   
}

enum DishCookingMethod: String, CaseIterable, Identifiable {
    
    case padella
    case vapore
    case frittura
    case forno
    case griglia
    case crudo
    
    case altro // creare la possibilità per il ristoratore di specificare qualunque cosa voglia
    
    var id: String { self.rawValue }
}

enum DishType:String, CaseIterable, Identifiable {
    // Potremmo associare l'icona standard ad ogni categoria
    case antipasto
    case primo
    case secondo
    case contorno
    
    case pizza
    case tavolaCalda
    case panino
    case piadina
    
    case bevanda
    case dessert

    case altro  // creare la possibilità per il ristoratore di specificare qualunque cosa voglia 
    
    var id: String { self.rawValue }
}

enum DishBase:String, CaseIterable, Identifiable {
    // Potremmo Associare un icona ad ogni Tipo
    
    case carne // a base di carne o derivati (latte e derivati)
    case pesce // a base di pesce
    case vegetali // a base di vegetali
    
    var id: String { self.rawValue }
}

enum DishCategory: String, CaseIterable, Identifiable {
    
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegano // può contenere solo vegetali
    case milkFree // può contenere carne o pesce - Non può contenere latte&derivati
    case glutenFree // non contiene glutine
    
    var id: String { self.rawValue }
}

enum Allergeni:String, CaseIterable, Identifiable {
    
    //Potremmo associare un icona ad ogni allergene
    case arachidi_e_derivati
    case fruttaAguscio
    case latte_e_derivati
    case molluschi
    case crostacei
    case pesce
    case uova_e_derivati
    case sesamo
    case soia
    case glutine
    case lupini
    case senape
    case sedano
    case anidride_solforosa_e_solfiti
    
    case altro
 
    var id: String { self.rawValue }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .arachidi_e_derivati: return "Arachidi & derivati"
        case .fruttaAguscio: return "Frutta a guscio"
        case .latte_e_derivati: return "Latte & derivati"
        case .molluschi: return "Molluschi"
        case .pesce: return "Pesce"
        case .sesamo: return "Sesamo"
        case .soia: return "Soia"
        case .crostacei: return "Crostacei"
        case .glutine: return "Glutine"
        case .lupini: return "Lupini"
        case .senape: return "Senape"
        case .sedano: return "Sedano"
        case .anidride_solforosa_e_solfiti: return "Anidride Solforosa & Solfiti"
        case .uova_e_derivati: return "Uova & derivati"
        case .altro: return "Altro Non Specificato"
        
        }
        
    }
    
    
}
