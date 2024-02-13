//
//  ProductModelExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import MyFilterPackage

extension ProductModel:MyProVMPack_L0 {
    public typealias VM = AccounterVM
}

extension ProductModel {

   /* private func preCallHasAllIngredientSameQuality<T:MyProEnumPack_L0>(viewModel:AccounterVM,kpQuality:KeyPath<IngredientModel,T>,quality:T?) -> Bool {
        
        guard let unwrapQuality = quality else { return true }
        
       return self.hasAllIngredientSameQuality(viewModel: viewModel, kpQuality: kpQuality, quality: unwrapQuality)
        
    }*/ // Migrata su MyFoodiePackage 20.01.23
    

   /* func topRatedValue(readOnlyVM:AccounterVM) -> Double {
        
        let (media,count,_) = self.ratingInfo(readOnlyViewModel:readOnlyVM)
       
        return (media * Double(count))
     
    }*/ // 20.01.23 Ricollocata in MyFoodiePackage
    
    /// controlla tutti gii ingredienti attivi del piatto, se sono in stock, in arrivo, o in esaurimento. In caso affermativo ritorna true, il piatto è eseguibile
   /* func controllaSeEseguibile(viewModel:AccounterVM) -> Bool {
        // il controllo dello status è deprecato in futuro perchè sarà derivato dallo stato Scorte
        //07.02.24 Da aggiornare quando si andrà a lavorare su Menu e/o Monitor. Gli ingredienti atttivi() sono stati aggiornati
        let allIngActive = self.allIngredientsAttivi(viewModel: viewModel)
        
        let mapStock = allIngActive.map({
          /*  viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id)*/
            viewModel.getStatusScorteING(from: $0.id)
        })
        let filtraStock = mapStock.filter({
            $0 != .esaurito || $0 != .outOfStock
        })
        
        return allIngActive.count == filtraStock.count
        
    } */ // deprecata 16.03.23 || effettivo 08.02.24
    
    /// analizza gli ingredienti per comprendere se un piatto è eseguibile o meno
    func checkStatusExecution(viewModel:AccounterVM) -> ExecutionState {
        // 22_01_24 da Aggiornare in ragione del fatto che lo status degli ing è strettamente correlato in automatico con lo stato scorte.
        // Quando abbiamo creato questa func lo status dell'ing poteva essere forzato manualmente
        
        // 1. Eseguibile
        // 1a. Tutti gli ing sono disponibili, principali, secondari o eventuali sostituti
        // Passaggio di status sempre consentito. 16.03.23 Nessuna modifica da apportare
        
        //Update 09.07.23
        
        switch self.adress {
            
        case .preparazione: return checkStatusPreparazione(viewModel: viewModel)
        case .finito: return checkStatusAsProduct(viewModel: viewModel)
        case .composizione: return .eseguibileConRiserva
            
        }
        
       /* guard self.adress != .composizione else { return .eseguibileConRiserva }
 
        guard self.adress != .finito else {
            return .nonEseguibile
        } */
        //end update
      /*  let allIng = self.allIngredientsIn(viewModel: viewModel)
        
        if self.adress == .preparazione,
           allIng.isEmpty {
           return .nonEseguibile
        }
        
        let ingCount = allIng.count
        
        let ingActive = self.allIngredientsAttivi(viewModel: viewModel)
        let activeCount = ingActive.count
        
        guard ingCount != activeCount else { return .eseguibile }
        
        // 1b. Non tutti gli ing sono disponibili, ma sono tutti in stock
        // Passaggio di status consentito con alert informativo della presenza di ing inPausa. 16.03.23 da implementare
        let allInPausa = allIng.filter({ $0.statusTransition == .inPausa })
       /* let allInPausaAvaible = allInPausa.map({viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)}).contains(.esaurito) */
        
        let areNotAllIngInPausaAvaible = allInPausa.contains(where: { /*viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id) == .esaurito*/
           // viewModel.getStatusScorteING(from: $0.id) == .esaurito
            $0.statusScorte() == .esaurito
        })
        
        guard areNotAllIngInPausaAvaible else { return .eseguibile }
        
        // 2.Eseguibile con Riserva
        
        //2a. Se Gli ing in Pausa, e non in stock, sono tutti secondari è consentito eseguire il piatto con riserva dello chef
        // In questo caso il passaggio di Status da inPausa a Disponibile può essere consentito con conferma. 16.03.23 da implementare
        
        let idIngInPausa = allInPausa.map({$0.id})
        let ingredientiPrincipali = self.ingredientiPrincipali ?? []
        let areNotInPausaAllSecondary = ingredientiPrincipali.contains {
            idIngInPausa.contains($0)
        }
        
        guard areNotInPausaAllSecondary else { return .eseguibileConRiserva }
        
        // 3. Non Eseguibile. Il piatto contiene fra i principali degli ing in pausa e non in stock
        // In questo caso il passaggio di Status da inPausa a Disponibile deve essere bloccato. 16.03.23 da implementare
        
        return .nonEseguibile */
        
    }
    
   /* private func checkStatusPreparazione(viewModel:AccounterVM) -> ExecutionState {
        
        let allIng = self.allIngredientsIn(viewModel: viewModel)
        
        if self.adress == .preparazione,
           allIng.isEmpty {
           return .nonEseguibile
        }
        
        let ingCount = allIng.count
        
        let ingActive = self.allIngredientsAttivi(viewModel: viewModel)
        let activeCount = ingActive.count
        
        guard ingCount != activeCount else { return .eseguibile }
        
        // 1b. Non tutti gli ing sono disponibili, ma sono tutti in stock
        // Passaggio di status consentito con alert informativo della presenza di ing inPausa. 16.03.23 da implementare
        let allInPausa = allIng.filter({ $0.statusTransition == .inPausa })
       /* let allInPausaAvaible = allInPausa.map({viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)}).contains(.esaurito) */
        
        let areNotAllIngInPausaAvaible = allInPausa.contains(where: { /*viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id) == .esaurito*/
           // viewModel.getStatusScorteING(from: $0.id) == .esaurito
            $0.statusScorte() == .esaurito
        })
        
        guard areNotAllIngInPausaAvaible else { return .eseguibile }
        
        // 2.Eseguibile con Riserva
        
        //2a. Se Gli ing in Pausa, e non in stock, sono tutti secondari è consentito eseguire il piatto con riserva dello chef
        // In questo caso il passaggio di Status da inPausa a Disponibile può essere consentito con conferma. 16.03.23 da implementare
        
        let idIngInPausa = allInPausa.map({$0.id})
        let ingredientiPrincipali = self.ingredientiPrincipali ?? []
        let areNotInPausaAllSecondary = ingredientiPrincipali.contains {
            idIngInPausa.contains($0)
        }
        
        guard areNotInPausaAllSecondary else { return .eseguibileConRiserva }
        
        // 3. Non Eseguibile. Il piatto contiene fra i principali degli ing in pausa e non in stock
        // In questo caso il passaggio di Status da inPausa a Disponibile deve essere bloccato. 16.03.23 da implementare
        
        return .nonEseguibile
        
        
    }*/ // backup 07.02.24
    
    private func checkStatusPreparazione(viewModel:AccounterVM) -> ExecutionState {
        
        let allING = self.allIngredientsOrSubs(viewModel: viewModel)
        
        guard !allING.isEmpty else { return .nonEseguibile}
        
        let ingredientiPrincipali = self.ingredientiPrincipali ?? []
        
        let allEsauriti = allING.filter({$0.statusScorte() == .esaurito})// coincideranno con gli ing in pausa che non hanno un sostituto
        
        guard allEsauriti.isEmpty else {
            // vi sono ingredienti esauriti senza rimpiazzo
            let esauritiID = allEsauriti.map({$0.id})
            
            let esauriFraPrincipali = ingredientiPrincipali.contains(where: {
                esauritiID.contains($0)
            })
            
            if esauriFraPrincipali { return .nonEseguibile }
            else { return .eseguibileConRiserva }
        }
        
        // tutti gli ing sono disponibili o hanno un sostituto disponibile
        
        // verifichiamo se ve ne sono in esaurimento
        
        let allInEsaurimento = allING.filter({$0.statusScorte() == .inEsaurimento})
        
        guard allInEsaurimento.isEmpty else {
            
            // vi sono ing in esaurimento. Non possiamo sapere se riguardano un principale o un secondario per via di eventuali sostituzioni, e quindi non badiamo al path e lo rimandiamo ad un controllo manuale, indicandolo come eseguibile con riserva
            return .eseguibileConRiserva
            
        }
        
        return .eseguibile

    }
    
    private func checkStatusAsProduct(viewModel:AccounterVM) -> ExecutionState {
        
        guard let collegato = self.getIngredienteCollegatoAsProduct(viewModel: viewModel) else { return .nonEseguibile }
        
        let statoScorte = collegato.statusScorte()
        
        switch statoScorte {
            
        case .inEsaurimento:
            return .eseguibileConRiserva
        case .esaurito,.outOfStock:
            return.nonEseguibile
        case .inStock:
            return .eseguibile
        
        }
        
    }
    
    public enum ExecutionState:Property_FPC {
        
        static let allCases:[ExecutionState] = [.eseguibile,.eseguibileConRiserva,.nonEseguibile]
        
        case eseguibile
        case eseguibileConRiserva
        case nonEseguibile
        
        public func simpleDescription() -> String {
            switch self {
                
            case .eseguibile: return "Eseguibile"
            case .eseguibileConRiserva: return "con Riserva"
            case .nonEseguibile: return "Non Eseguibile"
            
            }
        }
        
        public func filterDescription() -> String {
            
            switch self {
            
            case .eseguibileConRiserva: return "Eseguibile con Riserva"
            default: return self.simpleDescription()
            
            }
        }
        
        public func returnTypeCase() -> ProductModel.ExecutionState {
           
            return self
        }
        
        public func orderAndStorageValue() -> Int {
            switch self {
                
            case .eseguibile: return 0
            case .eseguibileConRiserva: return 1
            case .nonEseguibile: return 2
            
            }
        }
        
        public func coloreAssociato() -> Color {
            
            switch self {
                
            case .eseguibile: return .seaTurtle_3
            case .eseguibileConRiserva: return .orange
            case .nonEseguibile: return .red.opacity(0.8)
            
            }
            
        }
        
    }
    
    
}

