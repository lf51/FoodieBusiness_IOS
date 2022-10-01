//
//  PropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import MapKit
import SwiftUI

// !! Nota Vocale 19.09 !! Sulle info della Proprietà

/* La registrazione di una proprietò avviene da Maps. Se l'attività non è ancora presente in Maps la registrazione non può avvenire. Potremmo predisporre una registrazione manuale ma non lo facciamo per i seguenti motivi:
 • Usando Maps ci affidiamo ad un servizio già collaudato e non ci dobbiamo preoccupare di verificare l'esistenza reale di quella proprietà, cosa che invece diventerebbe necessaria in caso di inserimento manuale.
 • Usando Maps inoltre non dobbiamo preoccuparci dei duplicati, ossia della possibilità che qualcuno registri un'attività esistente in modo manuale nella via di fianco creando confusione
 • Usando Maps risolviamo quindi delle grane "fiduciarie" e ci resta soltanto di autenticare il legame fra l'attività registrata e il registrante
 • Resta un problema per le nuove attività non ancora registrate su Maps. Per queste sarebbe necessario procedere in manuale, ma sacrifichiamo le nuovissime attività non ancora registrate per evitarci i problemi di cui sopra. Confidiamo nel fatto, poi, essendo la registrazione sulle mappe qualcosa da cui un'attività non può prescindere che questa avvenga al più presto abilitando così la registrazione sulla nostra App.

*/

