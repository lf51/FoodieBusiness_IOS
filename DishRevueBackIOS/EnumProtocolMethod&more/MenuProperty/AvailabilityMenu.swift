//
//  AvailabilityMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

enum AvailabilityMenu:Hashable {
    
    static var defaultValue: AvailabilityMenu = .noValue
    static var allCases:[AvailabilityMenu] = [.intervalloChiuso,.dataEsatta,.intervalloAperto]

    case dataEsatta
    case intervalloChiuso
    case intervalloAperto
    case noValue
    
    func shortDescription() -> String {
        
        switch self {
            
        case .dataEsatta:
            return "Data"
        case .intervalloChiuso:
            return "<..>"
        case .intervalloAperto:
            return "<..."
        case .noValue:
            return ""
        }
    }
    
    func extendedDescription() -> String? {
        
        switch self {
        case .dataEsatta:
            return "Scegli una data esatta. Es: Menu di Natale"
        case .intervalloChiuso:
            return "Programma il Menu con un Inizio e una Fine"
        case .intervalloAperto:
            return "Programma il Menu con un Inizio senza una Fine"
        case .noValue:
            return nil 
        }
        
    }
    
}
