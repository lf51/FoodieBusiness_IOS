//
//  IngredientModelExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyFilterPackage

extension IngredientModel:
    MyProToolPack_L1,
    MyProDescriptionPack_L0 {

    public func isEqual(to rhs: MyFoodiePackage.IngredientModel) -> Bool {
        
        self.id != rhs.id &&
        self.intestazione == rhs.intestazione &&
        self.origine == rhs.origine &&
        self.allergeni == rhs.allergeni &&
        self.conservazione == rhs.conservazione &&
        self.produzione == rhs.produzione &&
        self.provenienza == rhs.provenienza
        
    }

    public typealias VM = AccounterVM
  //  public typealias FPM = FilterPropertyModel
   // public typealias ST = StatusTransition
    public typealias DPV = DestinationPathView
   
   // public typealias SM = StatusModel
    
   /* public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String:Any] {
        
        let dictionary:[String:Any] = [
        
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.conservazione : self.conservazione.orderAndStorageValue(),
            DataBaseField.produzione : self.produzione.orderAndStorageValue(),
            DataBaseField.provenienza : self.provenienza.orderAndStorageValue(),
            DataBaseField.origine : self.origine.orderAndStorageValue(),
            DataBaseField.status : self.status.orderAndStorageValue(),
            DataBaseField.allergeni : self.conversioneAllergeniInt()
        
        ]
        
        return dictionary
        
    } */
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [IngredientModel]> {
        return \.db.allMyIngredients
      }
    
    public func dishWhereIn(readOnlyVM:AccounterVM) -> (dishCount:Int,Substitution:Int) {
        
        var dishCount: Int = 0
        var dishWhereHasSubstitute: Int = 0
        
        for dish in readOnlyVM.db.allMyDish {
            
            if dish.checkIngredientsInPlain(idIngrediente: self.id) {
                dishCount += 1
                if dish.checkIngredientHasSubstitute(idIngrediente: self.id) { dishWhereHasSubstitute += 1}
            }
        }
        return (dishCount,dishWhereHasSubstitute)
    }
    
 
    
  
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [IngredientModel]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String) {
        
        return (\.db.allMyIngredients, "Lista Ingredienti", "Ingrediente","leaf")
    }

    public func pathDestination() -> DestinationPathView {
        DestinationPathView.ingrediente(self)
    }
    
    
    public func modelStatusDescription() -> String {
        "Ingrediente (\(self.status.simpleDescription().capitalized))"
    } // deprecata in futuro
    
   
    
   /* public func modelPropertyCompare(filterProperty: FilterPropertyModel,readOnlyVM:AccounterVM) -> Bool {
        
        // 02.11 Abbiamo spostato tutte le funzioni di compare direttamente nel filterPropertyModel per avere uniformità e non duplicare codice
        
        self.modelStringResearch(string: filterProperty.stringaRicerca) &&//
        
        filterProperty.comparePropertyToProperty(local: self.provenienza, filter: \.provenienzaING) && //
        filterProperty.comparePropertyToProperty(local: self.produzione, filter: \.produzioneING) && //
        filterProperty.comparePropertyToProperty(local: self.origine, filter: \.origineING) &&//
        filterProperty.comparePropertyToCollection(localProperty: self.conservazione, filterCollection: \.conservazioneING) && //
        
        filterProperty.compareStatusTransition(localStatus: self.status) &&//
        filterProperty.compareStatoScorte(modelId: self.id, readOnlyVM: readOnlyVM) &&
        filterProperty.compareCollectionToCollection(localCollection: self.allergeni, filterCollection: \.allergeniIn) //
       

    } */
    
   /* public func modelStringResearch(string: String,readOnlyVM:AccounterVM? = nil) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let condtionOne = self.intestazione.lowercased().contains(ricerca)

        let allAllergens = self.allergeni.map({$0.intestazione.lowercased()})
        let allAllergensChecked = allAllergens.filter({$0.contains(ricerca)})
        
        let conditionTwo = !allAllergensChecked.isEmpty
        
        return condtionOne || conditionTwo

    }*/ // deprecata 22.12 da cancellare
    
    // La teniamo nel modello per permettere una maggiore customizzazione nella ricerca
    
   /* public static func sortModelInstance(lhs: IngredientModel, rhs: IngredientModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
        switch condition {
            
        case .alfabeticoDecrescente:
            return lhs.intestazione > rhs.intestazione
            
        case .livelloScorte:
          return readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: lhs.id).orderAndStorageValue() < readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: rhs.id).orderAndStorageValue()
            
        case .mostUsed:
            return lhs.dishWhereIn(readOnlyVM: readOnlyVM).dishCount > rhs.dishWhereIn(readOnlyVM: readOnlyVM).dishCount
            
            
        default:
            return lhs.intestazione < rhs.intestazione // alfabetico crescente va di default quando il sort è nil
        }
    }*/ // deprecata 22.12 da cancellare
    
    public func manageCambioStatus(nuovoStatus:StatusTransition,viewModel:AccounterVM) {
    
        let isCurrentlyDisponibile = self.status.checkStatusTransition(check: .disponibile)
        
        viewModel.manageCambioStatusModel(model: self, nuovoStatus: nuovoStatus)
       // viewModel.remoteStorage.modelRif_modified.insert(self.id)
        
        guard nuovoStatus != .disponibile, isCurrentlyDisponibile else { return }
        
        if nuovoStatus == .inPausa, viewModel.currentProperty.setup.autoPauseDish_byPauseING == .sempre {
            
            privateStatusChange()
            
        } else if nuovoStatus == .archiviato, viewModel.currentProperty.setup.autoPauseDish_byArchiveING == .sempre {
            privateStatusChange()
        }
        
        func privateStatusChange() {
            
            let allDishWhereIsIn = viewModel.allDishContainingIngredient(idIng: self.id)
            
            for dish in allDishWhereIsIn {
              //  dish.autoManageCambioStatus(viewModel: viewModel)
                if dish.status.checkStatusTransition(check: .disponibile) {
                    dish.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                    viewModel.remoteStorage.dish_countModificheIndirette += 1
                   //viewModel.dishStatusChanged += 1
                   // viewModel.remoteStorage.dishRif_modified.append(dish.id)
                   // viewModel.remoteStorage.dish_countModificheIndirette += 1
                   // viewModel.remoteStorage.modelRif_modified.append(dish.id)
                  //  viewModel.remoteStorage.applicaModificaIndiretta(id: dish.id, model: .dish)
                }
               
            }

        }

    } // deprecata in futuro
    
    public func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:AccounterVM) -> Bool { false }
    
    public func manageModelDelete(viewModel:AccounterVM) {
        
        let allDishWhereIsIn = viewModel.allDishContainingIngredient(idIng: self.id)
        
        guard !allDishWhereIsIn.isEmpty else {
            viewModel.deleteModel(itemModel: self)
          
            return }
        
        var allDishChanged:[ProductModel] = []
        
        for dish in allDishWhereIsIn {
            
            var new = dish
            let (ingPath,index) = new.individuaPathIngrediente(idIngrediente: self.id)
            
            if let ingPath,
               let index {
                new[keyPath: ingPath]!.remove(at: index)
                new.autoCleanElencoIngredientiOff()
            }
            allDishChanged.append(new)
        }
        
       // viewModel.updateItemModelCollection(items: allDishChanged) // deprecata
        
        viewModel.deleteModel(itemModel: self) {
            viewModel.updateModelCollection(items: allDishChanged, sub: .allMyDish)
        }
    }
    
    
}

