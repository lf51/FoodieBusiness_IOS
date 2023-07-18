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
    
  @State private var collaborator:CollaboratorModel?
    
    private enum RuoloUtente:String {
        
        case admin,collab
        
    }
    
  var body: some View {

      CSZStackVB(title: "Settings", backgroundColorView: backgroundColorView) {
 
          let currentUser:(userName:String,mail:String,ruolo:RuoloUtente) = {
              
               let datiUtente = self.viewModel.profiloUtente.datiUtente
              
              if datiUtente == nil {
                  
                  let user = self.authProcess.currentUser?.userDisplayName ?? "errorUserName"
                  let mail = self.authProcess.currentUser?.userEmail ?? "errorMail"
                  let ruolo:RuoloUtente = .admin
                  
                  return (user,mail,ruolo)
              } else {
                  
                  let user = self.viewModel.profiloUtente.datiUtente?.userName ?? "errorUserName"
                  let mail = self.viewModel.profiloUtente.datiUtente?.mail ?? "errorMail"
                  let ruolo:RuoloUtente = .collab
                  
                  return (user,mail,ruolo)
              }
   
          }()
          
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
                          
                          Text("\(currentUser.userName)")
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
                     
                      Text("\(currentUser.mail)")
                          .font(.system(.headline, design: .monospaced, weight: .light))
                          .foregroundColor(Color.seaTurtle_4)
                      
                      Image(systemName: "lock.fill")
                      
                  }
                  
                  HStack {
                      
                      Image(systemName: "shield.lefthalf.filled")
                          .foregroundColor(Color.seaTurtle_2)

                      Text(currentUser.ruolo.rawValue)
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
                      let currentUserUID = self.authProcess.currentUser?.userUID
                      
                      CSLabel_conVB(
                        placeHolder: "Collaboratori:",
                        imageNameOrEmojy: "person.crop.rectangle.stack",
                        backgroundColor:Color.seaTurtle_2) {
                            
                            Button {
                                
                                if let adminUID = currentUserUID {
                                    self.collaborator = CollaboratorModel(uidAmministratore:adminUID)
                                } /*else {
                                    self.collaborator = CollaboratorModel(uidAmministratore:"NoUID")
                                }*/ // else è da togliere
                                
                            } label: {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .foregroundColor(Color.seaTurtle_3)
                            }
                            .disabled(currentUserUID == nil)
                            .opacity(currentUserUID == nil ? 0.3 : 1.0)
                        }
                      
                      if let collabs = self.viewModel.profiloUtente.allMyCollabs {
                          
                          ScrollView(showsIndicators:false) {
                              ForEach(collabs,id:\.self) { collab in
                                  collabsRow(collab)
                              }
                          }
                          
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
                          self.viewModel.publishOnFirebase()
                      }
                      
                      CSButton_tight(title: "Erase Data", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.gray) {
                          self.viewModel.dbCompiler.firstAuthenticationFuture()
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
         
          //.disabled(self.viewModel.profiloUtente.datiUtente != nil)
          .disabled(currentUser.ruolo == .collab)
         
      } // chiusa ZStack
      .popover(item:$collaborator) { collabItem in
          CreaModCollabs(
            collabItem: collabItem,
            backgroundColor: backgroundColorView)
          .presentationDetents([.fraction(0.75)])
      }
  }
    
    // Method
    
    @ViewBuilder private func collabsRow(_ collab:CollaboratorModel) -> some View {
        
        let levelName = RestrictionLevel.namingLevel(allRestriction: collab.restrictionLevel)
        let isNonAccoppiato = collab.id.contains("UID_TEMP-")
        
        VStack(alignment:.leading) {
            
            HStack {

                Image(systemName: "arrow.up.arrow.down.circle")
                    .imageScale(.medium)
                    .foregroundColor(isNonAccoppiato ? .black : .blue)
                    .opacity(isNonAccoppiato ? 0.4 : 1.0)
                
                Text(collab.userName)
                    .foregroundColor(Color.seaTurtle_4)
                    .opacity(0.9)
                      
             Spacer()
                
                Button {
                    self.collaborator = collab
                } label: {
                    
                    Image(systemName: "person.fill.badge.minus")
                    .imageScale(.large)
                    .foregroundColor(Color.black)
                    .opacity(0.7)
                   // .opacity(0.6)
                    
                    Text(levelName)
                            .italic()
                            .foregroundColor(Color.seaTurtle_4)
                           // .opacity(0.9)
                   
                    
                }
                .padding(.horizontal)
                .background {
                    Color.seaTurtle_2.opacity(0.5)
                        .cornerRadius(5.0)
                }
             }
            
            VStack(alignment:.leading,spacing:5) {
                Text(collab.mail)
                    .italic()
                    .font(.caption)
                    .foregroundColor(Color.seaTurtle_4)
                    .opacity(0.8)
                
                Text("Collaborazione attiva dal: \(collab.inizioCollaborazione,format: .dateTime)")
                    .italic()
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .opacity(0.7)
                Text(collab.id)
                    .font(.caption2)
                    .foregroundColor(Color.black)
                    .opacity(0.5)
            }
            
            Divider()
        }
    }
    
    private struct CreaModCollabs:View {
        
        @EnvironmentObject var viewModel:AccounterVM
        
        @State private var collabItem:CollaboratorModel
        @State private var collabArchiviato:CollaboratorModel
        let backgroundColorView:Color

        init(collabItem:CollaboratorModel,backgroundColor:Color) {
            
            _collabItem = State(wrappedValue: collabItem)
            _collabArchiviato = State(wrappedValue: collabItem)
            self.backgroundColorView = backgroundColor
        }
        
        var body: some View {
            
            ZStack {

                let alreadyExist:Bool = {
                  let allID = self.viewModel.profiloUtente.allMyCollabs?.map({$0.id}) ?? []
                    return allID.contains(self.collabItem.id)
                    
                }()
                
                let isAccoppiato = !self.collabItem.id.contains("UID_TEMP-")
                
                Rectangle()
                    .fill(backgroundColorView.gradient)
                    .edgesIgnoringSafeArea(.top)
                    .zIndex(0)
                
                VStack(alignment:.leading) {
                    
                    Text(alreadyExist ? "\(self.collabItem.userName)" : "Nuovo Collaboratore")
                        .fontWeight(.semibold)
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .padding(.top,10)
                    
                    Spacer()
                    
                    VStack{

                        CSTextField_4(
                            textFieldItem: $collabItem.mail,
                            placeHolder: "email adress", image: "at",
                            showDelete: true,
                            keyboardType: .emailAddress)
                            .textContentType(.emailAddress)
                            .disabled(isAccoppiato)
                        // disabilitare se accoppiamento è andato in porto
                        
                        
                        CSTextField_4(
                            textFieldItem: $collabItem.userName,
                            placeHolder: "user name",
                            image: "person",
                            showDelete: true,
                            keyboardType: .default)
                        
                        Spacer()
                        
                        VStack(alignment:.leading,spacing:10) {
                            
                            CSLabel_conVB(
                                placeHolder: "Autorizzazioni",
                                placeHolderColor: nil,
                                imageNameOrEmojy: "lock",
                                imageColor: nil,
                                backgroundColor: .blue,
                                backgroundOpacity: 1.0) {
                                    
                                    Picker(selection: $collabItem.restrictionLevel) {
                                     
                                        ForEach(Array(RestrictionLevel.allLevel.keys.sorted()),id:\.self) { key in
                                            
                                            let value = RestrictionLevel.allLevel[key] ?? RestrictionLevel.level_1
                                            
                                            Text(key)
                                                .tag(value)
                                            
                                        }
                                    } label: {
                                        Text("")
                                    }
                                  
                                }
                            
                            ScrollView(showsIndicators:false) {
                                
                                ForEach(RestrictionLevel.allCases,id:\.self) { restrizione in
                                    
                                    let isIn = self.collabItem.restrictionLevel.contains(restrizione)
                                    
                                    HStack {
                                        Text(restrizione.simpleDescription())
                                            .font(.body)
                                            .fontWeight(.light)
                                        Spacer()
       
                                        CSButton_image(
                                            activationBool: isIn,
                                            frontImage: "x.circle.fill",
                                            backImage: "checkmark.circle.fill",
                                            imageScale: .large,
                                            backColor: .red.opacity(0.8),
                                            frontColor: .blue,
                                            rotationDegree: nil) {
                                                self.manageRestriction(restriction: restrizione)
                                            }
                                    }
                                   
                                    Divider()
                                    
                                    
                                }
                            }
                        }
                    }
           
                    
                    HStack(spacing:40) {
                        
                        let value:(creaMod:String,resetDelet:String) = {
                           
                            if alreadyExist { return ("Modifica","Rimuovi")}
                            else { return ("Crea","Reset")}
                            
                        }()
                        
                        let disableCreaMod:Bool = {
                           
                            if alreadyExist {
                                return self.collabItem == self.collabArchiviato ||
                                self.collabItem.mail == "" ||
                                self.collabItem.userName == ""
                                
                            }
                            else {
                                return self.collabItem.mail == "" ||
                                self.collabItem.userName == ""
                            }
                            
                        }()
                        
                        let disableResetDel:Bool = {
                           
                            if alreadyExist { return false }
                            else {
                                return self.collabItem == self.collabArchiviato
                            }
                        }()
                        
                        Spacer()
                        
                        CSButton_tight(
                         title: value.resetDelet,
                         fontWeight: .bold,
                         titleColor: .orange.opacity(0.85),
                         fillColor: .clear) {
                             self.resetDeleteCollab(collabExist: alreadyExist)
                         }
                         .disabled(disableResetDel)
                         .opacity(disableResetDel ? 0.6 : 1.0)
                        
                        CSButton_tight(
                         title: value.creaMod,
                         fontWeight: .semibold,
                         titleColor: .seaTurtle_1,
                         fillColor: .seaTurtle_3) {
                             self.creaModCollab(collabExist: alreadyExist)
                            }
                         .disabled(disableCreaMod)
                         .opacity(disableCreaMod ? 0.4 : 1.0)
                    }
                    .padding(.trailing)
                    
                       // .disabled(disableSave)
                   // }
                        Spacer()
                                
                }
                .padding(.horizontal,10)
                .zIndex(1)
                
            }
            .background(backgroundColorView.opacity(0.6))
           
        
            
        }
        
        // Method
        
        private func resetDeleteCollab(collabExist:Bool) {

            guard !collabExist else {
                //delete
                self.viewModel.alertItem = AlertModel(
                    title: "Azione non Reversibile",
                    message: "Clicca su elimina se vuoi rimuovere \(self.collabItem.userName) dai tuoi collaboratori",
                    actionPlus: ActionModel(
                        title: .elimina,
                        action: {
                            self.viewModel.profiloUtente.allMyCollabs?.removeAll(where: {$0.mail == self.collabItem.mail}) // possiamo usare anche ID
                        }))
                return
                
            }
            // reset
            self.collabItem = self.collabArchiviato
            
        }
        
        private func creaModCollab(collabExist:Bool) {
            
            guard !collabExist else {
                // modifica un collab esistente
                if let index = self.viewModel.profiloUtente.allMyCollabs?.firstIndex(where: {$0.id == self.collabItem.id}) {
                    self.viewModel.profiloUtente.allMyCollabs?.remove(at: index)
                    self.newCollab()
                }
                return
            }
           // crea collab nuovo
            // verificare che la mail (nuova) non sia già stata utilizzata.
            let allCollabsMail = self.viewModel.profiloUtente.allMyCollabs?.map({$0.mail}) ?? []
            let alreadyIn = allCollabsMail.contains(self.collabItem.mail)
            
            guard !alreadyIn else {
                
                self.viewModel.alertItem = AlertModel(
                    title: "Error",
                    message: "Esiste già un collaboratore con questa mail")
                return
                
            }
            
            self.newCollab()
        
        }
        
        private func newCollab() {
            self.viewModel.profiloUtente.allMyCollabs?.append(self.collabItem)
            let uidAdmin = self.collabItem.db_uidRef
            let new = CollaboratorModel(uidAmministratore: uidAdmin)
            self.collabItem = new
            self.collabArchiviato = new
        }
        
        private func manageRestriction(restriction:RestrictionLevel) {
            
            if self.collabItem.restrictionLevel.contains(restriction) {
                self.collabItem.restrictionLevel.removeAll(where: {$0 == restriction})
            } else {
                self.collabItem.restrictionLevel.append(restriction)
            }
            
        }
    }
    
}
/*
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
                          self.viewModel.publishOnFirebase()
                      }
                      
                      CSButton_tight(title: "Erase Data", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.gray) {
                          self.viewModel.dbCompiler.firstAuthenticationFuture()
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

   
    
}*/ // backup 17.07.23 per implementazione Collaboratori

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
        .environmentObject(AccounterVM())
        .accentColor(Color.white)
            
    }
}
