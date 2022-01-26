//
//  PropertiesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit

struct AddNewPropertySheetView: View {
    
   // @ObservedObject var propertyModel:PropertiesModel
    @State var cityAdress: String = ""
    
    // Search Place
    @State var adress: String = ""
    // Searched Place
    
    @State var places:[Place] = []
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        VStack {
            
            MapView(place: $region)
                .ignoresSafeArea()
                .frame(height:screenHeight * 0.25)
            
         //   Spacer()
            
            VStack {
                
               /* CSTextField_2(text: $cityAdress, placeholder: "city", symbolName: "house.circle",accentColor: .green,autoCap: .sentences,cornerRadius: 8.0) */
                CSTextField_2(text: $adress, placeholder: "property name / adress", symbolName: "location.circle.fill", accentColor: .green, autoCap:.words, cornerRadius: 8.0)
                
                if !places.isEmpty && adress != "" {
                    
                    ScrollView {
                        
                        VStack(spacing: 15) {
                            
                            ForEach(places) { place in
                                
                                Text(place.place.name ?? "")
                                
                                    .foregroundColor(.black)
                                    .frame(maxWidth:.infinity,alignment: .leading)
                                Divider()
                                
                                
                                
                                
                            }
                            
                        }.background(.pink)
                        
                    }
                    
                    
                }
                
                CSButton_2(title: "Register Property",accentColor: .white,backgroundColor: .green,cornerRadius: 8.0) {
                    // registrare la proprietà su firebase
                }
            }.padding()
            
           
            
            Spacer()
            
        }.onChange(of: adress) { newValue in
            // Searching Place...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if newValue == adress {
                    
                    // Search..
                    self.searchQuery()
                    
                }
            }
        }
    }
    
    func searchQuery() {
        
        self.places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.adress
        
        // Fetch..
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                
              return Place(place: item.placemark)
                
            })
            
        }
        
    }
    
    
    
}

/*struct PropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPropertiesView()
    }
} */