extension IngredientModel:Object_FPC {
    
    public static func sortModelInstance(lhs: IngredientModel, rhs: IngredientModel, condition: SortCondition?, readOnlyVM: AccounterVM) -> Bool {
        
        switch condition {
            
        case .alfabeticoDecrescente:
            return lhs.intestazione > rhs.intestazione
            
        case .livelloScorte:
            return lhs.statusScorte().orderAndStorageValue() < rhs.statusScorte().orderAndStorageValue() /*readOnlyVM.currentProperty.inventario.statoScorteIng(idIngredient: lhs.id).orderAndStorageValue() < readOnlyVM.currentProperty.inventario.statoScorteIng(idIngredient: rhs.id).orderAndStorageValue()*/
            
        case .mostUsed:
            return lhs.dishWhereIn(readOnlyVM: readOnlyVM).dishCount > rhs.dishWhereIn(readOnlyVM: readOnlyVM).dishCount
            
        default:
            return lhs.intestazione < rhs.intestazione
        }
    }
    
    public func stringResearch(string: String, readOnlyVM: AccounterVM?) -> Bool {
        
       // guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let condtionOne = self.intestazione.lowercased().contains(ricerca)

      //  let allAllergens = self.allergeni.map({$0.intestazione.lowercased()})
       // let allAllergensChecked = allAllergens.filter({$0.contains(ricerca)})
      // let conditionTwo = !allAllergensChecked.isEmpty
        let conditionTwo:Bool = {
           
            if let allergeneIn = self.allergeni {
                
                let allAllergens = allergeneIn.map({$0.intestazione.lowercased()})
                let allAllergensChecked = allAllergens.filter({$0.contains(ricerca)})
                return !allAllergensChecked.isEmpty
                
            } else { return false }
            
        }()
        
        return condtionOne || conditionTwo
        
        
    }
    
