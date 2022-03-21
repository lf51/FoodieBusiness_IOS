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

struct PropertyModel: MyModelProtocol {
    
    var intestazione: String = "" // deve sostituire il nome
    var alertItem: AlertModel?
    
    
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
    
  //  var scheduleServizio: [IntestazioneMenu] = [.colazione,.pranzo]
    
    var menuIn: [MenuModel] = [] // doppia scrittura con propertiesWhereIsIn in MenuModel
    
}

