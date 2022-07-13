//
//  AlertObject.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/01/22.
//

import Foundation


struct AlertModel: Identifiable {
    
  let id = UUID()
  let title: String
  let message: String
  var actionPlus: ActionModel? = nil
 // let actionTitle: String? = nil
 // let action: (() -> Void)? = nil
}