    public func propertyCompare(coreFilter: CoreFilter<Self>, readOnlyVM: AccounterVM) -> Bool {
        
        let filterProperties = coreFilter.filterProperties
        
        let stringResult:Bool = {
            
            let stringa = coreFilter.stringaRicerca
            guard stringa != "" else { return true }
            
            let result = self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: nil)
            return coreFilter.tipologiaFiltro.normalizeBoolValue(value: result)
            
        }()
        
        let allergens = self.allergeni ?? []
        
        return stringResult && // update 10.07.23 vedi ListIngredientView
        
        coreFilter.comparePropertyToProperty(localProperty: self.provenienza, filterProperty: filterProperties.provenienzaING) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.produzione, filterProperty: filterProperties.produzioneING) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.origine, filterProperty: filterProperties.origineING) &&
        
        coreFilter.comparePropertyToCollection(localProperty: self.conservazione, filterCollection: filterProperties.conservazioneING) &&
        
        coreFilter.compareCollectionToCollection(localCollection: allergens, filterCollection: filterProperties.allergeniIn) &&
        
        coreFilter.compareStatusTransition(localStatus: self.status, filterStatus: filterProperties.status) &&
        
        coreFilter.compareStatoScorte(modelId: self.id, filterInventario: filterProperties.inventario, readOnlyVM: readOnlyVM) &&
        
        coreFilter.compareStatusTransition(localStatus: self.status, singleFilter: filterProperties.status_singleChoice) &&
        
        coreFilter.compareStatoScorte(modelId: self.id, singleFilter: filterProperties.inventario_singleChoice, readOnlyVM: readOnlyVM)
        
    }
    
    public struct FilterProperty:SubFilterObject_FPC {
        
      //  public typealias M = IngredientModel
        
      //  public var coreFilter: CoreFilter
      //  public var sortCondition: SortCondition
        
        var status:[StatusTransition]?
       // var inventario:[Inventario.TransitoScorte]?
        var inventario:[StatoScorte]?
        
        //09.07.23 innesto per filtro visivo
        var status_singleChoice:StatusTransition?
       // var inventario_singleChoice:Inventario.TransitoScorte?
        var inventario_singleChoice:StatoScorte?
        //end innsto
        
        var provenienzaING:ProvenienzaIngrediente?
        var produzioneING:ProduzioneIngrediente?
        var origineING:OrigineIngrediente?
        var conservazioneING:[ConservazioneIngrediente]?
        var allergeniIn:[AllergeniIngrediente]?
        
        public init() {
           // self.coreFilter = CoreFilter()
           // self.sortCondition = .defaultValue
        }
        
        static public func reportChange(old: FilterProperty, new: FilterProperty) -> Int {
            
            countManageSingle_FPC(
                newValue: new.provenienzaING,
                oldValue: old.provenienzaING) +
            countManageSingle_FPC(
                newValue: new.produzioneING,
                oldValue: old.produzioneING) +
            countManageSingle_FPC(
                newValue: new.origineING,
                oldValue: old.origineING) +
            countManageCollection_FPC(
                newValue: new.status,
                oldValue: old.status) +
            countManageCollection_FPC(
                newValue: new.inventario,
                oldValue: old.inventario) +
            countManageCollection_FPC(
                newValue: new.conservazioneING,
                oldValue: old.conservazioneING) +
            countManageCollection_FPC(
                newValue: new.allergeniIn,
                oldValue: old.allergeniIn) +
            countManageSingle_FPC(
                newValue: new.inventario_singleChoice,
                oldValue: old.inventario_singleChoice) +
            countManageSingle_FPC(
                newValue: new.status_singleChoice,
                oldValue: old.status_singleChoice)
            
        }
    }
    
    public enum SortCondition:SubSortObject_FPC {
        
        static public var defaultValue: IngredientModel.SortCondition = .alfabeticoCrescente
        
        case alfabeticoCrescente
        case alfabeticoDecrescente
        
        case livelloScorte
        case mostUsed

        public func simpleDescription() -> String {
            
            switch self {
                
            case .alfabeticoCrescente: return "default"
            case .alfabeticoDecrescente: return "Alfabetico Decrescente"
            case .livelloScorte: return "Livello Scorte"
            case .mostUsed: return "Utilizzo"
    
            }
        }
        
        public func imageAssociated() -> String {
            
            switch self {
                
            case .alfabeticoCrescente: return "circle"
            case .alfabeticoDecrescente: return "textformat"
            case .livelloScorte: return "cart"
            case .mostUsed: return "aqi.medium"
     
            }
        }
        
    }
    
}

