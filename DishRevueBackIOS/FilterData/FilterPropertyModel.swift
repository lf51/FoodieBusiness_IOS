//
//  FilterPropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/11/22.
//

import Foundation
import MyFoodiePackage

public struct FilterPropertyModel: MyProSearchPack_Sub_0 {
    
    var countChange:Int = 0
    // Comune a Tutti
    var stringaRicerca:String = ""
    var sortCondition:SortCondition?
    
    var onlineOfflineMenu:MenuModel.OnlineStatus? {willSet {countManageSingle(newValue: newValue, oldValue: onlineOfflineMenu)}}

    var status:[StatusTransition] = [] { willSet { countManage(newValue: newValue, oldValue: status) }}
    
    // Proprietà di filtro Ingrediente
    var provenienzaING:ProvenienzaIngrediente? {willSet {countManageSingle(newValue: newValue, oldValue: provenienzaING)}}
    var produzioneING:ProduzioneIngrediente? {willSet {countManageSingle(newValue: newValue, oldValue: produzioneING)}}
    var conservazioneING:[ConservazioneIngrediente] = [] { willSet { countManage(newValue: newValue, oldValue: conservazioneING) }}
    var origineING:OrigineIngrediente? {willSet {countManageSingle(newValue: newValue, oldValue: origineING)}}
   
    
    // In Comune fra Modelli
    var inventario:[Inventario.TransitoScorte] = [] { willSet { countManage(newValue: newValue, oldValue: inventario) }}
    var allergeniIn:[AllergeniIngrediente] = [] { willSet { countManage(newValue: newValue, oldValue: allergeniIn) }}

    // Proprietà di filtro Preparazioni
   /* var percorsoPRP:[DishModel.PercorsoProdotto] = [] { willSet { if !newValue.contains(.prodottoFinito) { self.inventario = [] } }}  */
    var percorsoPRP:[DishModel.PercorsoProdotto] = [] { willSet { observingPercorso(newValue: newValue, oldValue: percorsoPRP) }}
    
    var dietePRP:[TipoDieta] = [] { willSet { countManage(newValue: newValue, oldValue: dietePRP) }}

   // var eseguibilePRP:Bool?
    var basePRP:DishModel.BasePreparazione? {willSet {countManageSingle(newValue: newValue, oldValue: basePRP)}}
 
    var categorieMenu:[CategoriaMenu] = [] { willSet { countManage(newValue: newValue, oldValue: categorieMenu) }}

    // Proprietà di filtro Menu
    var giornoServizio:GiorniDelServizio? {willSet {countManageSingle(newValue: newValue, oldValue: giornoServizio)}}

    var tipologiaMenu:TipologiaMenu? {willSet {countManageSingle(newValue: newValue, oldValue: tipologiaMenu)}}
    var rangeTemporaleMenu:AvailabilityMenu? {willSet {countManageSingle(newValue: newValue, oldValue: rangeTemporaleMenu)}}
    
    
    // Method
    
   /* func compareBoolProperty(local:Bool,filter:KeyPath<Self,Bool?>) -> Bool {
        
        let filterBool = self[keyPath: filter]
        guard filterBool != nil else { return true }
        return local == filterBool
    } */
    
    mutating func countManageSingle<P:MyProEnumPack_L0>(newValue:P?,oldValue:P?)  {
        var value:Int = 0
        
        if newValue == nil { value = -1 }
        else if oldValue == nil { value = 1 }
        else { value = 0 }
        
        self.countChange += value
      
    }
    
    mutating func countManageStringCollection(newValue:[String],oldValue:[String])  {
        
        let value = newValue.count - oldValue.count
        self.countChange += value
      
    }
    
    mutating func countManage<P:MyProEnumPack_L0>(newValue:[P],oldValue:[P])  {
        
        let value = newValue.count - oldValue.count
        self.countChange += value
      
    }
    
    mutating func observingPercorso(newValue:[DishModel.PercorsoProdotto],oldValue:[DishModel.PercorsoProdotto])  {
        
        self.countManage(newValue: newValue, oldValue: oldValue)
        
        if !newValue.contains(.prodottoFinito) { self.inventario = [] }
      
    }
 
