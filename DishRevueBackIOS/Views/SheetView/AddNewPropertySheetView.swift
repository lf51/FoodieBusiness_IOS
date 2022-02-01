//
//  PropertiesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit

struct AddNewPropertySheetView: View {
    
    @ObservedObject var propertyViewModel:PropertyVM

    @State private var query: String = ""
    @State private var currentProperty: PropertyModel = PropertyModel(name: "-", cityName: "-", coordinates:CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434), webSite: "-", phoneNumber: "-", streetAdress: "-")
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        VStack {
                
            MapView(propertyViewModel: propertyViewModel, query: $query)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:screenHeight * 0.40)
                
            VStack {
                        
                if !propertyViewModel.queryResults.isEmpty && query != "" {
                    
                    ScrollView {
                        
                        VStack(spacing: 15) {
                            
                            ForEach(propertyViewModel.queryResults) { place in
                                
                                QueryRow(place: place)
                                    .onTapGesture {
                                   // propertyViewModel.queryResults = []
                                    self.showPlaceData(place: place)
                            }
                                
                                Divider().shadow(radius: 1.0)

                            }
                        }
                    }
                }
         
            }//.padding()
            
            .frame(height:screenHeight * 0.25)
           // .background(.pink)
            .padding(.horizontal)
                 
            Label {
                
                Text("Activity Info")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } icon: {
                Image(systemName: "info.circle.fill")
                 //   .frame(width: 44, height: 44, alignment: .center)
                    
            }
            
            PropertyChoiceInfoView(vm:propertyViewModel)
               // .shadow(radius: 2.0)
               // .frame(maxWidth:.infinity)
                .frame(height:screenHeight * 0.15)
                // .background(.orange)
               // .padding()
            
            
            Spacer()
            
            CSButton_2(title: "Register Property",accentColor: .white,backgroundColor: .green,cornerRadius: 8.0) {
                // registrare la proprietà su firebase
                propertyViewModel.propertiesList.append(currentProperty)
            }
            .frame(height:screenHeight * 0.05)
            //.background(.gray)
            .padding()
            
        }.onChange(of: query) { newValue in
            // Searching Place...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if newValue == query {
                    
                    // Search..
                    self.searchQuery()
                    
                }
            }
        }
    }
    
    func searchQuery() {
        
       // self.queryResults.removeAll()
        self.propertyViewModel.queryResults.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.query
      //  request.region = MKCoordinateRegion(center: currentProperty.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9))
       // request.region = self.currentRegion
        // Fetch..
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.propertyViewModel.queryResults = result.mapItems.compactMap({ (item) -> PropertyModel? in
  
              return PropertyModel(
                
                name: item.name ?? "",
                cityName: item.placemark.locality ?? "",
                coordinates: item.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                webSite: item.url?.absoluteString ?? "",
                phoneNumber: item.phoneNumber ?? "",
                streetAdress: item.placemark.thoroughfare ?? "" // mi da il quartiere e voglio invece la via
                
              )
   
            })
            
            
        }
        
    }
    
    func showPlaceData(place:PropertyModel) {
        
        propertyViewModel.currentRegion = MKCoordinateRegion(center: place.coordinates , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.currentProperty = place
      //  propertyViewModel.queryResults = [] // se svuoto la cache non mi funziona più il pin sulla mappa. WHY?
        
    }
    
}

/*struct PropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPropertiesView()
    }
} */




