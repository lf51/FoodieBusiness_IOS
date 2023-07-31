//
//  MapView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit
import MyFoodiePackage

//SubView di NewPropertySheetView
struct MapView: View {
    
   // @ObservedObject var vm:PropertyVM
    @Binding var currentRegion: MKCoordinateRegion
    let queryResults: [MKMapItem]
    
    var body: some View {
          
        let allResult = queryResults.compactMap { (item) -> ItemCoordinate in
            
            return ItemCoordinate(coordinate: item.placemark.coordinate)
        }
        
        Map(coordinateRegion: $currentRegion,
            annotationItems: allResult) { item in
                
                MapMarker(coordinate: item.coordinate , tint: .cyan)
        
            }
    }
    
    private struct ItemCoordinate:Identifiable {
        let id:String
        let coordinate:CLLocationCoordinate2D
        
        init(coordinate: CLLocationCoordinate2D) {
            self.id = coordinate.latitude.formatted() + coordinate.longitude.formatted()
            self.coordinate = coordinate
        }
    }
}
/*struct MapView: View {
    
   // @ObservedObject var vm:PropertyVM
    @Binding var currentRegion: MKCoordinateRegion
    @Binding var queryResults: [PropertyModel]
    
    var body: some View {
          
            Map(coordinateRegion: $currentRegion,
                annotationItems: queryResults) { property in
                
                MapMarker(coordinate: property.coordinates , tint: .cyan)
            
            }
    }
} */ // 29.07.23 deprecata

/*
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(vm:PropertyVM())
    }
} */

