//
//  PropertiesModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import Foundation
import MapKit

/* // Deprecated il 22.03.2022 -> Inglobata nell'accounterVM
class PropertyVM: ObservableObject {
    /*
    // create dal sistema
    var allTheCommunityIngredients: [CommunityIngredientModel] = [] // load(fileJson)
    // la lista appIngredients sarà riempita da un json che creeremo con una lista di nomi di ingredienti. Dal nome verrà creato un Modello Ingrediente nel momento in cui sarà scelto dal ristoratore
    var listoneFromListaBaseModelloIngrediente: [IngredientModel] = [] // questo listone sarà creato contestualmente dalla listaBaseModelloIngrediente creata da un json
    
    // end create dal sistema
    @Published var allMyIngredients: [IngredientModel] = [] // questa è la lista dei "MIEI" ingredienti ed è trasversale ad ogni piatto e ad ogni proprietà dello stesso account
    
    */
    
    @Published var propertiesList: [PropertyModel] = [] // deve essere riempita con le proprietà create e salvate su firebase
    
    @Published var queryRequest: String = ""
    @Published var queryResults: [PropertyModel] = [] // viene riempita dalla query di ricerca
    
    @Published var currentRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
  //  @Published var currentProperty: PropertyModel = PropertyModel(name: "Activity Name", cityName: "City", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "https://fantabid.it/dishRevue/Milano/pizzium/viavigevano", phoneNumber: "phone number", streetAdress: "Street adress")
    
    @Published var showActivityInfo:Bool = false 
    @Published var alertItem: AlertModel?
    
    
    init() {
        
    
     //   propertiesList.append(propertyExample) // TEST CODE DA ELIMINARE
     //   fillFromListaBaseModello() // TEST CODE DA ELIMINARE
        
        
    }
 
  /*  func addNewProperty() {
        
        // Check che la proprietà non sia stata già aggiunta localmente
        
        /// Implementare il check sull'intero DataBase
        
        guard !self.propertiesList.contains(self.currentProperty) else {
            // add alert
            self.alertItem = AlertModel(title: "Error", message: "Property already Listed")
            self.showActivityInfo = false
            print("ITEM ALREADY IN")
            print("is Property empty \(self.propertiesList.isEmpty.description)")
            return }
        
        // add Alert
        self.alertItem = AlertModel(title: "\(self.currentProperty.intestazione) - \(self.currentProperty.cityName)", message: "New Property Added Successfully")
        
        // Aggiungiamo la proprietà localmente
        self.propertiesList.append(self.currentProperty)
        self.showActivityInfo = false
        print("Item Added")
        
        /// Implementare la registrazione sul database
        
    } */
    
    func storePropertyData() {
        
        // salviamo proprietà su firebase
    }
    
   /* func addDishOnMenu() {
        
        // aggiungiamo un piatto al menu
    }
    
    func removeDish() {
        
        // rimuove piatto dal menu del ristorante ma non dall'archivio Piatti
    } */
    
  /* func queryResearch() {

        self.queryResults.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.queryRequest
        // Fetch..
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.queryResults = result.mapItems.compactMap({ (item) -> PropertyModel? in
  
              return PropertyModel(
                
                intestazione: item.intestazione ?? "",
                cityName: item.placemark.locality ?? "",
                coordinates: item.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                webSite: item.url?.absoluteString ?? "",
                phoneNumber: item.phoneNumber ?? "",
                streetAdress: item.placemark.thoroughfare ?? "" 
                
              )
            })
        }
    } */
    
  /*  func showPlaceData(place:PropertyModel) {
        
        self.currentRegion = MKCoordinateRegion(center: place.coordinates , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.currentProperty = place
        self.showActivityInfo = true
    } */
    
    
    
    // CAPIRE COME RIMPIAZZARE E DOVE
    
    func onDismissSearchPropertySheet() {}
  /*  func onDismissSearchPropertySheet() {
        
        self.currentProperty = PropertyModel(name: "Activity Name", cityName: "City", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "https://fantabid.it/dishRevue/Milano/pizzium/viavigevano", phoneNumber: "phone number", streetAdress: "Street adress")
        
        self.currentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        self.queryRequest = ""
        self.queryResults = []
        self.showActivityInfo = false
        
    } */
   
    
    //
    
    
    // Codice da ELIMINARE - UTILE IN FASE DI COSTRUZIONE
    
  //  let propertyExample: PropertyModel = PropertyModel(name: "Osteria Favelas", cityName: "Sciacca", coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), imageNames: ["LogoAppBACKEND"], webSite: "https://fantabid.it", phoneNumber: "+39 333 7213895", streetAdress: "Via Conzo 26")
    
    
  /* let ing1 = CommunityIngredientModel(nome: "basilico")
   let ing2 = CommunityIngredientModel(nome: "aglio")
    let ing3 = CommunityIngredientModel(nome: "olio")
    let ing4 = CommunityIngredientModel(nome: "prezzemolo")
    let ing5 = CommunityIngredientModel(nome: "origano")
    let ing6 = CommunityIngredientModel(nome: "sale")
    let ing7 = CommunityIngredientModel(nome: "pepe")
    
    func fillFromListaBaseModello() { // TEST CODE DA MODIFICARE
        
        
        let ingList = [ing1,ing2,ing3,ing4,ing5,ing6,ing7]
        
        for ing in ingList {
            
            let ingMod = IngredientModel(nome: ing.nome)
            listoneFromListaBaseModelloIngrediente.append(ingMod)
            
        }

    } */
    
}


*/