extension ProductModel:MyProStarterPack_L1 {
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [ProductModel]> {
        return \.db.allMyDish
    }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [ProductModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
         return (
            \.db.allMyDish, "Lista Prodotti",
             self.adress.simpleDescription(),
             self.adress.imageAssociated().system
         )
     }
    
    public func isEqual(to rhs: MyFoodiePackage.ProductModel) -> Bool { // deprecata in futuro
        
        guard self.id != rhs.id else { return false }
        
        switch self.adress {
            
        case .preparazione:
            return isEqualPreparazione(to: rhs)
        case .composizione:
            return isEqualPreparazione(to: rhs)
        case .finito:
            return isEqualFinito(to: rhs)
        }

    }
    
    private func isEqualPreparazione(to rhs:ProductModel) -> Bool {
        
        self.intestazione == rhs.intestazione &&
        self.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        self.ingredientiSecondari == rhs.ingredientiSecondari
        
    }
    private func isEqualComposizione(to rhs:ProductModel) -> Bool {
        
       guard self.ingredienteSottostante != nil,
             rhs.ingredienteSottostante != nil else { return false }
        
       return self.intestazione == rhs.intestazione /*&&
        sottostante.isEqual(to: rhs_sottostante)*/
        
    }
    
    private func isEqualFinito(to rhs:ProductModel) -> Bool {
       
        guard let sottostante = self.rifIngredienteSottostante,
              let rhs_sottostante = rhs.rifIngredienteSottostante else { return false }
     
        return sottostante == rhs_sottostante
    }
}

