//
//  StatusModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/06/22.
//

import Foundation
import SwiftUI

enum StatusTransition:String {
    
  //  static var allCases: [StatusTransition] = [.pubblico,.inPausa,.archiviato]
 //   static var defaultValue: StatusTransition = .archiviato
    
    case pubblico // Rimette in moto da una Pausa
    case inPausa = "in Pausa"// Stop temporaneo --> Solo per gli ingredienti, quando temporaneamente in pausa vorrei dare la possibilità all'utente di sostituirli.
    case archiviato = "pubblicabile" // Stop incondizionato

    func colorAssociated() -> Color {
        
        switch self {
            
        case .pubblico:
            return Color.green
        case .inPausa:
            return Color.yellow
        case .archiviato:
            return Color.red
        }
    }
}

enum StatusModel:Equatable {
    
    case bozza
    case completo(StatusTransition)
    
    func imageAssociated() -> String {
        
        switch self {
        case .bozza:
           return "gear.badge.xmark"
        case .completo:
            return "circle.fill"
        }
    }
    
    func transitionStateColor() -> Color {
        
        switch self {
        case .bozza:
            return Color.black
        case .completo(let statusTransition):
            return statusTransition.colorAssociated()
        }
        
    }
    
    func simpleDescription() -> String {
        
        switch self {
        case .bozza:
            return "bozza"
        case .completo(let statusTransition):
            return statusTransition.rawValue
        }
    }
    
    
}
