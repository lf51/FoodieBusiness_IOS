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

extension CoreFilter {
    
    // Beta - Nel caso spostare nel MyFilterPackage
    
    mutating func countManageSingle<P:Property_FPC>(newValue:P?,oldValue:P?)  {
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
    
    mutating func countManage<P:Property_FPC>(newValue:[P]?,oldValue:[P]?)  {
        
        guard newValue != nil,
              oldValue != nil else { return }
        
        let value = newValue!.count - oldValue!.count
        self.countChange += value
      
    }
    
   /* mutating func observingPercorso(newValue:[DishModel.PercorsoProdotto],oldValue:[DishModel.PercorsoProdotto])  {
        
        self.countManage(newValue: newValue, oldValue: oldValue)
        
        if !newValue.contains(.prodottoFinito) { self.inventario = [] }
      
    } */
    
}
