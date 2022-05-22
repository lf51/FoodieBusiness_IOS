//
//  EditingPropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI
import MapKit

struct EditingPropertyModel: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: PropertyModel
    let backgroundColorView: Color
    
    @State private var openMenuList: Bool? = false
    
    var body: some View {
        
        CSZStackVB(title: itemModel.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                CSDivider()
                    
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {
                        
                        Text("Data ultimo aggiornamento gg/mm/yyyy")
                         
                    } // Box Iniziale
                    .padding(.bottom)
                    
                    CSLabel_1Button(
                        placeHolder: "Descrizione",
                        imageNameOrEmojy: "scribble",
                        backgroundColor: Color.black)
                    CSTextEditor_ModelDescription(itemModel: $itemModel)
                    
                    CSLabel_1Button(
                        placeHolder: "Info Servizio",
                        imageNameOrEmojy: nil,
                        backgroundColor: Color.black )
                    
                    Text("giorno di chiusura - dedotto da menu")
                    Text("Giorni/Orario di lavoro - dedotto da menu")
                    
                  CSLabel_2Button(
                    placeHolder: "Menu In",
                    imageName: "scroll",
                    backgroundColor: Color.black,
                    toggleBottoneTEXT: $openMenuList,
                    testoBottoneTEXT: "Seleziona")
                    
                    Text("Appariranno i Menu In della Proprietà")
                    
                    ForEach(itemModel.menuIn) { menu in
                        
                        Text(menu.intestazione)
                    }
                     
                    
                } // Chiusa Scroll View
                
                
              
                
            } // Chiusa VStack Madre
            .padding(.horizontal)
            
            if openMenuList! {
                
                SelettoreMyModel<_,MenuModel>(
                    itemModel: $itemModel,
                    allModelList: ModelList.propertyMenuList,
                    closeButton: $openMenuList)
                
            }
            
        } // Chiusa ZStack Madre
        
    }
}

struct EditingPropertyModel_Previews: PreviewProvider {
    
    @State static var testProperty: PropertyModel = PropertyModel(
        intestazione: "Osteria del Vicolo",
        cityName: "Sciacca",
        coordinates: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        webSite: "https://osteriadelcorso.com",
        phoneNumber: "3337213895",
        streetAdress: "via roma",
        numeroCivico: "21")
    
    static var previews: some View {

        NavigationView {
            EditingPropertyModel(itemModel: $testProperty, backgroundColorView: Color.cyan)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(AccounterVM())
    }
}
