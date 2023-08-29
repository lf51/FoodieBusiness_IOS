//
//  UserNameSettingView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/08/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct UserNameSettingView: View {
    
    @ObservedObject var authProcess:AuthenticationManager
    @State private var newDisplayName:String = ""
    
    var body: some View {
        
        CSZStackVB(
            title: "Imposta Nome Utente",
            titlePosition:.bodyEmbed([.horizontal], 10) ,
            backgroundColorView: .seaTurtle_1) {

                VStack {
                    
                    Spacer()
                    
                    Image(systemName: "fork.knife.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.seaTurtle_2)
                        .frame(maxWidth:500)
                        .padding(.vertical,60)
                    
                    Spacer()
                    
                    let placeHolder:String = {
                        let mail = AuthenticationManager.userAuthData.email
                        
                        let split = mail.split(separator: "@")
                        if let first = split.first {
                            return String(first)
                        } else {
                            return "userName"
                        }
                    }()
      
                    let disableButton:Bool = self.newDisplayName == ""
                    
                    let userNamePreview:String = self.authProcess.normalizzaUserNameString(newDisplayName: self.newDisplayName)
                    
                    VStack(alignment:.leading) {
                        CSTextField_1(
                            text: $newDisplayName,
                            placeholder: placeHolder,
                            symbolName: "at",
                            cornerRadius: 10,
                            keyboardType: .namePhonePad)
                        
                       
                            Text("preview: \(userNamePreview)")
                                .italic()
                                .font(.caption)
                                .foregroundStyle(Color.black)
                                .padding(.vertical,5)
                        
                        CSButton_large(
                            title: "Submit",
                            font: .title2,
                            accentColor: .seaTurtle_4,
                            backgroundColor: .seaTurtle_2,
                            cornerRadius: 10,
                            corners: .allCorners,
                            paddingValue: nil) {
                                // aggiorna nell'authentication
                                Task {
                                   try await submitAction()
                                }
                                // creare user nel firestore
                                
                            }
                            .opacity(disableButton ? 0.6 : 1.0)
                            .disabled(disableButton)
                            
                           // .padding(.bottom)

                        Text("• Può contenere caratteri alfanumerici;\n• Gli spazi vengono rimossi;\n• Le lettere maiuscole non sono riconosciute;\n• Una volta impostato non può essere modificato;\n• Identifica l'utente nell'organigramma della proprietà;\n• Non è visibile ai clienti, ma solo a eventuali collaboratori.")
                            .font(.subheadline)
                            .foregroundStyle(Color.black)
                            .lineSpacing(5.0)
                            .multilineTextAlignment(.leading)
                           // .frame(maxWidth:.infinity)
                            .padding(.vertical,5)
                           /* .background(
                                Color.gray.opacity(0.20)
                                    .cornerRadius(5.0)
                            )*/
                    }
                      //  .padding(.bottom)
                    Spacer()

                }
                
                
            }
        
       
    }
    
    // Method
    
    private func submitAction() async throws {
        // salva lo username nell'autentication
        print("OLD USERNAME:\(AuthenticationManager.userAuthData.userName)")
      try await self.authProcess.updateDisplayName(newDisplayName: self.newDisplayName)
        // salva l'utente su firestore
        let userAuthData = AuthenticationManager.userAuthData
        print("NEW USERNAME:\(AuthenticationManager.userAuthData.userName)")
        
        let userData = UserCloudData(
            id: userAuthData.id,
            email: userAuthData.email,
            userName: userAuthData.userName,
            isPremium: false)
        
      try await GlobalDataManager.user.publishUserCloudData(
        forUser: userAuthData.id,
        from: userData)
        
        print("DOPO AWAIT PUBLISH USER_SEND CHANGE AUTHCASE TO .auth")
        
        self.authProcess.authCase = .auth

    }
    
}
