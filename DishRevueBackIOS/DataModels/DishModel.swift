//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation
import SwiftUI

struct DishModel: MyProToolPack_L0,MyProVisualPack_L0,MyProDescriptionPack_L0,MyProStatusPack_L1   /*MyModelStatusConformity */ {
    
    static func viewModelContainerStatic() -> ReferenceWritableKeyPath<AccounterVM, [DishModel]> {
        return \.allMyDish
    }
    
   static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.status == rhs.status &&
        lhs.rifReviews == rhs.rifReviews &&
       // lhs.rating == rhs.rating &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.elencoIngredientiOff == rhs.elencoIngredientiOff &&
        lhs.idIngredienteDaSostituire == rhs.idIngredienteDaSostituire &&
        lhs.categoriaMenuDEPRECATA == rhs.categoriaMenuDEPRECATA &&
        lhs.categoriaMenu == rhs.categoriaMenu &&
      //  lhs.allergeni == rhs.allergeni &&
        lhs.dieteCompatibili == rhs.dieteCompatibili &&
        lhs.mostraDieteCompatibili == rhs.mostraDieteCompatibili &&
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
  //  var rating: [DishRatingModel] = [] // deprecata 13.09
    var rifReviews: [String] = [] // sostituisce il [DishRatingModel] con dei riferimenti allo stesso - vedi nota vocale 13.09

   
    
  //  var ingredientiPrincipaliDEPRECATO: [IngredientModel] = [] // deprecato in futuro (conclusa deprecazione il 29.08) - Sostituito dal riferimento
  //  var ingredientiSecondariDEPRECATO: [IngredientModel] = [] // deprecato in futuro (conclusa deprecazione il 29.08) - Sostituito dal riferimento
   // var elencoIngredientiOffDEPRECATO: [String:IngredientModel?] = [:] // deprecato in futuro(29.08 untill 31.08 ) - sostituire con String:String?
    
    var ingredientiPrincipali: [String] = [] // id IngredientModel
    var ingredientiSecondari: [String] = [] // id IngredientModel
    var elencoIngredientiOff: [String:String] = [:] // id Sostituito: idSOSTITUTO
    var idIngredienteDaSostituire: String? // è una proprietà di servizio che ci serve a bypassare lo status di inPausa per tranciare un ingrediente che probabilmente andrà sostituito. Necessario perchè col cambio da Model a riferimento nella View delle sostituzioni la visualizzazione dell'ingrediente da sostituire richiederebbe il cambio di status e dunque un pò di macello. Vedi Nota Vocale 30.08
    
    var categoriaMenu: String = "" // riferimento della CategoriaMenu
   
    var mostraDieteCompatibili: Bool = false
    
    // deprecate
    
    var status: StatusModel = .bozza() // deprecata in futuro per passaggio ai riferimenti
    var pricingPiatto:[DishFormat] = []//[DishFormat(type: .mandatory)] // deprecata in futuro per passaggio ai riferimenti
  //  var allergeni: [AllergeniIngrediente] = [] // derivati dagli ingredienti // deprecata in futuro - sostituita da un metodo // deprecata 12.09
    var categoriaMenuDEPRECATA: CategoriaMenu = .defaultValue // deprecata in futuro
    var dieteCompatibili:[TipoDieta] = [.standard] // derivate dagli ingredienti // deprecata in futuro - sostituire con un metodo
    var aBaseDi:OrigineIngrediente = .defaultValue // da implementare || derivata dagli ingredienti // deprecata in futuro
    
    // end deprecate
    
    
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
    
