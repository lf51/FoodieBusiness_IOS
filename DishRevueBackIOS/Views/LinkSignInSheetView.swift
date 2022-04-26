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
    let backgroundColorView: ZStack = {
        
        ZStack {
            Color.cyan
            Color.white.opacity(0.4)
        }
  
    }()

    var body: some View {
      
  //  NavigationView {
        
      ZStack {
          
          backgroundColorView
              .edgesIgnoringSafeArea(.all)
          
          VStack(alignment: .leading) {
              
              VStack(alignment:.leading) {
                  
                  Text("Welcome on Foodz!") // foodies // foodist
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
                  
                  authProcess.sendAlert(
                    openSignInView: false,
                    alertModel: AlertModel(
                        title: "Authentication Done",
                        message: "Utente \(user?.displayName ?? "") Autenticato correttamente"))

              case let .failure(error):
                  
                  authProcess.sendAlert(
                    openSignInView: true,
                    alertModel: AlertModel(
                        title: "Authentication Failed",
                        message: error.localizedDescription))
                  
              }
            }
          }
        }
      }
     /* .alert(item: $authProcess.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         }  */
   /* .sheet(isPresented: $authProcess.isPresentingSheet) {
        SuccessView(authProcess: authProcess)
    } */
   
      // Lo Sheet e l'Alert vanno in conflitto. Lo Sheet può essere una bella proposta come prima autenticazione per mostrare un carrello di slide e tips su come settare l'account o mostrare un primo settaggio in stile FantaBid
      //L'Alert mi piace per comunicare nei rientri che l'utente xxxx è autenticato. Però voglio che appaia per qualche secondo e si dissolva da solo. IN QUESTA FASE, comunque, sia lo SHEET che l'ALERT servivano a testare l'avvenuto signIN
  }
    
}


 struct LinkSignInSheetView_Previews: PreviewProvider {
     
  static var previews: some View {
      
          LinkSignInSheetView(authProcess: AuthPasswordLess())
    
  }
}
