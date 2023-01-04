//
//  DishModelExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import MyFilterPackage

extension DishModel:
    MyProToolPack_L1,
    MyProVisualPack_L1,
    MyProDescriptionPack_L0 {
   
    public typealias VM = AccounterVM
  // public typealias FPM = FilterPropertyModel
   // public typealias ST = StatusTransition
    public typealias DPV = DestinationPathView
    public typealias RS = RowSize
   // public typealias SM = StatusModel

   /* public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
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
        
        // Test
      
        
        //
        
        return documentData
    } */

    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [DishModel]> {
        return \.allMyDish
    }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [DishModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
         return (
            \.allMyDish, "Lista Piatti",
             self.percorsoProdotto.simpleDescription(),
             self.percorsoProdotto.imageAssociated()
         )
     }
    
    public func modelStatusDescription() -> String {
        "\(self.percorsoProdotto.simpleDescription()) (\(self.status.simpleDescription().capitalized))"
    }
        
    public func returnModelRowView(rowSize:RowSize) -> some View {
        DishModel_RowView(item: self,rowSize: rowSize)
    }
    
    public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let generalDisabled = self.status.checkStatusTransition(check: .archiviato)
        
        let disabilitaReview = self.rifReviews.isEmpty
        let priceCount = self.pricingPiatto.count
        let currencyCode = Locale.current.currency?.identifier ?? "EUR"
        let (ingredientsCount,ingredientsCantBeExpanded) = countIngredients()
        
        let isDelGiorno = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delGiorno)
        let isDelloChef = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delloChef)

        let isDisponibile = self.status.checkStatusTransition(check: .disponibile)

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

          Button {
              
              viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delGiorno)

          } label: {
              HStack{
                  
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
                     // innsesto 01.12.22
                      if self.status.checkStatusTransition(check: .disponibile) {
                          
                          viewModel.alertItem = AlertModel(
                            title: "Update Status Prodotto",
                            message: "Clicca su conferma se desideri porre il prodotto - \(self.intestazione) - nello status di - in Pausa -\nI Menu che contengono il prodotto potrebbero subire anch'essi modifiche di status.",
                            actionPlus: ActionModel(
                                title: .conferma,
                                action: {
                                    self.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                                }))
                      }
                      
                      
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
      .disabled(generalDisabled)
    }
    
    public func conditionToManageMenuInterattivo() -> (disableCustom: Bool, disableStatus: Bool, disableEdit: Bool, disableTrash: Bool, opacizzaAll: CGFloat) {
        
        if self.status.checkStatusTransition(check: .disponibile) {
              
              return (false,false,false,true,1.0)
          }
          
          else if self.status.checkStatusTransition(check: .inPausa) {
              
              return (false,false,false,true,0.8)
          }
          
          else {
              return (true,false,true,false,0.5)
          }
          
      }
    
    public func pathDestination() -> DestinationPathView {
        DestinationPathView.piatto(self)
    }
    
    public func manageCambioStatus(nuovoStatus: StatusTransition, viewModel: AccounterVM) {
        //Nota 27.11 // Nota 28.11
    let isCurrentlyDisponibile = self.status.checkStatusTransition(check: .disponibile)
    viewModel.manageCambioStatusModel(model: self, nuovoStatus: nuovoStatus)
  //  viewModel.remoteStorage.modelRif_modified.insert(self.id)
    
    guard isCurrentlyDisponibile else { return }

    let allMenuWithDish = viewModel.allMenuContaining(idPiatto: self.id)
    
    for eachMenu in allMenuWithDish.allModelWithDish {
        if eachMenu.status.checkStatusTransition(check: .disponibile) {
            eachMenu.autoManageCambioStatus(viewModel: viewModel,idPiattoEscluso: self.id)
          //  eachMenu.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
        }
    }
}
    
    public func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:AccounterVM) -> Bool { false }
    
   /* public func modelStringResearch(string: String, readOnlyVM:AccounterVM?) -> Bool {
        
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
    }  // deprecata 22.12 da cancellare
    
    public func modelPropertyCompare(filterProperty: FilterPropertyModel, readOnlyVM: AccounterVM) -> Bool {
        
        let allAllergeniIn = self.calcolaAllergeniNelPiatto(viewModel: readOnlyVM)
        let allDietAvaible = self.returnDietAvaible(viewModel: readOnlyVM).inDishTipologia
        let basePreparazione = self.calcolaBaseDellaPreparazione(readOnlyVM: readOnlyVM)
        
        return self.modelStringResearch(string: filterProperty.stringaRicerca,readOnlyVM: readOnlyVM) && //
        
        filterProperty.comparePropertyToCollection(localProperty: self.percorsoProdotto, filterCollection: \.percorsoPRP) && //
        
        filterProperty.compareStatusTransition(localStatus: self.status) && //
        
        filterProperty.compareCollectionToCollection(localCollection: allAllergeniIn, filterCollection: \.allergeniIn) && //
        
        filterProperty.compareCollectionToCollection(localCollection:allDietAvaible, filterCollection: \.dietePRP)  && //
        
        filterProperty.compareStatoScorte(modelId: self.id, readOnlyVM: readOnlyVM) && //
        
        self.preCallHasAllIngredientSameQuality(viewModel: readOnlyVM, kpQuality: \.produzione, quality: filterProperty.produzioneING) &&
        
        self.preCallHasAllIngredientSameQuality(viewModel: readOnlyVM, kpQuality: \.provenienza, quality: filterProperty.provenienzaING) &&
        
        filterProperty.comparePropertyToProperty(local: basePreparazione, filter: \.basePRP) //
        
    } // deprecata 22.12 da cancellare
    
    public static func sortModelInstance(lhs: DishModel, rhs: DishModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
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
    }*/ // deprecata 22.12 da cancellare
    
    public func manageModelDelete(viewModel: AccounterVM) {
        
        let allMenuWithDish = viewModel.allMenuContaining(idPiatto: self.id)
        
        guard allMenuWithDish.countWhereDishIsIn != 0 else {
            
            viewModel.deleteItemModel(itemModel: self)
            return
            
        }
        
        var allCleanedMenu:[MenuModel] = []
        for eachMenu in allMenuWithDish.allModelWithDish {
            
            var new = eachMenu
            
            if eachMenu.status.checkStatusTransition(check: .disponibile) {
                new.autoManageCambioStatus(viewModel: viewModel, idPiattoEscluso: self.id)
            }
            new.rifDishIn.removeAll(where: {$0 == self.id})
            
           /* if new.rifDishIn.isEmpty { new.status = eachMenu.status.changeStatusTransition(changeIn: .inPausa)} */
            allCleanedMenu.append(new)
            
        }
        viewModel.updateItemModelCollection(items: allCleanedMenu)
        viewModel.deleteItemModel(itemModel: self)
    }
    
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
    } // 31.12.22 Spostata nel Package
    
    /// ritorna gli ingredienti Attivi sostituendo gli ingredienti inPausa con gli eventuali sostituti
    func allIngredientsAttivi(viewModel:AccounterVM) -> [IngredientModel] {
        
        // Innesto 06.10
        guard !self.ingredientiPrincipali.contains(self.id) else {
           // Trattasi di ibrido
            if let model = viewModel.modelFromId(id: self.id, modelPath: \.allMyIngredients) { return [model] }
            else { return [] }
        }
        
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
    } //02.01.23 ricollocata in MyFoodiePackage
    
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
    }// 02.01.23 ricollata in MyFoodiePackage
    
    func calcolaAllergeniNelPiatto(viewModel:AccounterVM) -> [AllergeniIngrediente] {
      
        let allIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        var allergeniPiatto:[AllergeniIngrediente] = []
        
             for ingredient in allIngredients {
                 
                 let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni
                 allergeniPiatto.append(contentsOf: allergeneIngre)
             }

            let setAllergeniPiatto = Set(allergeniPiatto)
            let orderedAllergeni = Array(setAllergeniPiatto).sorted { $0.simpleDescription() < $1.simpleDescription() }
        
            return orderedAllergeni
    
     } // 02.01.23 Ricollocata in MyFoodiePackage
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
    func returnDietAvaible(viewModel:AccounterVM) -> (inDishTipologia:[TipoDieta],inStringa:[String]) {
        
        let allModelIngredients = self.allIngredientsAttivi(viewModel: viewModel)
        
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
        
    } // 02.01.23 Spostata in MyFoodiePackage
    
    /// Ritorna la media in forma di stringa delle recensioni di un Piatto, e il numero delle stesse come Int, e un array con i modelli delle recensioni
    func ratingInfo(readOnlyViewModel:AccounterVM) -> (media:Double,count:Int,allModelReview:[DishRatingModel]) {
        
        // Nota 13.09

        let allLocalReviews:[DishRatingModel] = readOnlyViewModel.modelCollectionFromCollectionID(collectionId: self.rifReviews, modelPath: \.allMyReviews)
        
        guard !allLocalReviews.isEmpty else {
            
            return (0.0,0,[])
        }
        
        let ratingCount: Int = allLocalReviews.count // item.rating.count
        let mediaPonderata = csCalcoloMediaRecensioni(elementi: allLocalReviews)
 
        return (mediaPonderata,ratingCount,allLocalReviews)
        
    }
    
    /// Torna un valore da usare per ordinare i model nella classifica TopRated. In questo caso torna il peso delle recensioni, ossia la media ponderata per il numero di recensioni
    func topRatedValue(readOnlyVM:AccounterVM) -> Double {
        
        let (media,count,_) = self.ratingInfo(readOnlyViewModel:readOnlyVM)
       
        return (media * Double(count))
     
    }
    
}

