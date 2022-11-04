//
//  FilterPropertyModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/11/22.
//

import Foundation

struct FilterPropertyModel {
    
    var countChange:Int = 0
    // Comune a Tutti
    var stringaRicerca:String = ""
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
    var rifIngredientiPRP:[String] = [] { willSet { countManageStringCollection(newValue: newValue, oldValue: rifIngredientiPRP) }} // Deprecato 04.11 -> Spostiamo il filtro per ingredienti nella ricerca. Vedi Nota sui Filtri 03.11
   // var eseguibilePRP:Bool?
    var basePRP:DishModel.BasePreparazione? {willSet {countManageSingle(newValue: newValue, oldValue: basePRP)}}
 
    // Proprietà di filtro Menu
    var giornoServizio:GiorniDelServizio? {willSet {countManageSingle(newValue: newValue, oldValue: giornoServizio)}}
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
        return local == filterProp
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
    
}
