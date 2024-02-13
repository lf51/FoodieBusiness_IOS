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
import MyPackView_L0
import Firebase

extension IngredientModel:MyProVMPack_L0 {

    public typealias VM = AccounterVM

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
    
}

extension IngredientModel:MyProStarterPack_L1 {
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [IngredientModel]> {
        return \.db.allMyIngredients
      }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [IngredientModel]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String) {
        
        return (\.db.allMyIngredients, "Lista Ingredienti", "Ingrediente","leaf")
    }
    
    public func isEqual(to rhs: MyFoodiePackage.IngredientModel) -> Bool {
        
        self.id != rhs.id &&
        self.intestazione == rhs.intestazione &&
        self.values == rhs.values
       /* self.origine == rhs.origine &&
        self.allergeni == rhs.allergeni &&
        self.conservazione == rhs.conservazione &&
        self.produzione == rhs.produzione &&
        self.provenienza == rhs.provenienza*/
        
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
           
            if let allergeneIn = self.values.allergeni {
                
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
        
        let allergens = self.values.allergeni ?? []
        let statoScorte = self.statusScorte()
        
        return stringResult && // update 10.07.23 vedi ListIngredientView
        
        coreFilter.comparePropertyToProperty(localProperty: self.values.provenienza, filterProperty: filterProperties.provenienzaING) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.values.produzione, filterProperty: filterProperties.produzioneING) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.values.origine, filterProperty: filterProperties.origineING) &&
        
        coreFilter.comparePropertyToCollection(localProperty: self.values.conservazione, filterCollection: filterProperties.conservazioneING) &&
        
        coreFilter.compareCollectionToCollection(localCollection: allergens, filterCollection: filterProperties.allergeniIn) &&
        
        coreFilter.comparePropertyToProperty(localProperty: self.ingredientType, filterProperty: filterProperties.tipologia) &&
       /* coreFilter.compareStatusTransition(localStatus: self.statusTransition, filterStatus: filterProperties.status) &&*/
        
       /* coreFilter.compareStatoScorte(modelId: self.id, filterInventario: filterProperties.inventario,tipologiaFiltro: coreFilter.tipologiaFiltro, readOnlyVM: readOnlyVM) &&*/
        coreFilter.comparePropertyToCollection(localProperty: statoScorte, filterCollection: filterProperties.inventario) &&
        
        coreFilter.comparePropertyToProperty(localProperty: statoScorte, filterProperty: filterProperties.inventario_singleChoice)
        
       /* coreFilter.compareStatusTransition(localStatus: self.statusTransition, singleFilter: filterProperties.status_singleChoice) &&*/
        
       /* coreFilter.compareStatoScorte(modelId: self.id, singleFilter: filterProperties.inventario_singleChoice, tipologiaFiltro: coreFilter.tipologiaFiltro, readOnlyVM: readOnlyVM)*/
        
    }
    
    public struct FilterProperty:SubFilterObject_FPC {
        
        //var status:[StatusTransition]?
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
        
        var tipologia:IngredientType?
        
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
            countManageSingle_FPC(
                newValue: new.tipologia,
                oldValue: old.tipologia) +
            /*countManageCollection_FPC(
                newValue: new.status,
                oldValue: old.status) +*/
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
        if self.values.conservazione != .defaultValue { count += 0.15 }
        if self.values.origine != .defaultValue { count += 0.15 }
            
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

extension IngredientModel:MyProVisualPack_L0 {
    
    public typealias RS = RowSize
    
    public func returnModelRowView(rowSize:RowSize) -> some View {
    
        IngredientModel_RowView(item: self, rowSize: rowSize)
    }
    
    public func opacityModelRowView(viewModel:AccounterVM) -> CGFloat {
        
        switch self.statusTransition {
            
        case .disponibile: return 1.0
        case .inPausa: return 0.7
        case .archiviato: return 0.4
        }
    }
    
   public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {

      /* let dishIn = self.dishWhereIn(readOnlyVM: viewModel)
       
       let statoScorte = self.statusScorte()
       let transitionScorte = self.transitionScorte()
       let ultimoAcquisto = self.lastAcquisto()*/
      
     /* let value:(raw:String,image:String) = {
         
          if transitionScorte == .inArrivo {
              return (transitionScorte.rawValue,transitionScorte.imageAssociata())
          } else {
              return (statoScorte.simpleDescription(),statoScorte.imageAssociata())
          }
          
      }()*/
       
       let dishIn = self.dishWhereIn(readOnlyVM: viewModel)
       let statoScorte = self.statusScorte()
       let transitionScorte = self.transitionScorte()
       
       let disabilitaButton:(cambioTemp:Bool,cambioPerma:Bool) = {
          
           let conditionOne = transitionScorte == .inArrivo
         //  let conditionTwo = transitionScorte == .pending
           let noDish = dishIn.dishCount == 0
           
           let tempChange = noDish || conditionOne || statoScorte != .esaurito
           let permanentChange = noDish
           
           return (tempChange,permanentChange)
       }()
        
       return VStack {
            
           vbFinitoLabel(viewModel: viewModel)
           vbVisualManageScorte(viewModel: viewModel,navigationPath: navigationPath)
         
          // Group {
               
               Button {
                   
                   viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneTemporaneaING(self))
                   
               } label: {
                   HStack{
                       Text("Cambio Temporaneo")
                       Image(systemName: "clock")
                   }
               }.disabled(disabilitaButton.cambioTemp)
               
               Button {

                   viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzionePermanenteING(self))
                   
               } label: {
                   HStack{
                       Text("Cambio Permanente")
                       Image(systemName: "exclamationmark.circle")
                   }
               }.disabled(disabilitaButton.cambioPerma)
         
        }
    }
    
    @ViewBuilder private func vbFinitoLabel(viewModel:AccounterVM) -> some View {
         
        if let asProduct {
            
            let label = self.ingredientType.simpleDescription()
            
            Group {
                
                Label {
                    Text("Type: \(label)")
                } icon: {
                    Image(systemName: "doc.on.doc")
                }
                
                Button {
                    viewModel.showSpecificModel = asProduct.id
                    
                    withAnimation {
                        viewModel.pathSelection = .dishList
                    }
                    
                } label: {
                    HStack {
                        Text("Vai al Prodotto")
                        Image(systemName: "arrow.up.forward.app")
                    }
                }
                
                
            }
        }
    
     }
    
    public func vbVisualManageScorte(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let dishIn = self.dishWhereIn(readOnlyVM: viewModel)
        
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
        
        let disabilitaButton:(inEsaurimento:Bool,esaurito:Bool,outOfStock:Bool) = {
           
            let conditionOne = transitionScorte == .inArrivo
           // let conditionTwo = transitionScorte == .pending
            
            let conditionThree = statoScorte == .outOfStock
            let conditionFour = statoScorte == .esaurito || conditionThree
            
            //let noDish = dishIn.dishCount == 0
            
            let inEsauri = statoScorte != .inStock
            let esauri = conditionOne || conditionFour
            let outOf = conditionOne || conditionThree
            
          //  let tempChange = noDish || conditionOne || statoScorte != .esaurito
          //  let permanentChange = noDish || conditionOne || conditionTwo
            
            return (inEsauri,esauri,outOf)
        }()
        
       return Menu {
            
            Button("in Esaurimento") {

                self.changeAndUpdateStatusTask(status: .inEsaurimento, viewModel: viewModel)
                
            }.disabled(disabilitaButton.inEsaurimento)
            
            Button("Esaurite") {

                self.changeAndUpdateStatusTask(status: .esaurito, viewModel: viewModel)

            }.disabled(disabilitaButton.esaurito)
            
            Button("Fuori Inventario",role: .destructive) {

                if dishIn.dishCount == 0 {
                    self.changeAndUpdateStatusTask(status: .outOfStock, viewModel: viewModel)
                } else {
                    viewModel.alertItem = AlertModel(
                        title: "Azione Bloccata",
                        message: "L'ingrediente è in uso e non può essere messo fuori inventario. E' possibile usare il modulo di cambio permanente per sostiuirlo e/o rimuoverlo dai prodotti.")
                }

            }.disabled(disabilitaButton.outOfStock)
            
           // if transitionScorte == .pending {
            if statoScorte != .inStock && transitionScorte != .inArrivo {
                
                Button("Rimetti in Stock") {

                    self.changeAndUpdateStatusTask(status: .inStock, viewModel: viewModel)
                    
                }
            }
            
           if let ultimoAcquisto {
               
               Text("Ultimo Acquisto Validato:\n\(ultimoAcquisto)")
               
               Button("Cronologia Acquisti") {
                   viewModel[keyPath: navigationPath].append(DestinationPathView.vistaCronologiaAcquisti(self))
                  // viewModel.logMessage = "FETCH SUB COLLECTION"
               }
               
           } else {
               
               Text("Cronologia Acquisti Vuota")
           }
           
            
        } label: {
            HStack{
                Text("Scorte \(value.raw)")
                Image(systemName: value.image)
            }
        }
        
    }
                                                    
    private func changeAndUpdateStatusTask(status:StatoScorte,viewModel:AccounterVM) {
                            
        Task {
           
            do {
                DispatchQueue.main.async {
                    viewModel.isLoading = true
                }
                try await changeAndUpdateStatus(status: status, viewModel: viewModel)
                
            } catch let error {
                
                DispatchQueue.main.async {
                    viewModel.isLoading = nil
                    viewModel.logMessage = error.localizedDescription
                }

            }
        }
    }
    
    public func changeAndUpdateStatus(status:StatoScorte,viewModel:AccounterVM) async throws {
                
       // throw CS_GenericError.propertyDataCorrotti
        
        let mainKey = IngredientModel.CodingKeys.inventario.rawValue
        let subKey = InventarioScorte.CodingKeys.status.rawValue
        
        let value = status.encodeAsString()
        let path = [mainKey:[subKey:value]]
        
        try await viewModel.updateSingleField(
            docId: self.id,
            sub: .allMyIngredients,
            path: path)
        
    }
 
    
}

