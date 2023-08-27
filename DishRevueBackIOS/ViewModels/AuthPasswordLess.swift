//
//  AuthPasswordLess.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import Foundation
import MyPackView_L0
import Firebase
import MyFoodiePackage

public class AuthPasswordLess: ObservableObject, Hashable {
    
    public static var userAuthData:(id:String,userName:String,mail:String,isPremium:Bool) = ("","","",false)
    
   public static func == (lhs: AuthPasswordLess, rhs: AuthPasswordLess) -> Bool {
       // lhs.currentUser == rhs.currentUser
       lhs.utenteCorrente == rhs.utenteCorrente
    }
    
    public func hash(into hasher: inout Hasher) {
      //  hasher.combine(currentUser?.userUID)
        hasher.combine(utenteCorrente?.id)
    }

   // @Published var currentUser: UserModel? // deprecato
    
    @Published var utenteCorrente: UserRoleModel? // deprecato
    @Published var email: String = ""
    
    @Published var showAlert: Bool = false 
    @Published var alertItem: AlertModel? {didSet {showAlert = true}}
    
    @Published var openSignInView: Bool = true // possibile deprecazione da sostituire con il valore nil o non nil dell'utente corrente

    @Published var isLoading:Bool = true // da settare
    
    @Published var authCase:AuthCase?
    
    init() {
        print("Init -> AuthPassWordLess")
        checkUserSignedIn()
     //   self.openSignInView = false // -> Ripistinare in futuro il checkUserSignedIn() / l'impostazione su false qui ci serve a bypassare l'auth nel simulatore
    }
    
