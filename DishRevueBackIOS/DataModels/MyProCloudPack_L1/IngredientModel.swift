//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation
import SwiftUI
import Firebase

// Creare Oggetto Ingrediente

struct IngredientModel:MyProToolPack_L1,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1,MyProCloudPack_L1 /*MyModelStatusConformity */ {
 
  static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [IngredientModel]> {
        return \.allMyIngredients
    }
    
  static func == (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.intestazione == rhs.intestazione &&
      lhs.descrizione == rhs.descrizione &&
      lhs.conservazione == rhs.conservazione &&
      lhs.produzione == rhs.produzione &&
      lhs.provenienza == rhs.provenienza &&
      lhs.allergeni == rhs.allergeni &&
      lhs.origine == rhs.origine &&
      lhs.status == rhs.status 
    //  lhs.inventario == rhs.inventario
   
    }
    
   // var id: String { creaID(fromValue: self.intestazione) } // Deprecata 18.08
    var id: String = UUID().uuidString //

    var intestazione: String = "" //
    var descrizione: String = "" //
    
    var conservazione: ConservazioneIngrediente = .defaultValue //
    var produzione: ProduzioneIngrediente = .defaultValue //
    var provenienza: ProvenienzaIngrediente = .defaultValue //
    
    var allergeni: [AllergeniIngrediente] = [] //
    var origine: OrigineIngrediente = .defaultValue //
    
    var status: StatusModel = .bozza() //
   // var inventario:Inventario = Inventario()

    // Method
    
    init(intestazione:String,descrizione:String,conservazione:ConservazioneIngrediente,produzione:ProduzioneIngrediente,provenienza:ProvenienzaIngrediente,allergeni:[AllergeniIngrediente],origine:OrigineIngrediente,status:StatusModel) {
        
        self.intestazione = intestazione
        self.descrizione = descrizione
        self.conservazione = conservazione
        self.produzione = produzione
        self.provenienza = provenienza
        self.allergeni = allergeni
        self.origine = origine
        self.status = status
        
        // usato nei test. da abolire
    }
    
    init() {
        
        // creare un init di default
        
    }
    
    init(id:String) {
        self.id = id
     
    }
    
