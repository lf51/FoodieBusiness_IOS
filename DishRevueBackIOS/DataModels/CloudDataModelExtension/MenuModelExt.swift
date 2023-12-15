//
//  MenuModelExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyFilterPackage

extension MenuModel:MyProVMPack_L0 {
    
    public typealias VM = AccounterVM

}

extension MenuModel {
    /// Gestisce il cambio automatico dello status. Chiede un idDaEscludere perchè la chiamata per l'update arriva da un piatto non ancora passato di status
    public func autoManageCambioStatus(viewModel:AccounterVM,idPiattoEscluso:String) {

        guard !self.tipologia.isDiSistema() else { return }
        
        let avaibleDish = allDishActive(idDishEscluso: idPiattoEscluso, viewModel: viewModel)
        if avaibleDish.isEmpty {
           // viewModel.menuStatusChanged += 1
           // viewModel.remoteStorage.menu_countModificheIndirette += 1
           // viewModel.remoteStorage.modelRif_modified.append(self.id)
          //  viewModel.remoteStorage.applicaModificaIndiretta(id: self.id, model: .menu)
            viewModel.manageCambioStatusModel(model: self, nuovoStatus: .inPausa)
            viewModel.remoteStorage.menu_countModificheIndirette += 1
        }
        
    }
    
    func allDishActive(idDishEscluso:String? = nil,viewModel:AccounterVM) -> [ProductModel] {
        
        let cleanRif = self.rifDishIn.filter({$0 != idDishEscluso})
        let allDishIn = viewModel.modelCollectionFromCollectionID(collectionId: cleanRif, modelPath: \.db.allMyDish)
        let avaibleDish = allDishIn.filter({
            $0.getStatusTransition(viewModel: viewModel) == .disponibile
        })
        return avaibleDish
    }
    
    public func preCallIsOnAir(filterValue:MenuModel.OnlineStatus?) -> Bool {
    
        switch filterValue {
            
        case .online:
            return isOnAirValue().today
        case .offline:
            return !isOnAirValue().today
            
        default:
            return true
        }
        
    }// Deprecata da accorpare l'OnlineStatus con quello che abbiamo creato nuovo con i codici
    
    /// Ritorna la media dei voti dei piatti contenuti. La media è pesata, tiene conto del numero di recensioni.
    func mediaValorePiattiInMenu(readOnlyVM:AccounterVM) -> Double {
        
        let allDish = readOnlyVM.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.db.allMyDish)
        
        let allAvaibleDish = allDish.filter({
            let statusTransition = $0.getStatusTransition(viewModel: readOnlyVM)
           return $0.adress != .finito &&
            statusTransition == .disponibile })
        
        let tuttiVotiPesati = allAvaibleDish.map({$0.topRatedValue(readOnlyVM: readOnlyVM)})
       /* let tuttiPesi = allAvaibleDish.map({Double($0.rifReviews.count)})*/
        let tuttiPesi = allAvaibleDish.map({Double($0.ratingInfo(readOnlyViewModel: readOnlyVM).count)})
        
        let sommaVotiPesati = csSommaValoriCollection(collectionValue: tuttiVotiPesati)
        let sommaPesi = csSommaValoriCollection(collectionValue: tuttiPesi)
        
        let media = sommaVotiPesati / sommaPesi
        return media
    }
}

extension MenuModel:MyProStarterPack_L1 { 
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [MenuModel]> {
         return \.db.allMyMenu
     }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [MenuModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.db.allMyMenu, "Lista Menu", "Menu","menucard")
    }
    
    public func isEqual(to rhs: MyFoodiePackage.MenuModel) -> Bool {
        
        self.tipologia == rhs.tipologia &&
        self.isAvaibleWhen == rhs.isAvaibleWhen &&
        self.dataInizio == rhs.dataInizio &&
        self.dataFine == rhs.dataFine &&
        self.oraInizio == rhs.oraInizio &&
        self.oraFine == rhs.oraFine &&
        self.rifDishIn == rhs.rifDishIn
        
    }
    
}

extension MenuModel:MyProVisualPack_L0 { 
    
    public typealias RS = RowSize
    
    public func returnModelRowView(rowSize:RowSize) -> some View {
        MenuModel_RowView(menuItem: self,rowSize: rowSize)
    }
    
    public func opacityModelRowView(viewModel:AccounterVM) -> CGFloat {
        
        guard !self.tipologia.isDiSistema() else { return 1.0 }
        
        let statusTransition = getStatusTransition(viewModel: viewModel)
        
        switch statusTransition {
        case .disponibile:
            return 1.0
        case .inPausa:
            return 0.8
        case .archiviato:
            return 0.5
        }
        
    }
    