extension DishModel: Object_FPC {
        
  //  public typealias VM = AccounterVM
    public static func sortModelInstance(lhs: DishModel, rhs: DishModel, condition: SortCondition?, readOnlyVM: VM) -> Bool {
        
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
    
    public func stringResearch(string: String, readOnlyVM: VM?) -> Bool {
        
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
    
    public func propertyCompare(coreFilter:CoreFilter<Self>, readOnlyVM: VM) -> Bool {
        
        let allAllergeniIn = self.calcolaAllergeniNelPiatto(viewModel: readOnlyVM)
        let allDietAvaible = self.returnDietAvaible(viewModel: readOnlyVM).inDishTipologia
        let basePreparazione = self.calcolaBaseDellaPreparazione(readOnlyVM: readOnlyVM)
        
       // let core = filterProperties.coreFilter
        
      //  return
        
      //  !self.status.checkStatusBozza() && // pre Condizione
        let properties = coreFilter.filterProperties
        
       return self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: readOnlyVM) &&
        
        coreFilter.comparePropertyToCollection(localProperty: self.percorsoProdotto, filterCollection: properties.percorsoPRP) &&
        
        coreFilter.compareCollectionToCollection(localCollection: allAllergeniIn, filterCollection: properties.allergeniIn) &&
        
        coreFilter.compareCollectionToCollection(localCollection: allDietAvaible, filterCollection: properties.dietePRP) &&
        
        coreFilter.comparePropertyToProperty(localProperty: basePreparazione, filterProperty: properties.basePRP) &&
        
        coreFilter.compareStatusTransition(localStatus: self.status, filterStatus: properties.status) &&
        
        coreFilter.compareStatoScorte(modelId: self.id, filterInventario: properties.inventario, readOnlyVM: readOnlyVM) &&
        
        self.preCallHasAllIngredientSameQuality(
            viewModel: readOnlyVM,
            kpQuality: \.produzione,
            quality: properties.produzioneING) &&
        
        self.preCallHasAllIngredientSameQuality(
            viewModel: readOnlyVM,
            kpQuality: \.provenienza,
            quality: properties.provenienzaING)
        
        
    }
    
    public struct FilterProperty:SubFilterObject_FPC {
       
       // public typealias M = DishModel 
        
      //  public var coreFilter: CoreFilter
      //  public var sortCondition: SortCondition
        
        var status:[StatusTransition]?
        
        var percorsoPRP:[DishModel.PercorsoProdotto]? { willSet {
            if let value = newValue,
               !value.contains(.prodottoFinito) { self.inventario = nil }
        }}
        var categorieMenu:[CategoriaMenu]?
        var basePRP:DishModel.BasePreparazione? //
        var allergeniIn:[AllergeniIngrediente]?
        var dietePRP:[TipoDieta]?
        
        var inventario:[Inventario.TransitoScorte]?
        
        var produzioneING:ProduzioneIngrediente? //
        var provenienzaING:ProvenienzaIngrediente? //
        
        public init() {
          //  self.coreFilter = CoreFilter()
         //   self.sortCondition = .defaultValue

        }
        
     /* public static func == (lhs:FilterProperty,rhs:FilterProperty) -> Bool {
            
            lhs.status == rhs.status &&
            lhs.percorsoPRP == rhs.percorsoPRP &&
            lhs.categorieMenu == rhs.categorieMenu &&
            lhs.basePRP == rhs.basePRP &&
            lhs.allergeniIn == rhs.allergeniIn &&
            lhs.dietePRP == rhs.dietePRP &&
            lhs.inventario == rhs.inventario &&
            lhs.produzioneING == rhs.produzioneING &&
            lhs.provenienzaING == rhs.provenienzaING
        } */
        
        public static func reportChange(old:FilterProperty,new:FilterProperty) -> Int {
     
            countManageSingle_FPC(
                newValue: new.produzioneING,
                oldValue: old.produzioneING) +
            countManageSingle_FPC(
                newValue: new.provenienzaING,
                oldValue: old.provenienzaING) +
            countManageSingle_FPC(
                newValue: new.basePRP,
                oldValue: old.basePRP) +
            countManageCollection_FPC(
                newValue: new.status,
                oldValue: old.status) +
            countManageCollection_FPC(
                newValue: new.percorsoPRP,
                oldValue: old.percorsoPRP) +
            countManageCollection_FPC(
                newValue: new.categorieMenu,
                oldValue: old.categorieMenu) +
            countManageCollection_FPC(
                newValue: new.allergeniIn,
                oldValue: old.allergeniIn) +
            countManageCollection_FPC(
                newValue: new.dietePRP,
                oldValue: old.dietePRP) +
            countManageCollection_FPC(
                newValue: new.inventario,
                oldValue: old.inventario)
            
        }

    }
    
    public enum SortCondition:SubSortObject_FPC {
        
        public static var defaultValue: SortCondition = .alfabeticoCrescente
        
        case alfabeticoCrescente
        case alfabeticoDecrescente
        
        case livelloScorte
        case mostUsed
        
        case mostRated
        case topRated
        case topPriced

        public func simpleDescription() -> String {
            
            switch self {
                
            case .alfabeticoCrescente: return "default"
            case .alfabeticoDecrescente: return "Alfabetico Decrescente"
            case .livelloScorte: return "Livello Scorte"
            case .mostUsed: return "Utilizzo"
  
            case .mostRated: return "Numero di Recensioni"
            case .topRated: return "Media Voto Ponderata"
            case .topPriced: return "Prezzo"

            }
        }
        
        public func imageAssociated() -> String {
            
            switch self {
                
            case .alfabeticoCrescente: return "circle"
            case .alfabeticoDecrescente: return "textformat"
            case .livelloScorte: return "cart"
            case .mostUsed: return "aqi.medium"
            case .mostRated: return "chart.line.uptrend.xyaxis"
            case .topRated: return "medal"
            case .topPriced: return "dollarsign"
          
            }
        }
        
        
    }
    
}
