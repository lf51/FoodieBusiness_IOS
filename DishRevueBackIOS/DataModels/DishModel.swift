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
    
    var alertItem: AlertModel?
    
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
    func createId() -> String
    
    static var defaultValue: Self { get }
}


enum DishSpecificValue: MyEnumProtocol, Hashable {
    
    static var defaultValue: DishSpecificValue = DishSpecificValue.unico("n/d", "1", "n/d")
    
    static var allCases: [DishSpecificValue] = [.unico("n/d","1","n/d"),.doppio("n/d","1","n/d"),.piccolo("n/d","1","n/d"),.medio("n/d","1","n/d"),.grande("n/d","1","n/d")]
    
    case unico(_ grammi:String, _ pax:String, _ prezzo: String)
    case doppio(_ grammi:String, _ pax:String, _ prezzo: String)
    
    case piccolo(_ grammi:String, _ pax:String, _ prezzo: String)
    case medio(_ grammi:String, _ pax:String, _ prezzo: String)
    case grande(_ grammi:String, _ pax:String, _ prezzo: String)
    
    case custom(_ nome: String, _ grammi: String, _ pax: String, _ prezzo: String)
   
    var id: String { self.createId() }
    
    func showAssociatedValue() -> (peso:String,porzioni:String,prezzo:String) {
        
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

    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .unico: return "Unico"
        case .piccolo: return "Piccolo"
        case .medio: return "Medio"
        case .grande: return "Grande"
        case .doppio: return "Double"
        case .custom(let nome, _,_,_): return nome.capitalized
                        
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
        let set_listaDelleTaglie = Set(listaDelleTaglie)
        
        let avaibleList: Set<String> =  ["unico", "double", "piccolo", "medio", "grande"]
        let avaibleSubList_1: Set<String> = ["unico", "double"]
        let avaibleSubList_2: Set<String> = ["piccolo", "medio", "grande"]
    
        if set_listaDelleTaglie.isDisjoint(with: avaibleList) {
            
            if avaibleList.contains(sceltaCorrente) { return true } else { return false }
        }
        
        else {
            
            if set_listaDelleTaglie.isDisjoint(with: avaibleSubList_1) {
                
                if avaibleSubList_2.contains(sceltaCorrente) {return false} else {return true}
                
            } else {
                
                if avaibleSubList_1.contains(sceltaCorrente) {return false } else {return true}
                
            }
        }
    }
    
    func qualeComboIsAvaible() -> String {
        
        let avaibleList =  ["unico", "double", "piccolo", "medio", "grande"]
        var avaibleSubList_1 = ["unico", "double"]
        var avaibleSubList_2 = ["piccolo", "medio", "grande"]
        
        if !avaibleList.contains(self.id) {
            
            return "La specifica \"\(self.simpleDescription())\" è utilizzabile solo in combinazione con altre specifiche Custom"
        }
        
        else if avaibleSubList_1.contains(self.id) {
            
            let index = avaibleSubList_1.firstIndex(of: self.id)
            avaibleSubList_1.remove(at: index!)
            
            return "La specifica \"\(self.simpleDescription())\" è utilizzabile solo in combinazione con la specifica \(avaibleSubList_1.description)"
        }
        
        else {
            
            let index = avaibleSubList_2.firstIndex(of: self.id)
            avaibleSubList_2.remove(at: index!)
            
            return "La specifica \"\(self.simpleDescription())\" è utilizzabile solo in combinazione con le specifiche \(avaibleSubList_2.description)"
            
        }
        
    }
    
    static func isCustomCaseNameOriginal(customName: String) -> Bool {
        
        let allCasesId = allCases.map({$0.id})
        let ipotetingCustomNameId = customName.replacingOccurrences(of:" ", with:"").lowercased()
        
        if allCasesId.contains(ipotetingCustomNameId) { return false } else { return true}
        
    }
    
}

enum DishCookingMethod: MyEnumProtocol  {
    
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
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }

}

enum DishType: MyEnumProtocol, Hashable {
    
    // quando scarichiamo i dati dal server, dobbiamo iterate tutte le tipologie salvate e inserirle nella static allCases. Insieme ai casi "standard" avremo così anche i casi custom.
    
    static var allCases: [DishType] = [.antipasto,.primo,.secondo,.contorno,.pizza,.bevanda,.dessert]
    static var defaultValue: DishType = DishType.tipologiaCustom("")
    
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
        
        guard let index = DishType.allCases.firstIndex(of: self) else { return }
        DishType.defaultValue = self
        DishType.allCases.remove(at: index)
        DishType.allCases.insert(self, at: 0)
        
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
    
}

enum DishBase: MyEnumProtocol {
    
    static var allCases: [DishBase] = [.carne,.pesce,.vegetali] // Non essendoci valori Associati, la allCases potrebbe essere implicita, ma la esplicitiamo per omettere il caso NoValue, di modo che non appaia fra le opzioni di scelta
    static var defaultValue: DishBase = DishBase.noValue
    
    // Potremmo Associare un icona ad ogni Tipo
    
    case carne // a base di carne o derivati (latte e derivati)
    case pesce // a base di pesce
    case vegetali // a base di vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .carne: return "Carne"
        case .pesce: return "Pesce"
        case .vegetali: return "Vegetali"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
}

enum DishCategory: MyEnumProtocol {
    
    static var allCases: [DishCategory] = [.standard,.vegetariano,.vegariano,.vegano]
    static var defaultValue: DishCategory = DishCategory.noValue

    case standard // contiene di tutto
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // non contiene latte animale e prodotti derivati
    case vegano // può contenere solo vegetali
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId()}
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .standard: return "Standard"
        case .vegetariano: return "Vegetariano"
        case .vegariano: return "Vegariano"
        case .vegano: return "Vegano"
        case .noValue: return "Nessun Valore"
        
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .standard: return "Contiene ingredienti di origine animale e suoi derivati"
        case .vegetariano: return "Esclude la carne e il pesce"
        case .vegariano: return "Esclude il Latte Animale e i suoi derivati"
        case .vegano: return "Contiene SOLO ingredienti di origine vegetale"
        case .noValue: return ""
        
        }
        
    }
    
}

enum DishAvaibleFor: MyEnumProtocol {
    
    // E' la possibilità di un piatto in Categoria standard di essere disponibile con modifiche per un'altra categoria
    static var allCases: [DishAvaibleFor] = [.vegetariano,.vegano,.vegariano,.glutenFree]
    static var defaultValue: DishAvaibleFor = DishAvaibleFor.noValue

    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // può contenere carne o pesce - Non può contenere latte&derivati
    case vegano // può contenere solo vegetali
    case glutenFree // non contiene glutine
    
    case noValue // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId()}
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .vegetariano: return "Vegetariana"
        case .vegariano: return "Vegariana" // Milk Free
        case .vegano: return "Vegana"
        case .glutenFree: return "Senza Glutine"
        case .noValue: return "Nessun Valore"
            
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
}

enum Allergeni: MyEnumProtocol {
    
    static var allCases: [Allergeni] = [.arachidi_e_derivati,.anidride_solforosa_e_solfiti,.crostacei,.fruttaAguscio,.glutine,.latte_e_derivati,.lupini,.molluschi,.pesce,.sedano,.senape,.sesamo,.soia,.uova_e_derivati]
    static var defaultValue: Allergeni = Allergeni.noValue
    
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
    
    case noValue // lo usiamo per avere un valore di default Nullo
 
    var id: String { self.createId() }
    
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
        case .noValue: return "Nessun Valore"
        
        }
        
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
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
