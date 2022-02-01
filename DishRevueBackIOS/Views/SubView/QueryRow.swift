//
//  QueryRow.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/02/22.
//

import SwiftUI
import MapKit

struct QueryRow: View {
    
    var place: PropertyModel
    
    var body: some View {
        
        HStack {
            
            Text(place.name)
                .bold()
            Text(" - \(place.streetAdress) -")
            Text(place.cityName)
                .italic()
                .foregroundColor(.gray)
            
                
                
        }
        .foregroundColor(.black)
        .shadow(radius: 1.0)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .frame(maxWidth:.infinity,alignment: .leading)
        

    }
}

struct QueryRow_Previews: PreviewProvider {
    
    static var place:PropertyModel = PropertyModel(name: "Test Restaurant", cityName: "Sciacca", coordinates:CLLocationCoordinate2D(), webSite: "https://fantabid.it", phoneNumber: "+39 333 72 13 895", streetAdress: "via Modigliani 19")
    
    static var previews: some View {
        QueryRow(place: QueryRow_Previews.place)
    }
}
