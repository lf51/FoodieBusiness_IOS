//
//  CoreFilterExtension.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/12/22.
//

import Foundation
import MyFoodiePackage
import MyFilterPackage

extension CoreFilter {
    
   /* func compareStatusTransition(localStatus:StatusModel,filterStatus:[StatusTransition]?) -> Bool {
        
        guard
            let filter = filterStatus,
            filter != [] else { return true }
      
        for value in filter {
            
            if localStatus.checkStatusTransition(check: value) { return true }
            else { continue }
            
        }
        return false
        
    }*/  // deprecata
    func compareStatusTransition(localStatus:StatusTransition,filterStatus:[StatusTransition]?,tipologiaFiltro:TipologiaFiltro) -> Bool {
        
        guard
            let filter = filterStatus,
            filter != [] else { return true }
      
        for value in filter {
            
            if localStatus == value { return true }
            else { continue }
            
        }
        return false
        
    }
    
    func compareStatusTransition(localStatus:StatusTransition,singleFilter:StatusTransition?,tipologiaFiltro:TipologiaFiltro) -> Bool {
        
        guard
            let filter = singleFilter else { return true }
      
        let condition = localStatus == filter
        
        return tipologiaFiltro.normalizeBoolValue(value: condition)
        
    }
    
   /* func compareStatoScorte(modelId:String,filterInventario:[StatoScorte]?,tipologiaFiltro:TipologiaFiltro, readOnlyVM:AccounterVM) -> Bool {
        
        guard let inventario = filterInventario,
              inventario != [] else { return true }
        
        let statoScorte = readOnlyVM.getStatusScorteING(from: modelId)
        let condition = inventario.contains(statoScorte)
        
        return tipologiaFiltro.normalizeBoolValue(value: condition)
    } */
    
   /* func compareStatoScorte(modelId:String,singleFilter:StatoScorte?,tipologiaFiltro:TipologiaFiltro, readOnlyVM:AccounterVM) -> Bool {
        
        guard let inventario = singleFilter else { return true }
        
        let statoScorte = readOnlyVM.getStatusScorteING(from: modelId)
        let condition = statoScorte == inventario
        return tipologiaFiltro.normalizeBoolValue(value: condition)
    }*/ // create 09.07.23

}
