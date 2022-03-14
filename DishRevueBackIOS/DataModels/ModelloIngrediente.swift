//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation

// Creare Oggetto Ingrediente

struct ModelloIngrediente: CustomGridAvaible {
    
  static func == (lhs: ModelloIngrediente, rhs: ModelloIngrediente) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.provenienza == rhs.provenienza &&
      lhs.produzione == rhs.produzione &&
      lhs.conservazione == rhs.conservazione
    }
    
    var id: String { self.nome.replacingOccurrences(of:" ", with:"").lowercased() }

    var nome: String
    
  //  var cottura: DishCookingMethod // la cottura la evitiamo in questa fase perchè può generare confusione
    var provenienza: ProvenienzaIngrediente
    var produzione: ProduzioneIngrediente
  //  var stagionalita: StagionalitaIngrediente // la stagionalità non ha senso poichè è inserita dal ristoratore, ed è inserita quando? Ha senso se la attribuisce il sistema, ma è complesso.
    var conservazione: ConservazioneIngrediente
    
    var dishWhereIsUsed: [DishModel] = [] // creiamo la doppia scrittura, ossia registriamo l'ingrediente nel piatto, e il piatto nell'ingrediente, di modo da avere un array di facile accesso per mostrare tutti i piatti che utilizzano quel dato ingrediente
    
    
    // In futuro serviranno delle proprietà ulteriori, pensando nell'ottica che l'ingrediente possa essere gestito dall'app in chiave economato, quindi gestendo quantità e prezzi e rifornimenti necessari
    
    init() {
        
        self.nome = ""
       
        self.provenienza = .defaultValue
        self.produzione = .defaultValue
     
        self.conservazione = .defaultValue
        
    }
    
    init(nome: String, provenienza: ProvenienzaIngrediente, metodoDiProduzione: ProduzioneIngrediente) {
        
        self.nome = nome
     
        self.provenienza = provenienza
        self.produzione = metodoDiProduzione
        self.conservazione = .defaultValue
       
    }
    
    init(nome:String) {
        
        self.nome = nome
     
        self.provenienza = .defaultValue
        self.produzione = .defaultValue
        self.conservazione = .defaultValue
    }
    
}
