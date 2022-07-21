//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation
import SwiftUI

// Creare Oggetto Ingrediente

struct IngredientModel:MyModelStatusConformity {
    
    func returnNewModel() -> (tipo: IngredientModel, nometipo: String) {
        (IngredientModel(),"Nuovo Ingrediente")
    }
 
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        IngredientModel_RowView(item: self)
    }

    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func modelStatusDescription() -> String {
        "Ingrediente (\(self.status.simpleDescription().capitalized))"
    }
    
    
    func viewModelContainer() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM, [IngredientModel]>, nomeContainer: String, nomeOggetto:String) {
        
        return (\.allMyIngredients, "Lista Ingredienti", "Ingrediente")
    }

    func pathDestination() -> DestinationPathView {
        DestinationPathView.ingrediente(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
  static func == (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.intestazione == rhs.intestazione &&
      lhs.descrizione == rhs.descrizione &&
      lhs.provenienza == rhs.provenienza &&
      lhs.produzione == rhs.produzione &&
      lhs.conservazione == rhs.conservazione &&
      lhs.origine == rhs.origine &&
      lhs.allergeni == rhs.allergeni &&
      lhs.status == rhs.status
    }
    
    var id: String { creaID(fromValue: self.intestazione) }

    var intestazione: String = ""
    var descrizione: String = ""
    
    var conservazione: ConservazioneIngrediente = .defaultValue
    var produzione: ProduzioneIngrediente = .defaultValue
    var provenienza: ProvenienzaIngrediente = .defaultValue
    
    var allergeni: [AllergeniIngrediente] = []
    var origine: OrigineIngrediente = .defaultValue
    
    var status: StatusModel = .vuoto
    

}