extension IngredientModel:MyProNavigationPack_L0 {
  
    public typealias DPV = DestinationPathView
    
    public func pathDestination() -> DestinationPathView {
        DestinationPathView.ingrediente(self)
    }
}

extension IngredientModel:MyProStatusPack_L02 {
    
    public func visualStatusDescription(viewModel: AccounterVM) -> (internalImage: String, internalColor: Color, externalColor: Color, description: String) {
        
        let imageInternal = self.status.imageAssociated()
        let colorInternal = self.statusTransition.colorAssociated()
        let dashedColor = self.statusScorte().coloreAssociato()
        
        let type = self.ingredientType.tapDescription()
        let form = "Form: \(self.status.simpleDescription())"
        let stato = "Stato: \(self.statusTransition.simpleDescription())"
        
        let descrizione = "\(type)\n\(form)\n\(stato)\nScorte: \(self.statoScorteDescription())"
        
        return (imageInternal,colorInternal,dashedColor,descrizione)
        
    }
}

extension IngredientModel:MyProEditingPack_L0 {
    
    public func disabilitaEditing(viewModel:AccounterVM) -> Bool {
        
        self.statusTransition == .archiviato || self.asProduct != nil
        
    }
}

extension IngredientModel:MyProTrashPack_L0 {
    
