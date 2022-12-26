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
    
    func compareStatoScorte(modelId:String,filterInventario:[Inventario.TransitoScorte]?, readOnlyVM:AccounterVM) -> Bool {
        
        guard let inventario = filterInventario,
              inventario != [] else { return true }
        
        let statoScorte = readOnlyVM.inventarioScorte.statoScorteIng(idIngredient: modelId)
        
        return inventario.contains(statoScorte)
    }

}
