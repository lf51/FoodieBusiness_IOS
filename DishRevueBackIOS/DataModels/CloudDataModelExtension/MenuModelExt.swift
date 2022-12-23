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

extension MenuModel:
    MyProToolPack_L1,
    MyProVisualPack_L1,
    MyProDescriptionPack_L0 {
    
    public typealias VM = AccounterVM
   // public typealias FPM = FilterPropertyModel
  //  public typealias ST = StatusTransition
    public typealias DPV = DestinationPathView
    public typealias RS = RowSize
   // public typealias SM = StatusModel
    
    
   public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [MenuModel]> {
        return \.allMyMenu
    }
    
   /* public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String:Any] {
        
        let documentData:[String:Any] = [
            
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.rifDishIn : self.rifDishIn,
            DataBaseField.tipologia : self.tipologia.orderAndStorageValuePlus(), // Nota 16.11
            DataBaseField.status : self.status.orderAndStorageValue(),
            DataBaseField.isAvaibleWhen : self.isAvaibleWhen.orderAndStorageValue(),
            DataBaseField.giorniDelServizio : self.giorniDelServizio.map({$0.orderAndStorageValue()}),
            DataBaseField.dataInizio : self.dataInizio,
            DataBaseField.dataFine : self.dataFine,
            DataBaseField.oraInizio : self.oraInizio,
            DataBaseField.oraFine : self.oraFine
        
        ]
        return documentData
    } */
    
    public func manageModelDelete(viewModel: AccounterVM) {
        viewModel.deleteItemModel(itemModel: self)
    }
    
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
    
    
    public func manageCambioStatus(nuovoStatus: StatusTransition, viewModel: AccounterVM) {
        
        viewModel.manageCambioStatusModel(model: self, nuovoStatus: nuovoStatus)
        viewModel.remoteStorage.modelRif_modified.insert(self.id)
      
    }
    
    func allDishActive(idDishEscluso:String? = nil,viewModel:AccounterVM) -> [DishModel] {
        
        let cleanRif = self.rifDishIn.filter({$0 != idDishEscluso})
        let allDishIn = viewModel.modelCollectionFromCollectionID(collectionId: cleanRif, modelPath: \.allMyDish)
        let avaibleDish = allDishIn.filter({$0.status.checkStatusTransition(check: .disponibile)})
        return avaibleDish
    }
    
    public func conditionToManageMenuInterattivo() ->(disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat) {
        
        guard !self.tipologia.isDiSistema() else {
            return (false,true,true,false,1.0)
        }
        
        guard !self.status.checkStatusTransition(check: .disponibile) else {
            return (false,false,false,true,1.0)
        }
        
        if self.status.checkStatusTransition(check: .inPausa) {
            
            return (false,false,false,true,0.8)
        }
        else {
            
            return (false,false,true,false,0.5)
        }
        
    }
    /// gestisce in modo specifico quando un menu può essere riportato a .disponibile
    public func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:AccounterVM) -> Bool {
       self.allDishActive(viewModel: viewModel).isEmpty
    }
    
    public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let disabilita = self.rifDishIn.isEmpty
        let dishCount = viewModel.allMyDish.count
        let dishInMenu = self.rifDishIn.count
        
      return VStack {
            
            Button {
             //   viewModel[keyPath: navigationPath].append(DestinationPathView.categoriaMenu)
             
                
            } label: {
                HStack{
                    Text("Anteprima")
                    Image(systemName: "eye")
                }
            }.disabled(disabilita)
          
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
    
   /* public static func sortModelInstance(lhs: MenuModel, rhs: MenuModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
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
    }*/ // deprecate 22.12 da cancellare
    
   /* public func modelStringResearch(string: String,readOnlyVM:AccounterVM?) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)

        guard readOnlyVM != nil else { return conditionOne }
        
        let allDish = readOnlyVM?.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.allMyDish)
       
        guard let allD = allDish else { return conditionOne }
        
        let mapped = allD.map({$0.intestazione.lowercased()})
        let allChecked = mapped.filter({$0.contains(ricerca)})
        
        let conditionTwo = !allChecked.isEmpty
        
        return conditionOne || conditionTwo
    }*/ // deprecata 22.12 cancellare
    
    public func preCallIsOnAir(filterValue:MenuModel.OnlineStatus?) -> Bool {
    
        switch filterValue {
            
        case .online:
            return isOnAir(checkTimeRange: false)
        case .offline:
            return !isOnAir(checkTimeRange: false)
            
        default:
            return true
        }
        
    }
    
   /* public func modelPropertyCompare(filterProperty: FilterPropertyModel, readOnlyVM: AccounterVM) -> Bool {
        
        self.modelStringResearch(string: filterProperty.stringaRicerca,readOnlyVM: readOnlyVM) && //
        self.preCallIsOnAir(filterValue: filterProperty.onlineOfflineMenu) &&
        
        filterProperty.compareStatusTransition(localStatus: self.status) && //
        
        filterProperty.compareCollectionToProperty(localCollection: self.giorniDelServizio, filterProperty: \.giornoServizio) && //
        
        filterProperty.comparePropertyToProperty(local: self.tipologia, filter: \.tipologiaMenu) &&//
        
        filterProperty.comparePropertyToProperty(local: self.isAvaibleWhen, filter: \.rangeTemporaleMenu) //
    
        
    }*/ // deprecata 22.12 da cancellare
    
    public func returnModelRowView(rowSize:RowSize) -> some View {
        MenuModel_RowView(menuItem: self,rowSize: rowSize)
    }
    
    public func modelStatusDescription() -> String {
        "Menu (\(self.status.simpleDescription().capitalized))"
    }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [MenuModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.allMyMenu, "Lista Menu", "Menu","menucard")
    }

    public func pathDestination() -> DestinationPathView {
        
        DestinationPathView.menu(self)
    }
    
    /// Ritorna la media dei voti dei piatti contenuti. La media è pesata, tiene conto del numero di recensioni.
    func mediaValorePiattiInMenu(readOnlyVM:AccounterVM) -> Double {
        
        let allDish = readOnlyVM.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.allMyDish)
        
        let allAvaibleDish = allDish.filter({
            $0.percorsoProdotto != .prodottoFinito &&
            $0.status.checkStatusTransition(check: .disponibile) })
        
        let tuttiVotiPesati = allAvaibleDish.map({$0.topRatedValue(readOnlyVM: readOnlyVM)})
        let tuttiPesi = allAvaibleDish.map({Double($0.rifReviews.count)})
        
        let sommaVotiPesati = csSommaValoriCollection(collectionValue: tuttiVotiPesati)
        let sommaPesi = csSommaValoriCollection(collectionValue: tuttiPesi)
        
        let media = sommaVotiPesati / sommaPesi
        return media
    }
    
}// end struct

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
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)

        guard readOnlyVM != nil else { return conditionOne }
        
        let allDish = readOnlyVM?.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.allMyDish)
       
        guard let allD = allDish else { return conditionOne }
        
        let mapped = allD.map({$0.intestazione.lowercased()})
        let allChecked = mapped.filter({$0.contains(ricerca)})
        
        let conditionTwo = !allChecked.isEmpty
        
        return conditionOne || conditionTwo
    }
    
    public func propertyCompare(filterProperties: FilterProperty, readOnlyVM: AccounterVM) -> Bool {
        
        let core = filterProperties.coreFilter
        
        return self.stringResearch(string: core.stringaRicerca, readOnlyVM: readOnlyVM) &&
        
        self.preCallIsOnAir(filterValue: filterProperties.onlineOfflineMenu) &&
        
        core.compareStatusTransition(localStatus: self.status, filterStatus: filterProperties.status) &&
        
        core.compareCollectionToProperty(localCollection: self.giorniDelServizio, filterProperty: filterProperties.giornoServizio) &&
        
        core.comparePropertyToProperty(localProperty: self.tipologia, filterProperty: filterProperties.tipologiaMenu) &&
        
        core.comparePropertyToProperty(localProperty: self.isAvaibleWhen, filterProperty: filterProperties.rangeTemporaleMenu)
        
    }
    
    public struct FilterProperty:SubFilterObject_FPC {
        
        public typealias M = MenuModel
        
        public var coreFilter: CoreFilter
        public var sortCondition: SortCondition
        
        var giornoServizio:GiorniDelServizio?
        var status:[StatusTransition]?
        var tipologiaMenu:TipologiaMenu?
        var rangeTemporaleMenu:AvailabilityMenu?
        var onlineOfflineMenu:MenuModel.OnlineStatus?
        
        public init() {
            self.coreFilter = CoreFilter()
            self.sortCondition = .defaultValue
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
