//
//  AccountSetup.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/11/22.
//

import Foundation
import Firebase

struct AccountSetup:MyProCloudPack_L1 {
   
    var id: String
    var startCountDownMenuAt:TimeValue
    var mettiInPausaDishByIngredient: ActionValue

    init(id: String, startCountDownMenuAt: TimeValue, mettiInPausaDishByIngredient: ActionValue) {
        // Non dovrebbe essere in uso
        self.id = id
        self.startCountDownMenuAt = startCountDownMenuAt
        self.mettiInPausaDishByIngredient = mettiInPausaDishByIngredient
    }
    
    init() {
        
        self.id = "userSetup"
        self.startCountDownMenuAt = .sixty
        self.mettiInPausaDishByIngredient = .mai
    
    }
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        let countDownInt = frDoc[DataBaseField.startCountDownMenuAt] as? Int ?? 0
        let pausaInt = frDoc[DataBaseField.mettiInPausaDishByIngredient] as? Int ?? 0
        
        self.id = frDoc.documentID
        self.startCountDownMenuAt = TimeValue.convertiInCase(fromNumber: countDownInt)
        self.mettiInPausaDishByIngredient = ActionValue.convertiInCase(fromNumber: pausaInt)
        
    }
    
    func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.startCountDownMenuAt : self.startCountDownMenuAt.orderAndStorageValue(),
            DataBaseField.mettiInPausaDishByIngredient : self.mettiInPausaDishByIngredient.orderAndStorageValue()
        ]
        return documentData
    }
    
    struct DataBaseField {
        
        static let startCountDownMenuAt = "startCountDownValue"
        static let mettiInPausaDishByIngredient = "mettiInPausaDishByING"
    }
    
    //
    
    enum ActionValue:String,MyProCloudPack_L0 {
        
        static var allCases:[ActionValue] = [.sempre,.mai,.chiedi]
        static var defaultValue:ActionValue = .mai
        
        case sempre
        case mai
        case chiedi
        
        func orderAndStorageValue() -> Int {
            switch self {
                
            case .mai: return 0
            case .sempre: return 1
            case .chiedi: return 2
            }
        }
        
        static func convertiInCase(fromNumber: Int) -> AccountSetup.ActionValue {
            switch fromNumber {
                
            case 0: return .mai
            case 1: return .sempre
            case 2: return .chiedi
            default: return .defaultValue
            }
        }
        
    }
    
    enum TimeValue:Int,MyProCloudPack_L0 {
        
        static var allCases:[TimeValue] = [.trenta,.sixty,.novanta]
        static var defaultValue:TimeValue = .sixty
        
        case trenta = 30
        case sixty = 60
        case novanta = 90
        
        func orderAndStorageValue() -> Int {
            switch self {
            case .trenta: return 30
            case .sixty: return 60
            case .novanta: return 90
            }
        }
        
        static func convertiInCase(fromNumber: Int) -> AccountSetup.TimeValue {
            switch fromNumber {
                
            case 30: return .trenta
            case 60: return .sixty
            case 90: return .novanta
                
            default: return .defaultValue
                
            }
        }
    }
}
