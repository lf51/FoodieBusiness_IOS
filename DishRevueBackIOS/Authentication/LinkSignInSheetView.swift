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
   
    @ObservedObject var authProcess: AuthenticationManager
    @State private var email:String = ""
    let backgroundColorView = Color.seaTurtle_1
    
    var body: some View {

        ZStack {
            
            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
  
          VStack(alignment: .center) {
              
              HStack(alignment:.top) {
                  
                  VStack(alignment:.leading,spacing: -5) {
                      
                      Text("Foodies!") // foodies // foodist // foodz / foodish / weFoodies / Foodies! / WeeFoodies / foodie
                            .font(.system(.largeTitle, design: .rounded,weight: .bold))
                            .foregroundStyle(Color.black)
                      Text("for business")
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.yellow)
                  }
                  
                  Spacer()
 
              }

              VStack {
                  
                  Spacer()
                  
                  Image(systemName: "fork.knife.circle")
                      .resizable()
                      .scaledToFit()
                      .foregroundStyle(Color.seaTurtle_2)
                      .frame(maxWidth:500)
                      .padding(.vertical,60)
                  
                  Spacer()
                  
                  CSTextField_1(
                      text: $email,
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
                        self.authProcess.sendSignInLink(to:email)
                        self.email = ""
                     
                    })
                  .disabled(email.isEmpty)
            
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
              
              self.authProcess.passwordlessSignIn(link: link) { result in
                
              switch result {
                  
              case let .success(user):

                  self.authProcess.sendDispatchAlert(
                    alertModel: AlertModel(
                        title: "Authentication Complete",
                        message: "Utente \(user?.displayName ?? "") Autenticato correttamente"))

              case let .failure(error):
                  
                  self.authProcess.sendDispatchAlert(
                    alertModel: AlertModel(
                        title: "Authentication Failed",
                        message: error.localizedDescription))
                  
              }
            }
          }
        }
      }
        .csAlertModifier(isPresented: $authProcess.showAlert, item: self.authProcess.alertItem)

  }
    
}

struct LinkSignInSheetView_Previews: PreviewProvider {
     
  static var previews: some View {
      
      NavigationStack {
          LinkSignInSheetView(authProcess: AuthenticationManager())
      }
    
  }
}
