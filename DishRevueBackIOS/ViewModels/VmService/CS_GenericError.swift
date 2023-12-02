//
//  CSError.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/09/23.
//

import Foundation

enum CS_FirebaseError:Error,LocalizedError {
    
    case invalidPropertySnap
    
    
    var errorDescription: String? {
        
        switch self {
        case .invalidPropertySnap:
            return NSLocalizedString("[ERRORE]_Il riferimento della proprietà sul database è corrotto", comment: "Riferimento Propietà mancante")
        }
        
    }
    
}


enum CS_GenericError:Error,LocalizedError {
    
    case propertyAlreadyRegistered
    case propertyDataCorrotti
    case fastImportDishWithNoIng
    case invalidPreparazioneStructure
    
    var errorDescription: String? {
        
        switch self {
            
        case .propertyAlreadyRegistered:
            return NSLocalizedString("Per reclami e/o errori contattare info@foodies.com.", comment: "Proprietà già registrata")
            
        case .propertyDataCorrotti:
            return NSLocalizedString("Provare a riavviare.\nPer reclami e/o errori contattare info@foodies.com.", comment: "Collegamento ai dati corrotto")
            
        case .fastImportDishWithNoIng:
            return NSLocalizedString("[Error]_Ciascuna preparazione deve contenere almeno un ingrediente", comment: "Creazione in blocco interrotta")
            
        case .invalidPreparazioneStructure:
            return NSLocalizedString("[Error]_La preparazione deve contenere almeno un ingrediente principale", comment: "Array Ingredienti principali vuoto")
        }
        
        
    }
    
}
