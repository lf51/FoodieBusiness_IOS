//
//  LinkSignInView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/01/22.
//

import SwiftUI
import Firebase

struct LinkSignInSheetView: View {
   
    @ObservedObject var authProcess: AuthPasswordLess
    let backgroundColorView = Color("SeaTurtlePalette_1")
    
    var body: some View {
      
  //  NavigationView {
        
        ZStack {
            
            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
          //  backgroundColorView
            //  .edgesIgnoringSafeArea(.all)
          
          VStack(alignment: .leading) {
              
              HStack(alignment:.top) {
                  
                  VStack(alignment:.leading,spacing: -5) {
                      
                      Text("Foodies!") // foodies // foodist // foodz / foodish / weFoodies / Foodies! / WeeFoodies / foodie
                            .font(.system(.largeTitle, design: .rounded,weight: .bold))
                         // .font(.system(size: 120, weight: .bold, design: .rounded))
                            .foregroundColor(Color.black)
                      Text("for business")
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.yellow)
                  }
                  
                  Spacer()
                  
                  Text("Skip")
                      .font(.caption)
                      .foregroundColor(Color("SeaTurtlePalette_4"))
                      .onTapGesture {
                          withAnimation {
                              self.authProcess.openSignInView = false
                          }
                      }
                  
              }

              VStack {
                  
                  Image(systemName: "fork.knife.circle")
                      .resizable()
                      .scaledToFit()
                      .foregroundColor(Color("SeaTurtlePalette_2"))
                      .padding(.vertical,60)
                  
                  CSTextField_1(
                      text: $authProcess.email,
                      placeholder: "Email",
                      symbolName: "person.circle.fill",
                      keyboardType: .emailAddress
                  )

                  CSButton_large(title: "Send Link", accentColor: .white,backgroundColor: Color("SeaTurtlePalette_2"),cornerRadius: 16.0, action: {
                        authProcess.sendSignInLink()
                     
                    })
                        .disabled(authProcess.email.isEmpty)
            
                   Text("Accesso e Registrazione senza password. ")
                          .font(.caption)
                          .fontWeight(.light)
                  
                  Spacer()
                  
                  Image("LogoAppBACKEND")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 50, height: 50)
              }
   
              
          }
          .padding(.horizontal)
          .onOpenURL { url in
            
          let link = url.absoluteString
            print("url/link:\(link)")
            
          if Auth.auth().isSignIn(withEmailLink: link) {
              
              authProcess.passwordlessSignIn(link: link) { result in
                
              switch result {
                  
              case let .success(user):
                
                  authProcess.sendDispatchAlert(
                    openSignInView: false,
                    alertModel: AlertModel(
                        title: "Authentication Complete",
                        message: "Utente \(user?.displayName ?? "") Autenticato correttamente"))

              case let .failure(error):
                  
                  authProcess.sendDispatchAlert(
                    openSignInView: true,
                    alertModel: AlertModel(
                        title: "Authentication Failed",
                        message: error.localizedDescription))
                  
              }
            }
          }
        }
      }
      .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
      // Lo Sheet e l'Alert vanno in conflitto. Lo Sheet può essere una bella proposta come prima autenticazione per mostrare un carrello di slide e tips su come settare l'account o mostrare un primo settaggio in stile FantaBid
      //L'Alert mi piace per comunicare nei rientri che l'utente xxxx è autenticato. Però voglio che appaia per qualche secondo e si dissolva da solo. IN QUESTA FASE, comunque, sia lo SHEET che l'ALERT servivano a testare l'avvenuto signIN
  }
    
}

/*
struct LinkSignInSheetViewBACKUP: View {
   
    @ObservedObject var authProcess: AuthPasswordLess
    let backgroundColorView: ZStack = {
        
        ZStack {
          //  Color.cyan
            Color("SeaTurtlePalette_1")
            Color.white.opacity(0.4)
        }
  
    }()
    
  //  let backgroundColorView = Color("SeaTurtlePalette_1")
    
    var body: some View {
      
  //  NavigationView {
        
      ZStack {
          
          backgroundColorView
              .edgesIgnoringSafeArea(.all)
          
          VStack(alignment: .leading) {
              
              VStack(alignment:.leading) {
                  
                  Text("Foodies!") // foodies // foodist // foodz / foodish / weFoodies / Foodies! / WeeFoodies
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                  Text("for business")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.yellow)
              }

              VStack {
                  
                  Image(systemName: "fork.knife.circle")
                      .resizable()
                      .scaledToFit()
                      .foregroundColor(Color.cyan)
                      .padding(.vertical,60)
                  
                  CSTextField_1(
                      text: $authProcess.email,
                      placeholder: "Email",
                      symbolName: "person.circle.fill",
                      keyboardType: .emailAddress
                  )

                  CSButton_large(title: "Send Link", accentColor: .white,backgroundColor: .cyan,cornerRadius: 16.0, action: {
                        authProcess.sendSignInLink()
                     
                    })
                        .disabled(authProcess.email.isEmpty)
            
                   Text("Accesso e Registrazione senza password. ")
                          .font(.caption)
                          .fontWeight(.light)
                  
                  Spacer()
                  
                  Image("LogoAppBACKEND")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 50, height: 50)
              }
              
         //   Spacer()
              
              
             
              
          }
          .padding()
         // .navigationBarTitle("Passwordless Login")
      // }
        .onOpenURL { url in
            
          let link = url.absoluteString
            print("url/link:\(link)")
            
          if Auth.auth().isSignIn(withEmailLink: link) {
              
              authProcess.passwordlessSignIn(link: link) { result in
                
              switch result {
                  
              case let .success(user):
                  
                  authProcess.sendDispatchAlert(
                    openSignInView: false,
                    alertModel: AlertModel(
                        title: "Authentication Complete",
                        message: "Utente \(user?.displayName ?? "") Autenticato correttamente"))

              case let .failure(error):
                  
                  authProcess.sendDispatchAlert(
                    openSignInView: true,
                    alertModel: AlertModel(
                        title: "Authentication Failed",
                        message: error.localizedDescription))
                  
              }
            }
          }
        }
      }
      .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
      /*.alert(item: $authProcess.alertItem) { alert -> Alert in
         csSendAlert(alertModel: alert)
         }*/ // serve a gestire le info di autenticazione Iniziali
   /* .sheet(isPresented: $authProcess.openSignInView) {
        SuccessView(authProcess: authProcess)
    } */
   
      // Lo Sheet e l'Alert vanno in conflitto. Lo Sheet può essere una bella proposta come prima autenticazione per mostrare un carrello di slide e tips su come settare l'account o mostrare un primo settaggio in stile FantaBid
      //L'Alert mi piace per comunicare nei rientri che l'utente xxxx è autenticato. Però voglio che appaia per qualche secondo e si dissolva da solo. IN QUESTA FASE, comunque, sia lo SHEET che l'ALERT servivano a testare l'avvenuto signIN
  }
    
}*/ // backup 12.11


 struct LinkSignInSheetView_Previews: PreviewProvider {
     
  static var previews: some View {
      
      NavigationStack {
          LinkSignInSheetView(authProcess: AuthPasswordLess())
      }
    
  }
}
