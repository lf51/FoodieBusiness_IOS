//
//  MapCategoryContainer.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/03/22.
//

import Foundation

enum MapCategoryContainer {
    
    static var allMenuMapCategory: [MapCategoryContainer] = [.tipologiaMenu,.giorniDelServizio,.statusMenu]
    static var allIngredientMapCategory: [MapCategoryContainer] = [.conservazione,.produzione,.provenienza]
    static var allDishMapCategory: [MapCategoryContainer] = [.categoria,.base,.tipologiaPiatto,.statusPiatto]
    
    static var menuDefault: MapCategoryContainer = .tipologiaMenu
    static var ingredientDefault: MapCategoryContainer = .produzione
    static var dishDefault: MapCategoryContainer = .categoria
    
    case tipologiaMenu // comune sia al menu che al piatto // stored
    case giorniDelServizio // collection
    case statusMenu
    
    case conservazione // stored
    case produzione // stored
    case provenienza // stored
    
    case categoria // stored
    case base // stored
    case tipologiaPiatto
    case statusPiatto
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .tipologiaMenu:
            return "Tipologia"
        case .giorniDelServizio:
            return "Giorni Servizio"
        case .statusMenu:
            return "Status"
        case .conservazione:
           return "Conservazione"
        case .produzione:
            return "Produzione"
        case .provenienza:
            return "Provenienza"
        case .categoria:
            return "Portata"
        case .base:
            return "A base Di"
        case .tipologiaPiatto:
            return "Tipologia"
        case .statusPiatto:
            return "Status"
        }
        
    }
    
}
