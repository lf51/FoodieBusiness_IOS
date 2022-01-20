//
//  AlertObject.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/01/22.
//

import Foundation

struct AlertObject: Identifiable {
  var id = UUID()
  var title: String
  var message: String
}
