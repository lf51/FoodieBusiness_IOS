//
//  DishFormati.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

struct DishFormat: Hashable {
    
    var label: String
    var price: String
    
    let type: DishFormatType
   
    init(type: DishFormatType) {
        self.label = ""
        self.price = ""
        self.type = type
    }
    
}

enum DishFormatType {
    
    case mandatory,opzionale
}