    public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
      //  let disabilita = self.rifDishIn.isEmpty
        let dishCount = viewModel.db.allMyDish.count
        let dishInMenu = self.rifDishIn.count
       
        let rigenera:Bool = {
            let isDiSistema = self.tipologia.isDiSistema()
            let isOnAir = self.isOnAirValue().today
            
            return isDiSistema && !isOnAir
        }()
     
      return Group {

          if rigenera {
              
              Button {
                  viewModel.rigeneraMenuDiSistema(from: self)

              } label: {
                  HStack{
                      Text("Rigenera")
                      Image(systemName: "wand.and.stars")
                  }
              }
          }
        
          Button {
              viewModel[keyPath: navigationPath].append(DestinationPathView.vistaPiattiEspansa(self))
              
          } label: {
              HStack{
                  Text("Espandi Piatti (\(dishInMenu)/\(dishCount))")
                  Image(systemName: "fork.knife.circle")
              }
          }.disabled(dishCount == 0)
            
        }
    }
}

extension MenuModel:Object_FPC {
    
    public static func sortModelInstance(lhs: MenuModel, rhs: MenuModel, condition: SortCondition?, readOnlyVM: AccounterVM) -> Bool {
        
        switch condition {
            
        case .alfabeticoDecrescente:
            return lhs.intestazione < rhs.intestazione
            
        case .dataInizio:
           return lhs.dataInizio < rhs.dataInizio
            
        case .mostContaining:
            return lhs.rifDishIn.count > rhs.rifDishIn.count
            
        case .topRated:
           return lhs.mediaValorePiattiInMenu(readOnlyVM: readOnlyVM) >
            rhs.mediaValorePiattiInMenu(readOnlyVM: readOnlyVM)
            
        case .dataFine:
            return lhs.dataFine < rhs.dataFine
            
        case .topPriced:
            return lhs.tipologia.returnMenuPriceValue().asDouble >
            rhs.tipologia.returnMenuPriceValue().asDouble
            
        default:
            return lhs.intestazione < rhs.intestazione
        }
        
        
    }
    
    public func stringResearch(string: String, readOnlyVM: AccounterVM?) -> Bool {
        
      //  guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)

        guard readOnlyVM != nil else { return conditionOne }
        
        let allDish = readOnlyVM?.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.db.allMyDish)
       
        guard let allD = allDish else { return conditionOne }
        
        let mapped = allD.map({$0.intestazione.lowercased()})
        let allChecked = mapped.filter({$0.contains(ricerca)})
        
        let conditionTwo = !allChecked.isEmpty
        
        return conditionOne || conditionTwo
    }
    
    public func propertyCompare(coreFilter:CoreFilter<Self>, readOnlyVM: AccounterVM) -> Bool {
        
        let filterProperties = coreFilter.filterProperties
        
        let stringResult:Bool = {
            
            let stringa = coreFilter.stringaRicerca
            guard stringa != "" else { return true }
            
            let result = self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: readOnlyVM)
            return coreFilter.tipologiaFiltro.normalizeBoolValue(value: result)
            
        }()
        
        let statusTransition = getStatusTransition(viewModel: readOnlyVM)

        
        return stringResult &&
        //self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: readOnlyVM) &&
        
        self.preCallIsOnAir(filterValue: filterProperties.onlineOfflineMenu) &&
        
        coreFilter.compareStatusTransition(localStatus: statusTransition, filterStatus: filterProperties.status) &&
        
        coreFilter.compareCollectionToProperty(localCollection: self.giorniDelServizio, filterProperty: filterProperties.giornoServizio) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.tipologia, filterProperty: filterProperties.tipologiaMenu) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.isAvaibleWhen, filterProperty: filterProperties.rangeTemporaleMenu)
        
    }
    
    public struct FilterProperty:SubFilterObject_FPC {
        
      //  public typealias M = MenuModel
        
      //  public var coreFilter: CoreFilter
      //  public var sortCondition: SortCondition
        
        var giornoServizio:GiorniDelServizio?
        var status:[StatusTransition]?
        var tipologiaMenu:TipologiaMenu?
        var rangeTemporaleMenu:AvailabilityMenu?
        var onlineOfflineMenu:MenuModel.OnlineStatus?
        
        public init() {
           // self.coreFilter = CoreFilter()
           // self.sortCondition = .defaultValue
        }
        
        static public func reportChange(old: FilterProperty, new: FilterProperty) -> Int {
            
            countManageSingle_FPC(
                newValue: new.giornoServizio,
                oldValue: old.giornoServizio) +
            countManageSingle_FPC(
                newValue: new.tipologiaMenu,
                oldValue: old.tipologiaMenu) +
            countManageSingle_FPC(
                newValue: new.rangeTemporaleMenu,
                oldValue: old.rangeTemporaleMenu) +
            countManageSingle_FPC(
                newValue: new.onlineOfflineMenu,
                oldValue: old.onlineOfflineMenu) +
            countManageCollection_FPC(
                newValue: new.status,
                oldValue: old.status)
        }
        
    }
    
    public enum SortCondition:SubSortObject_FPC {
        
        public static var defaultValue: MenuModel.SortCondition = .alfabeticoCrescente
        
        case alfabeticoCrescente
        case alfabeticoDecrescente
    
        case mostContaining
        case topRated
        case topPriced
        
        case dataInizio
        case dataFine
        
        public func simpleDescription() -> String {
            
            switch self {
                
            case .alfabeticoCrescente: return "default"
            case .alfabeticoDecrescente: return "Alfabetico Decrescente"
            case .mostContaining: return "Prodotti Contenuti"
            case .topRated: return "Media Voto Ponderata"
            case .topPriced: return "Prezzo"
            case .dataInizio: return "Data Inizio Servizio"
            case .dataFine: return "Data Fine Servizio"
                
            }
        }
        
        public func imageAssociated() -> String {
            
            switch self {
                
            case .alfabeticoCrescente: return "circle"
            case .alfabeticoDecrescente: return "textformat"
            case .mostContaining: return "aqi.medium"
            case .topRated: return "medal"
            case .topPriced: return "dollarsign"
            case .dataInizio: return "play.circle"
            case .dataFine: return "stop.circle"
                
            }
            
        }
        
    }
    
}

