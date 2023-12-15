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
    func compareStatusTransition(localStatus:StatusTransition,filterStatus:[StatusTransition]?) -> Bool {
        
        guard
            let filter = filterStatus,
            filter != [] else { return true }
      
        for value in filter {
            
            if localStatus == value { return true }
            else { continue }
            
        }
        return false
        
    }
    
    func compareStatusTransition(localStatus:StatusTransition,singleFilter:StatusTransition?) -> Bool {
        
        guard
            let filter = singleFilter else { return true }
      
            return localStatus == filter
        
    }
   /* func compareStatusTransition(localStatus:StatusModel,singleFilter:StatusTransition?) -> Bool {
        
        guard
            let filter = singleFilter else { return true }
      
            return localStatus.checkStatusTransition(check: filter)
        
    } */ // deprecata
    
    func compareStatoScorte(modelId:String,filterInventario:[StatoScorte]?, readOnlyVM:AccounterVM) -> Bool {
        
        guard let inventario = filterInventario,
              inventario != [] else { return true }
        
       /* let statoScorte = readOnlyVM.currentProperty.inventario.statoScorteIng(idIngredient: modelId) */
        let statoScorte = readOnlyVM.getStatusScorteING(from: modelId)
        
        return inventario.contains(statoScorte)
    }
    
    func compareStatoScorte(modelId:String,singleFilter:StatoScorte?, readOnlyVM:AccounterVM) -> Bool {
        
        guard let inventario = singleFilter else { return true }
        
        let statoScorte = readOnlyVM.getStatusScorteING(from: modelId)
        
        return statoScorte == inventario
    } // create 09.07.23

}
