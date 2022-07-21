//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation
import SwiftUI

struct DishModel:MyModelStatusConformity {
    
    func returnNewModel() -> (tipo: DishModel, nometipo: String) {
        (DishModel(),"Nuovo Piatto")
    }
    
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        DishModel_RowView(item: self)
    }
    
    
   static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.rating == rhs.rating &&
        lhs.status == rhs.status &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
       //lhs.areAllergeniOk == rhs.areAllergeniOk &&
        lhs.allergeni == rhs.allergeni &&
        lhs.dieteCompatibili == rhs.dieteCompatibili &&
        lhs.pricingPiatto == rhs.pricingPiatto &&
        lhs.aBaseDi == rhs.aBaseDi
       // dobbiamo specificare tutte le uguaglianze altrimenti gli enumScroll non mi funzionano perchè non riesce a confrontare i valori
    }
    
    var id: String { creaID(fromValue: self.intestazione) }
    
    var intestazione: String
    var descrizione: String
    var rating: String

    var status: StatusModel
    
    var ingredientiPrincipali: [IngredientModel]
    var ingredientiSecondari: [IngredientModel]
    
    var categoriaMenu: CategoriaMenu
    
  //  var areAllergeniOk: Bool = false
    var allergeni: [AllergeniIngrediente] // derivati dagli ingredienti

    var dieteCompatibili:[DishTipologia] // derivate dagli ingredienti
    var pricingPiatto:[DishFormat]

    var aBaseDi:OrigineIngrediente = .defaultValue // da implementare || derivata dagli ingredienti
    
    init() {
        
        self.intestazione = ""
        self.descrizione = ""
        self.rating = ""
        self.status = .vuoto
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.categoriaMenu = .defaultValue
      //  self.areAllergeniOk = false
        self.allergeni = []
        self.dieteCompatibili = [.standard]
        self.pricingPiatto =  [DishFormat(type: .mandatory)]
 
    }
    
    func creaID(fromValue: String) -> String {
        print("DishModel/creaID()")
      return fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // non mi piace
    
    func modelStatusDescription() -> String {
        "Piatto (\(self.status.simpleDescription().capitalized))"
    }
    
    func viewModelContainer() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM, [DishModel]>, nomeContainer: String, nomeOggetto:String) {
        
        return (\.allMyDish, "Lista Piatti", "Piatto")
    }
       
    func pathDestination() -> DestinationPathView {
        DestinationPathView.piatto(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}


