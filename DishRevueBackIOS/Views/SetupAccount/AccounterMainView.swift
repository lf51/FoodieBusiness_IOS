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
    let backgroundColorView: Color
    
    var body: some View {
        
        Text("SETUP")
    }
}
/*
struct AccounterMainView: View {
   
  @ObservedObject var authProcess: AuthPasswordLess
  @EnvironmentObject var viewModel: AccounterVM
    
  let backgroundColorView: Color
    
 // @State private var newDisplayName: String = ""
 // @State private var wannaChangeDisplayName: Bool = false
    
   /* private var disableChange:Bool { return false
     //   self.viewModel.currentUserRoleModel?.id != self.viewModel.currentProperty?.organigramma.admin.id
    }*/
    
  @State private var collaborator:UserRoleModel?
    
    
  var body: some View {

      CSZStackVB(title: "Settings", backgroundColorView: backgroundColorView) {
          
          let currentUser:(userName:String,mail:String) = {
              let user = self.viewModel.currentUserRoleModel
              return (user.userName,user.mail)
           
          }()
       
         VStack(alignment:.leading) {
              
             VStack(alignment:.leading,spacing:10) {
                 
                 CSLabel_1Button(
                    placeHolder: "Dati Utente",
                    imageNameOrEmojy: "person.text.rectangle",
                    backgroundColor:Color.seaTurtle_2)
        
                 HStack {
                     
                     Image(systemName: "key.fill")
                         .foregroundColor(Color.seaTurtle_2)
                     
                     Text("\(currentUser.mail)")
                         .font(.system(.headline, design: .monospaced, weight: .light))
                         .foregroundColor(Color.seaTurtle_4)
                     
                     Image(systemName: "lock.fill")
                     
                 }
                 
                 HStack {
                     
                     Image(systemName: "person.fill")
                         .foregroundColor(Color.seaTurtle_2)

                         Text("\(currentUser.userName)")
                             .font(.system(.headline, design: .monospaced, weight: .semibold))
                             .foregroundColor(Color.seaTurtle_4)
    
                 }
                
             }
             
          ScrollView(showsIndicators:false) {
              
              VStack(alignment:.leading, spacing: 10.0) {
                  
                  VStack {
                      
                      CSLabel_1Button(
                         placeHolder: "Property",
                         imageNameOrEmojy: "person.text.rectangle",
                         backgroundColor: .seaTurtle_2)
                      
                  if let currentProp = self.viewModel.currentProperty {
                      
                      self.vbCurrentProperty(propertyIn: currentProp)
                    
                  } else {
                      
                      Text("nessuna collaborazione o proprietà registrata")
                          .italic()
                          .font(.caption)
                          .foregroundColor(.black)
                          .opacity(0.8)
                      
                  }
                      
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
                  
                  
              } //

          } // chiusa Scroll
             
             Spacer()
             
             VStack(alignment:.trailing) {
                 
                 HStack {
                     
                     CSButton_tight(title: "Log Out", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                         self.authProcess.logOutUser()
                     }
                     
                     Spacer()
                     
                     CSButton_tight(title: "Pubblica", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.green) {
                         self.viewModel.publishOnFirebase { error in
                             
                             if error {
                                 
                                 self.viewModel.alertItem = AlertModel(title: "Server Message", message: "Pubblicazione dati fallita")
                                 
                             } else {
                                 self.viewModel.alertItem = AlertModel(title: "Server Message", message: "Pubblicazione dati avvenuta con successo")
                             }
                             
                         }
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
             
          
        } // chiusa VStack Madre
         .padding(.horizontal)
        // .disabled(currentUser.ruolo == .collab)
      } // chiusa ZStack
      .onAppear { self.viewModel.fetchPropertyData() }
      .onChange(of: self.viewModel.currentProperty, perform: { newValue in
          print("rilevato change currentProperty")
      })
      .popover(item:$collaborator) { collabItem in
          CreaModCollabs(
            collabItem: collabItem,
            backgroundColor: backgroundColorView)
          .presentationDetents([.fraction(0.75)])
      }
  }
    
    // Method
    
    @ViewBuilder private func vbCurrentProperty(propertyIn:PropertyModel) -> some View {
        
        let propID = propertyIn.id
        let propName = propertyIn.intestazione
        
        let admin = propertyIn.organigramma.admin
        let startDate = self.viewModel.currentUserRoleModel.inizioCollaborazione ?? .now
        let startDateString = csTimeFormatter().data.string(from: startDate)
        
        let referenceIn:(testo:String,ruolo:RoleModel) = {
            
            if let ref = self.viewModel.cloudData.allMyPropertiesRef.first(where: {$0.value == propID})?.key {
                
                if ref == .collab {
                    return ("Admin: \(admin.userName)",.collab)
                }
                else { return (ref.rawValue,.admin) }
                
            } else {
                return ("Error(No_reference_in)",.client) // non dovrebbe mai verificarsi
            }
        
        }()
        
        HStack {
            
            Image(systemName: "shield.lefthalf.filled")
                .foregroundColor(Color.seaTurtle_2)
            
            Text(propName)
                .italic()
                .font(.system(.headline, design: .monospaced, weight: .light))
                .foregroundColor(Color.seaTurtle_4)
            
            Image(systemName: "lock.fill")
            
        }
        
        HStack {

            Image(systemName: "shield.lefthalf.filled")
                .foregroundColor(Color.seaTurtle_2)
            
            Text(referenceIn.testo)
                .italic()
                .font(.system(.headline, design: .monospaced, weight: .light))
                .foregroundColor(Color.seaTurtle_4)
            
            Image(systemName: "lock.fill")
            
        }
        
        if referenceIn.ruolo == .collab {
            
            HStack {
                
                Image(systemName: "shield.lefthalf.filled")
                    .foregroundColor(Color.seaTurtle_2)
                
                Text("Mio Ruolo: \(referenceIn.ruolo.rawValue)")
                    .italic()
                    .font(.system(.headline, design: .monospaced, weight: .light))
                    .foregroundColor(Color.seaTurtle_4)
                
                Image(systemName: "lock.fill")
                
            }
            
        }

        Text(startDateString)
            .italic()
            .font(.caption)
            .foregroundColor(.black)
            .opacity(0.8)
        
        VStack(alignment:.leading) {
  
            let disableCollab = referenceIn.ruolo != .admin
            
            CSLabel_conVB(
              placeHolder: "Collaboratori:",
              imageNameOrEmojy: "person.crop.rectangle.stack",
              backgroundColor:Color.seaTurtle_2) {
                  
                  Button {
                      
                      self.collaborator = UserRoleModel()
                      
                  } label: {
                      Image(systemName: "plus.circle")
                          .imageScale(.large)
                          .foregroundColor(Color.seaTurtle_3)
                  }
                  .disabled(disableCollab)
                  .opacity(disableCollab ? 0.3 : 1.0)
              }
            
            if let collabs = self.viewModel.currentProperty?.organigramma.allAdminCollabs {
                
                //   ScrollView(showsIndicators:false) {
                VStack {
                    ForEach(collabs,id:\.self) { collab in
                        collabsRow(collab,disable: disableCollab)
                    }
                }
                
            }
            
        }
        
        
    
    }
    
    
    @ViewBuilder private func collabsRow(_ collab:UserRoleModel,disable:Bool) -> some View {
        
        let levelName = RestrictionLevel.namingLevel(allRestriction: collab.restrictionLevel ?? [])
        let isNonAccoppiato = collab.id.contains("NON_ACCOPPIATO")
        
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
                
                Menu {
                    
                    Button {
                        self.collaborator = collab
                    } label: {
                        Text("Edit")
                    }
                    
                    Button(role:.destructive) {
                        withAnimation {
                            self.deleteCollab(collab: collab)
                        }
                    } label: {
                        Text("Rimuovi")
                    }
                    
                } label: {
                    
                    Image(systemName: "person.fill.badge.minus")
                    .imageScale(.large)
                    .foregroundColor(Color.black)
                    .opacity(0.7)

                    Text(levelName)
                            .italic()
                            .foregroundColor(Color.seaTurtle_4)
                          
                }
                .padding(.horizontal)
                .background {
                        Color.seaTurtle_2.opacity(0.5)
                            .cornerRadius(5.0)
                    }
                .disabled(disable)

             }
            
            VStack(alignment:.leading,spacing:5) {
                Text(collab.mail)
                    .italic()
                    .font(.caption)
                    .foregroundColor(Color.seaTurtle_4)
                    .opacity(0.8)
                
                Text("Collaborazione attiva dal: \(collab.inizioCollaborazione ?? .now,format: .dateTime)")
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
    
    private func deleteCollab(collab:UserRoleModel) {

        self.viewModel.alertItem = AlertModel(
            title: "Azione non Reversibile",
            message: "Clicca su elimina se vuoi rimuovere \(collab.userName) dai tuoi collaboratori",
            actionPlus: ActionModel(
                title: .elimina,
                action: {
                    self.viewModel.currentProperty?.organigramma.allAdminCollabs?.removeAll(where: {$0.id == collab.id})
                   
                }))
        
    }
    
    private struct CreaModCollabs:View {
        
        @EnvironmentObject var viewModel:AccounterVM
        @Environment(\.presentationMode) var presentationMode
        
        @State private var localAlert:String?
        
        @State private var collabItem:UserRoleModel
        @State private var collabArchiviato:UserRoleModel
        let backgroundColorView:Color

        init(collabItem:UserRoleModel,backgroundColor:Color) {
            
            _collabItem = State(wrappedValue: collabItem)
            _collabArchiviato = State(wrappedValue: collabItem)
            self.backgroundColorView = backgroundColor
        }
        
        var body: some View {
            
            ZStack {

                let alreadyExist:Bool = {
                    let allID = self.viewModel.currentProperty?.organigramma.allAdminCollabs?.map({$0.id}) ?? []
                    return allID.contains(self.collabItem.id)
                    
                }()
                
                let isAccoppiato = !self.collabItem.id.contains("NON_ACCOPPIATO")
                
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
                    
                    VStack {

                        VStack(alignment:.leading) {
                            CSTextField_4(
                                textFieldItem: $collabItem.mail,
                                placeHolder: "email adress", image: "at",
                                showDelete: true,
                                keyboardType: .emailAddress)
                                .textContentType(.emailAddress)
                                .disabled(isAccoppiato)
                            
                            if let alert = localAlert {
                                Text(alert)
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.black)
                            } else {
                                Text("Campo Obbligatorio")
                                    .italic()
                                    .font(.caption2)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                            }
                            
                        }
                        
                        VStack(alignment:.leading) {
                            
                            CSTextField_4(
                                textFieldItem: $collabItem.userName,
                                placeHolder: "user name",
                                image: "person",
                                showDelete: true,
                                keyboardType: .default)
                            
                            Text("Campo Obbligatorio")
                                .italic()
                                .font(.caption2)
                                .foregroundColor(.black)
                                .opacity(0.7)
                        }
                        
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
                                    .accentColor(.seaTurtle_4)
                                  
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
                        
                        let creaMod:String = {
                           
                            if alreadyExist { return "Modifica"}
                            else { return "Crea"}
                            
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
                        
                        let disableReset:Bool = self.collabItem == self.collabArchiviato
                        
                        Spacer()
                        
                        CSButton_tight(
                         title: "Reset",
                         fontWeight: .bold,
                         titleColor: .orange.opacity(0.85),
                         fillColor: .clear) {
                             self.resetCollab()
                         }
                         .disabled(disableReset)
                         .opacity(disableReset ? 0.6 : 1.0)
                        
                        CSButton_tight(
                         title: creaMod,
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
        
        private func resetCollab() {

            self.collabItem = self.collabArchiviato
            
        }
        
        private func creaModCollab(collabExist:Bool) {
            
            guard !collabExist else {
                // modifica un collab esistente
                if let index = self.viewModel.currentProperty?.organigramma.allAdminCollabs?.firstIndex(where: {$0.id == self.collabItem.id}) {
                    
                    self.viewModel.currentProperty?.organigramma.allAdminCollabs?.remove(at: index)
                    self.newCollab()
                }
                return
            }
           // crea collab nuovo
 
            self.newCollab()
        
        }
        
        private func emailCheckAlert() {
            
            let allCollabsMail = self.viewModel.currentProperty?.organigramma.allAdminCollabs?.map({$0.mail}) ?? []
            let alreadyIn = allCollabsMail.contains(self.collabItem.mail)
            
            if alreadyIn { self.localAlert = "⚠️ Esiste già un collaboratore con questa mail" }
            else { self.localAlert = nil  }
            
        }
        
        private func newCollab() {
            
            self.emailCheckAlert()
            
            guard self.localAlert == nil else { return }
            
            if var container = self.viewModel.currentProperty?.organigramma.allAdminCollabs {
                
                container.append(self.collabItem)
                self.viewModel.currentProperty?.organigramma.allAdminCollabs = container
                
            } else {
                self.viewModel.currentProperty?.organigramma.allAdminCollabs = [collabItem]
            }
            
           // let uidAdmin = self.collabItem.db_uidRef
           // let new = CollaboratorModel(uidAmministratore: uidAdmin)
            let new = UserRoleModel()
            self.collabItem = new
            self.collabArchiviato = new
            
            self.presentationMode.wrappedValue.dismiss()
            print("newCollab Container \(self.viewModel.currentProperty?.organigramma.allAdminCollabs?.isEmpty)")
        }
        
        private func manageRestriction(restriction:RestrictionLevel) {
            
            if self.collabItem.restrictionLevel.contains(restriction) {
                self.collabItem.restrictionLevel.removeAll(where: {$0 == restriction})
            } else {
                self.collabItem.restrictionLevel.append(restriction)
            }
            
        }
    }
    
}*/ // 30.07.23 Backup

/*
struct AccounterMainViewDEPRECATA: View {
   
  @ObservedObject var authProcess: AuthPasswordLess
  @EnvironmentObject var viewModel: AccounterVM
    
  let backgroundColorView: Color
    
  @State private var newDisplayName: String = ""
  @State private var wannaChangeDisplayName: Bool = false
    
    private var disableChange:Bool {
        self.viewModel.currentUserRoleModel?.id != self.viewModel.currentProperty?.organigramma.admin.id
    }
    
  @State private var collaborator:CollaboratorModel?
    
    
  var body: some View {

      CSZStackVB(title: "Settings", backgroundColorView: backgroundColorView) {
          
          let currentUser:(userName:String,mail:String,ruolo:RoleModel,dataInizio:String) = {
              
              let mail = self.authProcess.currentUser?.userEmail ?? "errorMail"
              let propertyId = self.viewModel.currentProperty?.id ?? "NoValue"
              let role = self.viewModel.cloudData.allMyPropertiesRef.first(where: {$0.value == propertyId })?.key ?? .client
              
              if let datiUtente = self.viewModel.currentUserRoleModel {
                  
                  let user = datiUtente.userName
                  let dataStart = datiUtente.inizioCollaborazione
                  let dataString = csTimeFormatter().data.string(from: dataStart)
                  
                  return (user,mail,role,dataString)
                 
              } else {
                  
                  let user = self.authProcess.currentUser?.userDisplayName ?? "errorUserName"
                  let dataStart = "No date poichè non c'è proprietà"
                  
                  return (user,mail,role,dataStart)
                  
              }
          }()
       
         VStack(alignment:.leading) {
              
             VStack(alignment:.leading,spacing:10) {
                 
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
                           }.disabled(currentUser.ruolo == .collab)
                       
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
                             
                             if let property = self.viewModel.currentProperty {
                                 
                                 self.viewModel.dbCompiler.publishGenericOnFirebase(collection: .propertyCollection, refKey: property.id, element: property)
                             }
                             
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
                 
             }
             
          ScrollView(showsIndicators:false) {
              
              VStack(alignment:.leading, spacing: 10.0) {
                  
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
                          
                          //   ScrollView(showsIndicators:false) {
                          VStack {
                              ForEach(collabs,id:\.self) { collab in
                                  collabsRow(collab)
                              }
                          }
                          
                      }
                      
                  }
              } //

          } // chiusa Scroll
             
             Spacer()
             
             VStack(alignment:.trailing) {
                 
                 HStack {
                     
                     CSButton_tight(title: "Log Out", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                         self.authProcess.logOutUser()
                     }
                     
                     Spacer()
                     
                     CSButton_tight(title: "Pubblica", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.green) {
                         self.viewModel.publishOnFirebase { error in
                             
                             if error {
                                 
                                 self.viewModel.alertItem = AlertModel(title: "Server Message", message: "Pubblicazione dati fallita")
                                 
                             } else {
                                 self.viewModel.alertItem = AlertModel(title: "Server Message", message: "Pubblicazione dati avvenuta con successo")
                             }
                             
                         }
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
             
          
        } // chiusa VStack Madre
         .padding(.horizontal)
         .disabled(currentUser.ruolo == .collab)
      } // chiusa ZStack
      .onAppear { self.viewModel.fetchPropertyData() }
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
        let isNonAccoppiato = collab.id.contains("NON_ACCOPPIATO")
        
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
                
                Menu {
                    
                    Button {
                        self.collaborator = collab
                    } label: {
                        Text("Edit")
                    }
                    
                    Button(role:.destructive) {
                        withAnimation {
                            self.deleteCollab(collab: collab)
                        }
                    } label: {
                        Text("Rimuovi")
                    }
                    
                } label: {
                    
                    Image(systemName: "person.fill.badge.minus")
                    .imageScale(.large)
                    .foregroundColor(Color.black)
                    .opacity(0.7)

                    Text(levelName)
                            .italic()
                            .foregroundColor(Color.seaTurtle_4)
                          
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
    
    private func deleteCollab(collab:CollaboratorModel) {
        
        self.viewModel.alertItem = AlertModel(
            title: "Azione non Reversibile",
            message: "Clicca su elimina se vuoi rimuovere \(collab.userName) dai tuoi collaboratori",
            actionPlus: ActionModel(
                title: .elimina,
                action: {
                    self.viewModel.profiloUtente.allMyCollabs?.removeAll(where: {$0.id == collab.id})
                }))
        
    }
    
    private struct CreaModCollabs:View {
        
        @EnvironmentObject var viewModel:AccounterVM
        @Environment(\.presentationMode) var presentationMode
        
        @State private var localAlert:String?
        
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
                
                let isAccoppiato = !self.collabItem.id.contains("NON_ACCOPPIATO")
                
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
                    
                    VStack {

                        VStack(alignment:.leading) {
                            CSTextField_4(
                                textFieldItem: $collabItem.mail,
                                placeHolder: "email adress", image: "at",
                                showDelete: true,
                                keyboardType: .emailAddress)
                                .textContentType(.emailAddress)
                                .disabled(isAccoppiato)
                            
                            if let alert = localAlert {
                                Text(alert)
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.black)
                            } else {
                                Text("Campo Obbligatorio")
                                    .italic()
                                    .font(.caption2)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                            }
                            
                        }
                        
                        VStack(alignment:.leading) {
                            
                            CSTextField_4(
                                textFieldItem: $collabItem.userName,
                                placeHolder: "user name",
                                image: "person",
                                showDelete: true,
                                keyboardType: .default)
                            
                            Text("Campo Obbligatorio")
                                .italic()
                                .font(.caption2)
                                .foregroundColor(.black)
                                .opacity(0.7)
                        }
                        
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
                                    .accentColor(.seaTurtle_4)
                                  
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
                        
                        let creaMod:String = {
                           
                            if alreadyExist { return "Modifica"}
                            else { return "Crea"}
                            
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
                        
                        let disableReset:Bool = self.collabItem == self.collabArchiviato
                        
                        Spacer()
                        
                        CSButton_tight(
                         title: "Reset",
                         fontWeight: .bold,
                         titleColor: .orange.opacity(0.85),
                         fillColor: .clear) {
                             self.resetCollab()
                         }
                         .disabled(disableReset)
                         .opacity(disableReset ? 0.6 : 1.0)
                        
                        CSButton_tight(
                         title: creaMod,
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
        
        private func resetCollab() {

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
 
            self.newCollab()
        
        }
        
        private func emailCheckAlert() {
            
            let allCollabsMail = self.viewModel.profiloUtente.allMyCollabs?.map({$0.mail}) ?? []
            let alreadyIn = allCollabsMail.contains(self.collabItem.mail)
            
            if alreadyIn { self.localAlert = "⚠️ Esiste già un collaboratore con questa mail" }
            else { self.localAlert = nil  }
            
        }
        
        private func newCollab() {
            
            self.emailCheckAlert()
            
            guard self.localAlert == nil else { return }
            
            if var container = self.viewModel.profiloUtente.allMyCollabs {
                
                container.append(self.collabItem)
                self.viewModel.profiloUtente.allMyCollabs = container
                
            } else {
                self.viewModel.profiloUtente.allMyCollabs = [collabItem]
            }
            
            let uidAdmin = self.collabItem.db_uidRef
            let new = CollaboratorModel(uidAmministratore: uidAdmin)
            self.collabItem = new
            self.collabArchiviato = new
            
            self.presentationMode.wrappedValue.dismiss()
            print("newCollab Container \(self.viewModel.profiloUtente.allMyCollabs?.isEmpty)")
        }
        
        private func manageRestriction(restriction:RestrictionLevel) {
            
            if self.collabItem.restrictionLevel.contains(restriction) {
                self.collabItem.restrictionLevel.removeAll(where: {$0 == restriction})
            } else {
                self.collabItem.restrictionLevel.append(restriction)
            }
            
        }
    }
    
}*/  // deprecata 24.07.23
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
    static var user:UserRoleModel = UserRoleModel()
    @ObservedObject static var auth:AuthPasswordLess = AuthPasswordLess()
    
    static var previews: some View {
        NavigationStack {
            
         //   NavigationLink {
            AccounterMainView(authProcess: auth, backgroundColorView: Color.seaTurtle_1)
                   
         /*  } label: {
                Text("Test").foregroundColor(Color.red)
            } */
       
        }
        .environmentObject(AccounterVM(userAuth:user))
        .accentColor(Color.white)
            
    }
}
