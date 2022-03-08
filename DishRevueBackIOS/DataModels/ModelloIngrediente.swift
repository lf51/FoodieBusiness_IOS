//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation

// Creare Oggetto Ingrediente

struct ModelloIngrediente: IngredientConformation {
    
  static func == (lhs: ModelloIngrediente, rhs: ModelloIngrediente) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.provenienza == rhs.provenienza &&
      lhs.produzione == rhs.produzione &&
      lhs.conservazione == rhs.conservazione
    }
    
    var id: String { self.nome.replacingOccurrences(of:" ", with:"").lowercased() }

    var nome: String
    
  //  var cottura: DishCookingMethod // la cottura la evitiamo in questa fase perchè può generare confusione
    var provenienza: ProvenienzaIngrediente
    var produzione: ProduzioneIngrediente
  //  var stagionalita: StagionalitaIngrediente // la stagionalità non ha senso poichè è inserita dal ristoratore, ed è inserita quando? Ha senso se la attribuisce il sistema, ma è complesso.
    var conservazione: ConservazioneIngrediente
    
    var dishWhereIsUsed: [DishModel] = [] // creiamo la doppia scrittura, ossia registriamo l'ingrediente nel piatto, e il piatto nell'ingrediente, di modo da avere un array di facile accesso per mostrare tutti i piatti che utilizzano quel dato ingrediente
    
    
    // In futuro serviranno delle proprietà ulteriori, pensando nell'ottica che l'ingrediente possa essere gestito dall'app in chiave economato, quindi gestendo quantità e prezzi e rifornimenti necessari
    
    init() {
        
        self.nome = ""
       
        self.provenienza = .defaultValue
        self.produzione = .defaultValue
     
        self.conservazione = .defaultValue
        
    }
    
    init(nome: String, provenienza: ProvenienzaIngrediente, metodoDiProduzione: ProduzioneIngrediente) {
        
        self.nome = nome
     
        self.provenienza = provenienza
        self.produzione = metodoDiProduzione
        self.conservazione = .defaultValue
       
    }
    
    init(nome:String) {
        
        self.nome = nome
     
        self.provenienza = .defaultValue
        self.produzione = .defaultValue
        self.conservazione = .defaultValue
    }
    
    
}

enum ConservazioneIngrediente: MyEnumProtocol {
    
    static var allCases: [ConservazioneIngrediente] = [.fresco,.congelato,.surgelato,.conserva]
    static var defaultValue: ConservazioneIngrediente = ConservazioneIngrediente.custom("")
    
    var id: String {self.createId()}
    
    case fresco
    case congelato
    case surgelato
    case conserva
    
    case custom(_ metodoDiConservazione:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .fresco: return "Fresco"
        case .conserva: return "Conserva"
        case .surgelato: return "Surgelato"
        case .congelato: return "Congelato"
        case .custom(let metodoDiConservazione): return metodoDiConservazione.capitalized
            
        }
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with: "").lowercased()
    }
    
    
}

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
    
enum ProvenienzaIngrediente: MyEnumProtocol {
    
    static var defaultValue: ProvenienzaIngrediente = ProvenienzaIngrediente.custom("")
    static var allCases: [ProvenienzaIngrediente] = [.HomeMade, .Italia, .Europa, .RestoDelMondo]
    
    var id: String { self.createId() }
    
        case HomeMade
        case Italia
        case Europa
        case RestoDelMondo
        case custom(_ località:String)
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .HomeMade: return "Fatto in Casa"
        case .Italia: return "Italia"
        case .Europa: return "Comunità Europea"
        case .RestoDelMondo: return "Resto del Mondo"
        case .custom(let località): return località.capitalized
            
            }
        }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with:"").lowercased()
        }
    
    }
    
    


// End Creazione Oggetto Ingrediente

protocol IngredientConformation: Identifiable, Equatable {
    
    var nome:String {get}
}

// Modello base da caricare da un Json

struct BaseModelloIngrediente: IngredientConformation {
    
    var id: String {self.nome.replacingOccurrences(of: " ", with: "").lowercased() }
    
    let nome: String
    
}



func load<T:Decodable>(_ filename:String) -> T {
    
    let data:Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {fatalError("Non è possibile trovare \(filename) in the main bundle") }
    
    do {
        data = try Data(contentsOf: file)
    } catch {fatalError("Non è possibile caricare il file \(filename)") }
    
    do { let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {fatalError("Impossibile eseguire il PARSE sul file \(filename) as \(T.self):\n\(error)") }
    
}