extension IngredientModel:MyProProgressBar {
    
    public var countProgress: Double {

        var count:Double = 0.0
        
        if self.intestazione != "" { count += 0.35 }
        if let descrizione,
            descrizione != "" { count += 0.35 }
        if self.conservazione != .defaultValue { count += 0.15 }
        if self.origine != .defaultValue { count += 0.15 }
            
        return count
        
    }

}

extension IngredientModel:MyProSubCollectionPack {
    
    public typealias Sub = CloudDataStore.SubCollectionKey
    
    public func subCollection() -> MyFoodiePackage.CloudDataStore.SubCollectionKey {
        .allMyIngredients
    }
    public func sortCondition(compare rhs: IngredientModel) -> Bool {
        self.intestazione < rhs.intestazione
    }
}

extension IngredientModel:MyProVisualPack_L1 {
    
    public typealias RS = RowSize
    
    public func returnModelRowView(rowSize:RowSize) -> some View {
        // rowSize da implementare // 22.06 Implementata
        IngredientModel_RowView(item: self, rowSize: rowSize)
    }
    
    public func conditionToManageMenuInterattivo() -> (disableCustom: Bool, disableStatus: Bool, disableEdit: Bool, disableTrash: Bool, opacizzaAll: CGFloat) {
        
        if self.status.checkStatusTransition(check: .disponibile) {
            return(false,false,false,true,1.0)
        }
        else if self.status.checkStatusTransition(check: .inPausa) {
            return(false,false,false,true,0.8)
        }
        else {
            return (true,false,true,false,0.5)
        }
    }
    
   public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
              
        let generalDisabled = self.status.checkStatusTransition(check: .archiviato)
        
