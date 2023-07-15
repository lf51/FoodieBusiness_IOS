//
//  AccounterView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/04/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct AccounterMainView: View {
   
  @ObservedObject var authProcess: AuthPasswordLess
  @EnvironmentObject var viewModel: AccounterVM
    
  let backgroundColorView: Color
    
  @State private var newDisplayName: String = ""
  @State private var wannaChangeDisplayName: Bool = false
    
  var body: some View {

      CSZStackVB(title: "Settings", backgroundColorView: backgroundColorView) {
 
          VStack(alignment:.leading) {
              
              VStack(alignment:.leading, spacing: 10.0) {

                  let value:(string:String,color:Color) = {
                     
                      if wannaChangeDisplayName {
                          return ("Fatto",Color.seaTurtle_3)
                      } else {
                          return ("Edit",Color.seaTurtle_2)
                      }
                  }()
                  
                  CSLabel_conVB(
                      placeHolder: "Dati Utente",
                      imageNameOrEmojy: "person.text.rectangle",
                      backgroundColor:Color.seaTurtle_2) {
                       
                          Text(value.string)
                              .bold()
                              .foregroundColor(value.color)
                              .onTapGesture {
                                  withAnimation {
                                      self.wannaChangeDisplayName.toggle()
                                  }
                              }
                      }

                  HStack {
                      
                      Image(systemName: "person.fill")
                          .foregroundColor(Color.seaTurtle_2)

                      if !wannaChangeDisplayName {
                          
                          Text("\(self.authProcess.currentUser?.userDisplayName ?? "not_username")")
                              .font(.system(.headline, design: .monospaced, weight: .semibold))
                              .foregroundColor(Color.seaTurtle_4)

                          
                      } else {
                          
                          CSTextField_5(textFieldItem: $newDisplayName, placeHolder: "UserName", image: "at", showDelete: true, keyboardType: .default){
                              
                              self.authProcess.updateDisplayName(newDisplayName: self.newDisplayName)
                              self.newDisplayName = ""
                              self.wannaChangeDisplayName = false

                          }
                      }

                  }

                  HStack {
                      
                      Image(systemName: "key.fill")
                          .foregroundColor(Color.seaTurtle_2)
                     
                      Text("\(self.authProcess.currentUser?.userEmail ?? "email")")
                          .font(.system(.headline, design: .monospaced, weight: .light))
                          .foregroundColor(Color.seaTurtle_4)
                      
                      Image(systemName: "lock.fill")
                      
                  }
                  
                  HStack {
                      
                      Image(systemName: "shield.lefthalf.filled")
                          .foregroundColor(Color.seaTurtle_2)

                      Text(authProcess.currentUser?.userEmailVerified ?? false ? "Amministratore" : "not_verified")
                          .italic()
                          .font(.system(.headline, design: .monospaced, weight: .light))
                          .foregroundColor(Color.seaTurtle_4)
                      
                      Image(systemName: "lock.fill")
    
                  }

                  VStack(alignment:.leading,spacing: 5) {
                      
                      CSLabel_1Button(
                        placeHolder: "Funzioni",
                        imageNameOrEmojy: "gear",
                        backgroundColor: Color.seaTurtle_2)
                      
                      Group {
 
                          HStack {
                              
                              Text("Auto-Pause Preparazione by pausing Ingredient")
                              CSInfoAlertView(title: "Info", message: .cambioStatusPreparazioni)
                              Spacer()
                              Picker(selection: $viewModel.cloudData.setupAccount.autoPauseDish_byPauseING) {
                                  ForEach(AccountSetup.autoPauseDish_allCases,id:\.self) { value in

                                      Text("\(value.rawValue)")
                                      
                                  }
                              } label: {
                                  Text("")
                              }
                          }
                          
                         Divider()
                          
                          HStack {
                              
                              Text("Auto-Pause Preparazioni by archive Ingredient")
                              CSInfoAlertView(title: "Info", message: .cambioStatusPreparazioni)
                              Spacer()
                              Picker(selection: $viewModel.cloudData.setupAccount.autoPauseDish_byArchiveING) {
                                  ForEach(AccountSetup.autoPauseDish_allCases,id:\.self) { value in

                                      Text("\(value.rawValue)")
                                      
                                  }
                              } label: {
                                  Text("")
                              }
                          }
                          
                         Divider()
                          
                          HStack {
                              
                              Text("Count Down Menu Off")
                              CSInfoAlertView(title: "Info", message: .timerMenu)
                              Spacer()
                              Picker(selection: $viewModel.cloudData.setupAccount.startCountDownMenuAt) {
                                  ForEach(AccountSetup.TimeValue.allCases,id:\.self) { value in

                                          Text("\(value.rawValue) minuti")
                                      
                                  }
                              } label: {
                                  Text("")
                              }
                          }
                      }
                    //  .font(.subheadline)
                      
                  }
 
                  VStack(alignment:.leading) {
                      //Nota 24.11 - Collaboratori
                      CSLabel_conVB(
                        placeHolder: "Autorizzazioni:",
                        imageNameOrEmojy: "person.crop.rectangle.stack",
                        backgroundColor:Color.seaTurtle_4) {
                            Text("Add")
                                .bold()
                                .foregroundColor(Color.seaTurtle_4)
                                .opacity(0.4)
                              
                        }
                      
                      VStack(alignment:.leading) {
                          
                          HStack {

                           Text("\(self.authProcess.currentUser?.userEmail ?? "email")")
                                  .foregroundColor(Color.seaTurtle_4)
                                  .opacity(0.8)
                                    
                           Spacer()
                           Text(authProcess.currentUser?.userEmailVerified ?? false ? "Admin" : "not_verified")
                                   .italic()
                                   .foregroundColor(Color.seaTurtle_4)
                                   .opacity(0.8)
                          
                           Image(systemName: "person.fill.badge.minus")
                           .imageScale(.large)
                           .foregroundColor(Color.seaTurtle_4)
                           .opacity(0.4)
                           
                           }
                          
                          Text(authProcess.currentUser?.userUID ?? "nil")
                              .font(.caption)
                              .foregroundColor(Color.seaTurtle_4)
                              .opacity(0.4)
                          Divider()
                      }
                  }
              } //
              
              Spacer()
              
              VStack(alignment:.trailing) {
                  
                  HStack {
                      
                      CSButton_tight(title: "Log Out", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                          self.authProcess.logOutUser()
                            }
                      
                      Spacer()
                      
                      CSButton_tight(title: "Pubblica", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.green) {
                          self.viewModel.saveDataOnFirebase()
                      }
                      
                      Spacer()
                      
                      CSButton_tight(title: "Elimina Account", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.red) {
                          self.authProcess.eliminaAccount()
                      }
             
                  }
                /*  Text(authProcess.currentUser?.userUID ?? "nil")
                      .font(.caption)
                      .foregroundColor(Color.gray) */
              }

              CSDivider()
          } // chiusa VStack Madre
          .padding(.horizontal)
          
         
      } // chiusa ZStack
 
  }
    
    // Method

   
    
}

struct AccounterMainView_Previews: PreviewProvider {
    
    @ObservedObject static var auth:AuthPasswordLess = AuthPasswordLess()
    
    static var previews: some View {
        NavigationStack {
            
         //   NavigationLink {
            AccounterMainView(authProcess: auth, backgroundColorView: Color.seaTurtle_1)
                   
         /*  } label: {
                Text("Test").foregroundColor(Color.red)
            } */
       
        }
        .environmentObject(testAccount)
        .accentColor(Color.white)
            
    }
}
