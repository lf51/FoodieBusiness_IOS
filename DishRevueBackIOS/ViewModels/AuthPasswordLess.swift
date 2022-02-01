//
//  AuthPasswordLess.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import Foundation
import Firebase

class AuthPasswordLess: ObservableObject {
    
    static var isUserAuth:Bool = true // Impostare di default su FALSE. Viene aggiornato se l'utente fa l'Auth - Non è stato ancora agganciato
    
    @Published var email: String = ""
    @Published var alertItem: AlertModel?
    @Published var isPresentingSheet: Bool = true
    
    @Published var displayName: String = ""
    
    init() {
        print("Step_1 -> INIT")
        checkUserSignedIn()
    }
    
    func sendSignInLink() {
        
      let actionCodeSettings = ActionCodeSettings()
      actionCodeSettings.url = URL(string: "https://dishrevuebackios.page.link/backendauth") // dynamic link
      actionCodeSettings.handleCodeInApp = true
      actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
      actionCodeSettings.setAndroidPackageName("com.example.dishrevuebackandroid", installIfNotAvailable: false, minimumVersion: "12")

        Auth.auth().sendSignInLink(toEmail: self.email, actionCodeSettings: actionCodeSettings) { error in
        guard error == nil else {
            
            print("Errore nell'autenticazione: \(error!.localizedDescription)")
            
            self.alertItem = AlertModel(
            title: "The sign in link could not be sent.",
            message: error!.localizedDescription
          )
            return
        }
            self.alertItem = AlertModel(title: "Authentication Link Sent", message: "Check in your email inbox or spam")
            UserDefaults.standard.set(self.email, forKey: "Email")
            self.email = ""
            print("Link Succesfully sent")
          
      }
    }
    
    func passwordlessSignIn(link: String,
                                    completion: @escaping (Result<User?, Error>) -> Void) {
        
        if let email = UserDefaults.standard.string(forKey: "Email") {
            
            Auth.auth().signIn(withEmail: email, link: link) { result, error in
              
            if let error = error {
              print("ⓧ Authentication error: \(error.localizedDescription).")
              completion(.failure(error))
                // inserire alert
                
            } else {
              print("✔ Authentication was successful.")
              completion(.success(result?.user))
                self.isPresentingSheet = false
                self.displayName = result?.user.displayName ?? result?.user.email ?? ""
                self.alertItem = AlertModel(title: "Authentication", message: "User \(result?.user.email ?? "") successfully Authenticated")
            }
          }
            
        }
    }
    
    func checkUserSignedIn() {
                
        if let user = Auth.auth().currentUser {
            print("STEP_2 - User already Signed In")
            
            print("User email: \(user.email ?? "")")
            print("User UID: \(user.uid)")
            print("IsEmailVerified: \(user.isEmailVerified)")
            print("UserProviderID: \(user.providerID)")
            print("UserName: \(user.displayName ?? "")")
            self.isPresentingSheet = false
            self.displayName = user.displayName ?? user.email ?? ""
            self.alertItem = AlertModel(title: "Check Authentication", message: "User \(self.displayName) successfully Authenticated")
            
        }
        else {

            print("STEP_2 - NO USER IN") }
      
    }

    func deleteCurrentUser() {
        
        if let user = Auth.auth().currentUser {
            
            user.delete { error in
                
                guard error == nil else {
                    
                    print("DeleteStage - Error:\(error?.localizedDescription ?? "")")
                    self.alertItem = AlertModel(title: "Error", message: "\(error?.localizedDescription ?? "") - SigningOut CurrentUser. Sign-In again to delete")
                    self.signOutCurrentUser()
                    
                    return
                }
                
                self.alertItem = AlertModel(title: "Delete Account", message: "Account Deleted Successfully")
                print("DeleteStage - Account Deleted")
            }
        }
    }
    
    func signOutCurrentUser() {
        
        print("SignOutStage")
        
        let firebaseAuth = Auth.auth()
        
        do {
            
            try firebaseAuth.signOut()
            
            self.alertItem = AlertModel(title: "SignOut", message: "User Signed Out Successfully")
            print("SignOut Successfully")
            
        } catch let signOutError as NSError {
            
            self.alertItem = AlertModel(title: "SignOut", message: "Error signingOut")
            print("Error signingOut: %@", signOutError)
        }
        
    }

    func updateCurrentUserProfile() {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = self.displayName
       // changeRequest?.photoURL // da implementare
        
        changeRequest?.commitChanges(completion: { error in
            
            guard error == nil else {
                
                print("Error Updating User Profile")
                return
            }
            
            print("Update User Profile Successfully")
        })

    }




    
    
//Fine Classe
}

