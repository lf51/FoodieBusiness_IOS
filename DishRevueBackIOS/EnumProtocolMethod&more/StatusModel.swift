//
//  StatusModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/06/22.
//

import Foundation
import SwiftUI

enum StatusTransition:Equatable {
    
  //  static var allCases: [StatusTransition] = [.pubblico,.inPausa,.archiviato]
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

enum StatusModel:Equatable { // vedi Nota Consegna 17.07
    
    case nuovo
    case bozza
    case completo(StatusTransition)
    
    func imageAssociated() -> String {
        
        switch self {
        case .nuovo:
            return "doc.badge.plus"
        case .bozza:
           return "hammer.circle.fill"//"doc.badge.gearshape" //  // moon.fill
        case .completo:
            return "circle.fill"
        }
    }
    
    func transitionStateColor() -> Color {
        
        switch self {
        case .nuovo:
            return Color.black
        case .bozza:
            return Color.red
        case .completo(let statusTransition):
            return statusTransition.colorAssociated()
        }
        
    }
    
    func simpleDescription() -> String {
        
        switch self {
        case .nuovo:
            return "nuovo"
        case .bozza:
            return "bozza"
        case .completo(let statusTransition):
            return statusTransition.simpleDescription()
        }
    }

}
