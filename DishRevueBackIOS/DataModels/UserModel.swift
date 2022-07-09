//
//  UserModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation

struct UserModel:Equatable {
    
    
    let userEmail: String
    let userUID: String
    let userProviderID: String
    var userDisplayName: String
    let userEmailVerified: Bool
    
    // let isUserIdentityVerified: Bool
}
