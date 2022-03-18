//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation

struct MenuModel:MyModelProtocol {
    
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.tipologia == rhs.tipologia &&
        lhs.isAvaibleWhen == rhs.isAvaibleWhen &&
        lhs.dataInizio == rhs.dataInizio &&
        lhs.dataFine == rhs.dataFine &&
        lhs.giorniDelServizio == rhs.giorniDelServizio &&
        lhs.oraInizio == rhs.oraInizio &&
        lhs.oraFine == rhs.oraFine
        
    }
    
    var id: String {self.intestazione.replacingOccurrences(of: " ", with: "").lowercased() }
    
    var propertiesWhereIsUsed: [PropertyModel] = [] // doppia scrittura con MenuIn in PropertyModel
    var dishIn: [DishModel] = [] // doppia scrittura con MenuWhereIsIn in DishModel
    
    var intestazione: String = ""
    var tipologia: TipologiaMenu = .defaultValue
    
    var isAvaibleWhen: AvailabilityMenu = .defaultValue
    var dataInizio: Date = Date() // ruolo duplice, data inizio e data esatta
    var dataFine: Date = Date().advanced(by: 604800) // opzionale perchè possiamo non avere una fine in caso di data fissa
    var giorniDelServizio:[GiorniDelServizio] = []
    var oraInizio: Date = Date()
    var oraFine: Date = Date().advanced(by: 1800)
    
    var alertItem: AlertModel?
    //
    
//    init() {}
    init() {
        
    }
    
  //  var oraInizio: String
  //  var oraFine: String
    
}

enum AvailabilityMenu:Hashable {
    
    static var defaultValue: AvailabilityMenu = .noValue
    static var allCases:[AvailabilityMenu] = [.intervalloChiuso,.dataEsatta,.intervalloAperto]

    case dataEsatta
    case intervalloChiuso
    case intervalloAperto
    case noValue
    
    func shortDescription() -> String {
        
        switch self {
            
        case .dataEsatta:
            return "Data"
        case .intervalloChiuso:
            return "<..>"
        case .intervalloAperto:
            return "<..."
        case .noValue:
            return ""
        }
    }
    
    func extendedDescription() -> String {
        
        switch self {
        case .dataEsatta:
            return "Scegli una data esatta. Es: Menu di Natale"
        case .intervalloChiuso:
            return "Programma il Menu con un Inizio e una Fine"
        case .intervalloAperto:
            return "Programma il Menu con un Inizio senza una Fine"
        case .noValue:
            return ""
        }
        
    }
    
}

enum TipologiaMenu: MyEnumProtocol {
   
    static var allCases: [TipologiaMenu] = [.fisso(costo: "n/d"),.allaCarta]
    static var defaultValue: TipologiaMenu = .noValue
    
    var id:String {self.createId()}
    
    case fisso(persone:String = "1",costo: String)
    case allaCarta
    case noValue
    
    func simpleDescription() -> String {
        
        switch self {
        case .fisso:
            return "Fisso"
        case .allaCarta:
            return "Alla Carta"
        case .noValue:
            return ""
        }
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func editingAvaible() -> Bool {
        
        switch self {
            
        case .fisso:
            return true
        case .allaCarta:
            return false
        case .noValue:
            return false
        }
        
    }
}


enum GiorniDelServizio: MyEnumProtocol {

    static var defaultValue: GiorniDelServizio = .lunedi
    static var allDayService: [GiorniDelServizio] = [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato,.domenica] // abbiamo creato questo array uguale ma diverso dall'AllCases per aprire in futuro lo spazio ad un array con i giorni di attività escluso il giorno di riposo
    var id: String {self.createId()}
    
    case lunedi
    case martedi
    case mercoledi
    case giovedi
    case venerdi
    case sabato
    case domenica
    
    func simpleDescription() -> String {
        
        switch self {
        case .lunedi:
            return "Lunedi"
        case .martedi:
            return "Martedi"
        case .mercoledi:
            return "Mercoledi"
        case .giovedi:
            return "Giovedi"
        case .venerdi:
            return "Venerdi"
        case .sabato:
            return "Sabato"
        case .domenica:
            return "Domenica"
        }
    }
    
