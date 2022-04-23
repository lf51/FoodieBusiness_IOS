//
//  LinkSignInView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/01/22.
//

import SwiftUI
import Firebase

/// Main view where user can login in using Email Link Authentication.
struct LinkSignInSheetView: View {
   
    @ObservedObject var authProcess: AuthPasswordLess

  var body: some View {
      
  //  NavigationView {
        
      VStack(alignment: .leading) {
          
        Text("PasswordLess Authentication")
            .font(.largeTitle)
            .fontWeight(.semibold)
          
        Text("Authenticate users with only their email, no password required!")
          .padding(.bottom, 60)

        CSTextField_1(
            text: $authProcess.email, placeholder: "Email", symbolName: "person.circle.fill"
        )

          CSButton_large(title: "Send Link", accentColor: .white,backgroundColor: .cyan,cornerRadius: 16.0, action: {
              authProcess.sendSignInLink()
           
          })
              .disabled(authProcess.email.isEmpty)

        Spacer()
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
              authProcess.isPresentingSheet = user?.isEmailVerified ?? false
          case let .failure(error):
              authProcess.isPresentingSheet = false
              
            authProcess.alertItem = AlertModel(
              title: "An authentication error occurred.",
              message: error.localizedDescription
            )
          }
        }
      }
    }
   /* .sheet(isPresented: $authProcess.isPresentingSheet) {
        SuccessView(authProcess: authProcess)
    } */
   /* .alert(item: $authProcess.alertItem) { alert -> Alert in
      Alert(
        title: Text(alert.title),
        message: Text(alert.message)
      )
    } */
      // Lo Sheet e l'Alert vanno in conflitto. Lo Sheet può essere una bella proposta come prima autenticazione per mostrare un carrello di slide e tips su come settare l'account o mostrare un primo settaggio in stile FantaBid
      //L'Alert mi piace per comunicare nei rientri che l'utente xxxx è autenticato. Però voglio che appaia per qualche secondo e si dissolva da solo. IN QUESTA FASE, comunque, sia lo SHEET che l'ALERT servivano a testare l'avvenuto signIN
  }
    
}

/// A custom styled TextField with an SF symbol icon.


/// A custom styled button with a custom title and action.


/// Displayed when a user successfuly logs in.


/* struct SuccessView: View {
   
    @ObservedObject var authProcess: AuthPasswordLess

  var body: some View {
    /// The first view in this `ZStack` is a `Color` view that expands
    /// to set the background color of the `SucessView`.
    ZStack {
      Color.orange
        .edgesIgnoringSafeArea(.all)

      VStack(alignment: .leading) {
        Group {
          Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.semibold)

            Text(authProcess.displayName.lowercased())
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)

        }
        .padding(.leading)

        Image(systemName: "checkmark.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(0.5)
          
          Spacer()
          
          VStack{
              
              CSTextField_2(text: $authProcess.displayName, placeholder: "Custom Display Name", symbolName: "person.circle.fill",accentColor: .orange, backGroundColor: .clear,autoCap: .none,cornerRadius: 16.0)
              
              CSButton_large(title: "Change Name",accentColor:.white, backgroundColor: .orange, cornerRadius: 16.0) {
                  authProcess.updateCurrentUserProfile()
              }
          }
          
          
          Spacer()
          
          HStack {
              
              Button {
                  authProcess.deleteCurrentUser()
              } label: {
                  Text("Delete Account").foregroundColor(.red)
              }
              
             Spacer()
              
              Button {
                  authProcess.signOutCurrentUser()
              } label: {
                  Text("SIGN OUT").foregroundColor(.blue)
              }
              
          }.padding()
            
          
      }
      .foregroundColor(.white)
    }
  }
} */



/* struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
} */
