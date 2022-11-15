//
//  DishFormati.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

struct DishFormat:Hashable{
        
    var label: String
    var price: String
    
    let type: DishFormatType
   
    init(type: DishFormatType) {
        self.label = ""
        self.price = ""
        self.type = type
    }
    
    func creaDocumentDataForFirebase() -> [String : Any] {
        
        let documentData:[String:Any] = [
            "label":self.label,
            "price":self.price,
            "type":self.type.orderAndStorageValue()
        ]
        return documentData
    }
    
    
}

enum DishFormatType:MyProCloudPack_L0 {
    
    case mandatory,opzionale
    
    func orderAndStorageValue() -> Int {
        switch self {
        case .mandatory: return 0
        case .opzionale: return 1
        }
    }
    
    static func convertiInCase(fromNumber: Int) -> DishFormatType {
        switch fromNumber {
        case 0: return .mandatory
        default: return .opzionale
        }
    }

}


