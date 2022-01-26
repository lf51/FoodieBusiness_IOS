//
//  Place.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import Foundation
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
    
    
    
}