struct PropertyModel:MyProStarterPack_L1,MyProVisualPack_L0,MyProDescriptionPack_L0 /*: MyProModelPack_L0, Hashable*/{

    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [PropertyModel]> {
        return \.allMyProperties
    }
        
    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        VStack {
            
            Button {
               // viewModel.deleteItemModel(itemModel: property)
            } label: {
                HStack {
                    
                    Image(systemName:"eye")
                    Text("Vedi Info")
                    
                }
            }
            
            Button {
               viewModel[keyPath: navigationPath].append(DestinationPathView.property(self))
            } label: {
                HStack {
                    Image(systemName:"arrow.up.forward.square")
                    Text("Edit")
                }
            }
            
            Button {
               // viewModel.deleteItemModel(itemModel: property)
            } label: {
                HStack {
                    
                    Image(systemName:"person.badge.shield.checkmark.fill")
                    Text("Chiedi Verifica")
                    
                }
            }.disabled(true)
            
            Button(role:.destructive) {
                viewModel.deleteItemModel(itemModel: self)
            } label: {
                HStack {
                    Image(systemName:"trash")
                    Text("Elimina")
                    
                }
            }
            
         
        }
    }
    
   /* func returnNewModel() -> (tipo: PropertyModel, nometipo: String) {
        (PropertyModel(),"Nuova Proprietà")
    } */

  /*  func returnModelTypeName() -> String {
        "Proprietà"
    } */ // deprecata
    
    
    func returnModelRowView() -> some View {
        PropertyModel_RowView(itemModel: self)
    }
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [PropertyModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.allMyProperties,"Lista Proprietà", "Proprietà","house")
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var intestazione: String = "" // deve sostituire il nome
    var descrizione: String = ""
   /* var descrizione: String = "La registrazione di una proprietò avviene da Maps. Se l'attività non è ancora presente in Maps la registrazione non può avvenire. Potremmo predisporre una registrazione manuale ma non lo facciamo per i seguenti motivi: Usando Maps ci affidiamo ad un servizio già collaudato e non ci dobbiamo preoccupare di verificare l'esistenza reale di quella proprietà, cosa che invece diventerebbe necessaria in caso di inserimento manuale. Usando Maps inoltre non dobbiamo preoccuparci dei duplicati, ossia della possibilità che qualcuno registri un'attività esistente in modo manuale nella via di fianco creando confusione. Usando Maps risolviamo quindi delle grane fiduciarie e ci resta soltanto di autenticare il legame fra l'attività registrata e il registrante. Resta un problema per le nuove attività non ancora registrate su Maps. Per queste sarebbe necessario procedere in manuale, ma sacrifichiamo le nuovissime attività non ancora registrate per evitarci i problemi di cui sopra. Confidiamo nel fatto, poi, essendo la registrazione sulle mappe qualcosa da cui un'attività non può prescindere che questa avvenga al più presto abilitando così la registrazione sulla nostra App." */
  //  var alertItem: AlertModel?
    
    static func == (lhs: PropertyModel, rhs: PropertyModel) -> Bool {
        
        lhs.id == rhs.id  &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.menuIn == rhs.menuIn 
    }
    
    var id: String { get {
        
        // let cod1 = name.replacingOccurrences(of: " ", with: "-").lowercased()
        // let cod2 = cityName.replacingOccurrences(of: " ", with: "-").lowercased()
        let cod3 = String(coordinates.latitude).replacingOccurrences(of: ".", with: "A")
        let cod4 = String(coordinates.longitude).replacingOccurrences(of: ".", with: "E")
        
        let codId = cod3 + cod4
        
        return codId
        
        // let id = UUID().uuidString // Questo sistema non garantisce l'unicità. Il compilatore andrebbe a considerare due oggetti diversi, due location uguali, ossia con stesso nome indirizzo e blabla solo perchè avrebbero due id differenti. Il grande Nick ci viene in soccorso e crea una computed
        
        // l'utilizzo di .hashValue non garantisce UNICITA?. Non va bene perchè produce un id diverso fra le varie sessioni. Quindi può andare bene nella sessione locale ma non per salvare l'info sul dataBase
        
        /// Sistema di identificazione NON SODDISFACENTE -- Temo Rallentamenti. Nella ricerca, quando si trova a livello macro, crea degli id che non sono Univoci
        
    } set { } } // Modifica 18.08 per convenienza su lavori nell'ingredientModel - Da Testare e sistemare
    
  //  let name: String
    var cityName: String
    var coordinates: CLLocationCoordinate2D
    var imageNames: [String] = []
    var webSite: String
    var phoneNumber: String
    var streetAdress: String
    var numeroCivico: String
    
  //  var scheduleServizio: [IntestazioneMenu] = [.colazione,.pranzo]
    
    var menuIn: [MenuModel] = [] // riempito Automaticamente con i Menu marchiati come completo(.pubblico) // Forse Deprecata 28.06 Accediamo direttamente ai menu salvati nel viewModel filtrandoli per lo status. Evitiamo così di duplicare "inutilmente?" i dati
    
    lazy var serviceSchedule: [GiorniDelServizio:[(String,String)]] = { // Deprecata
        
        print("dentro serviceSchedule in PropertyModel")
        
        var giorniServizio:[GiorniDelServizio:[(String,String)]] = [:]
        
        for menu in self.menuIn {
            
            for day in menu.giorniDelServizio {
                
                if giorniServizio[day] != nil {
                    
                    giorniServizio[day]?.append((menu.oraInizio.description,menu.oraFine.description))
                } else {
                    
                    giorniServizio[day] = [ (menu.oraInizio.description,menu.oraFine.description)]
        
                }
      
            }
           
        }
        
        return giorniServizio
   
    }()
    
  //  var status: StatusModel = .bozza // Qui non so quanto serva. Da Inquadrare.
    
    init() { // utile quando creaiamo la @State NewProperty
        
        self.intestazione = ""
        self.cityName = ""
        self.coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    init (intestazione: String, cityName: String, coordinates: CLLocationCoordinate2D, webSite: String, phoneNumber: String, streetAdress: String, numeroCivico: String) {
        
        self.intestazione = intestazione
        self.cityName = cityName
        self.coordinates = coordinates
        self.webSite = webSite
        self.phoneNumber = phoneNumber
        self.streetAdress = streetAdress
        self.numeroCivico = numeroCivico
    
    }
    
    init(nome: String) { 
        
        self.intestazione = nome
        self.cityName = ""
        self.coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    init(nome: String, coordinates: CLLocationCoordinate2D) {
        
        self.intestazione = nome
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    // Method
    
    private func creaSchedule() {
        
        print("dentro creaSchedule in PropertyModel")
        
        var giorniServizio:[GiorniDelServizio:[(String,String)]] = [:]
        
        for menu in self.menuIn {
            
            for day in menu.giorniDelServizio {
                
                if giorniServizio[day] != nil {
                    
                    giorniServizio[day]?.append((menu.oraInizio.description,menu.oraFine.description))
                } else {
                    
                    giorniServizio[day] = [ (menu.oraInizio.description,menu.oraFine.description)]
        
                }
      
            }
           
        }
        
    }
    
    
    
}

