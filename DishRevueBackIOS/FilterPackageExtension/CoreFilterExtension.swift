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
    
    func compareStatusTransition(localStatus:StatusModel,filterStatus:[StatusTransition]?) -> Bool {
        
        guard
            let filter = filterStatus,
            filter != [] else { return true }
      
        for value in filter {
            
            if localStatus.checkStatusTransition(check: value) { return true }
            else { continue }
            
        }
        return false
        
    } 
    
    func compareStatusTransition(localStatus:StatusModel,singleFilter:StatusTransition?) -> Bool {
        
        guard
            let filter = singleFilter else { return true }
      
            return localStatus.checkStatusTransition(check: filter)
        
    }  // creata 16.03.23
    
    func compareStatoScorte(modelId:String,filterInventario:[Inventario.TransitoScorte]?, readOnlyVM:AccounterVM) -> Bool {
        
        guard let inventario = filterInventario,
              inventario != [] else { return true }
        
        let statoScorte = readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: modelId)
        
        return inventario.contains(statoScorte)
    }

}