extension MenuModel:MyProProgressBar {
    
    public var countProgress: Double {
        
        var count:Double = 0.0
        
        if self.intestazione != "" { count += 0.2}
        if self.descrizione != "" { count += 0.1 }
        if self.tipologia != .defaultValue { count += 0.2 }
        if self.isAvaibleWhen != .defaultValue { count += 0.2 }
        if self.rifDishIn != [] { count += 0.3 }
        
        return count
        
    }
}

extension MenuModel:MyProSubCollectionPack {
    
    public typealias Sub = CloudDataStore.SubCollectionKey
    
    public func subCollection() -> MyFoodiePackage.CloudDataStore.SubCollectionKey {
        .allMyMenu
    }
    
    public func sortCondition(compare rhs: MenuModel) -> Bool {
        self.intestazione < rhs.intestazione
    }
}

extension MenuModel:MyProNavigationPack_L0 { 
    
    public typealias DPV = DestinationPathView
    
    public func pathDestination() -> DestinationPathView {
        DestinationPathView.menu(self)
    }
}

extension MenuModel:MyProStatusPack_L1 {
    
    public var status: StatusModel { self.getStatus() }
    
    public func getStatus() -> StatusModel {
        
        if self.optionalComplete() { return .completo }
        else { return .bozza }
    }
    
    public func getStatusTransition(viewModel:AccounterVM) -> StatusTransition {
        
       // guard let statusCache else { return .archiviato }
        
        return .disponibile // da sviluppare convertendo un Intero
    }
    
    public func setStatusTransition(to status:StatusTransition,viewModel: AccounterVM) {
        //
    }
    public func disabilitaSetStatusTransition(viewModel: AccounterVM) -> (general: Bool, upToDisponibile: Bool) {
        
        // da sviluppare la parte dell'UpToDisponibile
        //  self.allDishActive(viewModel: viewModel).isEmpty
        
        let isDiSistema = self.tipologia.isDiSistema()
        
        return(isDiSistema,false)
        
    }
    
    public func modelStatusDescription() -> String {
        "Menu (\(self.status.simpleDescription().capitalized))"
    }
    
   
}

extension MenuModel:MyProStatusPack_L02 {
    
    public func visualStatusDescription(viewModel: AccounterVM) -> (internalImage: String, internalColor: Color, externalColor: Color, description: String) {
        return ("x.circle",Color.gray,Color.gray,"DA SVILUPPARE")
    }
}

extension MenuModel:MyProEditingPack_L0 {
    
    public func disabilitaEditing(viewModel:AccounterVM) -> Bool {
        // se di sistema
        guard !self.tipologia.isDiSistema() else { return true }
        // se archiviato
        
        let statusTransition = StatusTransition.decodeStatus(from: self.statusCache)
        
        return statusTransition == .archiviato
        
      
        
    }
}

extension MenuModel:MyProTrashPack_L0 {
    
    public func disabilitaTrash(viewModel:AccounterVM) -> Bool {
        
        guard !self.tipologia.isDiSistema() else { return false }
        
        let statusTransition = StatusTransition.decodeStatus(from: self.statusCache)
        
        return statusTransition != .archiviato
    }
    
    public func manageModelDelete(viewModel: AccounterVM) {
       
        viewModel.deleteModel(itemModel: self)
    }
    
}
