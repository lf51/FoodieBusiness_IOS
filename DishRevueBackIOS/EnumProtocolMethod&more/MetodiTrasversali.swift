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
} // Deprecata in futuro // da sostituire

func csTimeFormatter() -> (ora:DateFormatter,data:DateFormatter) {
    
    let time = DateFormatter()
    time.timeStyle = .short
    
    let date = DateFormatter()
    date.dateStyle = .long
    
    return (time,date)
    
}

/// Nasconde la Keyboard
func csHideKeyboard(){
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

/// Ritorna un array di case unici (ripuliti dai valori Associati, dai duplicati, e ordinati) di ENUM conformi al MyEnumProtocolMapConform [lf51]
/// - Parameter array: array description
/// - Returns: description
func csRipulisciArray<T:MyEnumProtocolMapConform>(array:[T]) -> [T] {
    
    var arrayCentrifugato:[T] = []
    
    for eachCase in array {
        
        let element:T = eachCase.returnTypeCase()
        arrayCentrifugato.append(element)
        
    }
    
    let secondStep = Array(Set(arrayCentrifugato))
    let lastStep = secondStep.sorted{$0.orderValue() < $1.orderValue()}
    
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

/// Reset Crezione Modello - Torna un modello Vuoto o il Modello Senza Modifiche
func resetModel<M:MyModelStatusConformity>(modelAttivo:inout M,modelArchiviato:M) {
  
    modelAttivo = modelArchiviato
}
