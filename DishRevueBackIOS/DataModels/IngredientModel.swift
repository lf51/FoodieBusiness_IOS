//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation

// Creare Oggetto Ingrediente

struct IngredientModel: CustomGridAvaible {
    
  static func == (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.provenienza == rhs.provenienza &&
      lhs.produzione == rhs.produzione &&
      lhs.conservazione == rhs.conservazione
    }
    
    var dishWhereIsUsed: [DishModel] = [] // doppia scrittura con ListaIngredienti Principali e Secondari nel DishModel
    
    var id: String { self.intestazione.replacingOccurrences(of:" ", with:"").lowercased() }

    var intestazione: String
    
  //  var cottura: DishCookingMethod // la cottura la evitiamo in questa fase perchè può generare confusione
    var provenienza: ProvenienzaIngrediente
    var produzione: ProduzioneIngrediente
  //  var stagionalita: StagionalitaIngrediente // la stagionalità non ha senso poichè è inserita dal ristoratore, ed è inserita quando? Ha senso se la attribuisce il sistema, ma è complesso.
    var conservazione: ConservazioneIngrediente
    
    
    
    
    // In futuro serviranno delle proprietà ulteriori, pensando nell'ottica che l'ingrediente possa essere gestito dall'app in chiave economato, quindi gestendo quantità e prezzi e rifornimenti necessari
    
    init() {
        
        self.intestazione = ""
       
        self.provenienza = .defaultValue
        self.produzione = .defaultValue
     
        self.conservazione = .defaultValue
        
    }
    
    init(nome: String, provenienza: ProvenienzaIngrediente, metodoDiProduzione: ProduzioneIngrediente) {
        
        self.intestazione = nome
     
        self.provenienza = provenienza
        self.produzione = metodoDiProduzione
        self.conservazione = .defaultValue
       
    }
    
    init(nome:String) {
        
        self.intestazione = nome
     
        self.provenienza = .defaultValue
        self.produzione = .defaultValue
        self.conservazione = .defaultValue
    }
    
}
