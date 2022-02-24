//
//  PropertiesModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import Foundation
import MapKit

class PropertyVM: ObservableObject {
    
    @Published var listaIngredienti: [ModelloIngrediente] = [] // questa è lista degli ingredienti ed è trasversale ad ogni piatto e ad ogni proprietà
    
    @Published var propertiesList: [PropertyModel] = [] // deve essere riempita con le proprietà create e salvate su firebase
    
    @Published var queryRequest: String = ""
    @Published var queryResults: [PropertyModel] = [] // viene riempita dalla query di ricerca
    
    @Published var currentRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var currentProperty: PropertyModel = PropertyModel(name: "Activity Name", cityName: "City", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "https://fantabid.it/dishRevue/Milano/pizzium/viavigevano", phoneNumber: "phone number", streetAdress: "Street adress")
    
    @Published var showActivityInfo:Bool = false 
    @Published var alertItem: AlertModel?
    
    
    init() {
        
        propertiesList.append(propertyExample) // TEST CODE
        
        
    }
 
    func addNewProperty() {
        
        // Check che la proprietà non sia stata già aggiunta localmente
        
        /// Implementare il check sull'intero DataBase
        
        guard !self.propertiesList.contains(self.currentProperty) else {
            // add alert
            self.alertItem = AlertModel(title: "Error", message: "Property already Listed")
            self.showActivityInfo = false
            print("ITEM ALREADY IN")
            print(self.propertiesList.isEmpty.description)
            return }
        
        // add Alert
        self.alertItem = AlertModel(title: "\(self.currentProperty.name) - \(self.currentProperty.cityName)", message: "New Property Added Successfully")
        
        // Aggiungiamo la proprietà localmente
        self.propertiesList.append(self.currentProperty)
        self.showActivityInfo = false
        print("Item Added")
        
        /// Implementare la registrazione sul database
        
    }
    
    func storePropertyData() {
        
        // salviamo proprietà su firebase
    }
    
    func addDishOnMenu() {
        
        // aggiungiamo un piatto al menu
    }
    
    func removeDish() {
        
        // rimuove piatto dal menu del ristorante ma non dall'archivio Piatti
    }
    
    func queryResearch() {

        self.queryResults.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.queryRequest
        // Fetch..
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.queryResults = result.mapItems.compactMap({ (item) -> PropertyModel? in
  
              return PropertyModel(
                
                name: item.name ?? "",
                cityName: item.placemark.locality ?? "",
                coordinates: item.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                webSite: item.url?.absoluteString ?? "",
                phoneNumber: item.phoneNumber ?? "",
                streetAdress: item.placemark.thoroughfare ?? "" 
                
              )
            })
        }
    }
    
    func showPlaceData(place:PropertyModel) {
        
        self.currentRegion = MKCoordinateRegion(center: place.coordinates , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.currentProperty = place
        self.showActivityInfo = true
    }
    
    func onDismissSearchPropertySheet() {
        
        self.currentProperty = PropertyModel(name: "Activity Name", cityName: "City", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "https://fantabid.it/dishRevue/Milano/pizzium/viavigevano", phoneNumber: "phone number", streetAdress: "Street adress")
        
        self.currentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        self.queryRequest = ""
        self.queryResults = []
        self.showActivityInfo = false
        
    }
   
    
    
    
    
    // Codice da ELIMINARE - UTILE IN FASE DI COSTRUZIONE
    
    let propertyExample: PropertyModel = PropertyModel(name: "Osteria Favelas", cityName: "Sciacca", coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), imageNames: ["LogoAppBACKEND"], webSite: "https://fantabid.it", phoneNumber: "+39 333 7213895", streetAdress: "Via Conzo 26")
    
    
    
    
}
