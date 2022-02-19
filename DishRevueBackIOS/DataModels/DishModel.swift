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
    var ingredientiPrincipali: [String]
    var ingredientiSecondari: [String]
    // var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    // var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var type: DishType
    var aBaseDi: DishBase
    var metodoCottura: DishCookingMethod
    var category: DishCategory
    var avaibleFor: [DishAvaibleFor]
    var allergeni: [Allergeni]
    var tagliaPiatto: [DishSpecificValue]
    
    var restaurantWhereIsOnMenu: [PropertyModel] = []
    
    init() { // init di un piatto nuovo e "vuoto"
        
        self.name = ""
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.aBaseDi = .defaultValue
        self.type = .defaultValue
        self.allergeni = []
        self.tagliaPiatto = []
        self.category = .defaultValue
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
        
    }
   
}

protocol MyEnumProtocol: CaseIterable,Identifiable,Equatable { // Protocollo utile per un Generic di modo da passare differenti oggetti(ENUM) alla stessa View
      
    func simpleDescription() -> String
    
    static var defaultValue: Self { get }
}


enum DishSpecificValue: MyEnumProtocol {
    
    static var defaultValue: DishSpecificValue = DishSpecificValue.unico("n/d", "1", "n/d")
    
    static var allCases: [DishSpecificValue] = [.unico("n/d","1","n/d"),.doppio("n/d","1","n/d"),.piccolo("n/d","1","n/d"),.medio("n/d","1","n/d"),.grande("n/d","1","n/d"),.custom("Custom","n/d","1","n/d")]
    
    case unico(_ grammi:String, _ pax:String, _ prezzo: String)
    case doppio(_ grammi:String, _ pax:String, _ prezzo: String)
    
    case piccolo(_ grammi:String, _ pax:String, _ prezzo: String)
    case medio(_ grammi:String, _ pax:String, _ prezzo: String)
    case grande(_ grammi:String, _ pax:String, _ prezzo: String)
    
    case custom(_ nome: String, _ grammi: String, _ pax: String, _ prezzo: String)
   
    var id: String { self.simpleDescription() }
    