    // Metodi comparazione Per filtraggio
    
    /// Verifica che tutti gli elementi di una collezione filtro siano all'interno di una collezione da filtrare
    func compareCollectToCollectIntero(localCollection:[String],filterCollection:KeyPath<Self,[String]>) -> Bool {
        
        let filterCollect = self[keyPath: filterCollection]
        
        guard filterCollect != [] else { return true }
        
        for element in filterCollect {
            
            if localCollection.contains(element) { continue }
            else { return false }
        }
        
        return true

    }
    
     func comparePropertyToProperty<P:MyProEnumPack_L0>(local:P,filter:KeyPath<Self,P?>) -> Bool {
        
        let filterProp = self[keyPath: filter]
        
        guard filterProp != nil else { return true }
         return local.returnTypeCase() == filterProp?.returnTypeCase()
    }
      
    func comparePropertyToCollection<P:MyProEnumPack_L0>(localProperty:P,filterCollection:KeyPath<Self,[P]>) -> Bool {
        
        let filterCollect = self[keyPath: filterCollection]
        
        guard filterCollect != [] else { return true }
        
        return filterCollect.contains(localProperty)
            
    }
    
    func compareCollectionToProperty<P:MyProEnumPack_L0>(localCollection:[P],filterProperty:KeyPath<Self,P?>) -> Bool {
        
        let filterProp = self[keyPath: filterProperty]
        
        guard filterProp != nil else { return true }
        
        return localCollection.contains(filterProp!)
            
    }
    
    func compareCollectionToCollection<P:MyProEnumPack_L0>(localCollection:[P],filterCollection:KeyPath<Self,[P]>) -> Bool {
        
        let filterCollect = self[keyPath: filterCollection]
        
        guard filterCollect != [] else { return true }
        
        for value in filterCollect {
            if localCollection.contains(value) { return true }
            else { continue }
        }
        
        return false
      //  return localCollection.contains(filterCollect)
    }
    
    func compareStatusTransition(localStatus:StatusModel) -> Bool {
        
        guard self.status != [] else { return true}
      
        for value in self.status {
            
            if localStatus.checkStatusTransition(check: value) { return true }
            else { continue }
            
        }
        return false
        
    }
    
    func compareStatoScorte(modelId:String,readOnlyVM:AccounterVM) -> Bool {
        
        guard self.inventario != [] else { return true }
        
        let statoScorte = readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: modelId)
        
        return self.inventario.contains(statoScorte)
    }
    
    // Sort Space

    public enum SortCondition {
    
        case alfabeticoDecrescente
        
        case livelloScorte
        case mostUsed
        case mostContaining
        
        case mostRated
        case topRated
        case topPriced
        
        case dataInizio
        case dataFine
        
        
        func simpleDescription() -> String {
            
            switch self {
                
            case .alfabeticoDecrescente:
                return "Alfabetico Decrescente"
            case .livelloScorte:
                return "Livello Scorte"
            case .mostUsed:
                return "Utilizzo"
            case .mostContaining:
                return "Prodotti Contenuti"
            case .mostRated:
                return "Numero di Recensioni"
            case .topRated:
                return "Media Voto Ponderata"
            case .topPriced:
                return "Prezzo"
            case .dataInizio:
                return "Data Inizio Servizio"
            case .dataFine:
                return "Data Fine Servizio"
                
            }
            
        }
        
        func imageAssociated() -> String {
            
            switch self {
                
            case .alfabeticoDecrescente:
                return "textformat"
            case .livelloScorte:
                return "cart"
            case .mostUsed,.mostContaining:
                return "aqi.medium"
            case .mostRated:
                return "chart.line.uptrend.xyaxis"
            case .topRated:
                return "medal"
            case .topPriced:
                return "dollarsign"
            case .dataInizio:
                return "play.circle"
            case .dataFine:
                return "stop.circle"
                
            }

        }
        
    }
    
    
    
}
