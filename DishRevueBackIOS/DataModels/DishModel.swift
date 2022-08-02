//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation
import SwiftUI

struct DishRating:Hashable {
    
    let voto: String // il voto deve avere il formato INT
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
    
    func isVoteInRange(min:Int,max:Int) -> Bool {
        
        guard let vote = Double(self.voto) else { return false }
        
        let intVote = Int(vote)
        
        return intVote >= min && intVote <= max
        
    }
    
    
    
    
    
    init(voto: String, titolo: String, commento: String) {
        self.voto = voto
        self.titolo = titolo
        self.commento = commento
        
        self.dataRilascio = Date() // viene inizializzata in automatico con la data di init che dovrebbe corrispondere alla data di rilascio della review
    }
}


struct DishModel:MyModelStatusConformity {
    
    func customInteractiveMenu() -> some View {
        
        VStack {
            
            Button {
               // myModel.wrappedValue.status = .completo(.inPausa)
                
            } label: {
                HStack{
                    Text("Vedi Recensioni")
                    Image(systemName: "eye")
                }
            }
            
        }

    }
    

   static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.status == rhs.status &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
        lhs.allergeni == rhs.allergeni &&
        lhs.dieteCompatibili == rhs.dieteCompatibili &&
        lhs.pricingPiatto == rhs.pricingPiatto &&
        lhs.aBaseDi == rhs.aBaseDi
       // dobbiamo specificare tutte le uguaglianze altrimenti gli enumScroll non mi funzionano perchè non riesce a confrontare i valori
    }
    
    var id: String { creaID(fromValue: self.intestazione) }
    
    var intestazione: String = ""
    var descrizione: String = ""
  //  var rating: String // deprecata in futuro - sostituire con array di tuple (Voto,Commento)
    var rating: [DishRating] = []

    var status: StatusModel = .vuoto
    
    var ingredientiPrincipali: [IngredientModel] = []
    var ingredientiSecondari: [IngredientModel] = []
    
    var categoriaMenu: CategoriaMenu = .defaultValue

    var allergeni: [AllergeniIngrediente] = [] // derivati dagli ingredienti

    var dieteCompatibili:[TipoDieta] = [.standard] // derivate dagli ingredienti
    var pricingPiatto:[DishFormat] = [DishFormat(type: .mandatory)]

    var aBaseDi:OrigineIngrediente = .defaultValue // da implementare || derivata dagli ingredienti // deprecata in futuro
    
   /* init() {
        
        self.intestazione = ""
        self.descrizione = ""
     //   self.rating = ""
        self.status = .vuoto
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.categoriaMenu = .defaultValue
      //  self.areAllergeniOk = false
        self.allergeni = []
        self.dieteCompatibili = [.standard]
        self.pricingPiatto =  [DishFormat(type: .mandatory)]
 
    } */
    
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
    
    func returnNewModel() -> (tipo: DishModel, nometipo: String) {
        (DishModel(),"Nuovo Piatto")
    }
    
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        DishModel_RowView(item: self)
    }
}