    public func disabilitaTrash(viewModel:AccounterVM) -> Bool {
       
        self.statusTransition != .archiviato
    }
    
    public func manageModelDelete(viewModel:AccounterVM) {
        // se l'ing è contenuto in almeno un piatto non può essere messo fuori inventario. Se non è fuori inventario lo statusTransition non è su archiviato. Se non è archiviato non può essere eliminato
        // la pulizia dei piatti viene quindi effettuata manualmente dall'utente
      
        viewModel.deleteModel(itemModel: self)
    }
    
   /* public func manageModelDelete(viewModel:AccounterVM) {
        
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
            viewModel.updateModelCollection(
                items: allDishChanged,
                sub: CloudDataStore.SubCollectionKey.allMyDish)
        }
    }*/ // 27_12_23 obsoleta
    
}

extension IngredientModel {
    
    public var ingredientType:IngredientType { self.getIngredientType() }
    
    private func getIngredientType() -> IngredientType {
        
        guard self.asProduct != nil else { return .standard }
        return .asProduct

    }
    
   /* public func getIngredientType(viewModel:AccounterVM) -> IngredientType {
        
        guard viewModel.isASubOfReadyProduct(id: self.id) != nil else {
            return .standard
        }
        return .asProduct

    }*/ // deprecata
    
   /* public func isAReadyProduct(viewModel:AccounterVM) -> Bool {
        
        viewModel.isASubOfReadyProduct(id: self.id) != nil

    }*/
    
    public enum IngredientType:String,Codable,Property_FPC {
        
        static var allCases:[IngredientType] = [.standard,.asProduct]
        
        case standard
        case asProduct
        
        public func imageAssociated() -> String {
            
            switch self {
            case .standard:
               return "leaf"
           /* case .diSintesi:
                return "lasso.badge.sparkles"*/
            case .asProduct:
                return "takeoutbag.and.cup.and.straw"
          //  case .limited:
            //    return "x.circle"
            }
            
        }
        
        public func simpleDescription() -> String {
            
            switch self {
            case .standard:
               return "standard"
            case .asProduct:
                return "as product"
           // case .limited:
             //   return "sottostante composizione"
            }
            
        }
        
        public func tapDescription() -> String {
            
            switch self {
            case .standard:
               return "Ingrediente Standard"
            case .asProduct:
                return "Ingrediente e prodotto in vendita"
            }
            
        }
        
        public func coloreAssociato() -> Color {
            
            switch self {
            case .standard:
                return Color.yellow
            case .asProduct:
                return Color.gray
          //  case .limited:
            //    return Color.clear
            }
        }
        
        public func returnTypeCase() -> MyFoodiePackage.IngredientModel.IngredientType {
            return self
        }
        
        public func orderAndStorageValue() -> Int {
            
            switch self {
            case .standard:
                return 0
            case .asProduct:
                return 1
            }
        }
        
        
    }

    
}
