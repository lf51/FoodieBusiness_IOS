//
//  QueryRow_NewPropertySubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/03/22.
//

import SwiftUI
import MapKit
import MyFoodiePackage

struct QueryRow_NewPropertySubView: View {
    
    var place: MKMapItem
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            let value:(nome:String,adress:String,city:String) = {
                
                let name = place.name ?? ""
                let street = place.placemark.thoroughfare ?? ""
                let civico = place.placemark.subThoroughfare ?? ""
                let adress = street + "," + " " + civico
                let city = place.placemark.locality ?? ""
                
                return(name,adress,city)
                
            }()
            
            Text(value.nome)
                .bold()
                .foregroundStyle(Color.black)
                .font(.body)
            
            HStack {
                
                Text(value.adress)
                    .italic()
                    .foregroundStyle(Color.black)
                Spacer()
                Text(value.city)
                    .foregroundStyle(Color.gray)
                
            }
            
            
        }
        .shadow(radius: 1.0)
       // .multilineTextAlignment(.leading)
       // .lineLimit(1)
        .frame(maxWidth:.infinity)
        .padding(.horizontal,5)
        
    }
}

/*
struct QueryRow_NewPropertySubView_Previews: PreviewProvider {
    static var previews: some View {
        QueryRow_NewPropertySubView()
    }
}
*/
