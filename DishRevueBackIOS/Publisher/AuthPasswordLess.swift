//
//  AuthPasswordLess.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import Foundation
import Firebase

class AuthPasswordLess: ObservableObject {
    
   // @Published var email: String = "" --> spostare qui la state var in LinkSignInView
    @Published var alertItem: AlertObject?
    
    func sendSignInLink(email:String) {
        
      let actionCodeSettings = ActionCodeSettings()
    //  actionCodeSettings.url = URL(string: "https://dishrevueproject.firebaseapp.com") //deep link del dynamic link di sotto
      actionCodeSettings.url = URL(string: "https://dishrevuebackios.page.link/backendauth") // dynamic link
      actionCodeSettings.handleCodeInApp = true
      actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
      actionCodeSettings.setAndroidPackageName("com.example.dishrevuebackandroid", installIfNotAvailable: false, minimumVersion: "12")

      Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
        guard error == nil else {
            
            print("Errore nell'autenticazione: \(error!.localizedDescription)")
            
            self.alertItem = AlertObject(
            title: "The sign in link could not be sent.",
            message: error!.localizedDescription
          )
            return
        }
          
          print("Link Succesfully sent")
          
          // salvare email nello userDefault per futuri accessi -- DA CAPIRE!!
          
      }
    }
    
    func passwordlessSignIn(email: String, link: String,
                                    completion: @escaping (Result<User?, Error>) -> Void) {
        
      Auth.auth().signIn(withEmail: email, link: link) { result, error in
        if let error = error {
          print("ⓧ Authentication error: \(error.localizedDescription).")
          completion(.failure(error))
        } else {
          print("✔ Authentication was successful.")
          completion(.success(result?.user))
        }
      }
    }

}

