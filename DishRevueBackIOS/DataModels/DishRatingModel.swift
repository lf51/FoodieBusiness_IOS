//
//  DishRatingModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/08/22.
//

import Foundation
import SwiftUI
import Firebase

struct DishRatingModel: MyProStarterPack_L0,MyProCloudPack_L1,Hashable {
    
   // let id:String
    let id: String
    let rifPiatto: String // Lo mettiamo per avere un riferimento incrociato
    
    let voto: String // il voto deve essere un INT ma vine salvato come double : ex 8.0. Quindi nelle trasformazioni lo trattiamo come Double. Da Creare una ghera con i valori selezionabili prestabiliti
    let titolo: String // deve avere un limite di caratteri
    let commento: String
    let dataRilascio: Date // Messo in Var per i test, riportare come let
    let image: String // 19.10 Togliere le virgolette di default.
    
    init(/*id:String,*/voto: String, titolo: String, commento: String, idPiatto: String) {
        
        // Utile solo per i test. Il cliente business non crea recensioni.
        self.id = UUID().uuidString
        
        self.voto = voto
        self.titolo = titolo
        self.commento = commento
        self.rifPiatto = idPiatto
        self.image = "circle"
        
        self.dataRilascio = Date() // viene inizializzata in automatico con la data di init che dovrebbe corrispondere alla data di rilascio della review
       // self.id = id
    }
    
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        self.id = frDoc.documentID
        
        self.voto = frDoc[DataBaseField.voto] as? String ?? ""
        self.titolo = frDoc[DataBaseField.titolo] as? String ?? ""
        self.commento = frDoc[DataBaseField.commento] as? String ?? ""
        self.rifPiatto = frDoc[DataBaseField.rifPiatto] as? String ?? ""
        self.image = frDoc[DataBaseField.image] as? String ?? ""
    
        self.dataRilascio = frDoc[DataBaseField.dataRilascio] as? Date ?? .now
    }
    
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.rifPiatto : self.rifPiatto,
            DataBaseField.voto : self.voto,
            DataBaseField.titolo : self.titolo,
            DataBaseField.commento : self.commento,
            DataBaseField.image : self.image,
            DataBaseField.dataRilascio : self.dataRilascio
        
        ]
        
        return documentData
    }
    
    struct DataBaseField {
        
        static let rifPiatto = "rifPiatto"
        static let voto = "voto"
        static let titolo = "titolo"
        static let commento = "commento"
        static let image = "rifImage"
        static let dataRilascio = "dataRilascio"
        
    }
    
    //
    
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
