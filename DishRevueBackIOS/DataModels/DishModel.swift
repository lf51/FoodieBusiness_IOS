//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation

struct DishModel: Identifiable {
    
    var id:String = UUID().uuidString
    
    var name: String
    var ingredientiPrincipali: [String] // i macro ingredienti classici di una ricetta
    var ingredientiSecondari: [String] // un maggior dettaglio sugli ingredienti usanti in preparazione // Esempio cotoletta panata nel Burro piuttosto che nell'Olio di Oliva o Olio di Semi
    
    //var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    
    var quantità: Int?
   // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var aBaseDi: DishBase
    var type: DishType
    var allergeni: [Allergeni]
    var category: [DishCategory]
    var metodoCottura: DishCookingMethod
    
    var tagliaPiatto: [DishSpecificValue] = []
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

struct Ingrediente {
    
    let nome: String
    
    let cottura: DishCookingMethod?
    let provenienza: String?
    let produzione: QualityIngrediente?
    
}

enum QualityIngrediente: String {
    
    case convenzionale = "Convenzionale"
    case biologio = "Bio"
    case naturale = "Naturale"
    case selvatico = "Selvatico"
    case homeMade = "Fatto in Casa"
    
   /* func simpleDescription() -> String {
        
        switch self {
            
        case .convenzionale: return "Convenzionale"
        case .biologio: return "Bio"
        case .naturale: return "Naturale"
        case .selvatico: return "Selvatico"
        case .homeMade: return "Fatto in Casa"
            
        }
        
    } */
    
}

enum DishSpecificValue: CaseIterable, Identifiable {
    
    static var allCases: [DishSpecificValue] = [.unico(0,1,0.0),.doppio(0,1,0.0),.piccolo(0,1,0.0),.medio(0,1,0.0),.grande(0,1,0.0)]
    
    case unico(_ grammi:Int, _ pax:Int, _ prezzo: Double)
    case doppio(_ grammi:Int, _ pax:Int, _ prezzo: Double)
    
    case piccolo(_ grammi:Int, _ pax:Int, _ prezzo: Double)
    case medio(_ grammi:Int, _ pax:Int, _ prezzo: Double)
    case grande(_ grammi:Int, _ pax:Int, _ prezzo: Double)
   
    var id: String { self.simpleDescription() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .unico: return "Unico"
        case .piccolo: return "Piccolo"
        case .medio: return "Medio"
        case .grande: return "Grande"
        case .doppio: return "Double"
                        
        }
    }

    
    func isTagliaAlreadyIn(newDish: DishModel) -> Bool  {
        
        newDish.tagliaPiatto.contains { taglia in
            
            taglia.id == self.id // controlliamo che l'array tagliaPiatto non contenga già un elemento con lo stesso id.
            
        }
        
    }
    
    func isSceltaBloccata(newDish: DishModel) -> Bool {
        
        // prima opzione
        guard !newDish.tagliaPiatto.isEmpty else {return false}
        //
        let sceltaCorrente = self.id
        let listaDelleTaglie = newDish.tagliaPiatto.map {$0.id}
        
        let avaibleList_1: Set<String> = ["Unico", "Double"]
        let avaibleList_2: Set<String> = ["Piccolo", "Medio", "Grande"]
        
        let set_listaDelleTaglie = Set(listaDelleTaglie)
        
        if set_listaDelleTaglie.isDisjoint(with: avaibleList_1) {
            
            if avaibleList_2.contains(sceltaCorrente) {return false } else {return true}
            
        } else {
            
            if avaibleList_1.contains(sceltaCorrente) {return false } else {return true}
            
        }
    }
    
    
    
    
}

enum DishCookingMethod: String, CaseIterable, Identifiable {
    
    case padella
    case bollito
    case vapore
    case frittura_olio
    case frittura_aria
    case forno_elettrico
    case forno_a_legna
    case griglia
    case piastra
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
    
    //Potremmo associare un icona ad ogni allergene e utilizzare la simpleDescription() al posto dei RawValue
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
