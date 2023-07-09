//
//  LinkSignInView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/01/22.
//

import SwiftUI
import MyPackView_L0
import Firebase

struct LinkSignInSheetView: View {
   
    @ObservedObject var authProcess: AuthPasswordLess
    let backgroundColorView = Color.seaTurtle_1
    
    var body: some View {
      
  //  NavigationView {
        
        ZStack {
            
            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
          //  backgroundColorView
            //  .edgesIgnoringSafeArea(.all)
          
          VStack(alignment: .center) {
              
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
                      .foregroundColor(.seaTurtle_4)
                      .onTapGesture {
                          withAnimation {
                              self.authProcess.openSignInView = false
                          }
                      }
                  
              }

              VStack {
                  
                  Spacer()
                  
                  Image(systemName: "fork.knife.circle")
                      .resizable()
                      .scaledToFit()
                      .foregroundColor(.seaTurtle_2)
                      .frame(maxWidth:500)
                      .padding(.vertical,60)
                  
                  Spacer()
                  
                  CSTextField_1(
                      text: $authProcess.email,
                      placeholder: "Email",
                      symbolName: "person.circle.fill",
                      keyboardType: .emailAddress
                  )

                  CSButton_large(
                    title: "Send Link",
                    accentColor: .white,
                    backgroundColor: .seaTurtle_2,
                    cornerRadius: 16.0,
                    action: {
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
              .frame(maxWidth:700)
              
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

struct LinkSignInSheetView_Previews: PreviewProvider {
     
  static var previews: some View {
      
      NavigationStack {
          LinkSignInSheetView(authProcess: AuthPasswordLess())
      }
    
  }
}
