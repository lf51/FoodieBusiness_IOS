//
//  MapCategoryContainer.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/03/22.
//

import Foundation

enum MapCategoryContainer {
    
    static var allMenuMapCategory: [MapCategoryContainer] = [.menuAz,.tipologiaMenu,.giorniDelServizio,.statusMenu]
    static var allIngredientMapCategory: [MapCategoryContainer] = [.ingredientAz,.provenienza,.conservazione,.produzione]
    static var allDishMapCategory: [MapCategoryContainer] = [.dishAz,.categoria,.base,.tipologiaPiatto,.statusPiatto]
    
   // static var defaultCase: MapCategoryContainer = .aZ
   // static var menuDefault: MapCategoryContainer = .tipologiaMenu
   // static var ingredientDefault: MapCategoryContainer = .produzione
   // static var dishDefault: MapCategoryContainer = .categoria
    
    case tipologiaMenu
    case giorniDelServizio // collection
    case statusMenu
    
    case conservazione // stored
    case produzione // stored
    case provenienza // stored
    
    case categoria // stored
    case base // stored
    case tipologiaPiatto
    case statusPiatto
    
    case menuAz
    case ingredientAz
    case dishAz
    
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
        case .menuAz,.ingredientAz,.dishAz:
            return "a..z"
        }
        
    }
    
}
