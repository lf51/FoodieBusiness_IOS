//
//  PropertiesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

/* 03.02.2022 --> Bozza Definitiva */

import SwiftUI
import MapKit

/* // BACKUP 21.03 per modifiche nella creazione della Nuova Proprietà

struct NewPropertySheetView: View {
    
    @ObservedObject var vm:PropertyVM
    @Binding var isShowingSheet:Bool 
  
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        
        ZStack {
                
                MapView(vm: vm)
                .ignoresSafeArea()
                .zIndex(0)
                
            VStack(alignment: .trailing) {
                
                Button("Dismiss") {self.isShowingSheet.toggle()}.padding(.trailing).padding(.top)
           
                CSTextField_2(text: $vm.queryRequest, placeholder: "property name / adress", symbolName: "location.circle", accentColor: .green, backGroundColor: .white, autoCap:.words, cornerRadius: 5.0).padding(.horizontal)
                
                QueryScrollView(vm: vm)
                    
                    .frame(maxWidth:.infinity)
                    .frame(height:screenHeight * 0.25)
                    .background(vm.queryResults.isEmpty ? Color.clear : Color(.secondarySystemFill))
                    .shadow(radius: 0.5)
                    .cornerRadius(5.0)
                    .padding(.horizontal)
                    .zIndex(1)
                
                Spacer()
                
                if vm.showActivityInfo {
                    
                PropertyChoiceInfoView(vm:vm,screenWidth: screenWidth,frameHeight: screenHeight * 0.20)
                            .padding(.vertical, screenHeight * 0.05 )
                    
                }
      
            }
            
        }
        .onChange(of: vm.queryRequest) { newValue in
            // Searching Place...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if newValue == vm.queryRequest {
                    
                    // Search..
                    vm.queryResearch()
                    
                }
            }
        }
        .alert(item: $vm.alertItem) { alert -> Alert in
            Alert(
                title: Text(alert.title).bold(),
                message: Text(alert.message).fontWeight(.light),
                dismissButton: .default(Text("Continue")))
         }
    }
}

// Preview

struct NewPropertySheetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewPropertySheetView(vm: PropertyVM(), isShowingSheet: .constant(true))
    
       /* PropertyChoiceInfoView(vm: PropertyVM(),screenWidth: UIScreen.main.bounds.width,frameHeight:  UIScreen.main.bounds.height * 0.15)*/
    }
}

/* struct QueryRow_Previews: PreviewProvider {
    
    static var place:PropertyModel = PropertyModel(name: "Test Restaurant", cityName: "Sciacca", coordinates:CLLocationCoordinate2D(), webSite: "https://fantabid.it", phoneNumber: "+39 333 72 13 895", streetAdress: "via Modigliani 19")
    
    static var previews: some View {
        QueryRow(place: QueryRow_Previews.place)
    }
} */

// SubView

struct QueryRow: View {
    
    var place: PropertyModel
    
    var body: some View {
        
        HStack {
            
            Text(place.name)
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

struct QueryScrollView: View {
    
    @ObservedObject var vm: PropertyVM
    
    var body: some View {
        VStack {
            
            if !vm.queryResults.isEmpty && vm.queryRequest != "" {
                
                ScrollView {
                    
                    VStack(spacing: 15) {
                        
                        ForEach(vm.queryResults) { place in
                            
                            QueryRow(place: place)
                                .onTapGesture {
                                    // propertyViewModel.queryResults = []
                                    vm.showPlaceData(place: place)
                                }
                            
                            Divider().shadow(radius: 1.0).padding(.horizontal)
                        
                        }
                    }
                }
            }
        }
    }
}

struct PropertyChoiceInfoView: View {
    
    @ObservedObject var vm: PropertyVM
    var screenWidth:CGFloat
    var frameHeight:CGFloat
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: frameHeight/25) {
                            
                    Text(vm.currentProperty.name)
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.heavy)
                    .lineLimit(1)

                    Text(vm.currentProperty.streetAdress)
                    .italic()
                    .fontWeight(.light)
                    .lineLimit(1)

                    Text(vm.currentProperty.cityName)
                    .fontWeight(.semibold)

                    Text(vm.currentProperty.webSite)
                    .fontWeight(.ultraLight)
                    .lineLimit(1)

                    Text(vm.currentProperty.phoneNumber)
                    .fontWeight(.semibold)
                        
            }.frame(maxWidth: (screenWidth*0.92) * 0.65)
          
           Spacer()
            
            VStack{
                
                CSButton_large(title: "Add Property", accentColor: .white, backgroundColor: .cyan, cornerRadius: 5.0) {
                    
                    vm.addNewProperty()
                    // Registrare su FireBase Proprietà
                }

            }.frame(maxWidth: (screenWidth*0.92) * 0.35)
                    
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


*/