extension ProductModel: Object_FPC {
        
  //  public typealias VM = AccounterVM
    public static func sortModelInstance(lhs: ProductModel, rhs: ProductModel, condition: SortCondition?, readOnlyVM: VM) -> Bool {
        
        let lhsRevCount = lhs.ratingInfo(readOnlyViewModel: readOnlyVM).count
        let rhsRevCount = rhs.ratingInfo(readOnlyViewModel: readOnlyVM).count
        
        switch condition {
            
        case .alfabeticoDecrescente:
            return lhs.intestazione > rhs.intestazione
            
        case .livelloScorte:
            
            if let lhsRif = lhs.rifIngredienteSottostante,
               let rhsRif = rhs.rifIngredienteSottostante {
                
                let lhsValue = readOnlyVM.getStatusScorteING(from: lhsRif).orderAndStorageValue()
                let rhsValue = readOnlyVM.getStatusScorteING(from: rhsRif).orderAndStorageValue()
                
               return lhsValue < rhsValue
                
            } else {
                return false 
            }
            
             /*readOnlyVM.currentProperty.inventario.statoScorteIng(idIngredient: lhs.id).orderAndStorageValue() <
                readOnlyVM.currentProperty.inventario.statoScorteIng(idIngredient: rhs.id).orderAndStorageValue()*/
        case .mostUsed:
            return readOnlyVM.allMenuContaining(idPiatto: lhs.id).countWhereDishIsIn >
            readOnlyVM.allMenuContaining(idPiatto: rhs.id).countWhereDishIsIn
            
        case .mostRated:
           // return lhs.rifReviews.count > rhs.rifReviews.count
            return lhsRevCount > rhsRevCount
            
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
        
       // guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)
        
        guard readOnlyVM != nil else { return conditionOne } // è inutile percheè passeremo sempre un valore valido. Lo mettiamo per forma. Abbiamo messo il parametro optional per non passarlo negli altri modelli dove non ci serve
        
        let allIngredients = self.allIngredientsIn(viewModel: readOnlyVM!)
      //  let allIngredients = self.allIngredientsAttivi(viewModel: readOnlyVM!)
        let allINGMapped = allIngredients.map({$0.intestazione.lowercased()})
        
        let allINGChecked = allINGMapped.filter({$0.contains(ricerca)})
        let conditionTwo = !allINGChecked.isEmpty
        
        return conditionOne || conditionTwo
        // inserire la ricerca degli ingredienti
    }
    
    public func propertyCompare(coreFilter:CoreFilter<Self>, readOnlyVM: VM) -> Bool {
        
        let properties = coreFilter.filterProperties
        
        let allAllergeniIn = self.calcolaAllergeniNelPiatto(viewModel: readOnlyVM)
        let allDietAvaible = self.returnDietAvaible(viewModel: readOnlyVM).inDishTipologia
        let basePreparazione = self.calcolaBaseDellaPreparazione(readOnlyVM: readOnlyVM)
        let allRIFCategories = properties.categorieMenu?.map({$0.id})
        let percorso = self.adress
        
        let stringResult:Bool = {
            
            let stringa = coreFilter.stringaRicerca
            guard stringa != "" else { return true }
            
            let result = self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: readOnlyVM)
            return coreFilter.tipologiaFiltro.normalizeBoolValue(value: result)
            
        }()
        
        let executionState:ExecutionState = self.checkStatusExecution(viewModel: readOnlyVM)
        
        let statusTransition = getStatusTransition(viewModel: readOnlyVM)
        let statoScorte = getStatoScorteAsProduct(viewModel: readOnlyVM)

       return stringResult &&
        
        coreFilter.comparePropertyToCollection(localProperty: percorso, filterCollection: properties.percorsoPRP) &&
        
        coreFilter.compareRifToCollectionRif(localPropertyRif: self.categoriaMenu,
           filterCollection: allRIFCategories) &&
        
        coreFilter.compareCollectionToCollection(localCollection: allAllergeniIn, filterCollection: properties.allergeniIn) &&
        
        coreFilter.compareCollectionToCollection(localCollection: allDietAvaible, filterCollection: properties.dietePRP) &&
        
        coreFilter.comparePropertyToProperty(localProperty: basePreparazione, filterProperty: properties.basePRP) &&
        
       /* coreFilter.compareStatusTransition(localStatus: statusTransition, filterStatus: properties.status, tipologiaFiltro: coreFilter.tipologiaFiltro) &&*/
        coreFilter.comparePropertyToCollection(localProperty: statusTransition, filterCollection: properties.status) &&
        
        // innsesto 16.03.23
        
       /* coreFilter.compareStatusTransition(
            localStatus: statusTransition,
            singleFilter: properties.status_singleChoice, tipologiaFiltro: coreFilter.tipologiaFiltro) &&*/
        coreFilter.comparePropertyToProperty(localProperty: statusTransition, filterProperty: properties.status_singleChoice) &&
        
        coreFilter.comparePropertyToProperty(localProperty: executionState, filterProperty: properties.executionState) &&
        
        // end 16.03
        
       /* coreFilter.compareStatoScorte(modelId: self.id, filterInventario: properties.inventario, tipologiaFiltro: coreFilter.tipologiaFiltro, readOnlyVM: readOnlyVM) &&*/
        coreFilter.comparePropertyToCollection(localProperty: statoScorte, filterCollection: properties.inventario) &&
        
        self.preCallHasAllIngredientSameQuality(
            viewModel: readOnlyVM,
            kpQuality: \.values.produzione,
            quality: properties.produzioneING,
            tipologiaFiltro: coreFilter.tipologiaFiltro) &&
        
        self.preCallHasAllIngredientSameQuality(
            viewModel: readOnlyVM,
            kpQuality: \.values.provenienza,
            quality: properties.provenienzaING,
            tipologiaFiltro: coreFilter.tipologiaFiltro)
        
        
    }
    
