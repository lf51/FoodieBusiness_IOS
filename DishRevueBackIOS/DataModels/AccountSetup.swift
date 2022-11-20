//
//  AccountSetup.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/11/22.
//

import Foundation

struct AccountSetup:MyProCloudPack_L1 {
   
    var id: String = "userSetup"
    // mettiamo qui tutte le enum e i valori per il settaggio personalizzato da parte dell'utente
    var startCountDownMenuAt:TimeValue = .sixty
    var mettiInPausaDishByIngredient: ActionValue = .mai
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.startCountDownMenuAt : self.startCountDownMenuAt.orderAndStorageValue(),
            DataBaseField.mettiInPausaDishByIngredient : self.mettiInPausaDishByIngredient.orderAndStorageValue()
        ]
        return documentData
    }
    
    struct DataBaseField:MyTest {
        
        static let startCountDownMenuAt = "startCountDownValue"
        static let mettiInPausaDishByIngredient = "mettiInPausaDishByING"
    }
    
    
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
