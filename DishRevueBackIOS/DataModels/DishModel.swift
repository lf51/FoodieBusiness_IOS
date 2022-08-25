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
        
    func customInteractiveMenu(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        VStack {
            
            Button {
                
                viewModel[keyPath: navigationPath].append(DestinationPathView.recensioni(self))
                
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
        lhs.rating == rhs.rating &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.elencoIngredientiOff == rhs.elencoIngredientiOff &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
        lhs.allergeni == rhs.allergeni &&
        lhs.dieteCompatibili == rhs.dieteCompatibili &&
        lhs.pricingPiatto == rhs.pricingPiatto &&
       // lhs.sostituzioneIngredientiTemporanea == rhs.sostituzioneIngredientiTemporanea &&
        lhs.aBaseDi == rhs.aBaseDi
       // dobbiamo specificare tutte le uguaglianze altrimenti gli enumScroll non mi funzionano perchè non riesce a confrontare i valori
    }
    
  //  var id: String { creaID(fromValue: self.intestazione) } // deprecata 18.08
    var id: String = UUID().uuidString
    
    var intestazione: String = ""
    var descrizione: String = ""
  //  var rating: String // deprecata in futuro - sostituire con array di tuple (Voto,Commento)
    var rating: [DishRatingModel] = []

    var status: StatusModel = .vuoto
    
    var ingredientiPrincipali: [IngredientModel] = []
    var ingredientiSecondari: [IngredientModel] = []
    var elencoIngredientiOff: [String:IngredientModel?] = [:]
    
    //var sostituzioneIngredientiTemporanea: [String:String] = [:] // key = idSostituito / value = idSostituto // deprecato - Sostituire con [String:IngredientModel]
    
    var categoriaMenu: CategoriaMenu = .defaultValue
    var pricingPiatto:[DishFormat] = []//[DishFormat(type: .mandatory)]

    var allergeni: [AllergeniIngrediente] = [] // derivati dagli ingredienti // deprecata in futuro - sostituita da un metodo

    var dieteCompatibili:[TipoDieta] = [.standard] // derivate dagli ingredienti // deprecata in futuro - sostituire con un metodo
   

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
        (DishModel(),"Piatto")
    }
    
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        DishModel_RowView(item: self) // conforme al Protocollo
    }

    /// Controlla la presenza dell'idIngrediente sia fra gl iingredienti Principali e Secondari, sia fra i sostituti
    func checkIngredientsIn(idIngrediente:String) -> Bool {
        
        var allSostituti:[IngredientModel] = []
        
        if !self.elencoIngredientiOff.isEmpty {
            
            for (_,ingredient) in self.elencoIngredientiOff {
                
                if ingredient != nil {
                    allSostituti.append(ingredient!)
                }
               
                
            }
        }
 
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allSostituti
        let condition = allTheIngredients.contains(where: {$0.id == idIngrediente })
        
        return condition

    }
    
    /// ritorna solo gli ingredienti Attivi, dunque toglie gli eventuali ingredienti SOSTITUITI e li rimpiazza con i SOSTITUTI
    private func ritornaTuttiGliIngredientiAttivi() -> [IngredientModel] {
        
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari
        
        guard !self.elencoIngredientiOff.isEmpty else {
            return allTheIngredients
        }
        
        var allFinalIngredients = allTheIngredients
    
        for (key,value) in self.elencoIngredientiOff {
            
            if allTheIngredients.contains(where: {$0.id == key}) && value != nil {
                
                let position = allFinalIngredients.firstIndex{$0.id == key}
                allFinalIngredients[position!] = value!
            }
            
        }
        
        
        
      /*  for ingredient in allTheIngredients {
            
            if allTheKeys.contains(ingredient.id) {

                let position = allFinalIngredients.firstIndex{$0.id == ingredient.id}
                self.elencoIngredientiOff[ingredient.id]
                
                if let newOne = self.elencoIngredientiOff[ingredient.id] {
                    allFinalIngredients[position!] = newOne!
                }
            }
        } */
        
        return allFinalIngredients
        
    }
    
    func calcolaAllergeniNelPiatto() -> [AllergeniIngrediente] {
      
        let allIngredients = ritornaTuttiGliIngredientiAttivi()
        var allergeniPiatto:[AllergeniIngrediente] = []
        
             for ingredient in allIngredients {
                 
                 let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni
                 allergeniPiatto.append(contentsOf: allergeneIngre)
             }

            let setAllergeniPiatto = Set(allergeniPiatto)
            let orderedAllergeni = Array(setAllergeniPiatto).sorted { $0.simpleDescription() < $1.simpleDescription() }
        
            return orderedAllergeni
    
     }
    
   /* func filteredByIngrediet(idIngredient:String) -> Bool {
        
     self.ingredientiPrincipali.contains(where: { $0.id == idIngredient }) ||
     self.ingredientiSecondari.contains(where: { $0.id == idIngredient })
     
    } */ // Deprecata - spostata nel viewModel
}


