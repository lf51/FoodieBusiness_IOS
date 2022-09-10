//
//  SystemMessage.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/08/22.
//

import Foundation

/// Usiamo questa Enum per messaggi di sistema ripetuti in diversi punti dell'App
enum SystemMessage {
// Teoricamente questa enum ha senso per messaggi uguali ripetuti. L'unico che viene ripetuto è quello degli allergeni.
    case allergeni
    case ingredienteSecondario
    case sostituzioneTemporaneaING
    case sostituzionePermanenteING
    case formattazioneInserimentoVeloce
    
    
    func simpleDescription() -> String {
        
        switch self {
        case .allergeni:
            return "Il Regolamento UE n.1169/2011, entrato in vigore il 13 dicembre 2014, ha introdotto l'obbligo per produttori ed esercizi commerciali di segnalare, nei cibi, la presenza di sostanze che possono provocare allergie o intolleranze.\n\nL'applicativo fornisce un elenco dei 14 allergeni obbligatori per legge, e l'utente ha l'obbligo di associare ad ogni ingrediente l'eventuale allergene contenuto.\n\nL'utente che conferma una lista allergeni incompleta se ne assume la piena responsabilità.\n\nIn nessun caso l'applicativo può essere ritenuto responsabile della mancata e/o incompleta segnalazione degli allergeni.\n\nQualora la lista allergeni dovesse risultare incompleta, l'utente è invitato a controllare la corretta indicazione degli allergeni negli ingredienti.\n\nQualora il problema persista per un errore imputabile all'applicativo, l'utente è tenuto a NON Pubblicare o a Rimuovere il piatto, ed a segnalare il disservizio all'indirizzo mail segnalaBug@foodies.com"
            
        case .ingredienteSecondario:
            return "Indicare come secondario un ingrediente usato in piccole quantità nella preparazione del piatto."
            
        case .sostituzioneTemporaneaING:
            return "Per ragioni di carenza temporanea, l'utente ha la facoltà qui di sostituire temporaneamente, ma senza limiti di tempo, un ingrediente con un altro.\n\nNella lista ingredienti di ciascun piatto saranno così visualizzati entrambi gli elementi, l'ingrediente sostituito e il sostituto, fino a quando l'utente, tornato nuovamente disponibile l'ingrediente carente, non provvederà manualmente ad annullare la sostituzione.\nL'ingrediente sostituito sarà posto automaticamente nello stato di 'in Pausa', e basterà riportarlo allo stato di 'Disponibile' per ripristinare la titolarità nella lista ingredienti di ciascun piatto.\n\nIl cambio può essere unico, ossia un solo sostituto per tutti i piatti, oppure può essere scelto un sostituto differente per ogni piatto."
            
        case .sostituzionePermanenteING:
            return "L'utente può qui eliminare o sostituire in modo veloce e permanente un ingrediente da tutti i piatti che lo contengono o una parte di essi. Qualora la sostituzione riguardi tutti i piatti, l'ingrediente sarà posto nello stato di 'Archiviato'.\nA differenza del cambio temporaneo, la sostituzione non è visibile nella lista ingredienti del piatto, e non è reversibile riportando l'ingrediente su 'Disponibile'.\nDove non indicato un sostituto, l'ingrediente sarà di default eliminato, salvo esplicita azione di mantenimento.\n\nIl cambio può essere unico, ossia un solo sostituto per tutti i piatti, oppure può essere scelto un sostituto differente per ogni piatto."
            
        case .formattazioneInserimentoVeloce:
            return "E' possibile inserire contemporaneamente un numero imprecisato di piatti. Per ogni piatto va creata una stringa secondo il seguente schema:\n\nNome del piatto,1° ingrediente, 2° ingrediente, n° ingrediente.Nome altro piatto,1° ingrediente,2°ingrediente,ecc.\n\n Esempio (due piatti, due stringhe):\nSpaghetti alla carbonara,pecorino DOP,prezzemolo,tuorlo d'uovo,pepe nero,sale.Bucatini alla matriciana,guanciale,pepe nero,sale.\n\nE' preferibile non usare spazi fra le punteggiature.\nIl punto segna la fine di un piatto e l'inzio di un altro.\nLa virgola separa il nome del piatto dagli ingredienti, e ciascun ingrediente dall'altro.\n\nNon usare il punto e la virgola per fini diversi, ad esempio per le sigle.\nDOP ✅\nD.O.P ❌\nDOC ✅\nD.O.C. ❌"
        }
        
    }
    
    
}
