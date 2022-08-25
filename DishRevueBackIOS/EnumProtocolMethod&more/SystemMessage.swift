//
//  SystemMessage.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/08/22.
//

import Foundation

/// Usiamo questa Enum per messaggi di sistema ripetuti in diversi punti dell'App
enum SystemMessage {

    case allergeni
    
    
    func simpleDescription() -> String {
        
        switch self {
        case .allergeni:
            return "Il Regolamento UE n.1169/2011, entrato in vigore il 13 dicembre 2014, ha introdotto l'obbligo per produttori ed esercizi commerciali di segnalare, nei cibi, la presenza di sostanze che possono provocare allergie o intolleranze.\n\nL'applicativo fornisce un elenco dei 14 allergeni obbligatori per legge, e l'utente ha l'obbligo di associare ad ogni ingrediente l'eventuale allergene contenuto.\n\nL'utente che conferma una lista allergeni incompleta se ne assume la piena responsabilità.\n\nIn nessun caso l'applicativo può essere ritenuto responsabile della mancata e/o incompleta segnalazione degli allergeni.\n\nQualora la lista allergeni dovesse risultare incompleta, l'utente è invitato a controllare la corretta indicazione degli allergeni negli ingredienti.\n\nQualora il problema persista per un errore imputabile all'applicativo, l'utente è tenuto a NON Pubblicare o a Rimuovere il piatto, ed a segnalare il disservizio all'indirizzo mail segnalaBug@foodies.com"
        }
        
    }
    
    
}
