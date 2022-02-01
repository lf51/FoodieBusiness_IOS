//
//  PropertiesModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import Foundation
import MapKit

class PropertyVM:ObservableObject {
    
    @Published var propertiesList: [PropertyModel] = [] // deve essere riempita con le proprietà create e salvate su firebase
    @Published var queryResults: [PropertyModel] = [] // viene riempita dalla query di ricerca
    
    @Published var currentRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var currentProperty: PropertyModel = PropertyModel(name: "Ristorante Prova Ancora Dai Amuni", cityName: "Sciacca", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "https://fantabid.it", phoneNumber: "+39 333 7213895", streetAdress: "Vicolo conzo 26")
}
