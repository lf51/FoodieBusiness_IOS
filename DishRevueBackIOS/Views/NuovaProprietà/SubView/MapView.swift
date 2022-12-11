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
    @Binding var queryResults: [PropertyModel]
    
    var body: some View {
          
            Map(coordinateRegion: $currentRegion,
                annotationItems: queryResults) { property in
                
                MapMarker(coordinate: property.coordinates , tint: .cyan)
                
            }
    }
}

/*
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(vm:PropertyVM())
    }
} */

