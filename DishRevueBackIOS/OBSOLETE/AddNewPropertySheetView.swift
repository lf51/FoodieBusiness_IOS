//
//  PropertiesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MapKit

/* DEPRECATED 21.03.2022

struct AddNewPropertySheetView: View {
    
    @ObservedObject var vm:PropertyVM
  
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        
        VStack {
                
            MapView(vm: vm)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:screenHeight * 0.35)
                
            QueryScrollView(vm: vm)
                
                .frame(maxWidth:.infinity)
                .frame(height:screenHeight * 0.2)
              //  .background(Color.gray.opacity(0.1))
                .shadow(radius: 0.5)
                .padding(.horizontal)
            
            Spacer()
        
            PropertyChoiceInfoView(vm:vm,screenWidth: screenWidth,frameHeight: screenHeight * 0.20)
                    .overlay(
                        InfoOverlayPointView(placeHolder:"Activity Info", imageName:"info.circle", foregroundColor: .gray, offsetPoint: -25.0),alignment: .topLeading
                    )
                    .padding(.vertical, screenHeight * 0.05 )
            
            CSButton_large(title: "Add Property",accentColor: .white,backgroundColor: .cyan.opacity(0.6),cornerRadius: 8.0) {
                // registrare la proprietà su firebase
                vm.addNewProperty()
            }
            //.frame(height:screenHeight * 0.05)
            .padding(.horizontal)
     
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
    }
}

struct AddNewPropertySheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPropertySheetView(vm: PropertyVM())
    }
}





struct InfoOverlayPointView: View {
    
    var placeHolder: String
    var imageName: String
    var foregroundColor: Color
    var offsetPoint: CGFloat
    
    var body: some View {
        HStack {
            
            Image(systemName: imageName)
                .foregroundColor(foregroundColor)
            
            Text(placeHolder)
                .font(.subheadline)
                .foregroundColor(foregroundColor)
            
        }
        .padding(.leading)
        .offset(y:offsetPoint)
        
    }
}


*/