    public struct FilterProperty:SubFilterObject_FPC {

        var status:[StatusTransition]?
        // innest0 16.03.23
        var status_singleChoice:StatusTransition?
        var executionState:ExecutionState?
        // 16.03 end
        var percorsoPRP:[ProductAdress]? { willSet {
            if let value = newValue,
               !value.contains(.finito) { self.inventario = nil }
        }}
        var categorieMenu:[CategoriaMenu]?
        var basePRP:ProductModel.BasePreparazione? //
        var allergeniIn:[AllergeniIngrediente]?
        var dietePRP:[TipoDieta]?

        var inventario:[StatoScorte]?
        var produzioneING:ProduzioneIngrediente? //
        var provenienzaING:ProvenienzaIngrediente? //
        
        public init() {
          //  self.coreFilter = CoreFilter()
         //   self.sortCondition = .defaultValue

        }
        
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
                oldValue: old.inventario) +
            countManageSingle_FPC(
                newValue: new.executionState,
                oldValue: old.executionState) +
            countManageSingle_FPC(
                newValue: new.status_singleChoice,
                oldValue: old.status_singleChoice)
            
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

extension ProductModel: MyProProgressBar {
    
    public var countProgress: Double { selectCountProgress() }
    
    private func selectCountProgress() -> Double {
        
        switch self.adress {
            
        case .preparazione:
            return progressPreparazione()
        default:
            return progressIbrido()
            
        }
    }
    
