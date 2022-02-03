//
//  PropertiesModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import Foundation
import MapKit

class PropertyVM: ObservableObject {
    
    @Published var propertiesList: [PropertyModel] = [] // deve essere riempita con le proprietà create e salvate su firebase
    
    @Published var queryRequest: String = ""
    @Published var queryResults: [PropertyModel] = [] // viene riempita dalla query di ricerca
    
    @Published var currentRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var currentProperty: PropertyModel = PropertyModel(name: "Activity Name", cityName: "City", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "https://fantabid.it/dishRevue/Milano/pizzium/viavigevano", phoneNumber: "phone number", streetAdress: "Street adress")
    
    @Published var showActivityInfo:Bool = false 
    @Published var alertItem: AlertModel?
    
    func storePropertyData() {}
    
    func addNewProperty() {
        
        guard !self.propertiesList.contains(self.currentProperty) else {
            // add alert
            self.alertItem = AlertModel(title: "Error", message: "Property already Listed")
            
            print("ITEM ALREADY IN")
            print(self.propertiesList.isEmpty.description)
            return }
        
        
        // add Alert
        self.alertItem = AlertModel(title: "Property List ", message: "New Property Added Successfully")
        
        self.propertiesList.append(self.currentProperty)
        print("Item Added")
        
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
                streetAdress: item.placemark.thoroughfare ?? "" // mi da il quartiere e voglio invece la via
                
              )
            })
        }
    }
    
    func showPlaceData(place:PropertyModel) {
        
        self.currentRegion = MKCoordinateRegion(center: place.coordinates , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.currentProperty = place
      //  propertyViewModel.queryResults = [] // se svuoto la cache non mi funziona più il pin sulla mappa. WHY?
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
    
}
