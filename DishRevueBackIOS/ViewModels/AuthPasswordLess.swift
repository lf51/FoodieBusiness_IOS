//
//  AuthPasswordLess.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import Foundation
import Firebase

class AuthPasswordLess: ObservableObject {
    
  //  static var isUserAuth:Bool = false // Impostare di default su FALSE. Viene aggiornato se l'utente fa l'Auth - Non è stato ancora agganciato
    @Published var userInfo: UserModel?
    
    @Published var email: String = ""
    @Published var alertItem: AlertModel?
    @Published var isPresentingSheet: Bool = true

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
            
            print("ⓧ Authentication error: \(error!.localizedDescription)")
            
            self.alertItem = AlertModel(
            title: "Authentication Link non inviato. Riprova.",  //"The sign in link could not be sent."
            message: error!.localizedDescription
          )
            return
        }
            self.alertItem = AlertModel(title: "Authentication Link inviato a \(self.email).", message: "Controlla dallo stesso device la tua posta in arrivo (o la cartella spam) e clicca sul link.")
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
              //  self.isPresentingSheet = true
                
            } else {
              print("✔ Authentication was successful.")
              completion(.success(result?.user))

                self.userInfo = UserModel(
                    userEmail: result?.user.email ?? "",
                    userUID: result?.user.uid ?? "",
                    userProviderID: result?.user.providerID ?? "",
                    userDisplayName: result?.user.displayName ?? result?.user.email ?? "",
                    userEmailVerified: result?.user.isEmailVerified ?? false)
                
              //  self.isPresentingSheet = false
                //self.displayName = result?.user.displayName ?? result?.user.email ?? ""
               
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
            
            self.userInfo = UserModel(
                userEmail: user.email ?? "",
                userUID: user.uid,
                userProviderID: user.providerID,
                userDisplayName: user.displayName ?? user.email ?? "",
                userEmailVerified: user.isEmailVerified)
        
        //    self.displayName = user.displayName ?? user.email ?? ""
            self.alertItem = AlertModel(
                title: "Authentication",
                message: "Utente \(self.userInfo?.userDisplayName ?? "") autenticato.")
            
        }
        
        else {
           // self.isPresentingSheet = true // è true di default
            print("STEP_2 - NO USER IN") }
      
    }

    func deleteCurrentUser() {
        
        if let user = Auth.auth().currentUser {
            
            user.delete { error in
                
                guard error == nil else {
                    
                    print("DeleteStage - Error:\(error?.localizedDescription ?? "")")
                    self.alertItem = AlertModel(
                        title: "Blocco di Sicurezza",
                        message: "\(error?.localizedDescription ?? "") -\nDisconnessione utente corrente. Riconnetersi nuovamente e procedere all'eliminazione.")
                    self.signOutCurrentUser()
                    
                    return
                }
                
                self.alertItem = AlertModel(
                    title: "Dispiace Salutarti :-(",
                    message: "Il tuo Account è stato correttamente eliminato.")
                print("DeleteStage - Account Deleted")
            }
        }
    }
    
    func signOutCurrentUser() {
        
        print("SignOutStage")
        
        let firebaseAuth = Auth.auth()
        
        do {
            
            try firebaseAuth.signOut()
            
            sendAlert(
                openSignInView: true,
                alertModel: AlertModel(
                    title: "Disconessione",
                    message: "Utente disconnesso con successo."))
            
            self.isPresentingSheet = true
            self.alertItem = AlertModel(
                title: "Disconessione",
                message: "Utente disconnesso con successo.")
            
            
            print("SignOut Successfully")
            
        } catch let signOutError as NSError {
            
            self.alertItem = AlertModel(
                title: "Errore",
                message: "\(signOutError.localizedDescription)")
            print("Error signingOut: %@", signOutError)
        }
        
    }

    func updateCurrentUserProfile() {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = self.userInfo?.userDisplayName
    //    changeRequest?.displayName = self.displayName
       // changeRequest?.photoURL // da implementare
        
        changeRequest?.commitChanges(completion: { error in
            
            guard error == nil else {
                
                print("Error Updating User Profile")
                self.alertItem = AlertModel(
                    title: "Errore",
                    message: "\(error?.localizedDescription ?? "")")
                return
            }
            
            self.alertItem = AlertModel(
                title: "Bene!",
                message: "Profile aggiornato correttamente.")
            
            print("Update User Profile Successfully")
        })

    }
  
    func updateDisplayName(newDisplayName: String) {
        
        // Inserire in futuro controllo di unicità
        
        guard newDisplayName != "" else {
            
            self.userInfo?.userDisplayName = self.userInfo?.userEmail ?? ""
            // non facciamo update sul server, poichè nel signIn sa che quando il displayName è vuoto deve visualizzare la mail
            return }
        let newUserName = "@" + newDisplayName.replacingOccurrences(of: " ", with: "").lowercased()
        
        self.userInfo?.userDisplayName = newUserName
        
        self.updateCurrentUserProfile()
        
    }
    
    /// Open/Close SignInView e send alert with Dispatch(0.5'')
    func sendAlert(openSignInView: Bool, alertModel: AlertModel) {
        
        self.isPresentingSheet = openSignInView
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.alertItem = alertModel
        }
    }
//Fine Classe
}

struct UserModel {
    
    let userEmail: String
    let userUID: String
    let userProviderID: String
    var userDisplayName: String
    let userEmailVerified: Bool
    
    
    // let isUserVerified: Bool
     
}
