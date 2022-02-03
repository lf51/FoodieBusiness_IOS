//
//  MapView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit

//SubView di NewPropertySheetView

struct MapView: View {
    
    @ObservedObject var vm:PropertyVM
    
    var body: some View {
          
            Map(coordinateRegion: $vm.currentRegion,
                annotationItems: vm.queryResults) { property in
                
                MapMarker(coordinate: property.coordinates , tint: .cyan)
                
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

