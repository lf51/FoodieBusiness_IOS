//
//  DishRatingModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/08/22.
//

import Foundation
import SwiftUI

struct DishRatingModel:Hashable {
    
    let voto: String // il voto deve essere un INT ma vine salvato come double : ex 8.0. Quindi nelle trasformazioni lo trattiamo come Double.
    let titolo: String // deve avere un limite di caratteri
    let commento: String
    let dataRilascio: Date
    
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
    

    init(voto: String, titolo: String, commento: String) {
        self.voto = voto
        self.titolo = titolo
        self.commento = commento
        
        self.dataRilascio = Date() // viene inizializzata in automatico con la data di init che dovrebbe corrispondere alla data di rilascio della review
    }
}
