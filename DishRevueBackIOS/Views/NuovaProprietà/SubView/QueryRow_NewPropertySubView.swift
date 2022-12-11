//
//  QueryRow_NewPropertySubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/03/22.
//

import SwiftUI
import MyFoodiePackage

struct QueryRow_NewPropertySubView: View {
    
    var place: PropertyModel
    
    var body: some View {
        
        HStack {
            
            Text(place.intestazione)
                .bold()
            Text("• \(place.streetAdress) •")
            Text(place.cityName)
                .italic()
                .foregroundColor(.gray)
            
        }
        .foregroundColor(.black)
        .shadow(radius: 1.0)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .frame(maxWidth:.infinity,alignment: .leading)
        .padding(.horizontal)
        
    }
}

/*
struct QueryRow_NewPropertySubView_Previews: PreviewProvider {
    static var previews: some View {
        QueryRow_NewPropertySubView()
    }
}
*/
