//
//  DishFormati.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import Firebase

struct DishFormat:Hashable,MyProCloudPack_L1 {
    
    var id:String = "DishFormatPrice_NoneID" // Non serve. Non lo salviamo su firebase e quindi ne viene assegnato uno nuovo ogni volta
    
    var label: String
    var price: String
    
    let type: DishFormatType
   
    init(type: DishFormatType) {
        self.label = ""
        self.price = ""
        self.type = type
    }
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        let typeInt = frDoc[DataBaseField.type] as? Int ?? 0
        
        self.label = frDoc[DataBaseField.label] as? String ?? ""
        self.price = frDoc[DataBaseField.price] as? String ?? ""
        self.type = DishFormatType.convertiInCase(fromNumber: typeInt)
    }
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
            DataBaseField.label : self.label,
            DataBaseField.price : self.price,
            DataBaseField.type : self.type.orderAndStorageValue()
        ]
        return documentData
    }
    
    struct DataBaseField {
        
        static let label = "label"
        static let price = "price"
        static let type = "type"
        
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


