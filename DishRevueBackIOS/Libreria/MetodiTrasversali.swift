//
//  MethodTrasversali.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage



func csValidateValue(value: String, convalidaAsDouble: Bool) -> Bool {
   
   if convalidaAsDouble {
       
       if let righValue = Double(value.replacingOccurrences(of: ",", with: ".")) { if righValue >= 0 {return true} else {return false} } else {return false}
       
   } else {
       // convalida Int
       if let rightValue = Int(value) { if rightValue > 0 {return true} else {return false} } else {return false}
       
   }
} // Deprecata in futuro // da sostituire // deprecata 22.09





/// Ritorna un array di case unici (ripuliti dai valori Associati, dai duplicati, e ordinati) di ENUM conformi al MyEnumProtocolMapConform [lf51]
/// - Parameter array: array description
/// - Returns: description




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
