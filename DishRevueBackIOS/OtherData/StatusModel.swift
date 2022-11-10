//
//  StatusModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/06/22.
//

import Foundation
import SwiftUI

enum StatusTransition:MyProEnumPack_L0,Equatable {
    
    static var allCases: [StatusTransition] = [.disponibile,.inPausa,.archiviato]
 //   static var defaultValue: StatusTransition = .archiviato
    
    case disponibile // Rimette in moto da una Pausa
    case inPausa // Stop temporaneo --> Solo per gli ingredienti, quando temporaneamente in pausa vorrei dare la possibilità all'utente di sostituirli.
    case archiviato  // Stop incondizionato

    func simpleDescription() -> String {
        
        switch self {
        case .disponibile:
            return "disponibile"
        case .inPausa:
            return "in Pausa"
        case .archiviato:
            return "non disponibile"
        }
    }
    
    func returnTypeCase() -> StatusTransition {
        self
    }
    
    func orderAndStorageValue() -> Int {
        switch self {
        case .disponibile:
            return 0
        case .inPausa:
            return 1
        case .archiviato:
            return 2
        }
    }
    
    func colorAssociated() -> Color {
        
        switch self {
            
        case .disponibile:
            return Color.green
        case .inPausa:
            return Color.yellow
        case .archiviato:
            return Color.red
        }
    }
}

enum StatusModel:Equatable,MyProCloudPack_L0 { // vedi Nota Consegna 17.07
    
   // case nuovo // deprecato 07.09
    case bozza(StatusTransition? = nil)
    case completo(StatusTransition)
    
    func imageAssociated() -> String {
        
        switch self {
        case .bozza:
           return "hammer.circle.fill"//"doc.badge.gearshape" //  // moon.fill
        case .completo:
            return "circle.dashed.inset.filled"//"circle.fill"
        }
    }
    
    func transitionStateColor() -> Color {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition?.colorAssociated() ?? Color.gray
        case .completo(let statusTransition):
            return statusTransition.colorAssociated()
        }
        
    }
    
    func simpleDescription() -> String {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition?.simpleDescription() ?? "Nuovo"
        case .completo(let statusTransition):
            return statusTransition.simpleDescription()
        }
    }
    
    func checkStatusTransition(check:StatusTransition) -> Bool {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition == check
        case .completo(let statusTransition):
            return statusTransition == check
        }
        
    }
    
    func changeStatusTransition(changeIn: StatusTransition) -> Self {
        
        switch self {
        case .bozza(_):
            return .bozza(changeIn)
        case .completo(_):
            return .completo(changeIn)
        }
        
    }
    
    func checkStatusBozza() -> Bool {
        
        switch self {
        case .bozza(_):
            return true
        default: return false
        }
        
    }
    
    func orderAndStorageValue() -> Int {
        
        switch self {
        case .bozza(let statusTransition):
            let number = statusTransition == nil ? 0 : (1 + statusTransition!.orderAndStorageValue())
            return number
        case .completo(let statusTransition):
            let number = 4 + statusTransition.orderAndStorageValue()
            return number
        }
    }
    
    static func convertiInCase(fromNumber: Int) -> StatusModel {
        
        switch fromNumber {
            
        case 0:
            return .bozza()
        case 1:
            return .bozza(.disponibile)
        case 2:
            return .bozza(.inPausa)
        case 3:
            return .bozza(.archiviato)
        case 4:
            return .completo(.disponibile)
        case 5:
            return .completo(.inPausa)
        case 6:
            return .completo(.archiviato)
        default:
            return .bozza()
        }
    }
    
  /*  func estrapolaStatusTransition() -> StatusTransition? {
        
        switch self {
        case .bozza(let statusTransition):
            return statusTransition
        case .completo(let statusTransition):
            return statusTransition
        }
    } */
    

}