       return VStack {
            
            let statoScorte = self.statusScorte()
            let transitionScorte = self.transitionScorte()
            let ultimoAcquisto = self.lastAcquisto()
           
           let value:(raw:String,image:String) = {
              
               if transitionScorte == .inArrivo {
                   return (transitionScorte.rawValue,transitionScorte.imageAssociata())
               } else {
                   return (statoScorte.simpleDescription(),statoScorte.imageAssociata())
               }
               
           }()
                
                Menu {
                    
                    Button("in Esaurimento") {
                        
                       /* viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inEsaurimento)*/
                        self.changeAndUpdateStatus(status: .inEsaurimento, viewModel: viewModel)

                        
                        
                    }.disabled(statoScorte != .inStock)
                    
                    Button("Esaurite") {
                        
                       /* viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .esaurito)
                        // innesto 01.12.22
                        if self.status.checkStatusTransition(check: .disponibile) {
                            self.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                        } */
                        
                        self.changeAndUpdateStatus(status: .esaurito, viewModel: viewModel)

                        
                        
                    }.disabled(statoScorte == .esaurito || transitionScorte == .inArrivo)
                    
                    if transitionScorte == .pending {
                        
                        Button("Rimetti in Stock") {
                            
                           /* viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inStock)*/
                            self.changeAndUpdateStatus(status: .inStock, viewModel: viewModel)
                            
                            
                        }
                    }
                    
                    Text("Ultimo Acquisto:\n\(ultimoAcquisto)")
                    
                    Button("Cronologia Acquisti") {
                       /* viewModel[keyPath: navigationPath].append(DestinationPathView.vistaCronologiaAcquisti(self))*/
                        viewModel.logMessage = "FETCH SUB COLLECTION"
                    }
                    
                } label: {
                    HStack{
                        Text("Scorte \(value.raw)")
                        Image(systemName: value.image)
                    }
                }

                Button {
                    
                    viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneING(self))
                    
                } label: {
                    HStack{
                        Text("Cambio Temporaneo")
                        /*Image(systemName: "arrowshape.turn.up.backward.badge.clock")*/
                        Image(systemName: "clock")
                    }
                }
                
                Button {

                    viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneING(self,isPermanente: true))
                    
                } label: {
                    HStack{
                        Text("Cambio Permanente")
                        Image(systemName: "exclamationmark.circle")
                      /*  Image(systemName: "arrow.left.arrow.right.circle") */
                    }
                }
 
        }
        .disabled(generalDisabled)
    }
    
    private func changeAndUpdateStatus(status:StatoScorte,viewModel:AccounterVM) {
        
        var updateIng = self
        updateIng.changeStatusScorte(newValue: status)
        viewModel.updateModelOnSub(itemModel: updateIng)
        
    }
    
   /* public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
              
        let generalDisabled = self.status.checkStatusTransition(check: .archiviato)
        
       return VStack {
            
            let statoScorte = viewModel.currentProperty.inventario.statoScorteIng(idIngredient: self.id)
            let ultimoAcquisto = viewModel.currentProperty.inventario.dataUltimoAcquisto(idIngrediente: self.id)
                
                Menu {
                    
                    Button("in Esaurimento") {
                        viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inEsaurimento)
                    }.disabled(statoScorte != .inStock)
                    
                    Button("Esaurite") {
                        viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .esaurito)
                        // innesto 01.12.22
                        if self.status.checkStatusTransition(check: .disponibile) {
                            self.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                        }
                        
                    }.disabled(statoScorte == .esaurito || statoScorte == .inArrivo)
                    
                    if statoScorte == .esaurito || statoScorte == .inEsaurimento {
                        
                        Button("Rimetti in Stock") {
                            viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inStock)
                        }
                    }
                    
                    Text("Ultimo Acquisto:\n\(ultimoAcquisto)")
                    
                    Button("Cronologia Acquisti") {
                        viewModel[keyPath: navigationPath].append(DestinationPathView.vistaCronologiaAcquisti(self))
                    }
                    
                } label: {
                    HStack{
                        Text("Scorte \(statoScorte.simpleDescription())")
                        Image(systemName: statoScorte.imageAssociata())
                    }
                }

                Button {
                    
                    viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneING(self))
                    
                } label: {
                    HStack{
                        Text("Cambio Temporaneo")
                        /*Image(systemName: "arrowshape.turn.up.backward.badge.clock")*/
                        Image(systemName: "clock")
                    }
                }
                
                Button {

                    viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneING(self,isPermanente: true))
                    
                } label: {
                    HStack{
                        Text("Cambio Permanente")
                        Image(systemName: "exclamationmark.circle")
                      /*  Image(systemName: "arrow.left.arrow.right.circle") */
                    }
                }
 
        }
        .disabled(generalDisabled)
    }*/ // backup_01_12_23
    
    
}
