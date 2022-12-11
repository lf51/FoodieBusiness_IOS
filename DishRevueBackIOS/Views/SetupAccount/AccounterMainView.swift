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
                          return ("Fatto",Color("SeaTurtlePalette_3"))
                      } else {
                          return ("Edit",Color("SeaTurtlePalette_2"))
                      }
                  }()
                  
                  CSLabel_conVB(
                      placeHolder: "Dati Utente",
                      imageNameOrEmojy: "person.text.rectangle",
                      backgroundColor:Color("SeaTurtlePalette_2")) {
                       
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
                          .foregroundColor(Color("SeaTurtlePalette_2"))

                      if !wannaChangeDisplayName {
                          
                          Text("\(self.authProcess.currentUser?.userDisplayName ?? "not_username")")
                              .font(.system(.headline, design: .monospaced, weight: .semibold))
                              .foregroundColor(Color("SeaTurtlePalette_4"))

                          
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
                          .foregroundColor(Color("SeaTurtlePalette_2"))
                     
                      Text("\(self.authProcess.currentUser?.userEmail ?? "email")")
                          .font(.system(.headline, design: .monospaced, weight: .light))
                          .foregroundColor(Color("SeaTurtlePalette_4"))
                      
                      Image(systemName: "lock.fill")
                      
                  }
                  
                  HStack {
                      
                      Image(systemName: "shield.lefthalf.filled")
                          .foregroundColor(Color("SeaTurtlePalette_2"))

                      Text(authProcess.currentUser?.userEmailVerified ?? false ? "Amministratore" : "not_verified")
                          .italic()
                          .font(.system(.headline, design: .monospaced, weight: .light))
                          .foregroundColor(Color("SeaTurtlePalette_4"))
                      
                      Image(systemName: "lock.fill")
    
                  }

                  VStack(alignment:.leading,spacing: 5) {
                      
                      CSLabel_1Button(
                        placeHolder: "Funzioni",
                        imageNameOrEmojy: "gear",
                        backgroundColor: Color("SeaTurtlePalette_2"))
                      
                      Group {
 
                          HStack {
                              
                              Text("Auto-Pause Preparazione by pausing Ingredient")
                              CSInfoAlertView(title: "Info", message: .cambioStatusPreparazioni)
                              Spacer()
                              Picker(selection: $viewModel.setupAccount.autoPauseDish_byPauseING) {
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
                              Picker(selection: $viewModel.setupAccount.autoPauseDish_byArchiveING) {
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
                              Picker(selection: $viewModel.setupAccount.startCountDownMenuAt) {
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
                        backgroundColor:Color("SeaTurtlePalette_4")) {
                            Text("Add")
                                .bold()
                                .foregroundColor(Color("SeaTurtlePalette_4"))
                                .opacity(0.4)
                              
                        }
                      
                      VStack(alignment:.leading) {
                          
                          HStack {

                           Text("\(self.authProcess.currentUser?.userEmail ?? "email")")
                                  .foregroundColor(Color("SeaTurtlePalette_4"))
                                  .opacity(0.8)
                                    
                           Spacer()
                           Text(authProcess.currentUser?.userEmailVerified ?? false ? "Admin" : "not_verified")
                                   .italic()
                                   .foregroundColor(Color("SeaTurtlePalette_4"))
                                   .opacity(0.8)
                          
                           Image(systemName: "person.fill.badge.minus")
                           .imageScale(.large)
                           .foregroundColor(Color("SeaTurtlePalette_4"))
                           .opacity(0.4)
                           
                           }
                          
                          Text(authProcess.currentUser?.userUID ?? "nil")
                              .font(.caption)
                              .foregroundColor(Color("SeaTurtlePalette_4"))
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
            AccounterMainView(authProcess: auth, backgroundColorView: Color("SeaTurtlePalette_1"))
                   
         /*  } label: {
                Text("Test").foregroundColor(Color.red)
            } */
       
        }
        .environmentObject(testAccount)
        .accentColor(Color.white)
            
    }
}


/*
 
 struct AccounterMainView: View {
    
   @ObservedObject var authProcess: AuthPasswordLess
   @EnvironmentObject var viewModel: AccounterVM
     
   let backgroundColorView: Color
     
   @State private var newDisplayName: String = ""
   @State private var wannaChangeDisplayName: Bool = false
  
   @State private var newCollab:CollaboratorModel?
     
   var body: some View {

       CSZStackVB(title: "Settings", backgroundColorView: backgroundColorView) {
  
           VStack(alignment:.leading) {
               
               VStack(alignment:.leading, spacing: 10.0) {

                   CSLabel_conVB(
                       placeHolder: "Dati Utente",
                       imageNameOrEmojy: "person.text.rectangle",
                       backgroundColor:Color("SeaTurtlePalette_2")) {
                           Text("Edit")
                               .onTapGesture {
                                   withAnimation {
                                       self.wannaChangeDisplayName.toggle()
                                   }
                               }
                           
                       }

                   HStack {
                       
                       Image(systemName: "person.fill")
                           .foregroundColor(Color("SeaTurtlePalette_2"))

                       if !wannaChangeDisplayName {
                           
                           Text("\(authProcess.currentUser?.userDisplayName ?? "DVlillofree")")
                               .font(.system(.headline, design: .monospaced, weight: .semibold))
                               .foregroundColor(Color("SeaTurtlePalette_4"))
                              /* .onTapGesture {
                                   withAnimation {
                                       self.wannaChangeDisplayName.toggle()
                                   }
                               } */
                           
                       } else {
                           
                           CSTextField_5(textFieldItem: $newDisplayName, placeHolder: "UserName", image: "at", showDelete: true, keyboardType: .default){
                               
                            //   withAnimation {
                                   authProcess.updateDisplayName(newDisplayName: self.newDisplayName)
                                   self.newDisplayName = ""
                                   self.wannaChangeDisplayName = false
                             //  }
                               
                               
                           }
                       }
                       
                     //  Spacer()
                   }
            
                   HStack {
                       
                       Image(systemName: "shield.lefthalf.filled")
                           .foregroundColor(Color("SeaTurtlePalette_2"))
                     /*  Text("Autorizzazione:")
                           //.italic()
                           .font(.system(.headline, design: .monospaced, weight: .semibold))
                           .foregroundColor(Color("SeaTurtlePalette_2"))
                           //.shadow(color: Color.white, radius: 10.0, x: 0, y:  0) */
                       
                       Text(authProcess.currentUser?.userUID ?? "Amministratore")
                           .italic()
                           .font(.system(.headline, design: .monospaced, weight: .light))
                           .foregroundColor(Color("SeaTurtlePalette_4"))
                       
                       Image(systemName: "lock.fill")
                       
                      //Spacer()
                   }
                   
                   HStack {
                       
                       Image(systemName: "key.fill")
                           .foregroundColor(Color("SeaTurtlePalette_2"))
                      
                       
                       Text("\(authProcess.currentUser?.userEmail ?? "DVlillof@gmailc.om")")
                           .font(.system(.headline, design: .monospaced, weight: .semibold))
                           .foregroundColor(Color("SeaTurtlePalette_4"))
                       
                       Image(systemName: "lock.fill")
                       
                   }
                   
              //     Divider()
                   
                   VStack(alignment:.leading,spacing: 0) {
                       
                       CSLabel_1Button(
                         placeHolder: "Setup Funzioni",
                         imageNameOrEmojy: "gear",
                         backgroundColor: Color("SeaTurtlePalette_2"))
                       
                       Group {
  
                           HStack {
                               
                               Text("Cambio Status Preparazioni")
                               CSInfoAlertView(title: "Info", message: .cambioStatusPreparazioni)
                               Spacer()
                               Picker(selection: $viewModel.setupAccount.mettiInPausaDishByIngredient) {
                                   ForEach(AccountSetup.ActionValue.allCases,id:\.self) { value in

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
                               Picker(selection: $viewModel.setupAccount.startCountDownMenuAt) {
                                   ForEach(AccountSetup.TimeValue.allCases,id:\.self) { value in

                                           Text("\(value.rawValue) minuti")
                                       
                                   }
                               } label: {
                                   Text("")
                               }
                           }
                       

                       }
                       .font(.subheadline)
                       
                   }
                   
                   
                   
                   VStack(alignment:.leading) {
                       
                      /* HStack {
                           
                           Image(systemName: "person.crop.rectangle.stack.fill")
                               .foregroundColor(Color("SeaTurtlePalette_2"))
                           
                           Text("Collaboratori:")
                               .font(.system(.title3, design: .monospaced, weight: .black))
                               .foregroundColor(Color("SeaTurtlePalette_2"))
                           
                          
                       }
                           .padding(.bottom,5) */
                       
                     CSLabel_conVB(
                         placeHolder: "Collaboratori(Da Sviluppare):",
                         imageNameOrEmojy: "person.crop.rectangle.stack.fill",
                         backgroundColor:Color("SeaTurtlePalette_2")) {
                             Text("Add")
                                 .onTapGesture {
                                     self.newCollab = CollaboratorModel(
                                         userEmail: "",
                                         livelloAutorità: "")
                                 }
                         }
                       
                      /* ForEach(self.viewModel.allMyCollabs) { collab in
                           
                           HStack {
                               Text(collab.userEmail)
                               Text(collab.livelloAutorità)
                                 Spacer()
                                 Image(systemName: "person.fill.badge.minus")
                                     .imageScale(.large)
                                     .foregroundColor(Color.white)
                                     
                             }
                        
                           Divider()
                       } */
                       
                     /*  HStack {
                          /* Image(systemName: "person.badge.shield.checkmark.fill")
                               .imageScale(.medium)
                               .foregroundColor(Color("SeaTurtlePalette_2")) */
                           
                           Text("gf@hotmail.it")
                           Text("Livello 5")
                           Spacer()
                           Image(systemName: "person.fill.badge.minus")
                               .imageScale(.large)
                             //  .bold()
                               .foregroundColor(Color.white)
                       }
                       Divider()
                       
                       HStack {
                           
                           Text("peppeF@gmail.it")
                           Text("Livello 4")
                           Spacer()
                           Image(systemName: "person.fill.badge.minus")
                               .imageScale(.large)
                              // .bold()
                               .foregroundColor(Color.white)
                       }
                       Divider() */
                       
                   }
                   
              
                 /* HStack {
                       
                       Image(systemName: "phone.fill")
                       CSText_tightRectangle(testo: "3337213895", fontWeight: .semibold, textColor: Color.yellow, strokeColor: Color.blue, fillColor: Color.cyan)
                           .onTapGesture {
                               withAnimation {
                                   self.wannaChangeDisplayName.toggle()
                               }
                           }
                       
                   } */

              //     Spacer()
                   
                
                       
                   
               }
               
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
                   
                   Text(UUID().uuidString)
                       .font(.caption)
                       .foregroundColor(Color.gray)
               }
               
               
            //   ExtractedView()
               
           } // chiusa VStack Madre
           .padding(.horizontal)
           
           
       } // chiusa ZStack
       .toolbar {
     
           CSText_tightRectangle(testo: "Richiedi Verifica", fontWeight: .semibold, textColor: Color.blue, strokeColor: Color.blue, fillColor: Color.cyan)
       }
      /* .popover(item: $newCollab) { collab in
           PopNewCollab(newCollab: collab, backgroundColor: backgroundColorView)
               .presentationDetents([.height(250)])
       } */
       
      /* .alert(item: $authProcess.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
           
       } */
       
       
     
   }
     
     // Method

    
     
 }
 
 
 */

