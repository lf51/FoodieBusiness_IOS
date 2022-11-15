//
//  UserModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation

struct UserModel:Equatable {
    
   /* static func == (lhs:UserModel,rhs:UserModel) -> Bool {
        
        lhs.userEmail == rhs.userEmail &&
        lhs.userUID == rhs.userUID &&
        lhs.userProviderID == rhs.userProviderID &&
        lhs.userDisplayName == rhs.userDisplayName &&
        lhs.userEmailVerified == rhs.userEmailVerified &&
        lhs.viewModel == rhs.viewModel
        
    }*/
    
    
    let userEmail: String // la mail con cui si autentica
    let userUID: String
    let userProviderID: String
    var userDisplayName: String // lo sceglie l'utente
    let userEmailVerified: Bool // lo diamo Noi e in alcuni casi possiamo renderlo automatico o semiAutomatico
    
    // 12.11
  //  let viewModel:AccounterVM
    
    // let isUserIdentityVerified: Bool
}

struct CollaboratorModel:Identifiable {
    
    let id:String = UUID().uuidString
    
    var userEmail: String // la mail con cui si autentica
  //  let userUID: String
  //  let userProviderID: String
 //   var userDisplayName: String // lo sceglie l'utente
  //  let userEmailVerified: Bool // lo diamo Noi e in alcuni casi possiamo renderlo automatico o semiAutomatico
    
    var livelloAutorità: String // creare una enum
    
    init(userEmail: String,livelloAutorità: String) {
        self.userEmail = userEmail
        self.livelloAutorità = livelloAutorità
    }
    // let isUserIdentityVerified: Bool
}
