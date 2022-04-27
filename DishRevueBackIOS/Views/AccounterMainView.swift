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
  let backgroundColorView: Color
    
  @State private var newDisplayName: String = ""
  @State private var wannaChangeDisplayName: Bool = false
 
  var body: some View {

      ZStack(alignment:.leading) {
          
          backgroundColorView.edgesIgnoringSafeArea(.top)

          VStack(alignment:.leading) {
              
              VStack(alignment:.leading, spacing: 10.0) {
                  
                  HStack {
                      
                      Image(systemName: "lock.fill")
                      
                      Text("\(authProcess.userInfo?.userEmail ?? "")")
                          .italic()
                          .accentColor(Color.gray)
                          .shadow(color: Color.white, radius: 10.0, x: 0, y:  0)
                      
                      Image(systemName: "person.fill.checkmark")
                          .foregroundColor(Color.blue)
                      
                  }
                  
                  
                  HStack {
                      
                      Image(systemName: "person.fill")
                      
                      CSText_tightRectangle(testo: "\(authProcess.userInfo?.userDisplayName ?? "")", fontWeight: .semibold, textColor: Color.yellow, strokeColor: Color.blue, fillColor: Color.cyan)
                          .onTapGesture {
                              withAnimation {
                                  self.wannaChangeDisplayName.toggle()
                              }
                          }
                      
                  }
           
              if wannaChangeDisplayName {
                  
                  CSTextField_5(textFieldItem: $newDisplayName, placeHolder: "UserName", image: "at", showDelete: true, keyboardType: .default){
                      
                      withAnimation {
                          authProcess.updateDisplayName(newDisplayName: self.newDisplayName)
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
                      
                      CSButton_tight(title: "Esci", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                          self.authProcess.logOutUser()
                            }
                      
                      Spacer()
                      
                      CSButton_tight(title: "Elimina Account", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.red) {
                          self.authProcess.eliminaAccount()
                      }
             
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
      .background(backgroundColorView.opacity(0.4))
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
    
          CSText_tightRectangle(testo: "Richiedi Verifica", fontWeight: .semibold, textColor: Color.blue, strokeColor: Color.blue, fillColor: Color.cyan)
      }
     /* .alert(item: $authProcess.alertItem) { alert -> Alert in
          Alert(
            title: Text(alert.title),
            message: Text(alert.message)
          )
          
      } */
      
      
    
  }
    
    // Method
    
   
    
}

struct AccounterMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            
         //   NavigationLink {
            AccounterMainView(authProcess: AuthPasswordLess(), backgroundColorView: Color.cyan)
                   
         /*  } label: {
                Text("Test").foregroundColor(Color.red)
            } */
       
        }
        .accentColor(Color.white)
            
    }
}



