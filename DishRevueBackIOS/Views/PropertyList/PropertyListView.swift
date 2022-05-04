//
//  PropertyListView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/04/22.
//

import SwiftUI

struct PropertyListView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
  //  @ObservedObject var authProcess: AuthPasswordLess
    let backgroundColorView: Color
    @State private var wannaAddNewProperty: Bool = false
    
    init(backgroundColorView:Color){
        
        self.backgroundColorView = backgroundColorView
        print("INIT -> PROPERTYLISTVIEW")
        
    }
    
    var body: some View {
        
        CSZStackVB(title: "Le Mie Proprietà", backgroundColorView: backgroundColorView) {
    
        
      /*  ZStack {
            
            backgroundColorView.edgesIgnoringSafeArea(.top) */
            
            VStack(alignment:.leading, spacing: 10.0) {
                
                RoundedRectangle(cornerRadius: 10.0) // da lo stacco per evitare l'inline.
                    .frame(height: 2.0)
                    .foregroundColor(Color.cyan) // Color.cyan lo rende invisibile
            
                  ScrollView(showsIndicators: false){
                        
                          ForEach($viewModel.allMyProperties) { $property in
                                
                                PropertyModel_RowView(itemModel: $property)
   
                          } // chiusa ForEach
                  }
            }
            .padding(.horizontal)
        }
        //  .navigationTitle(Text("Le Mie Proprietà"))
          .navigationBarItems(
              trailing:
                  
          LargeBar_TextPlusButton(buttonTitle: "Registra Proprietà",font: .callout, imageBack: Color.mint, imageFore: Color.white) {
              
              withAnimation {
                  self.wannaAddNewProperty.toggle()
              }
                  }
              )
         // .navigationBarTitleDisplayMode(.large)
          .sheet(isPresented: self.$wannaAddNewProperty) {
              
              NewPropertyMainView(isShowingSheet: self.$wannaAddNewProperty)
            
      }
       // .background(backgroundColorView.opacity(0.4))
    }
    
    // Method
    
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PropertyListView(backgroundColorView: Color.cyan).environmentObject(AccounterVM())
        }
    }
}
