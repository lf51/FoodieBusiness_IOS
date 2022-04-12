//
//  ViewBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/04/22.
//

import Foundation
import SwiftUI

@ViewBuilder func switchImageText(string: String?) -> some View { // verifica che la stringa contiene un solo carattere, in tal caso diamo per "certo" si tratti una emnojy e la trattiamo come testo. Utilizzato per CsLabel1 in data 08.11
    
        if let imageName = string {
            
            if imageName.count == 1 {Text(imageName)}
            else {Image(systemName: imageName)}
            
        } else { Image(systemName: "circle") }

}

@ViewBuilder func switchModelDataRowView<M:MyModelProtocol>(item: M/*, statusFilter: ModelStatus*/) -> some View {
     
     switch item.self {
         
     case is MenuModel:
         MenuModel_RowView(item: item as! MenuModel)
         
     case is DishModel:
         
         DishModel_RowView(item: item as! DishModel)
       /*  let item_1 = item as! DishModel
         if item_1.status == statusFilter {DishModel_RowView(item: item as! DishModel)}
         else { EmptyView() } */
     
     case is IngredientModel:
         IngredientModel_RowView(item: item as! IngredientModel)
         
     default:  Text("item is a notListed Type")
         
     }
 }
