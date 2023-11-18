//
//  CSError.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/09/23.
//

import Foundation

enum CSError:Error,LocalizedError {
    
    case propertyAlreadyRegistered
    case propertyDataCorrotti
    case fastImportDishWithNoIng
    
    var errorDescription: String? {
        
        switch self {
            
        case .propertyAlreadyRegistered:
        return NSLocalizedString("Per reclami e/o errori contattare info@foodies.com.", comment: "Proprietà già registrata")
            
        case .propertyDataCorrotti:
        return NSLocalizedString("Provare a riavviare.\nPer reclami e/o errori contattare info@foodies.com.", comment: "Collegamento ai dati corrotto")
            
        case .fastImportDishWithNoIng:
            
            return NSLocalizedString("Editing Error: Ciascun piatto deve contenere almeno un ingrediente", comment: "Creazione in blocco interrotta")
        }
        
        
    }
    
}