    func shortDescription() -> String {
        
        switch self {
            
        case .lunedi:
            return "L"
        case .martedi:
            return "Ma"
        case .mercoledi:
            return "Me"
        case .giovedi:
            return "G"
        case .venerdi:
            return "V"
        case .sabato:
            return "S"
        case .domenica:
            return "D"
        }
        
    }
    
    func createId() -> String {
        
        self.simpleDescription().lowercased()
    }
    
}

/*enum IntestazioneMenu: MyEnumProtocol,CustomGridAvaible {
    
    static func == (lhs: IntestazioneMenu, rhs: IntestazioneMenu) -> Bool {
        
        lhs.id == rhs.id
    }
    
    static var defaultValue: IntestazioneMenu = .custom(nome: "Nuovo Menu")
    
    static var allCases: [IntestazioneMenu] = [.colazione,.pranzo,.cena,.brunch,.aperitivo]
    
    var id: String {self.createId()}
    var nome: String {self.simpleDescription()}
    
    case colazione
    case pranzo
    case cena
    case brunch
    case aperitivo
    case custom(nome:String)
    
    func simpleDescription() -> String {
        
        switch self {
        case .colazione:
            return "Colazione"
        case .brunch:
            return "Brunch"
        case .pranzo:
            return "Pranzo"
        case .aperitivo:
            return "Aperitivo"
        case .cena:
            return "Cena"
        case .custom(let nome):
            return nome.capitalized
        }
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased()
    }
    
} */ // Deprecated 16.03.2022

/*
 
 func manipolateDateFromString(dateFormattedAsString: String) -> String {
     
     // la data è salvata come Stringa. E' una stringa complessa. Noi la riduciamo nuovamente come Date, la manipoliamo per estrapolare solo il dato che ci serve, ossia l'orario, e lo ritorniamo come stringa corta
     
     let formatterValue: DateFormatter = DateFormatter()
         formatterValue.timeStyle = .short
 
     let dateValue = ISO8601DateFormatter().date(from: dateFormattedAsString)
     
     let stringValue = formatterValue.string(from: dateValue ?? Date())
     
     print("DentroManipolateDate-Orario:\(stringValue)")
  //   return stringValue
     return stringValue
     // Non Funziona
 }
 
 
 */












/*enum MenuDelServizioBACKUP: MyEnumProtocol,CustomGridAvaible {
    
    static func == (lhs: MenuDelServizio, rhs: MenuDelServizio) -> Bool {
        
        lhs.id == rhs.id
    }
    
    static var defaultValue: MenuDelServizio = .custom(nome: "", inizio: "", fine: "", giorni: [])
    
    static var allCases: [MenuDelServizio] = [.colazione(inizio: "", fine: "", giorni: []),.pranzo(inizio: "", fine: "", giorni: []),.cena(inizio: "", fine: "", giorni: []),.brunch(inizio: "", fine: "", giorni: []),.aperitivo(inizio: "", fine: "", giorni: [])]
    
    var id: String {self.createId()}
    var nome: String {self.extendedDescription().nome}
    
    case colazione(inizio:String,fine:String,giorni:[GiorniDelServizio])
    case pranzo(inizio:String,fine:String,giorni:[GiorniDelServizio])
    case cena(inizio:String,fine:String,giorni:[GiorniDelServizio])
    case brunch(inizio:String,fine:String,giorni:[GiorniDelServizio])
    case aperitivo(inizio:String,fine:String,giorni:[GiorniDelServizio])
    
    
    case custom(nome:String,inizio:String,fine:String,giorni:[GiorniDelServizio])
    
    func simpleDescription() -> String {
        
        switch self {
        case .colazione:
            return "Colazione"
        case .brunch:
            return "Brunch"
        case .pranzo:
            return "Pranzo"
        case .aperitivo:
            return "Aperitivo"
        case .cena:
            return "Cena"
        case .custom(let nome,_,_,_):
            return nome.capitalized
        }
    }
    
    func extendedDescription() -> (nome:String,orario:String,dayIn:[String]) {
        
        switch self {
            
        case .colazione(let inizio, let fine, let giorni):
            let start = manipolateDateFromString(dateFormattedAsString: inizio)
            let end = manipolateDateFromString(dateFormattedAsString: fine)
            let dayIn = returnGiorniDelServizio(arrayGiorni: giorni)
            return ("Colazione","(\(start)-\(end))",dayIn)
            
        case .pranzo(let inizio, let fine, let giorni):
            let start = manipolateDateFromString(dateFormattedAsString: inizio)
            let end = manipolateDateFromString(dateFormattedAsString: fine)
            let dayIn = returnGiorniDelServizio(arrayGiorni: giorni)
            return ("Pranzo","(\(start)-\(end))",dayIn)
            
        case .cena(let inizio, let fine, let giorni):
            let start = manipolateDateFromString(dateFormattedAsString: inizio)
            let end = manipolateDateFromString(dateFormattedAsString: fine)
            let dayIn = returnGiorniDelServizio(arrayGiorni: giorni)
            return ("Cena","(\(start)-\(end))",dayIn)
            
        case .brunch(let inizio, let fine, let giorni):
            let start = manipolateDateFromString(dateFormattedAsString: inizio)
            let end = manipolateDateFromString(dateFormattedAsString: fine)
            let dayIn = returnGiorniDelServizio(arrayGiorni: giorni)
            return ("Brunch","(\(start)-\(end))",dayIn)
            
        case .aperitivo(let inizio, let fine, let giorni):
            let start = manipolateDateFromString(dateFormattedAsString: inizio)
            let end = manipolateDateFromString(dateFormattedAsString: fine)
            let dayIn = returnGiorniDelServizio(arrayGiorni: giorni)
            return ("Apertivo","(\(start)-\(end))",dayIn)
            
        case .custom(let nome, let inizio, let fine, let giorni):
            let start = manipolateDateFromString(dateFormattedAsString: inizio)
            let end = manipolateDateFromString(dateFormattedAsString: fine)
            let dayIn = returnGiorniDelServizio(arrayGiorni: giorni)
            return ("\(nome.capitalized)","(\(start)-\(end))",dayIn)
        }
    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func manipolateDateFromString(dateFormattedAsString: String) -> String {
        
        // la data è salvata come Stringa. E' una stringa complessa. Noi la riduciamo nuovamente come Date, la manipoliamo per estrapolare solo il dato che ci serve, ossia l'orario, e lo ritorniamo come stringa corta
        
        let formatterValue: DateFormatter = DateFormatter()
            formatterValue.timeStyle = .short
    
        let dateValue = ISO8601DateFormatter().date(from: dateFormattedAsString)
        
        let stringValue = formatterValue.string(from: dateValue ?? Date())
        
        print("DentroManipolateDate-Orario:\(stringValue)")
     //   return stringValue
        return stringValue
        // Non Funziona
    }
    
    func returnGiorniDelServizio(arrayGiorni: [GiorniDelServizio]) -> [String] {
        
        var dayIn:[String] = []
        
        for day in arrayGiorni {
            
            let dd = day.shortDescription()
            dayIn.append(dd)
            
        }
        
        return dayIn
    }
    
    
}*/

/* enum AvailabilityMenuBACKUP:Hashable {
    
    static var defaultValue: AvailabilityMenu = .intervalloAperto(intervalloData: DateInterval(start: .now, end: .distantFuture), neiGiorniDi: GiorniDelServizio.allDayService) // il default inizia subito, è un intervallo aperto, ed è valido tutti i giorni
    static var allCases:[AvailabilityMenu] = [.intervalloAperto(intervalloData: DateInterval(start: .now, end: .distantFuture), neiGiorniDi: GiorniDelServizio.allDayService),.dataEsatta(dataEsatta: DateComponents(year:2022, month: 12, day: 25)),.intervalloChiuso(intervalloData: DateInterval(start: .now, end: .distantFuture), neiGiorniDi: GiorniDelServizio.allDayService)]
    static var allCasesString: [String] = ["Data", "<...", "<..>"]
    
    case dataEsatta(dataEsatta:DateComponents)
    case intervalloChiuso(intervalloData: DateInterval, neiGiorniDi:[GiorniDelServizio])
    case intervalloAperto(intervalloData: DateInterval, neiGiorniDi:[GiorniDelServizio])
    
    func shortDescription() -> String {
        
        switch self {
            
        case .dataEsatta:
            return "Data"
        case .intervalloChiuso:
            return "<..>"
        case .intervalloAperto:
            return "<..."
        }
        
        
    }
    
} */
