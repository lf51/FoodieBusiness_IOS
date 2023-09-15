//
//  VM_ChangeStore.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/12/22.
//

import Foundation

struct RemoteChangeStorage:Equatable { // possibile deprecazione causa modifica architettura_ crea locale -> salva firebase -> importa locale
    
    // Nota 02.12.22 su cronologia Modifiche
    
    var dish_countModificheIndirette:Int = 0
    var menu_countModificheIndirette:Int = 0
    
    var modelRif_newOne:[String] = []
    var modelRif_modified:Set<String> = []
    var modelRif_deleted:[String:String] = [:] // key:Id_rif - value: model_intestazione

}
