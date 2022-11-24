//
//  UserModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation

struct UserModel:Equatable {

    let userEmail: String // la mail con cui si autentica
    let userUID: String
    let userProviderID: String
    var userDisplayName: String // lo sceglie l'utente
    let userEmailVerified: Bool // 

}
