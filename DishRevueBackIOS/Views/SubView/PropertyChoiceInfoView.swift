//
//  PropertyChoiceInfoView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/02/22.
//

import SwiftUI

struct PropertyChoiceInfoView: View {
    
    @ObservedObject var vm: PropertyVM
    var screenWidth:CGFloat = UIScreen.main.bounds.width
    
    @State private var example = "https://fantabid.it/ristoranteItalia/Milano/viaCorsico29"
    
    var body: some View {
        
        HStack {
    
            VStack(alignment: .leading,spacing: 5.0) {
                
                Text(vm.currentProperty.name)
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .lineLimit(1)
                   // .minimumScaleFactor(0.1)
                Divider()
                Text(vm.currentProperty.streetAdress)
                    .italic()
                    .fontWeight(.light)
                    
                Divider()
                Text(vm.currentProperty.cityName)
                    .fontWeight(.light)
                Divider()
                Text(example)
                    .fontWeight(.thin)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Divider()
                Text(vm.currentProperty.phoneNumber)
                    .fontWeight(.heavy)
                
                
            }
            .padding()
       
        }
        .background(.cyan.opacity(0.2))
        .cornerRadius(5.0)
        .shadow(radius: 5.0)
        .padding(.horizontal, screenWidth * 0.10)

        
    }
}

struct PropertyChoiceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyChoiceInfoView(vm: PropertyVM())
    }
}

//  Text(currentProperty.id)
//  Text("latitude: \(currentProperty.coordinates.latitude)")
//  Text("longitude: \(currentProperty.coordinates.longitude)")