     enum AuthCase {
        case noAuth
        case auth_noUserName
        case auth
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
            self.alertItem = AlertModel(title: "Authentication Link inviato a \(self.email)", message: "Nessuna password necessaria.\nApri da questo device la mail (se non la trovi cercala nello spam) e clicca sul link per autenticarti.")
            UserDefaults.standard.set(self.email, forKey: "email")
            self.email = ""
            print("Link Succesfully sent")
          
      }
    }
    
    func passwordlessSignIn(link: String,
                                    completion: @escaping (Result<User?, Error>) -> Void) {
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            
            Auth.auth().signIn(withEmail: email, link: link) { result, error in
              
            if let error = error {
              print("ⓧ Authentication error: \(error.localizedDescription).")
                self.authCase = .noAuth
              completion(.failure(error))
              //  self.openSignInView = true
                
            } else {
              print("✔ Authentication was successful.")
                
                if let userName = result?.user.displayName {
                    
                    Self.userAuthData.id = result?.user.uid ?? "ERROR_NOUID"
                    Self.userAuthData.userName = userName
                    Self.userAuthData.mail = result?.user.email ?? "ERROR_NOEMAIL"
                    
                    self.authCase = .auth
                    self.utenteCorrente = UserRoleModel(
                        uid: result?.user.uid ?? "ERROR_NOUID",
                        userName: userName,
                        mail: result?.user.email ?? "ERROR_NOEMAIL") // deprecato
                } else {
                    self.authCase = .auth_noUserName
                }

              completion(.success(result?.user))

               /* self.currentUser = UserModel(
                    userEmail: result?.user.email ?? "",
                    userUID: result?.user.uid ?? "",
                    userProviderID: result?.user.providerID ?? "",
                    userDisplayName: result?.user.displayName ?? result?.user.email ?? "",
                    userEmailVerified: result?.user.isEmailVerified ?? false) */
                
                
            
            }
          }
            
        }
    }
    
    func checkUserSignedIn() {
                
        guard let user = Auth.auth().currentUser else {
            self.authCase = .noAuth
           // self.openSignInView = true // è true di default
            print("AUTH - NO USER Authenticated")
            return
        }

        if let username = user.displayName {
            
            Self.userAuthData.id = user.uid
            Self.userAuthData.userName = username
            Self.userAuthData.mail = user.email ?? "ERROR_NOEMAIL"
            
            self.authCase = .auth
            
            self.utenteCorrente = UserRoleModel(
                uid: user.uid,
                userName: username,
                mail: user.email ?? "ERROR_NOEMAIL") // deprecato
            
        } else {
            
            // prima autentica o utente ha chiuso l'app dopo il primo sign In e lo userName non è stato settato
            self.authCase = .auth_noUserName
            
        }
        
        
       /* if let user = Auth.auth().currentUser {
          /*  print("STEP_2 - User already Signed In")
            
            print("User email: \(user.email ?? "")")
            print("User UID: \(user.uid)")
            print("IsEmailVerified: \(user.isEmailVerified)")
            print("UserProviderID: \(user.providerID)")
            print("UserName: \(user.displayName ?? "")") */
            self.openSignInView = false
            
            self.utenteCorrente = UserRoleModel(
                uid: user.uid,
                userName: user.displayName ?? "",
                mail: user.email ?? "ERROR_NOEMAIL")
            
           /* self.currentUser = UserModel(
                userEmail: user.email ?? "",
                userUID: user.uid,
                userProviderID: user.providerID,
                userDisplayName: user.displayName ?? user.email ?? "",
                userEmailVerified: user.isEmailVerified) */

          /*  self.alertItem = AlertModel(
                title: "Authentication",
                message: "Utente \(self.userInfo?.userDisplayName ?? "") autenticato.") */
            print("CheckUserSignedIn true")
        }
        
        else {
            self.authCase = .noAuth
           // self.openSignInView = true // è true di default
            print("STEP_2 - NO USER IN") } */
      
    }

    func logOutUser() {
        
        self.alertItem = AlertModel(
            title: "Logout",
            message: "Desideri uscire dall'Applicazione?",
            actionPlus: ActionModel(
                title: .conferma,
                action: {
                    self.signOutCurrentUser()
                }))
    }
    
    func eliminaAccount() {
        
        self.alertItem = AlertModel(
            title: "Eliminazione Account",
            message: "L'eliminazione dell'account è irreversibile e comporta la perdita di ogni dato.",
            actionPlus: ActionModel(
                title: .elimina,
                action: {
                    self.deleteCurrentUser()
                }))
        
    }
    
    func updateDisplayName(newDisplayName: String) {
       
        // il submit disable evita di passare userName vuoti == ""
       
        let newUserName = normalizzaUserNameString(newDisplayName: newDisplayName)
        
       // self.utenteCorrente?.userName = newUserName
        
        self.updateCurrentUserProfile(username: newUserName)
        
    }
    
    func normalizzaUserNameString(newDisplayName: String) -> String {
        
       "@" + newDisplayName.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    /*
    func updateDisplayName(newDisplayName: String) {
        
        // Inserire in futuro controllo di unicità
        
        guard newDisplayName != "" else {
            
          //  self.currentUser?.userDisplayName = self.currentUser?.userEmail ?? ""
            self.utenteCorrente?.userName = self.utenteCorrente?.mail ?? "@error"
            // non facciamo update sul server, poichè nel signIn sa che quando il displayName è vuoto deve visualizzare la mail
            return }
        let newUserName = "@" + newDisplayName.replacingOccurrences(of: " ", with: "").lowercased()
        
       // self.currentUser?.userDisplayName = newUserName
        self.utenteCorrente?.userName = newUserName
        
        self.updateCurrentUserProfile()
        
    }*/ // 20.08.23 Deporecata
    
   private func deleteCurrentUser() {
        
        if let user = Auth.auth().currentUser {
            
            user.delete { error in
                
                guard error == nil else {
                    
                    print("DeleteStage - Error:\(error?.localizedDescription ?? "")")
                    self.alertItem = AlertModel(
                        title: "Autenticazione Necessaria",
                        message: "\(error?.localizedDescription ?? "")",
                        actionPlus: ActionModel(
                            title: .continua,
                            action: {
                                self.signOutCurrentUser()
                            })

                    )
                    
                    return
                }
                
                self.sendDispatchAlert(openSignInView: true, alertModel: AlertModel(
                    title: "Dispiace Salutarti :-(",
                    message: "Il tuo Account è stato correttamente eliminato."))

                print("DeleteStage - Account Deleted")
            }
        }
    }
    
   private func signOutCurrentUser() {
        
        print("SignOutStage")
        
        let firebaseAuth = Auth.auth()
        
        do {
            
            try firebaseAuth.signOut()
            self.openSignInView = true
          //  self.currentUser = nil
            self.utenteCorrente = nil
    
            print("Sign-Out Successfully")
            
        } catch let signOutError as NSError {
            
            self.alertItem = AlertModel(
                title: "Errore Log-Out",
                message: "\(signOutError.localizedDescription)")
            print("Error signingOut: %@", signOutError)
        }
        
    }

    private func updateCurrentUserProfile(username:String) {
        
        let currentUser = Auth.auth().currentUser
        
        let changeRequest = currentUser?.createProfileChangeRequest()
        
       // changeRequest?.displayName = self.currentUser?.userDisplayName
       //changeRequest?.displayName = self.utenteCorrente?.userName
        changeRequest?.displayName = username
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
            
            Self.userAuthData.id = currentUser?.uid ?? "Error_NOUID"
            Self.userAuthData.userName = username
            Self.userAuthData.mail = currentUser?.email ?? "ERROR_NOEMAIL"
            
            self.utenteCorrente = UserRoleModel(
                uid: currentUser?.uid ?? "Error_NOUID",
                userName: username,
                mail: currentUser?.email ?? "ERROR_NOEMAIL") // deprecato
          
            self.authCase = .auth
            
            self.alertItem = AlertModel(
                title: "Success",
                message: "Profilo registrato correttamente.")
            
            print("Update User Profile Successfully")
        })

    }
    
    /// Open/Close SignInView e send alert with Dispatch(0.5'')
    func sendDispatchAlert(openSignInView: Bool, alertModel: AlertModel) {
        
        self.openSignInView = openSignInView
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.alertItem = alertModel
        }
    }
//Fine Classe
}

