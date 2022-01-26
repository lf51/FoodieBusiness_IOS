//
//  MapView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
   // @ObservedObject var propertyModel:PropertiesModel
    
    @Binding var place: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $place)
        
    }
}

/*struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
} */

