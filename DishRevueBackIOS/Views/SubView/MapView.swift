//
//  MapView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var propertyViewModel:PropertyVM
    @Binding var query: String 
  //  @Binding var place: MKCoordinateRegion
    
    
    var body: some View {
        
      //  Map(coordinateRegion: $place)
    
        ZStack {
            
            Map(coordinateRegion: $propertyViewModel.currentRegion,
                annotationItems: propertyViewModel.queryResults) { property in
                
                MapMarker(coordinate: property.coordinates , tint: .cyan)
                
            }
            
            VStack {
           
                CSTextField_2(text: $query, placeholder: "property name / adress", symbolName: "location.circle.fill", accentColor: .green, autoCap:.words, cornerRadius: 8.0).padding().padding(.top)
                
                Spacer()
            }
            
        }.shadow(radius: 2.0)
        
    }
}

/*struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
} */

