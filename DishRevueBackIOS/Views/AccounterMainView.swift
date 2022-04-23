//
//  AccounterView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/04/22.
//

import SwiftUI

struct AccounterMainView: View {
   
  @ObservedObject var authProcess: AuthPasswordLess
  @EnvironmentObject var viewModel: AccounterVM
  let backGroundColorView: Color
    
  
  @State private var newDisplayName: String = ""
    @State private var wannaChangeDisplayName: Bool = false
 
  var body: some View {

      ZStack(alignment:.leading) {
          
          backGroundColorView.edgesIgnoringSafeArea(.top)

          VStack(alignment:.leading) {
              
              VStack(alignment:.leading, spacing: 10.0) {
                  
                  HStack {
                      
                      Image(systemName: "lock.fill")
                      
                      Text("lillofriscia@gmail.comm")
                          .italic()
                          .accentColor(Color.gray)
                          .shadow(color: Color.white, radius: 10.0, x: 0, y:  0)
                      
                      Image(systemName: "person.fill.checkmark")
                          .foregroundColor(Color.blue)
                      
                  }
                  
                  
                  HStack {
                      
                      Image(systemName: "person.fill")
                      
                      CSText_tightRectangle(testo: "lilloFree", fontWeight: .semibold, textColor: Color.yellow, strokeColor: Color.blue, fillColor: Color.cyan)
                          .onTapGesture {
                              withAnimation {
                                  self.wannaChangeDisplayName.toggle()
                              }
                          }
                      
                  }
           
              if wannaChangeDisplayName {
                  
                  CSTextField_3(textFieldItem: $newDisplayName, placeHolder: "User Name") {
                      
                      withAnimation {
                          authProcess.displayName = self.newDisplayName
                          self.newDisplayName = ""
                          self.wannaChangeDisplayName = false
                      }
                  }
              }
             
                  HStack {
                      
                      Image(systemName: "phone.fill")
                      CSText_tightRectangle(testo: "3337213895", fontWeight: .semibold, textColor: Color.yellow, strokeColor: Color.blue, fillColor: Color.cyan)
                          .onTapGesture {
                              withAnimation {
                                  self.wannaChangeDisplayName.toggle()
                              }
                          }
                      
                  }

                  Spacer()
                  
                  HStack {
                      
                      CSText_tightRectangle(testo: "Disconnetti", fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.blue)
                      
                      Spacer()
                      
                      CSText_tightRectangle(testo: "Elimina Account", fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.red)
                      
                  }
                  
                  Text(UUID().uuidString)
                      .font(.caption)
                      .foregroundColor(Color.gray)
                      
                  
              }
              
              Spacer()
              
           //   ExtractedView()
              
          } // chiusa VStack Madre
          .padding(.horizontal)
          
          
      } // chiusa ZStack
      .background(backGroundColorView.opacity(0.4))
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
    
          CSText_tightRectangle(testo: "Richiedi Verifica", fontWeight: .semibold, textColor: Color.blue, strokeColor: Color.blue, fillColor: Color.cyan)
      }
      
    
  }
    
    // Method
    
   
    
}

struct AccounterMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            
         //   NavigationLink {
            AccounterMainView(authProcess: AuthPasswordLess(), backGroundColorView: Color.cyan)
                   
         /*  } label: {
                Text("Test").foregroundColor(Color.red)
            } */
       
        }
        .accentColor(Color.white)
            
    }
}



