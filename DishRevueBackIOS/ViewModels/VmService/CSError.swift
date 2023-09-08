//
//  CSError.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/09/23.
//

import Foundation

enum CSError:Error,LocalizedError {
    
    case propertyAlreadyRegistered
    
    var errorDescription: String? {
        
        switch self {
            
        case .propertyAlreadyRegistered:
        return NSLocalizedString("Per reclami e/o errori contattare info@foodies.com.", comment: "Proprietà già registrata")
            
        }
        
        
    }
    
}