    private func progressPreparazione() -> Double { 
        var count:Double = 0.0
        
        if self.intestazione != "" { count += 0.16 }
        if let descrizione,
        descrizione != "" { count += 0.1 }
        if self.categoriaMenu != CategoriaMenu.defaultValue.id &&
            self.categoriaMenu != "" { count += 0.16 }

        if self.ingredientiPrincipali != [] { count += 0.225 }
        if self.ingredientiSecondari != [] { count += 0.075 }
    
        if self.mostraDieteCompatibili { count += 0.1 }
        if !self.arePriceEmpty() { count += 0.18 }

        return count
    }
    
    private func progressIbrido() -> Double {
        var count:Double = 0.0
        
        if self.intestazione != "" { count += 0.16 }
        if let descrizione,
        descrizione != "" { count += 0.15 } // +0.3
        if self.categoriaMenu != CategoriaMenu.defaultValue.id &&
            self.categoriaMenu != "" { count += 0.16 }

        if self.mostraDieteCompatibili { count += 0.1 }
        if !self.arePriceEmpty() { count += 0.18 }

        if let ingredienteSottostante {
            
            if ingredienteSottostante.conservazione != .defaultValue { count += 0.125}
            if ingredienteSottostante.origine != .defaultValue {
                count += 0.125
            }
            
        }
        
        return count
    }
    
}

extension ProductModel {
    /// al 30.10.23 funziona solo per ingredienti principali e secondari. Da sviluppare sui sostituti e  sostituiti
   /* public func replaceIngredients(id old:String,with new:String) -> ProductModel? {
        
        let ingPath = self.individuaPathIngrediente(idIngrediente: old)
        
        guard let path = ingPath.path,
              let index = ingPath.index else { return nil }
        
        guard self[keyPath: path] != nil else { return nil }
        
        var newDish = self
        
        newDish[keyPath: path]![index] = new
        return newDish
        
    }*/
}

extension ProductModel:MyProSubCollectionPack {
    
    public typealias Sub = CloudDataStore.SubCollectionKey
    
    public func subCollection() -> MyFoodiePackage.CloudDataStore.SubCollectionKey {
        .allMyDish
    }
    public func sortCondition(compare rhs: MyFoodiePackage.ProductModel) -> Bool {
        self.intestazione < rhs.intestazione
    }
}

extension ProductModel:MyProNavigationPack_L0 { 
    
