//
//  MethodTrasversali.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import Foundation
import SwiftUI

/// trasferisci i valori da un fileJson ad un Oggetto
func csLoad<T:Decodable>(_ filename:String) -> T {
    
    let data:Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {fatalError("Non è possibile trovare \(filename) in the main bundle") }
    
    do {
        data = try Data(contentsOf: file)
    } catch {fatalError("Non è possibile caricare il file \(filename)") }
    
    do { let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {fatalError("Impossibile eseguire il PARSE sul file \(filename) as \(T.self):\n\(error)") }
    
}

func csValidateValue(value: String, convalidaAsDouble: Bool) -> Bool {
   
   if convalidaAsDouble {
       
       if let righValue = Double(value.replacingOccurrences(of: ",", with: ".")) { if righValue >= 0 {return true} else {return false} } else {return false}
       
   } else {
       // convalida Int
       if let rightValue = Int(value) { if rightValue > 0 {return true} else {return false} } else {return false}
       
   }
} // Deprecata in futuro // da sostituire // deprecata 22.09

func csTimeFormatter() -> (ora:DateFormatter,data:DateFormatter) {
    // !! Nota Vocale 20.09 AMPM !!
    let time = DateFormatter()
    time.timeStyle = .short
   // time.dateFormat = "HH:mm"
   // time.timeZone = .current
  //  time.timeZone = .gmt

    let date = DateFormatter()
   /* date.weekdaySymbols = ["Lun","Mar","Mer","Gio","Ven","Sab","Dom"]*/
   /* date.monthSymbols = ["Gen","Feb","Mar","Apr","Mag","Giu","Lug","Ago","Set","Ott","Nov","Dic"] */
    date.dateStyle = .long
    date.dateFormat = "dd MMMM yyyy"
 //   date.timeZone = .autoupdatingCurrent
 //   date.weekdaySymbols = ["Lun","Mar"]
    return (time,date)
    
}

/// Nasconde la Keyboard
func csHideKeyboard(){
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

/// Ritorna un array di case unici (ripuliti dai valori Associati, dai duplicati, e ordinati) di ENUM conformi al MyEnumProtocolMapConform [lf51]
/// - Parameter array: array description
/// - Returns: description
func csCleanAndOrderArray<T:MyProOrganizerPack_L0>(array:[T]) -> [T] {
    
    // T passa da MYEnumProtocolMapConform a MyProOrganizerPack
    
    // Modifiche 27.09
  //  var arrayCentrifugato:[T] = []
    
   /* for eachCase in array {
        
        let element:T = eachCase.returnTypeCase()
        arrayCentrifugato.append(element)
        
    } */
    let arrayCentrifugato:[T] = array.map({$0.returnTypeCase()})
 
    // end Mod 27.09
    
    let secondStep = Array(Set(arrayCentrifugato))
    let lastStep = secondStep.sorted{$0.orderAndStorageValue() < $1.orderAndStorageValue()}
    
   return lastStep
}

/// Pulisce la stringa da spazi duplici, e da puntiAcapo
func csStringCleaner(string:String) -> String {
    
    let firstStep = string.replacingOccurrences(of: "\n", with: "")
    
    let subStringaTesto = firstStep.split(separator: " ")
    let newStringaTesto: String = {
        
        var newString:String = ""
        for sub in subStringaTesto {
            
            newString = newString == "" ? String(sub) : (newString + " " + sub)
            
        }
        
        return newString
        
    }()

    return newStringaTesto
    
}

/// ritorna un array di Emojy
func csReturnEmojyCollection() -> [String] {

    let unicodeCollection:Set<UInt32> = [0x1F950,0x1F956,0x1F957,0x1F958,0x1F959,0x1F95A,0x1F95E,0x1F95F,0x1F961,0x1F962,0x1F963,0x1F964,0x1F967,0x1F968,0x1F969,0x1F96A,0x1F96B,0x1F96C,0x1F96E,0x1F96F,0x1F9C0,0x1F9C1,0x1F9C3,0x1F9C6,0x1F9C7,0x1F9C9,0x1F32D,0x1F32E,0x1F32F,0x1F354,0x1F355,0x1F356,0x1F357,0x1F358,0x1F359,0x1F35A,0x1F35B,0x1F35C,0x1F35D,0x1F35E,0x1F35F,0x1F361,0x1F362,0x1F363,0x1F364,0x1F365,0x1F366,0x1F368,0x1F369,0x1F36A,0x1F36E,0x1F370,0x1F371,0x1F372,0x1F373,0x1F374,0x1F37E,0x1F37F,0x1F375,0x1F376,0x1F377,0x1F378,0x1F379,0x1F37A,0x1F37B,0x1F37C,0x1F942,0x1FAD2,0x1F34D,0x1F345,0x1F347,0x1F34B,0x1F353,0x1F34F,0x1F37D,0x1F374,0x1F944,0x1F41F,0x1F414,0x1F404,0x1F402,0x1F416]
    
    var emojyCollection:[String] = []

        for i in unicodeCollection {
            
            guard let scalar = UnicodeScalar(i) else { continue }
            
            let c = String(scalar)
            emojyCollection.append(c)
            }
       
    let orderCollection = emojyCollection.sorted()
        
    return orderCollection
        
        
    }

/*
/// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse sempre in Stringa
func csIterateDishRating(item: DishModel) -> (media:String,count:String) {
    
    var sommaVoti: Double = 0.0
    var mediaRating: String = "0.00"
    
    let ratingCount: Int = item.rating.count
    let stringCount = String(ratingCount)
    
    guard !item.rating.isEmpty else {
        
        return (mediaRating,stringCount)
    }
    
    for rating in item.rating {
        
        let voto = Double(rating.voto)
        sommaVoti += voto ?? 0.00
    }
    
    let mediaAritmetica = sommaVoti / Double(ratingCount)
    mediaRating = String(format:"%.1f", mediaAritmetica)
    return (mediaRating,stringCount)
    
} */ // Deprecata 13.09 per trasformazione in riferimenti. Spostata nel dishModel

 func csSwitchSingolarePlurale(checkNumber:Int,wordSingolare:String,wordPlurale:String) -> String {
    
    if checkNumber == 1 { return wordSingolare}
    else { return wordPlurale}
}

/*
/// Reset Crezione Modello - Torna un modello Vuoto o il Modello Senza Modifiche
func csResetModel<M:MyModelStatusConformity>(modelAttivo:inout M,modelArchiviato:M) {
  
    modelAttivo = modelArchiviato
} */ // Deprecata

/// Analizza le proprietà di un ingrediente e tira fuori una stringa. Trasfersale al modello nuovo Ingrediente e al modello Ibrido
func csInfoIngrediente(areAllergeniOk:Bool,nuovoIngrediente:IngredientModel) -> String {
    
    var stringaAllergeni: String = "Presenza/assenza Allergeni non Confermata"
    var stringaCongeSurge: String = "\nMetodo di Conservazione non indicato"
    var metodoProduzione: String = ""
    
    if areAllergeniOk {
        
        if nuovoIngrediente.allergeni.isEmpty {
            stringaAllergeni = "Questo prodotto è privo di Allergeni."
        } else {

            let count = nuovoIngrediente.allergeni.count
            stringaAllergeni = "Questo prodotto contiene \(count > 1 ? "\(count) Allergeni" : "1 Allergene")."
        }
    }
    
    if nuovoIngrediente.conservazione != .defaultValue {
        
         stringaCongeSurge = "\nQuesto prodotto \( nuovoIngrediente.conservazione.extendedDescription())."
        
    }
    
    if nuovoIngrediente.produzione == .biologico {
        metodoProduzione = "\nProdotto BIO."
    }
    
    return ("\(stringaAllergeni)\(stringaCongeSurge)\(metodoProduzione)")
}

/// ritorna il valore della media Pesata di un array di Recensioni
func csCalcoloMediaRecensioni(elementi:[DishRatingModel]) -> Double {
    
    let votiEPesi = elementi.map({$0.votoEPeso()})
       
        var sommaVoti: Double = 0.0
        var sommaPesi: Double = 0.0
        
        for (v,p) in votiEPesi {
            
            let votoPesato = v * p
            sommaVoti += votoPesato
            sommaPesi += p
        }
        
        return sommaVoti / sommaPesi

}

/// somma dei valori di una collection di valori Double
func csSommaValoriCollection(collectionValue:[Double]) -> Double {
    
    var somma:Double = 0.0
    
    for value in collectionValue {
        
        somma += value
    }
    return somma
}

/// ritorna una medeglia per luna classifica generica, posizioni da 0, equivalente al primo posto, al 2, equivalente al terzo posto
func csRatingMedalReward(position:Int) -> String {
    
    if position == 0 { return "🥇" }
    else if position == 1 { return "🥈"}
    else if position == 2 { return "🥉" }
    else { return "" }
}

/// estrapola l'ora da una data e la trasforma in un numero Assoluto (è il numero di minuti totale) utile per un confronto fra orari
func csTimeConversione(data:Date) -> Int {
    
    let calendario = Calendar(identifier: .gregorian)
    
    let componentiData = calendario.dateComponents([.hour,.minute], from: data)
    let valoreAssoluto = (componentiData.hour! * 60) + componentiData.minute!
    return valoreAssoluto
}

func csTimeReverse(value:Int) -> Date {
    
    let minute = value % 60
    let hour = (value - minute) / 60
    
    let calendario = Calendar(identifier: .gregorian)
    let timeComponent = DateComponents(hour: hour, minute: minute)
    let reversingDate = calendario.date(from: timeComponent) ?? Date.now
    
    return reversingDate
}
