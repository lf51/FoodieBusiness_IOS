//
//  PropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation
import MapKit
import SwiftUI
import Firebase

// !! Nota Vocale 19.09 !! Sulle info della Proprietà

/* La registrazione di una proprietò avviene da Maps. Se l'attività non è ancora presente in Maps la registrazione non può avvenire. Potremmo predisporre una registrazione manuale ma non lo facciamo per i seguenti motivi:
 • Usando Maps ci affidiamo ad un servizio già collaudato e non ci dobbiamo preoccupare di verificare l'esistenza reale di quella proprietà, cosa che invece diventerebbe necessaria in caso di inserimento manuale.
 • Usando Maps inoltre non dobbiamo preoccuparci dei duplicati, ossia della possibilità che qualcuno registri un'attività esistente in modo manuale nella via di fianco creando confusione
 • Usando Maps risolviamo quindi delle grane "fiduciarie" e ci resta soltanto di autenticare il legame fra l'attività registrata e il registrante
 • Resta un problema per le nuove attività non ancora registrate su Maps. Per queste sarebbe necessario procedere in manuale, ma sacrifichiamo le nuovissime attività non ancora registrate per evitarci i problemi di cui sopra. Confidiamo nel fatto, poi, essendo la registrazione sulle mappe qualcosa da cui un'attività non può prescindere che questa avvenga al più presto abilitando così la registrazione sulla nostra App.

*/

struct PropertyModel:MyProStarterPack_L1,MyProVisualPack_L0,MyProDescriptionPack_L0,MyProCloudPack_L1 /*: MyProModelPack_L0, Hashable*/{
   
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
    
    
    func returnModelRowView(rowSize:RowSize) -> some View {
        // row size non implementata
        PropertyModel_RowView(itemModel: self)
    }
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [PropertyModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.allMyProperties,"Lista Proprietà", "Proprietà","house")
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var intestazione: String // deve sostituire il nome
    var descrizione: String
   /* var descrizione: String = "La registrazione di una proprietò avviene da Maps. Se l'attività non è ancora presente in Maps la registrazione non può avvenire. Potremmo predisporre una registrazione manuale ma non lo facciamo per i seguenti motivi: Usando Maps ci affidiamo ad un servizio già collaudato e non ci dobbiamo preoccupare di verificare l'esistenza reale di quella proprietà, cosa che invece diventerebbe necessaria in caso di inserimento manuale. Usando Maps inoltre non dobbiamo preoccuparci dei duplicati, ossia della possibilità che qualcuno registri un'attività esistente in modo manuale nella via di fianco creando confusione. Usando Maps risolviamo quindi delle grane fiduciarie e ci resta soltanto di autenticare il legame fra l'attività registrata e il registrante. Resta un problema per le nuove attività non ancora registrate su Maps. Per queste sarebbe necessario procedere in manuale, ma sacrifichiamo le nuovissime attività non ancora registrate per evitarci i problemi di cui sopra. Confidiamo nel fatto, poi, essendo la registrazione sulle mappe qualcosa da cui un'attività non può prescindere che questa avvenga al più presto abilitando così la registrazione sulla nostra App." */
  //  var alertItem: AlertModel?
    
    static func == (lhs: PropertyModel, rhs: PropertyModel) -> Bool {
        
        lhs.id == rhs.id  &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione
      //  lhs.menuIn == rhs.menuIn
    }
    
    var id: String
    var cityName: String
    var coordinates: CLLocationCoordinate2D
  //  var imageNames: [String] = []
    var webSite: String
    var phoneNumber: String
    var streetAdress: String
    var numeroCivico: String
    
  //  var scheduleServizio: [IntestazioneMenu] = [.colazione,.pranzo]
    
  //  var menuIn: [MenuModel] = [] // Nota 16.11 // riempito Automaticamente con i Menu marchiati come completo(.pubblico) // Forse Deprecata 28.06 Accediamo direttamente ai menu salvati nel viewModel filtrandoli per lo status. Evitiamo così di duplicare "inutilmente?" i dati
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        self.id = frDoc.documentID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.cityName = frDoc[DataBaseField.cityName] as? String ?? ""
        self.webSite = frDoc[DataBaseField.webSite] as? String ?? ""
        self.phoneNumber = frDoc[DataBaseField.phoneNumber] as? String ?? ""
        self.streetAdress = frDoc[DataBaseField.streetAdress] as? String ?? ""
        self.numeroCivico = frDoc[DataBaseField.numeroCivico] as? String ?? ""
        
        let latitudeString = frDoc[DataBaseField.latitude] as? String ?? ""
        let latitudeDegree = CLLocationDegrees(latitudeString) ?? 0.0
        
        let longitudeString = frDoc[DataBaseField.longitude] as? String ?? ""
        let longitudeDegree = CLLocationDegrees(longitudeString) ?? 0.0
        
        self.coordinates = CLLocationCoordinate2D(latitude: latitudeDegree, longitude: longitudeDegree)
    }
    
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.cityName : self.cityName,
            DataBaseField.webSite : self.webSite,
            DataBaseField.phoneNumber : self.phoneNumber,
            DataBaseField.streetAdress : self.streetAdress,
            DataBaseField.numeroCivico : self.numeroCivico,
            DataBaseField.latitude : self.coordinates.latitude.description,
            DataBaseField.longitude : self.coordinates.longitude.description
        ]
        
        return documentData
    }
    
    struct DataBaseField {
        
        static let intestazione = "intestazione"
        static let descrizione = "descrizione"
        static let cityName = "cityName"
        static let webSite = "webSite"
        static let phoneNumber = "phoneNumber"
        static let streetAdress = "streetAdress"
        static let numeroCivico = "numeroCivico"
        static let latitude = "latitudine"
        static let longitude = "longitudine"
        
    }
    
    //
    
  /*  lazy var serviceSchedule: [GiorniDelServizio:[(String,String)]] = { // Deprecata
        
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
   
    }() */ // deprecata 17.11
    
  //  var status: StatusModel = .bozza // Qui non so quanto serva. Da Inquadrare.
    
    init() { // utile quando creaiamo la @State NewProperty
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = ""
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    init (intestazione: String, cityName: String, coordinates: CLLocationCoordinate2D, webSite: String, phoneNumber: String, streetAdress: String, numeroCivico: String) {
        
        self.id = Self.creaID(coordinates: coordinates,cityName: cityName)
        self.intestazione = intestazione
        self.descrizione = ""
        self.cityName = cityName
        self.coordinates = coordinates
        self.webSite = webSite
        self.phoneNumber = phoneNumber
        self.streetAdress = streetAdress
        self.numeroCivico = numeroCivico
    
    }
    
    init(nome: String) {
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = nome
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    init(nome: String, coordinates: CLLocationCoordinate2D) {
        
        self.id = Self.creaID(coordinates: coordinates,cityName: "X")
        self.intestazione = nome
        self.descrizione = ""
        self.cityName = ""
        self.coordinates = coordinates
        self.webSite = ""
        self.phoneNumber = ""
        self.streetAdress = ""
        self.numeroCivico = ""
        
    }
    
    // Method
    
    private static func creaID(coordinates:CLLocationCoordinate2D,cityName:String) -> String {
        
        let city = cityName.uppercased()
        let latitude = String(coordinates.latitude).replacingOccurrences(of: ".", with: "A")
        let longitude = String(coordinates.longitude).replacingOccurrences(of: ".", with: "E")
        
        let codID = latitude + city + longitude
        
        return codID

    }
    
    
   /* private func creaSchedule() {
        
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
        
    } */ // deprecata 17.11
    
    
    
}

