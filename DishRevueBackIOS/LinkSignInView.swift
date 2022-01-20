//
//  LinkSignInView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/01/22.
//

import SwiftUI
import Firebase

/// Main view where user can login in using Email Link Authentication.
struct LinkSignInView: View {
    
  @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
  @State private var email: String = ""
  @State private var isPresentingSheet = false

  /// This property will cause an alert view to display when it has a non-null value.
//  @State private var alertItem: AlertItem? = nil

  var body: some View {
      
    NavigationView {
        
      VStack(alignment: .leading) {
          
        Text("Authenticate users with only their email, no password required!")
          .padding(.bottom, 60)

        CustomStyledTextField(
          text: $email, placeholder: "Email", symbolName: "person.circle.fill"
        )

          CustomStyledButton(title: "Send Link", action: {
              authProcess.sendSignInLink(email: email)
          })
          .disabled(email.isEmpty)

        Spacer()
      }
      .padding()
      .navigationBarTitle("Passwordless Login")
    }
    .onOpenURL { url in
        
      let link = url.absoluteString
        
      if Auth.auth().isSignIn(withEmailLink: link) {
          
          authProcess.passwordlessSignIn(email: email, link: link) { result in
            
          switch result {
          case let .success(user):
            isPresentingSheet = user?.isEmailVerified ?? false
          case let .failure(error):
            isPresentingSheet = false
            authProcess.alertItem = AlertObject(
              title: "An authentication error occurred.",
              message: error.localizedDescription
            )
          }
        }
      }
    }
    .sheet(isPresented: $isPresentingSheet) {
      SuccessView(email: email)
    }
    .alert(item: $authProcess.alertItem) { alert -> Alert in
      Alert(
        title: Text(alert.title),
        message: Text(alert.message)
      )
    }
  }
    
}

/// A custom styled TextField with an SF symbol icon.
struct CustomStyledTextField: View {
  @Binding var text: String
  let placeholder: String
  let symbolName: String

  var body: some View {
    HStack {
      Image(systemName: symbolName)
        .imageScale(.large)
        .padding(.leading)

      TextField(placeholder, text: $text)
        .padding(.vertical)
        .accentColor(.orange)
        .autocapitalization(.none)
    }
    .background(
      RoundedRectangle(cornerRadius: 16.0, style: .circular)
        .foregroundColor(Color(.secondarySystemFill))
    )
  }
}

/// A custom styled button with a custom title and action.
struct CustomStyledButton: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      /// Embed in an HStack to display a wide button with centered text.
      HStack {
        Spacer()
        Text(title)
          .padding()
          .accentColor(.white)
        Spacer()
      }
    }
    .background(Color.orange)
    .cornerRadius(16.0)
  }
}

/// Displayed when a user successfuly logs in.
struct SuccessView: View {
  let email: String

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

          Text(email.lowercased())
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
        }
        .padding(.leading)

        Image(systemName: "checkmark.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(0.5)
      }
      .foregroundColor(.white)
    }
  }
}

/* struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
} */
