//
//  PropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import MapKit

/* La registrazione di una proprietò avviene da Maps. Se l'attività non è ancora presente in Maps la registrazione non può avvenire. Potremmo predisporre una registrazione manuale ma non lo facciamo per i seguenti motivi:
 • Usando Maps ci affidiamo ad un servizio già collaudato e non ci dobbiamo preoccupare di verificare l'esistenza reale di quella proprietà, cosa che invece diventerebbe necessaria in caso di inserimento manuale.
 • Usando Maps inoltre non dobbiamo preoccuparci dei duplicati, ossia della possibilità che qualcuno registri un'attività esistente in modo manuale nella via di fianco creando confusione
 • Usando Maps risolviamo quindi delle grane "fiduciarie" e ci resta soltanto di autenticare il legame fra l'attività registrata e il registrante
 • Resta un problema per le nuove attività non ancora registrate su Maps. Per queste sarebbe necessario procedere in manuale, ma sacrifichiamo le nuovissime attività non ancora registrate per evitarci i problemi di cui sopra. Confidiamo nel fatto, poi, essendo la registrazione sulle mappe qualcosa da cui un'attività non può prescindere che questa avvenga al più presto abilitando così la registrazione sulla nostra App.

*/

struct PropertyModel: Identifiable, Equatable {
    static func == (lhs: PropertyModel, rhs: PropertyModel) -> Bool {
        
        lhs.id == rhs.id
    }
    
   var id: String {
        
       // let cod1 = name.replacingOccurrences(of: " ", with: "-").lowercased()
       // let cod2 = cityName.replacingOccurrences(of: " ", with: "-").lowercased()
        let cod3 = String(coordinates.latitude).replacingOccurrences(of: ".", with: "A")
        let cod4 = String(coordinates.longitude).replacingOccurrences(of: ".", with: "E")
    
        let codId = cod3 + cod4
       
       return codId
       
       // let id = UUID().uuidString // Questo sistema non garantisce l'unicità. Il compilatore andrebbe a considerare due oggetti diversi, due location uguali, ossia con stesso nome indirizzo e blabla solo perchè avrebbero due id differenti. Il grande Nick ci viene in soccorso e crea una computed
         
        // l'utilizzo di .hashValue non garantisce UNICITA?. Non va bene perchè produce un id diverso fra le varie sessioni. Quindi può andare bene nella sessione locale ma non per salvare l'info sul dataBase
       
       /// Sistema di identificazione NON SODDISFACENTE -- Temo Rallentamenti. Nella ricerca, quando si trova a livello macro, crea degli id che non sono Univoci
       
    }
    
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    var imageNames: [String] = []
    let webSite: String
    let phoneNumber: String
    let streetAdress: String
    
    var scheduleServizio: [MenuDelServizio] = [.colazione(inizio: "06.00", fine: "10.00", giorni: [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi]),.pranzo(inizio: "12.00", fine: "15.00", giorni: [.sabato])]
    
}

enum GiorniDelServizio: MyEnumProtocol {

    static var defaultValue: GiorniDelServizio = .lunedi
    
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

enum MenuDelServizio: MyEnumProtocol,CustomGridAvaible {
    
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
    
    
}
