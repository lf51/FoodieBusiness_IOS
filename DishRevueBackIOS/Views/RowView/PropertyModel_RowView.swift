//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//

import SwiftUI
import MapKit // necessario per la preview. Da eliminare

struct PropertyModel_RowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: PropertyModel

    var body: some View {
            
        CSZStackVB_Framed {
            
                    VStack(alignment:.leading) {
            
                        HStack(alignment: .center) {
  
                                Text(itemModel.intestazione)
                                    .font(.system(.title2,design:.rounded))
                                    .fontWeight(.heavy)
                                    .lineLimit(1)
                                    .foregroundColor(Color.white)
                     
                            Spacer()
                            
                            NavigationLink {
                                EditingPropertyModel(itemModel: $itemModel, backgroundColorView: Color("SeaTurtlePalette_1"))
                            } label: {
                                Image(systemName:"arrow.up.forward.square") // "rectangle.portrait.and.arrow.right"
                                    .imageScale(.medium)
                                    .foregroundColor(Color.white)
                            }
             
                        }
                        
                        Spacer()
                            
                            VStack(alignment:.leading,spacing:5) {

                                Text(itemModel.cityName)
                                .fontWeight(.semibold)

                                Text("\(itemModel.streetAdress), \(itemModel.numeroCivico)")
                                    .italic()
                                    .fontWeight(.light)
                                    .lineLimit(1)

                                Text(itemModel.webSite)
                                .fontWeight(.ultraLight)
                                .lineLimit(1)

                                HStack {
                                    
                                    Image(systemName: "phone.fill")
                                    Text(itemModel.phoneNumber)
                                    .fontWeight(.semibold)
                                }
                
                            }
                   
                    } // chiuda VStack madre
                    ._tightPadding()
                    
            } // chiusa Zstack Madre
    }
}

struct PropertyModel_RowView_Previews: PreviewProvider {
    
    @State static var testProperty: PropertyModel = PropertyModel(
        intestazione: "Osteria del Vicolo",
        cityName: "Sciacca",
        coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        webSite: "https://osteriadelcorso.com",
        phoneNumber: "3337213895",
        streetAdress: "via roma",
        numeroCivico: "21")
    
    static var previews: some View {

        
       /* PropertyModel_RowView(itemModel: $testProperty)
            .environmentObject(AccounterVM()) */
       NavigationView {
            EditingPropertyModel(itemModel: $testProperty, backgroundColorView: Color("SeaTurtlePalette_1"))
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}


