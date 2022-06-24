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
 
            
            VStack(alignment:.leading, spacing: 10.0) {
   
            CSDivider()
                
                  ScrollView(showsIndicators: false){
                        
                          ForEach($viewModel.allMyProperties) { $property in
                                
                                PropertyModel_RowView(itemModel: $property)
   
                          } // chiusa ForEach
                     
                  }
               
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                LargeBar_TextPlusButton(
                    buttonTitle: "Registra Proprietà",
                    font: .callout,
                    imageBack: viewModel.allMyProperties.isEmpty ? Color("SeaTurtlePalette_2") : Color.red.opacity(0.6),
                    imageFore: Color("SeaTurtlePalette_4")) {
                    
                    withAnimation {
                      
                        self.addNewPropertyCheck() // Abbiamo scelto di sviluppare come SingleProperty, ma Manteniamo una impostazione da "MultiProprietà" per eventuali sviluppi futuri e ci limitiamo quindi a disabilitare la possibilità di aggiungere altre proprietà dopo la prima.
                    }
                }
            }
        }
        .sheet(isPresented: self.$wannaAddNewProperty) {
            
            NewPropertyMainView(isShowingSheet: self.$wannaAddNewProperty)
          
    }
        
        
          /*.navigationBarItems(
              trailing:
                  
          LargeBar_TextPlusButton(buttonTitle: "Registra Proprietà",font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white) {
              
              withAnimation {
                  self.wannaAddNewProperty.toggle()
              }
                  }
              ) */
         // .navigationBarTitleDisplayMode(.large)
         
       // .background(backgroundColorView.opacity(0.4))
    }
    
    // Method
    
    private func addNewPropertyCheck() {
        
        guard viewModel.allMyProperties.isEmpty else {
            
            viewModel.alertItem = AlertModel(
                title: "⛔️ Restrizioni Account",
                message: "Spiacenti. Raggiunto il numero max di proprietà registrabili.")
            
            return }
        
        self.wannaAddNewProperty = true
        
    }
    
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PropertyListView(backgroundColorView: Color.cyan).environmentObject(AccounterVM())
        }
    }
}
