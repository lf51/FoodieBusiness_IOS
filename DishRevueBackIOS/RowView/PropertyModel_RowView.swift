//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//

import SwiftUI
import MapKit

struct PropertyModel_RowView: View {
    
    let item: PropertyModel
    
    var body: some View {
        
        ZStack(alignment:.leading){
            
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.white.opacity(0.3))
                .shadow(radius: 3.0)
                
            VStack(alignment:.leading) {
    
                HStack(alignment: .top) {
   
                    Text(item.intestazione)
                        .font(.system(.title2,design:.rounded))
                        .fontWeight(.heavy)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                }
                
                Spacer()

                VStack(alignment:.leading,spacing:5) {

                    Text(item.cityName)
                    .fontWeight(.semibold)
                    
                    Text(item.streetAdress)
                    .italic()
                    .fontWeight(.light)
                    .lineLimit(1)

                    Text(item.webSite)
                    .fontWeight(.ultraLight)
                    .lineLimit(1)

                    HStack {
                        
                        Image(systemName: "phone.fill")
                        Text(item.phoneNumber)
                        .fontWeight(.semibold)
                    }
                                        
                }
         
            } // chiuda VStack madre
            ._tightPadding()
        } // chiusa Zstack Madre
        .frame(width: 300, height: 150)
     
    }
}

struct PropertyModel_RowView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            PropertyModel_RowView(item: PropertyModel(
                intestazione: "Osteria del Corso",
                cityName: "Sciacca",
                coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                webSite: "https://osteriadelcorso.com",
                phoneNumber: "3337213895",
                streetAdress: "via roma 21"))
        }
    }
}
