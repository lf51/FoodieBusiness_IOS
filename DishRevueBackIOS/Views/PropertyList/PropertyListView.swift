//
//  PropertyListView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/04/22.
//

import SwiftUI

struct PropertyListView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var authProcess: AuthPasswordLess
    let backGroundColorView: Color
    @State private var wannaAddNewProperty: Bool = false
    
    var body: some View {
        
        ZStack {
            
            backGroundColorView.edgesIgnoringSafeArea(.top)
            
            VStack(alignment:.leading, spacing: 10.0) {
                
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(height: 4.0)
                    .foregroundColor(Color.cyan)
                   // .foregroundColor(Color.white.opacity(0.3))
                
                ScrollView(showsIndicators: false){
                    
                    ForEach(viewModel.allMyProperties) { property in
                        
                        PropertyModel_RowView(item: property)
                        
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle(Text("Le Mie Proprietà"))
            .navigationBarItems(
                trailing:
                    
            LargeBar_TextPlusButton(buttonTitle: "Registra Proprietà",font: .callout, imageBack: Color.mint, imageFore: Color.white) {
                        self.wannaAddNewPropertyButton()
                    }
                )
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: self.$wannaAddNewProperty) {
                
                NewPropertySheetView(isShowingSheet: self.$wannaAddNewProperty)
              
        }
        }
        .background(backGroundColorView.opacity(0.4))
        /* .sheet(isPresented: $authProcess.isPresentingSheet) {
             LinkSignInSheetView(authProcess: authProcess)
         }*/
    }
    
    // Method
    
    private func wannaAddNewPropertyButton() {
        
        if AuthPasswordLess.isUserAuth {
            
            self.wannaAddNewProperty = true
            print("Utente Autenticato, Apertura Sheet NuovaProprietà")
            
        } else {
            
            authProcess.isPresentingSheet = true
            print("Utente NON Auth, Apertura Sheet Authentication")
        }
    }
    
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PropertyListView(authProcess: AuthPasswordLess(), backGroundColorView: Color.cyan)
        }
    }
}