    init(frDoc:QueryDocumentSnapshot) {
        // init da firebase Data
        
        let conservazioneInt = frDoc[DataBaseField.conservazione] as? Int ?? 0
        let produzioneInt = frDoc[DataBaseField.produzione] as? Int ?? 0
        let provenienzaInt = frDoc[DataBaseField.provenienza] as? Int ?? 0
        let origineInt = frDoc[DataBaseField.origine] as? Int ?? 0
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        let allergeniInt = frDoc[DataBaseField.allergeni] as? [Int] ?? []
        
        self.id = frDoc.documentID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.conservazione = ConservazioneIngrediente.convertiInCase(fromNumber: conservazioneInt)
        self.produzione = ProduzioneIngrediente.convertiInCase(fromNumber: produzioneInt)
        self.provenienza = ProvenienzaIngrediente.convertiInCase(fromNumber: provenienzaInt)
        self.origine = OrigineIngrediente.convertiInCase(fromNumber: origineInt)
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        self.allergeni = allergeniInt.map({AllergeniIngrediente.convertiInCase(fromNumber: $0)})
  
    }
    
    
    func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String:Any] {
        
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
        
    }

    struct DataBaseField {
        
        static let intestazione = "intestazione"
        static let descrizione = "descrizione"
        static let conservazione = "conservazione"
        static let produzione = "produzione"
        static let provenienza = "provenienza"
        static let allergeni = "allergeni"
        static let origine = "origine"
        static let status = "status"
        
        
    }
    
    func manageModelDelete(viewModel:AccounterVM) {
        
        let allDishWhereIsIn = viewModel.allDishContainingIngredient(idIng: self.id)
        
        guard !allDishWhereIsIn.isEmpty else {
            viewModel.deleteItemModel(itemModel: self)
            return }
        
        var allDishChanged:[DishModel] = []
        
        for dish in allDishWhereIsIn {
            
            var new = dish
            let (ingPath,index) = new.individuaPathIngrediente(idIngrediente: self.id)
            
            if ingPath != nil, index != nil {
                new[keyPath: ingPath!].remove(at: index!)
                new.autoCleanElencoIngredientiOff()
            }
            allDishChanged.append(new)
        }
        
        viewModel.updateItemModelCollection(items: allDishChanged)
        viewModel.deleteItemModel(itemModel: self)
    }
    
    func conditionToManageMenuInterattivo() -> (disableCustom: Bool, disableStatus: Bool, disableEdit: Bool, disableTrash: Bool, opacizzaAll: CGFloat) {
        
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
    
    func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:AccounterVM   ) -> Bool { false }
    
    /// Mette in pausa tutti i piatti che contengono l'ingrediente il cui stato è passato da .disponibile a .inPausa o .archiviato
    func manageCambioStatus(nuovoStatus:StatusTransition,viewModel:AccounterVM) {
    
        let isCurrentlyDisponibile = self.status.checkStatusTransition(check: .disponibile)
        
        viewModel.manageCambioStatusModel(model: self, nuovoStatus: nuovoStatus)
       // viewModel.remoteStorage.modelRif_modified.insert(self.id)
        
        guard nuovoStatus != .disponibile, isCurrentlyDisponibile else { return }
        
        if nuovoStatus == .inPausa, viewModel.setupAccount.autoPauseDish_byPauseING == .sempre {
            
            privateStatusChange()
            
        } else if nuovoStatus == .archiviato, viewModel.setupAccount.autoPauseDish_byArchiveING == .sempre {
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

    }
    
    func conversioneAllergeniInt() -> [Int] {
        
        let numAllergeni = self.allergeni.map({$0.orderAndStorageValue()})
        return numAllergeni
        
    }
    // Protocollo di ricerca
    
    static func sortModelInstance(lhs: IngredientModel, rhs: IngredientModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
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
    }
    
    func modelStringResearch(string: String,readOnlyVM:AccounterVM? = nil) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let condtionOne = self.intestazione.lowercased().contains(ricerca)

        let allAllergens = self.allergeni.map({$0.intestazione.lowercased()})
        let allAllergensChecked = allAllergens.filter({$0.contains(ricerca)})
        
        let conditionTwo = !allAllergensChecked.isEmpty
        
        return condtionOne || conditionTwo

    } // La teniamo nel modello per permettere una maggiore customizzazione nella ricerca
    
    
    func modelPropertyCompare(filterProperty: FilterPropertyModel,readOnlyVM:AccounterVM) -> Bool {
        
        // 02.11 Abbiamo spostato tutte le funzioni di compare direttamente nel filterPropertyModel per avere uniformità e non duplicare codice
        
        self.modelStringResearch(string: filterProperty.stringaRicerca) &&
        filterProperty.comparePropertyToProperty(local: self.provenienza, filter: \.provenienzaING) &&
        filterProperty.comparePropertyToProperty(local: self.produzione, filter: \.produzioneING) &&
        filterProperty.comparePropertyToProperty(local: self.origine, filter: \.origineING) &&
        filterProperty.comparePropertyToCollection(localProperty: self.conservazione, filterCollection: \.conservazioneING) &&
        filterProperty.compareStatusTransition(localStatus: self.status) &&
        filterProperty.compareStatoScorte(modelId: self.id, readOnlyVM: readOnlyVM) &&
        filterProperty.compareCollectionToCollection(localCollection: self.allergeni, filterCollection: \.allergeniIn)
       

    }
    
    //
    func returnModelRowView(rowSize:RowSize) -> some View {
        // rowSize da implementare
        IngredientModel_RowView(item: self)
    }

    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // deprecata in futuro
    
    func modelStatusDescription() -> String {
        "Ingrediente (\(self.status.simpleDescription().capitalized))"
    } // deprecata in futuro
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [IngredientModel]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String) {
        
        return (\.allMyIngredients, "Lista Ingredienti", "Ingrediente","leaf")
    }

    func pathDestination() -> DestinationPathView {
        DestinationPathView.ingrediente(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
              
        let generalDisabled = self.status.checkStatusTransition(check: .archiviato)
        
       return VStack {
            
            let statoScorte = viewModel.inventarioScorte.statoScorteIng(idIngredient: self.id)
            let ultimoAcquisto = viewModel.inventarioScorte.dataUltimoAcquisto(idIngrediente: self.id)
                
                Menu {
                    
                    Button("in Esaurimento") {
                        viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inEsaurimento)
                    }.disabled(statoScorte != .inStock)
                    
                    Button("Esaurite") {
                        viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .esaurito)
                        // innesto 01.12.22
                        if self.status.checkStatusTransition(check: .disponibile) {
                            self.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                        }
                        
                    }.disabled(statoScorte == .esaurito || statoScorte == .inArrivo)
                    
                    if statoScorte == .esaurito || statoScorte == .inEsaurimento {
                        
                        Button("Rimetti in Stock") {
                            viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inStock)
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
    }
    
    
    /// Permette di sovrascrivere l'immagine associata all'origine con una immagine riferita agli allergeni che rispecchia meglio il prodotto - pensata e costruita per l'ingredientRow
    func associaImmagine() -> (name:String,size:Image.Scale) {
        
        var allergeneDiServizio:AllergeniIngrediente = .defaultValue
        
        if self.origine == .animale {
            
            if self.allergeni.contains(where: {
                
                $0 == .pesce || $0 == .crostacei || $0 == .molluschi
                
            }) { allergeneDiServizio = .pesce }
            
            else if self.allergeni.contains(where: {
                
                $0 == .latte_e_derivati
                
            }) { allergeneDiServizio = .latte_e_derivati }
            
            else if self.allergeni.contains(where: {
                
                $0 == .uova_e_derivati
                
            }) { allergeneDiServizio = .uova_e_derivati }
            
            else { return (self.origine.imageAssociated(),.large) }
            
        } else {
            
            if self.allergeni.contains(where: {
                
                $0 == .glutine
                
            }) { allergeneDiServizio = .glutine
                return (allergeneDiServizio.imageAssociated(),.medium)
            }// { allergeneDiServizio = .glutine }
            
            else if self.allergeni.contains(where: {
                
                $0 == .arachidi_e_derivati || $0 == .fruttaAguscio
                
            }) { allergeneDiServizio = .arachidi_e_derivati }
            
            else { return (self.origine.imageAssociated(),.large)}
    
        }
 
        return (allergeneDiServizio.imageAssociated(),.large)
    }
    
    func dishWhereIn(readOnlyVM:AccounterVM) -> (dishCount:Int,Substitution:Int) {
        
        var dishCount: Int = 0
        var dishWhereHasSubstitute: Int = 0
        
        for dish in readOnlyVM.allMyDish {
            
            if dish.checkIngredientsInPlain(idIngrediente: self.id) {
                dishCount += 1
                if dish.checkIngredientHasSubstitute(idIngrediente: self.id) { dishWhereHasSubstitute += 1}
            }
        }
        return (dishCount,dishWhereHasSubstitute)
    }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.produzione != .defaultValue &&
        self.provenienza != .defaultValue
    }
}




