//
//  CSError.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/09/23.
//

import Foundation

enum CS_FirebaseError:Error,LocalizedError {
    
    case invalidPropertySnap
    case queryCountZero
    case getDocsFail
    
    
    var errorDescription: String? {
        
        switch self {
        case .invalidPropertySnap:
            return NSLocalizedString("[ERRORE]_Il riferimento della proprietà sul database è corrotto", comment: "Riferimento Propietà mancante")
        case .queryCountZero:
            return NSLocalizedString("La Query non ha prodotto alcun risultato", comment: "Query Count Zero")
        case .getDocsFail:
            return NSLocalizedString("Impossibile accedere ai dati del documento. Controllare la connessione e riprovare", comment: "getDocument() Fail")
        }
        
    }
    
}

enum CS_GenericError:Error,LocalizedError {
    
    case propertyAlreadyRegistered
    case propertyDataCorrotti
    case fastImportDishWithNoIng
    case modelNameAlreadyIn(_:String)
    case invalidPreparazioneStructure
    
   
    
    var errorDescription: String? {
        
        switch self {
            
        case .propertyAlreadyRegistered:
            return NSLocalizedString("Per reclami e/o errori contattare info@foodies.com.", comment: "Proprietà già registrata")
            
        case .propertyDataCorrotti:
            return NSLocalizedString("Provare a riavviare.\nPer reclami e/o errori contattare info@foodies.com.", comment: "Collegamento ai dati corrotto")
            
        case .fastImportDishWithNoIng:
            return NSLocalizedString("[Error]_Ciascuna preparazione deve contenere almeno un ingrediente", comment: "Creazione in blocco interrotta")
            
        case .modelNameAlreadyIn(let name):
            return NSLocalizedString("[Error]_Esiste già una preparazione intitolata <\(name)> Cambiare e riprovare.", comment: "Creazione in blocco interrotta")
            
        case .invalidPreparazioneStructure:
            return NSLocalizedString("[Error]_La preparazione deve contenere almeno un ingrediente principale", comment: "Array Ingredienti principali vuoto")
            
        
        }
        
        
    }
    
}

enum CS_NewModelCheckError:Error,LocalizedError {
    
    case intestazioneMancante
    case intestazioneEsistente(_ description:String?)
    case descrizioneNonValda
    case categoriaMancante
    case erroreCompilazioneIngredienti
    case listaAllergeniNonValidata
    case formatPriceNotValid
    case formatPriceLabelNotValid
    case sottostanteNil
    case rifSottostanteNil
    case modelloEsistente
    
    case elencoProdottiVuoto
    case noServiceDays
    
    case erroreDiCompilazione
 
    
    var errorDescription: String? {
        
        switch self {
        case .intestazioneMancante:
            return NSLocalizedString("[ERRORE]_Intestazione Mancante", comment: "Check Fallito")
        case .intestazioneEsistente(let description):
            let string:String = {
                if let description { return description }
                else { return "Nome Modello esistente"}
            }()
            return NSLocalizedString("[FAIL]_\(string)", comment: "Creazione Fallita")
        case .descrizioneNonValda:
            return NSLocalizedString("[ERRORE]_Descrizione Mancante", comment: "Check Fallito")
        case .categoriaMancante:
            return NSLocalizedString("[ERRORE]_Indicare Categoria Menu", comment: "Check Fallito")
        case .erroreCompilazioneIngredienti:
            return NSLocalizedString("[ERRORE]_Info ingredienti mancanti", comment: "Check Fallito")
        case .listaAllergeniNonValidata:
            return NSLocalizedString("[ERRORE]_Validare lista Allergeni", comment: "Check Fallito")
        case .formatPriceNotValid:
            return NSLocalizedString("[ERRORE]_Prezzo inserito non valido", comment: "Check Fallito")
        case .formatPriceLabelNotValid:
            return NSLocalizedString("[ERRORE]_Label inserita non valida", comment: "Check Fallito")
        case .sottostanteNil:
            return NSLocalizedString("[ERRORE]_Sottostante corrotto", comment: "Check Fallito")
        case .rifSottostanteNil:
            return NSLocalizedString("[ERRORE]_rif sottostante corrotto", comment: "Check Fallito")
            
        case .modelloEsistente:
            return NSLocalizedString("[ERRORE]_Esiste già un modello con le medesime caratteristiche", comment: "Check Fallito")
      
        case .elencoProdottiVuoto:
            return NSLocalizedString("[ERRORE]_Il Menu deve contenere almento un prodotto.", comment: "Check Fallito")
            
        case .noServiceDays:
            return NSLocalizedString("[ERRORE]_Il Menu deve essere attivo almeno un giorno a settimana.", comment: "Check Fallito")
            
        case .erroreDiCompilazione:
            return NSLocalizedString("[ERRORE]_Una o più proprietà mancanti..", comment: "Check Fallito")
     
        }
        
    }
    
}

enum CS_ErroreGenericoCustom:Error,LocalizedError {
    
    case erroreGenerico(modelName:String,problem:String,reason:String)
   
    var errorDescription: String? {
        
        switch self {
        case .erroreGenerico(let model,let problem,let reason):
            return NSLocalizedString("[OGGETTO] \(model)\n[PROBLEM] \(problem)\n[REASON] \(reason) ", comment: "Errore Generico")
       
        }
        
    }
    
}