    public typealias DPV = DestinationPathView
    public func pathDestination() -> DestinationPathView {
        DestinationPathView.piatto(self)
    }
}

extension ProductModel:MyProStatusPack_L1 {

    public var status: StatusModel { self.getStatus() }
  
    /// Lo status Transition è ricavato in modo semi-Automatico. Il valore di default per i nuovi prodotti sarà zero, ovvero disponibile. In questo caso il transition si muoverà in automatico, riflettendo l'executionState. Se l'utente lo forza ad uno stato di inPausa o archiviato, l'executionState sarà ignorato. Se l'utente vuole ripristinare lo stato di disponibile, il sistema ritorneraà ad una assegnazione automatica in funzione dell'executionState. Potremmo rimpiazzare sul firebase lo status di .disponibile con un valore nil.
    public func getStatusTransition(viewModel:AccounterVM) -> StatusTransition {
        
        if statusCache == 0  {
            // automatizzato
            return getTransitionFromExecution(viewModel: viewModel)

        } else {
            // valore precedentemente forzato
            let currentStatus = StatusTransition.decodeStatus(from: self.statusCache)
            
            return currentStatus
        }

    }
    
  /*  private func getTransitionFromRifSottostante(viewModel:AccounterVM) -> StatusTransition {
        
        let sottostante = self.getSottostante(viewModel: viewModel).sottostante
        
        if let sottostante {
            return sottostante.statusTransition
        } else {
            // deve esserci un errore
            // throwerei un errore
            return .archiviato
        }
    } */
    
    private func getTransitionFromExecution(viewModel:AccounterVM) -> StatusTransition {
        
        let executionState = self.checkStatusExecution(viewModel: viewModel)
        
        switch executionState {
        case .eseguibile,.eseguibileConRiserva:
            return .disponibile
        case .nonEseguibile:
            return .inPausa
        }
        
    }
    
    public func setStatusTransition(
        to status: StatusTransition,
        viewModel: AccounterVM) {
        
        let menuIn = viewModel.allMenuContaining(idPiatto: self.id).countWhereDishIsIn
            
        if status == .archiviato,
           menuIn > 0 {
            // blocchiamo il passaggio di status perchè il prodotto è in menu
            
            viewModel.alertItem = AlertModel(
                title: "Azione Bloccata",
                message: "\(self.intestazione) è inserito in \(menuIn) menu e non può essere messo fuori inventario. Una volta rimosso da tutti i menu sarà possibile procedere.")
            
        } else {
            
            let value = String(status.orderAndStorageValue())
            let key = Self.CodingKeys.status.rawValue
            let path = [key:value]
            
            Task {
                
               try await viewModel.updateSingleField(
                    docId: self.id,
                    sub: .allMyDish,
                    path: path)
                
            }
            
        }
        
    }
    
    public func disabilitaSetStatusTransition(viewModel: AccounterVM) -> (general:Bool,upToDisponibile:Bool) {
        
        let executionState = self.checkStatusExecution(viewModel: viewModel)
        
        switch executionState {
        case .eseguibile,.eseguibileConRiserva:
            return (false,false)
        case .nonEseguibile:
            return (false,true)
        }
    }
    
    public func getStatus() -> StatusModel {
        
        if self.optionalComplete() { return .completo }
        else { return .bozza }
    }
    
    public func modelStatusDescription() -> String {
         "\(self.adress.simpleDescription()) (\(self.status.simpleDescription().capitalized))"
     }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    public func optionalComplete() -> Bool {
            
        let conditionOne:Bool = self.checkOptional()
        
       /* switch self.adress {
        case .preparazione:
           // conditionOne = checkOptionalPreparazione()
        case .composizione:
           // conditionOne = checkOptionalComposizione()
        case .finito:
           // conditionOne = true
        }*/
        
       return conditionOne && self.mostraDieteCompatibili
    }
    
    private func checkOptional() -> Bool {
        
        guard let descrizione else { return false }
        
        return descrizione != ""
    }
    
   /* private func checkOptionalComposizione() -> Bool {
    
        if let ingredienteSottostante {
            return false
          //  return ingredienteSottostante.optionalComplete()
        } else {
            return false
        }
        
    }*/
        
}

extension ProductModel:MyProStatusPack_L02 {
    