    func iterateTaglie() -> (peso:String,porzioni:String,prezzo:String) {
        
        switch self {
            
        case .unico(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .doppio(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .piccolo(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .medio(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .grande(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .custom(_, let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
            
        }
        
    }
    
  /*  func changeAssociatedValue(currentDish: inout DishModel, newValue: String) {
        
        let selfIndex = currentDish.tagliaPiatto.firstIndex(of: self)
        currentDish.tagliaPiatto.remove(at: selfIndex!)
        
        switch self {
            
        case .unico:
            currentDish.tagliaPiatto.append(.unico(newValue,newValue,newValue))
        case .doppio:
            currentDish.tagliaPiatto.append(.doppio(newValue,newValue,newValue))
        case .piccolo:
            currentDish.tagliaPiatto.append(.piccolo(newValue,newValue,newValue))
        case .medio:
            currentDish.tagliaPiatto.append(.medio(newValue,newValue,newValue))
        case .grande:
            currentDish.tagliaPiatto.append(.grande(newValue,newValue,newValue))
            
        }
        
        
    } */
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .unico: return "Unico"
        case .piccolo: return "Piccolo"
        case .medio: return "Medio"
        case .grande: return "Grande"
        case .doppio: return "Double"
        case .custom(let nome, _,_,_): return nome
                        
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
        
        // FUNZIONE DA IMPLEMENTARE PER TENERE CONTO DELLA CATEGORIA CUSTOM, e da implementare per impedire anche che venga dato come nome custom uno dei nomi dei casi dell'enum
    }
    
}

enum DishCookingMethod: MyEnumProtocol  {
    
    static var allCases: [DishCookingMethod] = [.padella,.bollito,.vapore,.frittura_olio,.frittura_aria,.forno_elettrico,.forno_a_legna,.griglia,.piastra,.crudo]
    static var defaultValue: DishCookingMethod = DishCookingMethod.altro("")
    
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
    
    case altro(_ customMethod:String) // creare la possibilità per il ristoratore di specificare qualunque cosa voglia
    
    var id: String { self.simpleDescription() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .padella: return "Padella"
        case .bollito: return "Bollito"
        case .vapore: return "Vapore"
        case .frittura_olio: return "Frittura con Olio"
        case .frittura_aria: return "Frittura ad Aria"
        case .forno_elettrico: return "Forno Elettrico"
        case .forno_a_legna: return "Forno a Legna"
        case .griglia: return "Griglia"
        case .piastra: return "Piastra"
        case .crudo: return "Crudo"
        case .altro(let customMethod): return customMethod
            
        }
    }
    // POSSIAMO TRASFORMARLO SUL MODELLO DEL DISHTYPE
}

enum DishType: MyEnumProtocol, Hashable {
    
    // quando scarichiamo i dati dal server, dobbiamo iterate tutte le tipologie salvate, e queste andranno a riempire la static allCases preventivamente svuotata. In questo modo i casi saranno tutti custom, e persisteranno(ovvero il ristoratore che ha creato una tipologia, se la ritroverà ogni volta che vuole creare un nuovo piatto). Di default, quindi prima che arrivino i dati dal server, la allCases avrà il contenuto scritto qui, che va a sostituire i vari singoli casi precedenti con un solo ma molteplice caso Custom
    
   // static var allCases: [DishType] = [.antipasto,.primo,.secondo,.contorno,.pizza,.bevanda,.dessert]
    static var allCases: [DishType] = [.tipologia("antipasti"),.tipologia("primi"),.tipologia("SEcondi"),.tipologia("ConTorni"),.tipologia("PiZze"),.tipologia("BevandE"),.tipologia("doLci")]
    static var defaultValue: DishType = DishType.tipologia("")
    
    // Potremmo associare l'icona standard ad ogni categoria
   /* case antipasto
    case primo
    case secondo
    case contorno
    
    case pizza
    
    case bevanda
    case dessert */

    case tipologia(_ customName:String)  // creare la possibilità per il ristoratore di specificare qualunque cosa voglia
    
    var id: String { self.createId() }
    
    func createId() -> String {
        
        switch self {
            
        case .tipologia(let customName): return customName.lowercased() // standardizziamo le stringhe ID in lowercases
            
        }
        
    }
    
    func simpleDescription() -> String {
   
        switch self {
            
      /*  case .antipasto: return "Antipasto"
        case .primo: return "Primo"
        case .secondo: return "Secondo"
        case .contorno: return "Contorno"
        case .pizza: return "Pizza"
        case .bevanda: return "Bevanda"
        case .dessert: return "Dessert" */
        case .tipologia(let customName): return customName.capitalized
        
        }
    }
    
}

enum DishBase: MyEnumProtocol {
    
    static var allCases: [DishBase] = [.carne,.pesce,.vegetali,.altro("da Specificare")]
    static var defaultValue: DishBase = DishBase.altro("")
    
    // Potremmo Associare un icona ad ogni Tipo
    
    case carne // a base di carne o derivati (latte e derivati)
    case pesce // a base di pesce
    case vegetali // a base di vegetali
    case altro(_ customBase: String)
    
    var id: String { self.simpleDescription() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .carne: return "Carne"
        case .pesce: return "Pesce"
        case .vegetali: return "Vegetali"
        case .altro(let customBase): return customBase
            
            
        }
    }
}

enum DishCategory: MyEnumProtocol {
    
    static var defaultValue: DishCategory = DishCategory.standard

    case standard // contiene di tutto
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // non contiene latte animale e prodotti derivati
    case vegano // può contenere solo vegetali
    
    var id: String { self.simpleDescription() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .standard: return "Standard"
        case .vegetariano: return "Vegetariano"
        case .vegariano: return "Vegariano"
        case .vegano: return "Vegano"
        
        }
    }
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .standard: return "Contiene ingredienti di origine animale e suoi derivati"
        case .vegetariano: return "Esclude la carne e il pesce"
        case .vegariano: return "Esclude il Latte Animale e i suoi derivati"
        case .vegano: return "Contiene SOLO ingredienti di origine vegetale"
        
        }
        
    }
    
}

enum DishAvaibleFor: MyEnumProtocol {
    
    // E' la possibilità di un piatto in Categoria standard di essere disponibile con modifiche per un'altra categoria
    static var allCases: [DishAvaibleFor] = [.vegetariano,.vegano,.vegariano,.glutenFree,.altro("da Specificare")]
    static var defaultValue: DishAvaibleFor = DishAvaibleFor.altro("da Specificare")

    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // può contenere carne o pesce - Non può contenere latte&derivati
    case vegano // può contenere solo vegetali
    case glutenFree // non contiene glutine
    case altro (_ customDiet: String)
    
    var id: String { self.simpleDescription() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .vegetariano: return "Vegetariana"
        case .vegariano: return "Vegariana" // Milk Free
        case .vegano: return "Vegana"
        case .glutenFree: return "Senza Glutine"
        case .altro(let customDiet): return "\(customDiet)"
            
        }
    }
}

enum Allergeni: MyEnumProtocol {
    
    static var allCases: [Allergeni] = [.arachidi_e_derivati,.fruttaAguscio,.latte_e_derivati,.molluschi,.crostacei,.pesce,.uova_e_derivati,.sesamo,.soia,.glutine,.lupini,.senape,.sedano,.anidride_solforosa_e_solfiti,.altro("da Specificare")]
    static var defaultValue: Allergeni = Allergeni.altro("da Specificare")
    
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
    
    case altro(_ otherAllergene: String)
 
    var id: String { self.simpleDescription() }
    
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
        case .altro(let otherAllergene): return otherAllergene
        
        }
        
    }
    
    
}


/*
// Creare Oggetto Ingrediente

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
    
} */

// End Creazione Oggetto Ingrediente
