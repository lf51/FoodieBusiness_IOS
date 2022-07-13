//
//  PropertiesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

/* 03.02.2022 --> Bozza Definitiva */

import SwiftUI
import MapKit

struct NewPropertyMainView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @Binding var isShowingSheet:Bool
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var newProperty: PropertyModel = PropertyModel()
    @State private var queryRequest: String = ""
    @State private var queryResults: [PropertyModel] = [] // viene riempita dalla query di ricerca
    @State private var currentRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var showActivityInfo:Bool = false
    
    var body: some View {
        
        ZStack {
                
                MapView(currentRegion: $currentRegion, queryResults: $queryResults)
                .ignoresSafeArea()
                .zIndex(0)
                
            VStack(alignment: .trailing) {
                
                Button("Dismiss") {self.isShowingSheet.toggle()}.padding(.trailing).padding(.top)
           
                CSTextField_2(text: $queryRequest, placeholder: "nome attività, indirizzo, città", symbolName: "location.circle", accentColor: .green, backGroundColor: .white, autoCap:.words, cornerRadius: 5.0).padding(.horizontal)
                
                QueryScrollView_NewPropertySubView(queryResults: $queryResults, queryRequest: $queryRequest, screenHeight: screenHeight){ property in
                   
                        self.showPlaceData(place: property)
                    
                }
                    .zIndex(1)
                
                Spacer()
                
                if showActivityInfo {
                    
                    ChoiceInfoView_NewPropertySubView(newProperty: $newProperty, screenWidth: screenWidth, frameHeight: screenHeight * 0.20) {
                        self.actionAddButton()
                    }
                        .padding(.vertical, screenHeight * 0.05 )
                    
                }
      
            }
            
        }
        .onChange(of: queryRequest) { newValue in
            // Searching Place...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if newValue == queryRequest { queryResearch() }
            }
        }
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

    }
    
    // Method
    
    private func actionAddButton() {
        
      //  self.viewModel.createOrUpdateItemModel(itemModel: newProperty)
        self.viewModel.createItemModel(itemModel: newProperty)
        print("CONTROLLARE ACRIONADDBUTTON() in NEWPROPERTYMAINVIEW")
        self.showActivityInfo = false
        self.queryResults = []
        self.queryRequest = ""
        
    }
    
   private func showPlaceData(place:PropertyModel) {
        
        self.currentRegion = MKCoordinateRegion(center: place.coordinates , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.newProperty = place
       // withAnimation { self.showActivityInfo = true }
        self.showActivityInfo = true
    }
    
   private func queryResearch() {

       withAnimation(.linear(duration: 0.5)) {
           self.queryResults.removeAll()
           self.showActivityInfo = false
       }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.queryRequest
        // Fetch..
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
            
            self.queryResults = result.mapItems.compactMap({ (item) -> PropertyModel? in
  
            //  print("itemDescription: \(item.description)")
            //  print("pointOfIntCategory: \(item.pointOfInterestCategory?.rawValue ?? ""/* == MKPointOfInterestCategory.restaurant.rawValue*/)")
              return PropertyModel(
                
                intestazione: item.name ?? "",
                cityName: item.placemark.locality ?? "",
                coordinates: item.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                webSite: item.url?.absoluteString ?? "",
                phoneNumber: item.phoneNumber ?? "",
                streetAdress: item.placemark.thoroughfare ?? "",
                numeroCivico: item.placemark.subThoroughfare ?? ""

              )
            })
        }
    }
}

// Preview
/*struct NewPropertySheetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewPropertySheetView(vm: PropertyVM(), isShowingSheet: .constant(true))
    
       /* PropertyChoiceInfoView(vm: PropertyVM(),screenWidth: UIScreen.main.bounds.width,frameHeight:  UIScreen.main.bounds.height * 0.15)*/
    }
} */