    public func visualStatusDescription(viewModel:AccounterVM) -> (internalImage:String,internalColor:Color,externalColor:Color,description:String) {
        
        let transition = getStatusTransition(viewModel: viewModel)
        
        let imageInt:String = self.status.imageAssociated()
    
        let coloreInterno = transition.colorAssociated()
        var coloreEsterno:Color
        
        let statusDescription = self.status.simpleDescription()
        let transitionDescription = transition.simpleDescription()
        let adressDescription = self.adress.tapDescription()
        var thirdString:String
        
        // Switch fra stato scorte per i prodotti finiti ed executionState per gli altri
        
        if let rif = self.rifIngredienteSottostante {
            
            let statoScorte = viewModel.getStatusScorteING(from: rif)
            coloreEsterno = statoScorte.coloreAssociato()
            thirdString = "Scorte: \(statoScorte.simpleDescription())"
            
        } else {
            
            let execution = self.checkStatusExecution(viewModel: viewModel)
            coloreEsterno = execution.coloreAssociato()
            thirdString = "Preparazione: \(execution.simpleDescription())"
            
        }
        
        let descrizione = "\(adressDescription)\nForm: \(statusDescription)\nStato: \(transitionDescription)\n\(thirdString)"
        
        return (imageInt,coloreInterno,coloreEsterno,descrizione)
        
        
    }
}

extension ProductModel:MyProEditingPack_L0 {
    
    public func disabilitaEditing(viewModel:AccounterVM) -> Bool {
        
        let statusTransition = getStatusTransition(viewModel: viewModel)
        return statusTransition == .archiviato
      
        
    }
}

extension ProductModel:MyProTrashPack_L0 {
    
    public func disabilitaTrash(viewModel:AccounterVM) -> Bool {
        
        let statusTransition = getStatusTransition(viewModel: viewModel)
        
        return statusTransition != .archiviato
    }
    
    public func manageModelDelete(viewModel: AccounterVM) {
        // da sistemare
        
        /*
         
        // da sistemare 27_12_23
        
        
        let allMenuWithDish = viewModel.allMenuContaining(idPiatto: self.id)
        
        guard allMenuWithDish.countWhereDishIsIn != 0 else {

            viewModel.deleteModel(itemModel: self)
            
            return
            
        }
        
        var allCleanedMenu:[MenuModel] = []
        
        for eachMenu in allMenuWithDish.allModelWithDish {
            
            var new = eachMenu
            
            if eachMenu.getStatusTransition(viewModel: viewModel) == .disponibile {
                new.autoManageCambioStatus(viewModel: viewModel, idPiattoEscluso: self.id)
            }
            new.rifDishIn.removeAll(where: {$0 == self.id})
            
           /* if new.rifDishIn.isEmpty { new.status = eachMenu.status.changeStatusTransition(changeIn: .inPausa)} */
            allCleanedMenu.append(new)
            
        }
        
         viewModel.deleteModel(itemModel: self){
             viewModel.updateModelCollection(items: allCleanedMenu, sub: CloudDataStore.SubCollectionKey.allMyMenu)
         }
        
        */
    
        viewModel.deleteModel(itemModel: self){
            // try test()
             test() // probabile uso per pulizia dei menu. Mentre per gli ingredienti la pulizia è manuale
        }
       
    }
    
    func test()  {
       // throw CS_GenericError.propertyDataCorrotti
        print("=======TEST()========")
    }
}

extension ProductModel:MyProVisualPack_L0 {
    
    public typealias RS = RowSize
    
    public func returnModelRowView(rowSize:RowSize) -> some View {
        ProductModel_RowView(item: self,rowSize: rowSize)
    }
    
    public func opacityModelRowView(viewModel: AccounterVM) -> CGFloat {
        let statusTransition = getStatusTransition(viewModel:viewModel)
        
        switch statusTransition {
            
        case .disponibile: return 1.0
        case .inPausa: return 0.7
        case .archiviato: return 0.4
        }
    }
    
    public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let statusTransition = getStatusTransition(viewModel: viewModel)
        
        let generalDisabled = statusTransition == .archiviato
        let priceCount = self.pricingPiatto.count
        let (ingredientsCount,ingredientsCanBeExpanded) = countIngredients()
        
        let isDisponibile = statusTransition == .disponibile
        
