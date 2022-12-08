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

    var autoPauseDish_byPauseING: ActionValue
    var autoPauseDish_byArchiveING: ActionValue
    var autoPauseDish_byDeleteING: ActionValue // 27.11 Non serve -> Vedi Nota 27.11

    static let autoPauseDish_allCases:[ActionValue] = [.sempre,.mai]
    
  /*  init(id: String, startCountDownMenuAt: TimeValue, autoPauseDish_byPauseING: ActionValue) {
        // Non dovrebbe essere in uso
        self.id = id
        self.startCountDownMenuAt = startCountDownMenuAt
        self.autoPauseDish_byPauseING = mettiInPausaDishByIngredient
    } */
    
    init() {
        
        self.id = "userSetup"
        self.startCountDownMenuAt = .sixty
        self.autoPauseDish_byPauseING = .sempre
        self.autoPauseDish_byDeleteING = .sempre
        self.autoPauseDish_byArchiveING = .sempre
    
    }
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        let countDownInt = frDoc[DataBaseField.startCountDownMenuAt] as? Int ?? 0
        let pausaInt = frDoc[DataBaseField.autoPauseDish_byPauseING] as? Int ?? 0
        let byDeleteInt = frDoc[DataBaseField.autoPauseDish_byDeleteING] as? Int ?? 0
        let byArchiveInt = frDoc[DataBaseField.autoPauseDish_byArchiveING] as? Int ?? 0
        
        self.id = frDoc.documentID
        self.startCountDownMenuAt = TimeValue.convertiInCase(fromNumber: countDownInt)
        self.autoPauseDish_byPauseING = ActionValue.convertiInCase(fromNumber: pausaInt)
        self.autoPauseDish_byArchiveING = ActionValue.convertiInCase(fromNumber: byArchiveInt)
        self.autoPauseDish_byDeleteING = ActionValue.convertiInCase(fromNumber: byDeleteInt)
        
    }
    
    func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.startCountDownMenuAt : self.startCountDownMenuAt.orderAndStorageValue(),
            DataBaseField.autoPauseDish_byPauseING : self.autoPauseDish_byPauseING.orderAndStorageValue(),
            DataBaseField.autoPauseDish_byArchiveING : self.autoPauseDish_byArchiveING.orderAndStorageValue(),
            DataBaseField.autoPauseDish_byDeleteING : self.autoPauseDish_byDeleteING.orderAndStorageValue()
            
        ]
        return documentData
    }
    
    struct DataBaseField {
        
        static let startCountDownMenuAt = "startCountDownValue"
        static let autoPauseDish_byPauseING = "autoPauseDish_byPauseING"
        static let autoPauseDish_byDeleteING = "autoPauseDish_byDeleteING"
        static let autoPauseDish_byArchiveING = "autoPauseDish_byArchiveING"
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
        
        static var allCases:[TimeValue] = [.quarter,.trenta,.fortyfive,.sixty,.seventyFive,.novanta,.twoHour]
        static var defaultValue:TimeValue = .sixty
        
        case quarter = 15
        case trenta = 30
        case fortyfive = 45
        case sixty = 60
        case seventyFive = 75
        case novanta = 90
        case twoHour = 120
        
        func orderAndStorageValue() -> Int {
            switch self {
            case .quarter: return 15
            case .trenta: return 30
            case .fortyfive: return 45
            case .sixty: return 60
            case .seventyFive: return 75
            case .novanta: return 90
            case .twoHour: return 120
            }
        }
        
        static func convertiInCase(fromNumber: Int) -> AccountSetup.TimeValue {
            switch fromNumber {
                
            case 15: return .quarter
            case 30: return .trenta
            case 45: return .fortyfive
            case 60: return .sixty
            case 75: return .seventyFive
            case 90: return .novanta
            case 120: return .twoHour
                
            default: return .defaultValue
                
            }
        }
    }
}
