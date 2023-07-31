//
//  ChoiceInfoView_NewPropertySubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/03/22.
//

import SwiftUI
import MapKit
import MyFoodiePackage

struct ChoiceInfoView_NewPropertySubView: View {
    
    let newProperty: MKMapItem
    var screenWidth:CGFloat
    var frameHeight:CGFloat
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: frameHeight/25) {
                            
                Text(newProperty.name ?? "")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.heavy)
                    .lineLimit(1)

                Text("\(newProperty.placemark.thoroughfare ?? ""), \(newProperty.placemark.subThoroughfare ?? "")")
                    .italic()
                    .fontWeight(.light)
                    .lineLimit(1)

                Text(newProperty.placemark.locality ?? "")
                    .fontWeight(.semibold)

                Text(newProperty.url?.absoluteString ?? "")
                    .fontWeight(.ultraLight)
                    .lineLimit(1)

                Text(newProperty.phoneNumber ?? "")
                    .fontWeight(.semibold)
                        
            }.frame(maxWidth: (screenWidth * 0.92) * 0.65)
          
           Spacer()
            
            VStack{
                
                CSButton_large(title: "Add Property", accentColor: .white, backgroundColor: .cyan, cornerRadius: 5.0) {
                    
                    action()
                    // Registrare su FireBase Proprietà
                }

            }.frame(maxWidth: (screenWidth * 0.92) * 0.35)
                    
        }
        .padding()
        .minimumScaleFactor(0.5)
        .frame(maxWidth: screenWidth)
        .frame(height: frameHeight, alignment: .leading)
        .border(.cyan, width: screenWidth*0.02)
        .background(Color.cyan.opacity(0.3))
        .cornerRadius(5.0)
        .shadow(radius: 2.0)
        .padding(.horizontal, screenWidth * 0.08)

    }
}

/*
struct ChoiceInfoView_NewPropertySubView_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceInfoView_NewPropertySubView()
    }
}
*/