      return VStack {
            
          vbSwitchReviewAndAdress(
            viewModel: viewModel,
            navigationPath: navigationPath)
          
          if priceCount > 1 {
              
              vbVisualPricing(priceCount: priceCount)
          }

          vbVisualManageMenuDiSistema(viewModel: viewModel)
              .disabled(!isDisponibile)
            //  .disabled(generalDisabled)
          
          vbVisualManageEspansioneMenu(viewModel: viewModel, navigationPath: navigationPath)
              .disabled(generalDisabled)
          
          if ingredientsCanBeExpanded {
              
              vbVisualManageEspansioneIngredienti(
                viewModel: viewModel,
                navigationPath: navigationPath,
                ingredientsCount: ingredientsCount)
                .disabled(ingredientsCount == 0)

          }

        }
     // .disabled(generalDisabled)
    }
    
   @ViewBuilder private func vbSwitchReviewAndAdress(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
       switch self.adress {
            
        case .finito:
           vbFinitoLabel(
            viewModel: viewModel,
            navigationPath: navigationPath)
           
        case .composizione,.preparazione:
            vbVisualReview(
                viewModel: viewModel,
                navigationPath: navigationPath)
        }
        
    }
    
   @ViewBuilder private func vbFinitoLabel(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
       Group {
        
           Label {
               Text("Type: ready product")
           } icon: {
               Image(systemName: "doc.on.doc")
           }
           
           if let rifIngredienteSottostante {
               
               Button {
                   viewModel.showSpecificModel = rifIngredienteSottostante
                   
                   withAnimation {
                       viewModel.pathSelection = .ingredientList
                   }
                   
               } label: {
                   HStack {
                       Text("Vai all'Ingrediente")
                       Image(systemName: "arrow.up.forward.app")
                   }
               }
               
           }

       }

    }
    
    private func vbVisualReview(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let reviewCount = self.ratingInfo(readOnlyViewModel: viewModel).count
        
        let disabilitaReview = reviewCount == 0
        
       return Button {
            
            viewModel[keyPath: navigationPath].append(DestinationPathView.recensioni(self.id))
            
        } label: {
            HStack{
                Text("Vedi Recensioni (\(reviewCount))")
                Image(systemName: "eye")
            }
        }.disabled(disabilitaReview)
        
    }
    
    private func vbVisualPricing(priceCount:Int) -> some View {
        
        let currencyCode = Locale.current.currency?.identifier ?? "EUR"
        
       return Menu {
       
           ForEach(self.pricingPiatto,id:\.self) { format in
  
               let price = Double(format.price) ?? 0
               Text("\(format.label) : \(price,format: .currency(code: currencyCode))")
            }
           
        } label: {

            Text("Prezziario (\(priceCount))")
          
        }
    }
    
    private func vbVisualManageMenuDiSistema(viewModel:AccounterVM) -> some View {
        
        let isDelGiorno = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delGiorno)
        let isDelloChef = viewModel.checkMenuDiSistemaContainDish(idPiatto: self.id, menuDiSistema: .delloChef)
        
       return Group {
            
            Button {
                
                viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delGiorno)

            } label: {
                HStack{
                    
                   /* Text(isDelGiorno ? "[-] Menu del Giorno" : "[+] Menu del Giorno")*/
                    Text("Menu del Giorno")
                    Image(systemName:isDelGiorno ? "x.circle" : "clock.badge.checkmark")
                }
            }
            
            Button {
                
                viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: self.id, menuDiSistema: .delloChef)

            } label: {
                HStack{
                   /* Text(isDelloChef ? "[-] Menu Consigliati" : "[+] Menu Consigliati")*/
                    Text("Menu Consigliati")
                    Image(systemName:isDelloChef ? "x.circle" : "clock.badge.checkmark")
                }
            }
        }
        
    }
    
    private func vbVisualManageEspansioneMenu(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let(_,allMenuMinusDS,allWhereDishIsIn) = viewModel.allMenuMinusDiSistemaPlusContain(idPiatto: self.id)
        
       return Button {
           
            viewModel[keyPath: navigationPath].append(DestinationPathView.vistaMenuEspansa(self))
      
        } label: {
            HStack{
                Text("Espandi altri Menu (\(allWhereDishIsIn)/\(allMenuMinusDS))")
                Image (systemName: "menucard")
            }
        }.disabled(allMenuMinusDS == 0)

    }
    
    private func vbVisualManageEspansioneIngredienti(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>,ingredientsCount:Int) -> some View {
        
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