    func viewModelContainerInstance() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM, [DishModel]>, nomeContainer: String, nomeOggetto:String) {
        
        return (\.allMyDish, "Lista Piatti", "Piatto")
    }
       
    func pathDestination() -> DestinationPathView {
        DestinationPathView.piatto(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
   /* func returnModelTypeName() -> String {
        "Piatto"
    } */ // deprecata
    
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        DishModel_RowView(item: self) // conforme al Protocollo
    }

    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let disabilita = self.rifReviews.isEmpty
        let priceCount = self.pricingPiatto.count
        
      return VStack {
            
            Button {
                
                viewModel[keyPath: navigationPath].append(DestinationPathView.recensioni(self))
                
            } label: {
                HStack{
                    Text("Vedi Recensioni")
                    Image(systemName: "eye")
                }
            }.disabled(disabilita)
          
          if priceCount > 1 {
              
              Menu {
             
                 ForEach(self.pricingPiatto,id:\.self) { format in
        
                    // let price = Double(format.price) ?? 0
                    // Text("\(format.label) : \(price,format: .currency(code: "EUR"))")
                     Text("\(format.label) : € \(format.price)")
                  }
                  
              } label: {

                  Text("Prezzi (\(priceCount))")
                
              }// end label menu

          } // end if
          
            
        }

    }
    /// controlla la presenza di un ingrediente soltanto fra i principali e i secondari
    func checkIngredientsInPlain(idIngrediente:String) -> Bool {
        
        let all = self.ingredientiPrincipali + self.ingredientiSecondari
        let condition = all.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// Controlla la presenza dell'idIngrediente sia fra gl iingredienti Principali e Secondari, sia fra i sostituti
    func checkIngredientsIn(idIngrediente:String) -> Bool {
        
        let allIDSostituti = self.elencoIngredientiOff.values
   
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allIDSostituti
        let condition = allTheIngredients.contains(where: {$0 == idIngrediente })
        
        return condition

    }
    
    /// controlla se un ingrediente ha un sostituto, ovvero se esiste la chiave a suo nome nell'elencoIngredientiOff
    func checkIngredientHasSubstitute(idIngrediente:String) -> Bool {
        
        let allSostituiti = self.elencoIngredientiOff.keys
        let condition = allSostituiti.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// ritorna il path dell'ingrediente, quindi o l'array di ingredienti principali, o quello dei secondari, o se assente in entrambi ritorna nil
     func individuaPathIngrediente(idIngrediente:String) -> (path:WritableKeyPath<Self,[String]>?,index:Int?) {
        
        if let index = self.ingredientiPrincipali.firstIndex(of: idIngrediente) {
            
            return (\.ingredientiPrincipali,index)
            
        } else if let index = self.ingredientiSecondari.firstIndex(of: idIngrediente) {
            
            return(\.ingredientiSecondari,index)
            
        } else { return (nil,nil)}
        
    }
    
   /* func sostituzionePermanenteIngrediente(idDaSostituire:String) {
        
        guard let pathIngrediente = self.individuaPathIngrediente(idIngrediente: idDaSostituire) else { return }
        
        let index = self[keyPath: pathIngrediente].firstIndex(of: idDaSostituire)
        
        if let sostituto = self.elencoIngredientiOff[idDaSostituire] {
            
            
            
        } else {
            
            self[keyPath: pathIngrediente].remove(at: index!)
            
        }
        
        
    } */
    /*
    /// ritorna solo gli ingredienti Attivi, dunque toglie gli eventuali ingredienti SOSTITUITI e li rimpiazza con i SOSTITUTI
    private func ritornaTuttiGliIngredientiAttivi() -> [IngredientModel] {
        
        let allTheIngredients = self.ingredientiPrincipaliDEPRECATO + self.ingredientiSecondariDEPRECATO
        
        guard !self.elencoIngredientiOffDEPRECATO.isEmpty else {
            return allTheIngredients
        }
        
        var allFinalIngredients = allTheIngredients
    
        for (key,value) in self.elencoIngredientiOffDEPRECATO {
            
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
        
    } */ // deprecata 26.08
    
    /// ritorna gli ingredienti meno le bozze e gli archiviati. Comprende i completi(.pubblici) e i completi(.inPausa)
    func allMinusArchiviati(viewModel:AccounterVM) -> [IngredientModel] {
        
        let allIngredientsID = self.ingredientiPrincipali + self.ingredientiSecondari
        let allTheIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIngredientsID, modelPath: \.allMyIngredients)
        let allMinusBozzeEArchiviati = allTheIngredients.filter({
          // !$0.status.checkStatusTransition(check: .archiviato)
            !$0.status.checkStatusTransition(check: .archiviato)
           /* $0.status != .completo(.archiviato) &&
            $0.status != .bozza() */
        })
        
        return allMinusBozzeEArchiviati
    }
    
    /// ritorna gli ingredienti Attivi sostituendo gli ingredienti inPausa con gli eventuali sostituti
    func allIngredientsAttivi(viewModel:AccounterVM) -> [IngredientModel] {
        
        let allMinusBozzeEArchiviati = allMinusArchiviati(viewModel: viewModel)

        let allInPausa = allMinusBozzeEArchiviati.filter({
            $0.status.checkStatusTransition(check: .inPausa)
            })
        
        guard !allInPausa.isEmpty else { return allMinusBozzeEArchiviati }
        
        guard !self.elencoIngredientiOff.isEmpty else {
            return allMinusBozzeEArchiviati.filter({
                $0.status.checkStatusTransition(check: .disponibile)
            })
        }
        
        var allActiveIDs = allMinusBozzeEArchiviati.map({$0.id})
        
        for ingredient in allInPausa {
            
            let position = allActiveIDs.firstIndex{$0 == ingredient.id}
            
            if let sostituto = self.elencoIngredientiOff[ingredient.id] {
                
                let(isActive,_,_) = viewModel.infoFromId(id: sostituto, modelPath: \.allMyIngredients)
                
                if isActive {
                    allActiveIDs[position!] = sostituto
                } else { allActiveIDs.remove(at: position!)}
                
            } else { allActiveIDs.remove(at: position!)}
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.allMyIngredients)
        
        return allActiveModels
    }
    
 /*
    /// ritorna gli ingredienti Attivi sostituendo gli ingredienti inPausa con gli eventuali sostituti
    func allIngredientsAttivi(viewModel:AccounterVM) -> [IngredientModel] {
        
        let allMinusBozzeEArchiviati = allMinusBozzeEArchiviati(viewModel: viewModel)

        let allInPausa = allMinusBozzeEArchiviati.filter({
            $0.status.checkStatusTransition(check: .inPausa)
          //  $0.status == .completo(.inPausa)
            })
        
        guard !allInPausa.isEmpty else { return allMinusBozzeEArchiviati }
        
        let onlyAvaible = allMinusBozzeEArchiviati.filter({!allInPausa.contains($0)})
        
        guard !self.elencoIngredientiOff.isEmpty else {return onlyAvaible}
                
        var allActiveIDs = allMinusBozzeEArchiviati.map({$0.id})
    
        for (key,value) in self.elencoIngredientiOff {
            
            if allInPausa.contains(where: {$0.id == key}) {
                
                let(isActive,_,_) = viewModel.infoFromId(id: value, modelPath: \.allMyIngredients)
                let position = allActiveIDs.firstIndex{$0 == key}
                
                if isActive {
                    allActiveIDs[position!] = value
                } else { allActiveIDs.remove(at: position!)}
                
            }
            
        }
        
        let allActiveModels = viewModel.modelCollectionFromCollectionID(collectionId: allActiveIDs, modelPath: \.allMyIngredients)
        
        return allActiveModels
        
    } */ //backUp 12.09 -> per semplificazione e migliorie
    /// ritorna un booleano indicante la presenza o meno di tutti ingredienti Bio
    func areAllIngredientBio(viewModel:AccounterVM) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        
        guard !allIngredient.isEmpty else { return false }
        
        for ingredient in allIngredient {
            if ingredient.produzione == .biologico { continue }
            else { return false }
        }
        return true
    }
   
    /// ritorna un booleano indicante la presenza o meno di ingredienti congelati/surgelati
    func areAllIngredientFreshOr(viewModel:AccounterVM) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        
        guard !allIngredient.isEmpty else { return false }
        
        for ingredient in allIngredient {
            if ingredient.conservazione == .altro { continue }
            else { return false }
        }
        return true
    }
    
    /*
    /// ritorna solo gli ingredienti Attivi, dunque toglie gli eventuali ingredienti SOSTITUITI e li rimpiazza con i SOSTITUTI
    private func allIDIngredientiAttivi() -> [String] {
        
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari
        
        guard !self.elencoIngredientiOff.isEmpty else {
            return allTheIngredients
        }
        
        var allFinalIngredients = allTheIngredients
    
        for (key,value) in self.elencoIngredientiOff {
            
            if allTheIngredients.contains(where: {$0 == key}) && value != nil {
                
                let position = allFinalIngredients.firstIndex{$0 == key}
                allFinalIngredients[position!] = value!
            }
            
        }
        
        return allFinalIngredients
        
    }*/ // deprecata 30.08 -> Trasformata per ritornare un array di IngredientModel attivi
     
    func calcolaAllergeniNelPiatto(viewModel:AccounterVM) -> [AllergeniIngrediente] {
      
        // modifica 30.08
       // let allIDIngredient = allIDIngredientiAttivi()
        
       // let allIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIDIngredient, modelPath: \.allMyIngredients)
        let allIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        
        // end 30.08
        var allergeniPiatto:[AllergeniIngrediente] = []
        
             for ingredient in allIngredients {
                 
                 let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni
                 allergeniPiatto.append(contentsOf: allergeneIngre)
             }

            let setAllergeniPiatto = Set(allergeniPiatto)
            let orderedAllergeni = Array(setAllergeniPiatto).sorted { $0.simpleDescription() < $1.simpleDescription() }
        
            return orderedAllergeni
    
     }
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
    func returnDietAvaible(viewModel:AccounterVM) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {

        // step 0
        // Modifica 30.08
      //  let allIDIngredient = self.allIDIngredientiAttivi()
        
       // let allModelIngredients = viewModel.modelCollectionFromCollectionID(collectionId: allIDIngredient, modelPath: \.allMyIngredients)
        
        let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        // end 30.08
        // step 1 ->
        
        var animalOrFish: [IngredientModel] = []
        var milkIn: [IngredientModel] = []
        var glutenIn: [IngredientModel] = []
        
        for ingredient in allModelIngredients {
            
            if ingredient.origine == .animale {
                
                if ingredient.allergeni.contains(.latte_e_derivati) { milkIn.append(ingredient) }
                
                else { animalOrFish.append(ingredient) }
                        }

            if ingredient.allergeni.contains(.glutine) { glutenIn.append(ingredient)}
        }
        
        // step 2 -->
        
        var dieteOk:[TipoDieta] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
        
        if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
        else if milkIn.isEmpty { dieteOk.append(.vegariano)}
        else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
        else {dieteOk.append(.standard) }
 
        var dieteOkInStringa:[String] = []
 
        for diet in dieteOk {
            
            let stringDiet = diet.simpleDescription()
            dieteOkInStringa.append(stringDiet)
       
        }
    
        return (dieteOk,dieteOkInStringa)
    }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.mostraDieteCompatibili &&
        !self.ingredientiPrincipali.isEmpty
       
    }
    
    /// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse sempre in Stringa, e un array con i modelli delle recensioni
    func ratingInfo(readOnlyViewModel:AccounterVM) -> (media:String,count:String,allModelReview:[DishRatingModel]) {
        
     //   let allLocalReviews:[DishRatingModel] = viewModel.allMyReviews.filter({$0.idPiatto == self.id}) // vedi nota vocale 13.09

        let allLocalReviews:[DishRatingModel] = readOnlyViewModel.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
        var sommaVoti: Double = 0.0
        var mediaRating: String = "0.00"
        
        let ratingCount: Int = allLocalReviews.count // item.rating.count
        let stringCount = String(ratingCount)
        
        guard !allLocalReviews.isEmpty else {
            
            return (mediaRating,stringCount,allLocalReviews)
        }
        
        for rating in allLocalReviews {
            
            if let voto = Double(rating.voto) { sommaVoti += voto }
            
        }
        
        let mediaAritmetica = sommaVoti / Double(ratingCount)
        mediaRating = String(format:"%.1f", mediaAritmetica)
        return (mediaRating,stringCount,allLocalReviews)
        
    }
    
}


