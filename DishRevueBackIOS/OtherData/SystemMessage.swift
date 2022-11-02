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
    case dieteCompatibili
    case elencoCategorieMenu
    case monitorRecensioni
    case infoScheduleServizio
    case cambioStatusPreparazioni
    case timerMenu
    
    case noValue
    
    func simpleDescription() -> String {
        
        switch self {
        case .allergeni:
            return "Il Regolamento UE n.1169/2011, entrato in vigore il 13 dicembre 2014, ha introdotto l'obbligo per produttori ed esercizi commerciali di segnalare, nei cibi, la presenza di sostanze che possono provocare allergie o intolleranze.\n\nL'applicativo fornisce un elenco dei 14 allergeni obbligatori per legge, e l'utente ha l'obbligo di associare ad ogni ingrediente l'eventuale allergene contenuto.\n\nL'utente che conferma una lista allergeni incompleta se ne assume la piena responsabilità.\n\nIn nessun caso l'applicativo può essere ritenuto responsabile della mancata e/o incompleta segnalazione degli allergeni.\n\nQualora la lista allergeni dovesse risultare incompleta, l'utente è invitato a controllare la corretta indicazione degli allergeni negli ingredienti.\n\nQualora il problema persista per un errore imputabile all'applicativo, l'utente è tenuto a NON Pubblicare o a Rimuovere il piatto, ed a segnalare il disservizio all'indirizzo mail segnalaBug@foodies.com"
            
        case .ingredienteSecondario:
            return "Indicare come Minore un ingrediente usato in piccole quantità nella preparazione del piatto."
            
        case .sostituzioneTemporaneaING:
            return "Per ragioni di carenza temporanea, l'utente ha la facoltà qui di sostituire temporaneamente, ma senza limiti di tempo, un ingrediente con un altro.\n\nNella lista ingredienti di ciascun piatto saranno così visualizzati entrambi gli elementi, l'ingrediente sostituito e il sostituto, fino a quando l'utente, tornato nuovamente disponibile l'ingrediente carente, non provvederà manualmente ad annullare la sostituzione.\nL'ingrediente sostituito sarà posto automaticamente nello stato di 'in Pausa', e basterà riportarlo allo stato di 'Disponibile' per ripristinare la titolarità nella lista ingredienti di ciascun piatto.\n\nIl cambio può essere unico, ossia un solo sostituto per tutti i piatti, oppure può essere scelto un sostituto differente per ogni piatto."
            
        case .sostituzionePermanenteING:
            return "L'utente può qui eliminare o sostituire in modo veloce e permanente un ingrediente da tutti i piatti che lo contengono o una parte di essi. Qualora la sostituzione riguardi tutti i piatti, l'ingrediente sarà posto nello stato di 'Archiviato'.\nA differenza del cambio temporaneo, la sostituzione non è visibile nella lista ingredienti del piatto, e non è reversibile riportando l'ingrediente su 'Disponibile'.\nDove non indicato un sostituto, l'ingrediente sarà di default eliminato, salvo esplicita azione di mantenimento.\n\nIl cambio può essere unico, ossia un solo sostituto per tutti i piatti, oppure può essere scelto un sostituto differente per ogni piatto."
            
        case .formattazioneInserimentoVeloce:
            return "E' possibile inserire contemporaneamente un numero imprecisato di piatti. Per ogni piatto va creata una stringa secondo il seguente schema:\n\nNome del piatto,1° ingrediente, 2° ingrediente, n° ingrediente.Nome altro piatto,1° ingrediente,2°ingrediente,ecc.\n\n Esempio (due piatti, due stringhe):\nSpaghetti alla carbonara,pecorino DOP,prezzemolo,tuorlo d'uovo,pepe nero,sale.Bucatini alla matriciana,guanciale,pepe nero,sale.\n\nE' preferibile non usare spazi fra le punteggiature.\nIl punto segna la fine di un piatto e l'inzio di un altro.\nLa virgola separa il nome del piatto dagli ingredienti, e ciascun ingrediente dall'altro.\n\nNon usare il punto e la virgola per fini diversi, ad esempio per le sigle.\nDOP ✅\nD.O.P ❌\nDOC ✅\nD.O.C. ❌"
            
        case .dieteCompatibili:
            return "Dati gli ingredienti del piatto, considerata la loro origine e le loro caratteristiche, il sistema ritorna una compatibilità con le diverse tipologie di dieta.\nL'utente ha la facoltà di scegliere se mostrare questa compatibilità, qualora la ritenesse corretta, o non mostrarla. In quest'ultimo caso il piatto sarà indicato come compatibile con una dieta standard, ovvero onnivora.\n\n"
            
        case .elencoCategorieMenu:
            return "Al pubblico saranno visibili solo le categorie che contengono dei piatti.\nL'utente può eliminare quelle superflue, modificare le esistenti e stabilire l'ordine di visualizzazione nei menu."
            
        case .monitorRecensioni:
            return "Totali -> Numero complessivo di recensioni rilasciate.\n\n24H -> Numero di recensioni rilasciate nelle ultime 24 ore.\n\nMedia -> Media globale\n\nMedia-L10 -> Media delle ultime dieci recensioni."
            
        case .infoScheduleServizio:
            return "Gli orari di apertura e chiusura sono dedotti dai menu disponibili.\n\n I menu con data esatta, dunque anche il Menu del Giorno e dello Chef, non sono presi in cosiderazione per la Time Schedule, e sono indicati a parte."
            
        case .cambioStatusPreparazioni:
            return "Quando un ingrediente è posto nello stato di in Pausa o Archiviato, le preparazioni che lo contengono possono essere passate in automatico allo stato di in Pausa (sempre, mai, o previa richiesta).\n\n Le preparazioni in Pausa sono invisibili al cliente. "
        case .timerMenu:
            return "L'utente può scegliere quanti minuti prima mostrare al cliente il count down della messa offline di un menu."
            
            
        case .noValue:
            return "Da inserire"
        }
        
    }
    
    
}
