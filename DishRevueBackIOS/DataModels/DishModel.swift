//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation
import SwiftUI
import Firebase

struct DishModel: MyProToolPack_L1,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1,MyProCloudPack_L1  /*MyModelStatusConformity */ {

    // 06.10 - In abbozzo
  
    
    var percorsoProdotto:PercorsoProdotto = .preparazioneFood
    
    // fine abbozzo 06.10
    
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [DishModel]> {
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
        lhs.percorsoProdotto == rhs.percorsoProdotto &&
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
    
    
    let test = calcolaAllergeniNelPiatto
    
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
    
    init(percorsoProdotto: PercorsoProdotto, id: String, intestazione: String, descrizione: String, rifReviews: [String], ingredientiPrincipali: [String], ingredientiSecondari: [String], elencoIngredientiOff: [String : String], idIngredienteDaSostituire: String? = nil, categoriaMenu: String, mostraDieteCompatibili: Bool, status: StatusModel, pricingPiatto: [DishFormat], categoriaMenuDEPRECATA: CategoriaMenu, dieteCompatibili: [TipoDieta], aBaseDi: OrigineIngrediente) {
        
        self.percorsoProdotto = percorsoProdotto
        self.id = UUID().uuidString
        self.intestazione = intestazione
        self.descrizione = descrizione
        self.rifReviews = rifReviews
        self.ingredientiPrincipali = ingredientiPrincipali
        self.ingredientiSecondari = ingredientiSecondari
        self.elencoIngredientiOff = elencoIngredientiOff
        self.idIngredienteDaSostituire = idIngredienteDaSostituire
        self.categoriaMenu = categoriaMenu
        self.mostraDieteCompatibili = mostraDieteCompatibili
        self.status = status
        self.pricingPiatto = pricingPiatto
        
        self.categoriaMenuDEPRECATA = categoriaMenuDEPRECATA
        self.dieteCompatibili = dieteCompatibili
        self.aBaseDi = aBaseDi
    }
    
    init() {
        self.percorsoProdotto = .preparazioneFood
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = ""
        self.rifReviews = []
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.elencoIngredientiOff = [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = ""
        self.mostraDieteCompatibili = false
        self.status = .bozza()
        self.pricingPiatto = []
        
        self.categoriaMenuDEPRECATA = .defaultValue
        self.dieteCompatibili = [.standard]
        self.aBaseDi = .defaultValue
    }
    
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        let percorsoInt = frDoc[DataBaseField.percorsoProdotto] as? Int ?? 0
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        
        self.percorsoProdotto = DishModel.PercorsoProdotto.convertiInCase(fromNumber: percorsoInt)
        self.id = frDoc.documentID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.rifReviews = frDoc[DataBaseField.rifReviews] as? [String] ?? []
        self.ingredientiPrincipali = frDoc[DataBaseField.ingredientiPrincipali] as? [String] ?? []
        self.ingredientiSecondari = frDoc[DataBaseField.ingredientiSecondari] as? [String] ?? []
        self.elencoIngredientiOff = frDoc[DataBaseField.elencoIngredientiOff] as? [String:String] ?? [:]
        self.idIngredienteDaSostituire = nil
        self.categoriaMenu = frDoc[DataBaseField.categoriaMenu] as? String ?? ""
        self.mostraDieteCompatibili = frDoc[DataBaseField.mostraDieteCompatibili] as? Bool ?? false
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        
        self.pricingPiatto = [] /*[frDoc[DataBaseField.pricingPiatto].map({ docSnap in
            if let snap = docSnap as? QueryDocumentSnapshot {
                DishFormat(frDoc: snap)
            }
        }) as? [DishFormat] ?? []] */ // 20.11 -> capire come fare
        
        self.categoriaMenuDEPRECATA = .defaultValue
        self.dieteCompatibili = [.standard]
        self.aBaseDi = .defaultValue
    }
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
            
            DataBaseField.percorsoProdotto : self.percorsoProdotto.orderAndStorageValue(),
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.rifReviews : self.rifReviews,
            DataBaseField.ingredientiPrincipali : self.ingredientiPrincipali,
            DataBaseField.ingredientiSecondari : self.ingredientiSecondari,
            DataBaseField.elencoIngredientiOff : self.elencoIngredientiOff,
            DataBaseField.categoriaMenu : self.categoriaMenu,
            DataBaseField.mostraDieteCompatibili : self.mostraDieteCompatibili,
            DataBaseField.status : self.status.orderAndStorageValue(),
            DataBaseField.pricingPiatto : self.pricingPiatto.map({$0.documentDataForFirebaseSavingAction()})
 
        ]
        return documentData
    }
    
    struct DataBaseField {
        
        static let percorsoProdotto = "percorsoProdotto"
        static let intestazione = "intestazione"
        static let descrizione = "descrizione"
        static let rifReviews = "rifReview"
        static let ingredientiPrincipali = "ingredientiPrincipali"
        static let ingredientiSecondari = "ingredientiSecondari"
        static let elencoIngredientiOff = "elencoIngredientiOff"
        static let categoriaMenu = "categoriaMenu"
        static let mostraDieteCompatibili = "mostraDieteCompatibili"
        static let status = "status"
        static let pricingPiatto = "pricing"
        
    }
    
    
    //
    
    
    func creaID(fromValue: String) -> String {
        print("DishModel/creaID()")
      return fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // non mi piace
    
    func modelStatusDescription() -> String {
      //  "Piatto (\(self.status.simpleDescription().capitalized))"
        "\(self.percorsoProdotto.simpleDescription()) (\(self.status.simpleDescription().capitalized))"
    }
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [DishModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
       // return (\.allMyDish, "Lista Piatti", "Piatto","fork.knife.circle")
        return (\.allMyDish, "Lista Piatti", self.percorsoProdotto.simpleDescription(),self.percorsoProdotto.imageAssociated())
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
    
    // SearchPack
    
    static func sortModelInstance(lhs: DishModel, rhs: DishModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
        switch condition {
            
  
        case .alfabeticoDecrescente:
            return lhs.intestazione > rhs.intestazione
            
        case .livelloScorte:
            return readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: lhs.id).orderAndStorageValue() <
                readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: rhs.id).orderAndStorageValue()
        case .mostUsed:
            return readOnlyVM.allMenuContaining(idPiatto: lhs.id).countWhereDishIsIn >
            readOnlyVM.allMenuContaining(idPiatto: rhs.id).countWhereDishIsIn
            
        case .mostRated:
            return lhs.rifReviews.count > rhs.rifReviews.count
            
        case .topRated:
            return lhs.topRatedValue(readOnlyVM: readOnlyVM) >
            rhs.topRatedValue(readOnlyVM: readOnlyVM)
            
        case .topPriced:
            return lhs.estrapolaPrezzoMandatoryMaggiore() >
            rhs.estrapolaPrezzoMandatoryMaggiore()
            
        default:
            return lhs.intestazione < rhs.intestazione
        }
    }
    
    
    func modelStringResearch(string: String, readOnlyVM:AccounterVM?) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)
        
        guard readOnlyVM != nil else { return conditionOne } // è inutile percheè passeremo sempre un valore valido. Lo mettiamo per forma. Abbiamo messo il parametro optional per non passarlo negli altri modelli dove non ci serve
        
        let allIngredients = self.allMinusArchiviati(viewModel: readOnlyVM!)
        let allINGMapped = allIngredients.map({$0.intestazione.lowercased()})
        
        let allInGChecked = allINGMapped.filter({$0.contains(ricerca)})
        let conditionTwo = !allInGChecked.isEmpty
        
        return conditionOne || conditionTwo
        // inserire la ricerca degli ingredienti
    }
    
    func modelPropertyCompare(filterProperty: FilterPropertyModel, readOnlyVM: AccounterVM) -> Bool {
        
        let allAllergeniIn = self.calcolaAllergeniNelPiatto(viewModel: readOnlyVM)
        let allDietAvaible = self.returnDietAvaible(viewModel: readOnlyVM).inDishTipologia
        let basePreparazione = self.calcolaBaseDellaPreparazione(readOnlyVM: readOnlyVM)
        
        return self.modelStringResearch(string: filterProperty.stringaRicerca,readOnlyVM: readOnlyVM) &&
        
        filterProperty.comparePropertyToCollection(localProperty: self.percorsoProdotto, filterCollection: \.percorsoPRP) &&
        
        filterProperty.compareStatusTransition(localStatus: self.status) &&
        
        filterProperty.compareCollectionToCollection(localCollection: allAllergeniIn, filterCollection: \.allergeniIn) &&
        
        filterProperty.compareCollectionToCollection(localCollection:allDietAvaible, filterCollection: \.dietePRP)  &&
        
        filterProperty.compareStatoScorte(modelId: self.id, readOnlyVM: readOnlyVM) &&
        
      /*  filterProperty.compareCollectToCollectIntero(localCollection: self.allIngredientsRif(), filterCollection: \.rifIngredientiPRP) && */ // deprecata 04.11
        
        self.preCallHasAllIngredientSameQuality(viewModel: readOnlyVM, kpQuality: \.produzione, quality: filterProperty.produzioneING) &&
        
        self.preCallHasAllIngredientSameQuality(viewModel: readOnlyVM, kpQuality: \.provenienza, quality: filterProperty.provenienzaING) &&
        
        filterProperty.comparePropertyToProperty(local: basePreparazione, filter: \.basePRP)
        
    }
    
    
    // end SearchPack
    
    func returnModelRowView(rowSize:RowSize) -> some View {
        DishModel_RowView(item: self,rowSize: rowSize) // conforme al Protocollo
    }

    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let disabilitaReview = self.rifReviews.isEmpty
        let priceCount = self.pricingPiatto.count
        let currencyCode = Locale.current.currency?.identifier ?? "EUR"
        let (ingredientsCount,ingredientsCantBeExpanded) = countIngredients()
        
        let isDelGiorno = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delGiorno)
        let isDelloChef = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delloChef)

        let isDisponibile = self.status.checkStatusTransition(check: .disponibile)
        
       /* let allMenuWhereIsIn = viewModel.allMyMenu.filter({
            $0.tipologia != .delGiorno &&
            $0.tipologia != .delloChef &&
            $0.rifDishIn.contains(self.id)
        }) */
        
        let(_,allMenuMinusDS,allWhereDishIsIn) = viewModel.allMenuMinusDiSistemaPlusContain(idPiatto: self.id)
        
      return VStack {
            
            Button {
                
                viewModel[keyPath: navigationPath].append(DestinationPathView.recensioni(self))
                
            } label: {
                HStack{
                    Text("Vedi Recensioni")
                    Image(systemName: "eye")
                }
            }.disabled(disabilitaReview)
          
          if priceCount > 1 {
              
              Menu {
             
                 ForEach(self.pricingPiatto,id:\.self) { format in
        
                     let price = Double(format.price) ?? 0
                     Text("\(format.label) : \(price,format: .currency(code: currencyCode))")
                  //   Text("\(format.label) : € \(format.price)")
                  }

                  
              } label: {

                  Text("Prezziario (\(priceCount))")
                
              }// end label menu

          } // end if
          
          // Test 21.09
          
          Button {
              
              viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delGiorno)

          } label: {
              HStack{
                  //Text(isDelGiorno ? "Rimuovi 🍽️ del Giorno" : "Imposta 🍽️ del Giorno")
                /*  let productIcon = self.percorsoProdotto.imageAssociated()
                  
                  Text(isDelGiorno ? "Rimuovi \(productIcon) del Giorno" : "Imposta \(productIcon) del Giorno")*/
                  Text(isDelGiorno ? "[-] dal Menu del Giorno" : "[+] nel Menu del Giorno")
               
                  Image(systemName:isDelGiorno ? "clock.badge.xmark" : "clock.badge.checkmark")
              }
          }.disabled(!isDisponibile)
          
          Button {
              
              viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delloChef)

          } label: {
              HStack{
                  Text(isDelloChef ? "Rimuovi dai consigliati" : "Consigliato dallo 👨🏻‍🍳")
                  Image(systemName:isDelloChef ? "x.circle" : "clock.badge.checkmark")
              }
          }.disabled(!isDisponibile)
          
          Button {
             
              viewModel[keyPath: navigationPath].append(DestinationPathView.vistaMenuEspansa(self))
        
          } label: {
              HStack{
                  Text("Espandi Menu (\(allWhereDishIsIn)/\(allMenuMinusDS))")
                  Image (systemName: "menucard")
              }
          }.disabled(allMenuMinusDS == 0)
          
          if ingredientsCantBeExpanded {
             
              let statoScorte = viewModel.inventarioScorte.statoScorteIng(idIngredient: self.id)
              let ultimoAcquisto = viewModel.inventarioScorte.dataUltimoAcquisto(idIngrediente: self.id)
              
              
              Menu {
                  
                  Button("in Esaurimento") {
                      viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inEsaurimento)
                  }.disabled(statoScorte != .inStock)
                  
                  Button("Esaurite") {
                      viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .esaurito)
                  }.disabled(statoScorte == .esaurito || statoScorte == .inArrivo)
                  
                  if statoScorte == .esaurito || statoScorte == .inEsaurimento {
                      
                      Button("Rimetti in Stock") {
                          viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inStock)
                      }
                  }
                  
                  Text("Ultimo Acquisto:\n\(ultimoAcquisto)")
                  
                  if let ingDS = viewModel.modelFromId(id: self.id, modelPath: \.allMyIngredients) {
                      
                      Button("Cronologia Acquisti") {
                          viewModel[keyPath: navigationPath].append(DestinationPathView.vistaCronologiaAcquisti(ingDS))
                      }
                  }
                  
                  
                  
              } label: {
                  HStack{
                      Text("Scorte \(statoScorte.simpleDescription())")
                      Image(systemName: statoScorte.imageAssociata())
                  }
              }
              
          } else {
              
              Button {
                  
                  viewModel[keyPath: navigationPath].append(DestinationPathView.vistaIngredientiEspansa(self))
            
              } label: {
                  HStack{
                      Text("Espandi Ingredienti (\(ingredientsCount))")
                      Image(systemName:"leaf")
                  }
              }
          }
          
       
          
          
        }

    }
    
    /// conta gli ingredienti secondari e principali
    func countIngredients() -> (count:Int,canBeExpanded:Bool) { // Da sistemare (04.10) // gli ingredienti non posso essere == 0
        let count = (self.ingredientiPrincipali + self.ingredientiSecondari).count
        let cantBe:Bool = {
            count == 0 ||
            self.ingredientiPrincipali.contains(self.id)
        }()
       return (count,cantBe)
    }
  
    /// controlla la presenza di un ingrediente soltanto fra i principali e i secondari
    func checkIngredientsInPlain(idIngrediente:String) -> Bool {
        
        let all = self.ingredientiPrincipali + self.ingredientiSecondari
        let condition = all.contains(where: {$0 == idIngrediente})
        return condition
    }
    
    /// Ritorna tutti i rif degli ingredienti contenuti nel piatto, senza badare allo status, ritorna i principali, i secondari, e i sostituti
    private func allIngredientsRif() -> [String] {
        
        let allIDSostituti = self.elencoIngredientiOff.values
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allIDSostituti
        
        return allTheIngredients
    }
    
    /// Controlla la presenza dell'idIngrediente sia fra gl iingredienti Principali e Secondari, sia fra i sostituti
    func checkIngredientsIn(idIngrediente:String) -> Bool {
        
      /*  let allIDSostituti = self.elencoIngredientiOff.values
   
        let allTheIngredients = self.ingredientiPrincipali + self.ingredientiSecondari + allIDSostituti */
       // let condition = allTheIngredients.contains(where: {$0 == idIngrediente })
        let allTheIngredients = self.allIngredientsRif()
        let condition = allTheIngredients.contains(idIngrediente)
        
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
        
        // Innesto 06.10
        guard !self.ingredientiPrincipali.contains(self.id) else {
           // Trattasi di ibrido
            if let model = viewModel.modelFromId(id: self.id, modelPath: \.allMyIngredients) { return [model] }
            else { return [] }
        }
        
        //
    
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
    
    /// controlla tutti gii ingredienti attivi del piatto, se sono in stock, in arrivo, o in esaurimento. In caso affermativo ritorna true, il piatto è eseguibile
    func controllaSeEseguibile(viewModel:AccounterVM) -> Bool {
        
        let allIngActive = self.allIngredientsAttivi(viewModel: viewModel)
        let mapStock = allIngActive.map({
            viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)
        })
        let filtraStock = mapStock.filter({
            $0 != .esaurito
        })
        
        return allIngActive.count == filtraStock.count
        
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
   /* func areAllIngredientBio(viewModel:AccounterVM) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        
        guard !allIngredient.isEmpty else { return false }
        
        for ingredient in allIngredient {
            if ingredient.produzione == .biologico { continue }
            else { return false }
        }
        return true
    }*/ // 19.10 deprecata - sostituito da una generica
   
    /// ritorna un booleano indicante la presenza o meno di ingredienti congelati/surgelati
   /* func areAllIngredientFreshOr(viewModel:AccounterVM) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        
        guard !allIngredient.isEmpty else { return true }
        
        for ingredient in allIngredient {
            if ingredient.conservazione == .altro { continue }
            else { return false }
        }
        return true
    }*/ // 19.10 deprecata - sostituito da una generica
    
    private func preCallHasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:AccounterVM,kpQuality:KeyPath<IngredientModel,T>,quality:T?) -> Bool {
        
        guard quality != nil else { return true }
        
       return self.hasAllIngredientSameQuality(viewModel: viewModel, kpQuality: kpQuality, quality: quality!)
        
    }
    
    func hasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:AccounterVM,kpQuality:KeyPath<IngredientModel,T>,quality:T) -> Bool {
        
        let allIngredient = self.allIngredientsAttivi(viewModel: viewModel)
        guard !allIngredient.isEmpty else { return false }
        
        for ingredient in allIngredient {
            if ingredient[keyPath: kpQuality] == quality { continue }
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
    
    /// Calcola se la preparazione è a base di carne, pesce, o verdure
    func calcolaBaseDellaPreparazione(readOnlyVM:AccounterVM) -> BasePreparazione {
        
        let allING = self.allIngredientsAttivi(viewModel: readOnlyVM)
        let allInGMapped = allING.map({$0.origine})
        
        guard allInGMapped.contains(.animale) else { return .vegetale }
        
        let allergeneIn = allING.map({$0.allergeni})
        
        for arrAll in allergeneIn {
            
            if arrAll.contains(where: {
                $0 == .pesce ||
                $0 == .molluschi ||
                $0 == .crostacei
            }) { return .pesce }
            else { continue }
        }
    
        return .carne
        
    }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.mostraDieteCompatibili &&
        !self.ingredientiPrincipali.isEmpty
       
    }
    
    /// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse come Int, e un array con i modelli delle recensioni
    func ratingInfo(readOnlyViewModel:AccounterVM) -> (media:Double,count:Int,allModelReview:[DishRatingModel]) {
        
     //   let allLocalReviews:[DishRatingModel] = viewModel.allMyReviews.filter({$0.idPiatto == self.id}) // vedi nota vocale 13.09

        let allLocalReviews:[DishRatingModel] = readOnlyViewModel.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
        guard !allLocalReviews.isEmpty else {
            
            return (0.0,0,[])
        }
        
        let ratingCount: Int = allLocalReviews.count // item.rating.count
        //let stringCount = String(ratingCount)
        
        // calcolo media Ponderata

      /*  var sommaVoti: Double = 0.0
        var sommaPesi: Double = 0.0
        
        for review in allLocalReviews {
            
         //   if let voto = Double(rating.voto) { sommaVoti += voto }
            let(voto,peso) = review.votoEPeso()
            sommaVoti += (voto * peso)
            sommaPesi += peso
        }
        
        let mediaPonderata = sommaVoti / sommaPesi
        */
       let mediaPonderata = csCalcoloMediaRecensioni(elementi: allLocalReviews)
      //  mediaInString = String(format:"%.1f", mediaPonderata)
        
        return (mediaPonderata,ratingCount,allLocalReviews)
        
    }
    
    /// Torna un valore da usare per ordinare i model nella classifica TopRated. In questo caso torna il peso delle recensioni, ossia la media ponderata per il numero di recensioni
    func topRatedValue(readOnlyVM:AccounterVM) -> Double {
        
        let (media,count,_) = self.ratingInfo(readOnlyViewModel:readOnlyVM)
       
        return (media * Double(count))
     
    }
    
  
    func estrapolaPrezzoMandatoryMaggiore() -> Double {
        
        guard let labelPrice = self.pricingPiatto.first(where: {$0.type == .mandatory}) else { return 0.0 }
        let price = Double(labelPrice.price) ?? 0.0
        return price
        
    }
    
    /// Torna il numero di recensioni, il numero rilasciato nelle 24h, la media generale, e la media delle ultime 10
    /*func ratingInfoPlus(readOnlyVM:AccounterVM) -> (totali:Int,l24:Int,mediaGen:Double,ml10:Double) {
        
        let currentDate = Date()
        let totalCount = self.rifReviews.count //.0
        
        let allRevModel = readOnlyVM.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
        let last24Count = allRevModel.filter({
            $0.dataRilascio < currentDate &&
            $0.dataRilascio > currentDate.addingTimeInterval(-86400)
        }).count // .1
 
        let reviewByDate = allRevModel.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        let onlyLastTen = reviewByDate.prefix(10)
        let onlyL10 = Array(onlyLastTen)
        
        let mediaGeneralePonderata = csCalcoloMediaRecensioni(elementi: allRevModel) //.2
        let mediaL10 = csCalcoloMediaRecensioni(elementi: onlyL10) //.3
        
        return (totalCount,last24Count,mediaGeneralePonderata,mediaL10)
    } */// 21.10 deprecata perchè sostituita con una gemella nel viewModel
    
  /*  func ratingInfoRange(readOnlyVM:AccounterVM) -> (negative:Int,positive:Int,top:Int,complete:Int,trend:Int,trendComplete:Int){
        
        let allRev = readOnlyVM.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
        let allVote = allRev.compactMap({Double($0.voto)})
        
        let negative = allVote.filter({$0 < 6.0}).count//.0
        let positive = allVote.filter({$0 >= 6.0}).count//.1
        let topRange = allVote.filter({$0 >= 9.0}).count //.2
        
        let complete = allRev.filter({
            $0.image != "" &&
            $0.titolo != "" &&
            $0.commento != ""
        }).count //.3
        
        // Analisi ultime 10 per indicare il trend
       
        let allByDate = allRev.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        let lastTen = allByDate.prefix(10)
        let lastTenArray = Array(lastTen)
        
        let l10AllVote = lastTenArray.compactMap({Double($0.voto)})
        
        let l10negative = l10AllVote.filter({$0 < 6.0}).count//.0
        let l10positive = l10AllVote.filter({$0 >= 6.0}).count//.1
        let l10topRange = l10AllVote.filter({$0 >= 9.0}).count //.2
        
        var trendValue:Int = 0 // 1 is Negativo / 5 is Positivo / 10 is Top Range
        
        if l10negative > l10positive { trendValue = 1 }
        else if l10positive > l10negative {
            
            let value = Double(l10topRange) / Double(l10positive)
            
            if value >= 0.5 { trendValue = 10 }
            else { trendValue = 5}
        }
        
        let l10Complete = lastTenArray.filter({
            $0.image != "" &&
            $0.titolo != "" &&
            $0.commento != ""
        }).count
        
        let completeFraLast10 = Double(l10Complete) / Double(lastTenArray.count)
        
        var trendComplete = 1
        if completeFraLast10 >= 0.5 { trendComplete = 2 }
        // trend completezza 1 negativo 2 positivo
        return (negative,positive,topRange,complete,trendValue,trendComplete)
    }*/ //deprecata 21.10 - messa nel viewModel. Un metodo unico per analizzare il singolo piatto e l'intero comparto recensioni
    
    
    enum BasePreparazione:MyProEnumPack_L0 {

        static var allCase:[BasePreparazione] = [.vegetale,.carne,.pesce]
        
        case vegetale,carne,pesce
        
        func simpleDescription() -> String {
            
            switch self {
            case .vegetale:
                return "Verdure"
            case .carne:
                return "Carne"
            case .pesce:
                return "Pesce"
            }
        }
        
        func returnTypeCase() -> DishModel.BasePreparazione {
           return self
        }

        func orderAndStorageValue() -> Int {
            return 0
        }
        
        func imageAssociate() -> String {
            
            switch self {
            case .vegetale:
                return "🥗"
            case .carne:
                return "🥩"
            case .pesce:
                return "🍤"
            }

        }
    }
    
    enum PercorsoProdotto:MyProEnumPack_L0,MyProCloudPack_L0 {

        static var allCases:[PercorsoProdotto] = [.preparazioneFood,.preparazioneBeverage,.prodottoFinito]
        
        case prodottoFinito //= "Prodotto Finito"
        case preparazioneFood //= "Piatto" // case standard di default
        case preparazioneBeverage //= "Drink"
        
        func imageAssociated() -> String {
            switch self {
            case .prodottoFinito:
                return "🧃"
            case .preparazioneFood:
                return "fork.knife.circle"
            case .preparazioneBeverage:
                return "wineglass"
                
            }
        }
        
        func simpleDescription() -> String {
            
            switch self {
                
            case .prodottoFinito:
                return "Prodotto Finito"
            case .preparazioneFood:
                return "Piatto"
            case .preparazioneBeverage:
                return "Drink"
                
            }
            
        }
        
        func returnTypeCase() -> DishModel.PercorsoProdotto {
            self
        }
        
        func orderAndStorageValue() -> Int {
            
            switch self {
                
            case .prodottoFinito:
                return 0
            case .preparazioneFood:
                return 1
            case .preparazioneBeverage:
                return 2
                
            }
        }
        
        static func convertiInCase(fromNumber: Int) -> DishModel.PercorsoProdotto {
            
            switch fromNumber {
            case 0: return .prodottoFinito
            case 1: return .preparazioneFood
            case 2: return .preparazioneBeverage
            default: return .preparazioneFood
            }
        }
        
      /*  func informalDescription() -> String {
            
            switch self {
                
            case .prodottoFinito:
                return "Prodotto in rivendita"
            case .preparazioneFood:
                return "Preparazione food"
            case .preparazioneBeverage:
                return "Preparazione beverage"
                
            }
            
        }*/
        
        func extendedDescription() -> String {
            
            switch self {
            case .prodottoFinito:
                return "Trattasi di un prodotto pronto che non richiede altri ingredienti per essere servito"
            default:
                return "E' il frutto della combinazione e/o lavorazione di uno o più ingredienti"
            }
        }
    }
    
}


