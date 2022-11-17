//
//  DishRatingModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/08/22.
//

import Foundation
import SwiftUI

struct DishRatingModel: MyProStarterPack_L0,MyProCloudPack_L1,Hashable {
    
   // let id:String
    let id: String = UUID().uuidString
    var rifPiatto: String // Lo mettiamo per avere un riferimento incrociato
    
    let voto: String // il voto deve essere un INT ma vine salvato come double : ex 8.0. Quindi nelle trasformazioni lo trattiamo come Double. Da Creare una ghera con i valori selezionabili prestabiliti
    let titolo: String // deve avere un limite di caratteri
    let commento: String
    var dataRilascio: Date // Messo in Var per i test, riportare come let
    let image: String = "circle" // 19.10 Togliere le virgolette di default.
    
    func creaDocumentDataForFirebase() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            "rifPiatto":self.rifPiatto,
            "voto":self.voto,
            "titolo":self.titolo,
            "commento":self.commento,
            "rifImage":self.image,
            "dataRilascio":self.dataRilascio
        
        ]
        
        return documentData
    }
    
    func rateColor() -> Color {
        
        guard let vote = Double(self.voto) else { return Color.gray }
      
        if vote <= 6.0 { return Color.red }
        else if vote <= 8.0 { return Color.orange }
        else if vote == 9.0 { return Color.yellow }
        else { return Color.green }
        
    }
    
    func isVoteInRange(min:Double,max:Double) -> Bool {
        
        guard let vote = Double(self.voto) else { return false }
            
        return vote >= min && vote <= max
        
    }
    

    init(/*id:String,*/voto: String, titolo: String, commento: String, idPiatto: String) {
        
        self.voto = voto
        self.titolo = titolo
        self.commento = commento
        self.rifPiatto = idPiatto
        
        self.dataRilascio = Date() // viene inizializzata in automatico con la data di init che dovrebbe corrispondere alla data di rilascio della review
       // self.id = id
    }
    
    // Method
    
    /// tiriamo fuori un voto e peso (il peso va da 0.1 a 1.05)
    func votoEPeso() -> (voto:Double,peso:Double) {
        
        let theVote = Double(self.voto) ?? 10.0
        
        // Peso va da 0.1 a 1.05
        var completingRate:Double
        if theVote > 7.4 { completingRate = 0.5 } //(6) min 0.5 max 1.05
        else if theVote > 3.9 { completingRate = 0.25 }//(7) min 0.25 max 0.80
        else { completingRate = 0.2 }//(8) min 0.2 max 0.75
        
        if self.titolo != "" { completingRate += 0.05 }
        if self.image != "" { completingRate += 0.15 }
        if self.commento != "" {
            
            let countChar = self.commento.replacingOccurrences(of: " ", with: "").count
           
            if countChar < 70 { completingRate += 0.2 }
            
            else if countChar > 70 && countChar <= 180 {
                completingRate += 0.35
            } // gold range
            
            else if countChar > 180 && countChar <= 300 { completingRate += 0.30 }
            else if countChar > 300 { completingRate += 0.25 }
            
        }
        
        // Special Case
     /*   if theVote == 0.0 && completingRate < 0.71 {
            completingRate = 0.1
        } */
        // end special case
        return (theVote,completingRate)
    }
    
}
