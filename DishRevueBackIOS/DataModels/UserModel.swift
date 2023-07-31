//
//  UserModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation

public struct UserModel:Equatable,Hashable {

    public let userEmail: String // la mail con cui si autentica
    public let userUID: String
    public let userProviderID: String
    public var userDisplayName: String // lo sceglie l'utente
    public let userEmailVerified: Bool //
    
    public init(userEmail: String, userUID: String, userProviderID: String, userDisplayName: String, userEmailVerified: Bool) {
        self.userEmail = userEmail
        self.userUID = userUID
        self.userProviderID = userProviderID
        self.userDisplayName = userDisplayName
        self.userEmailVerified = userEmailVerified
    }

}
