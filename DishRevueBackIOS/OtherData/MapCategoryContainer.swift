//
//  MapCategoryContainer.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/03/22.
//

import Foundation

enum MapCategoryContainer /*:MyEnumProtocolMapConform*/ {

    static var allMenuMapCategory: [MapCategoryContainer] = [.tipologiaMenu(),.giorniDelServizio(),.menuAz/*.statusMenu*/]
    static var allIngredientMapCategory: [MapCategoryContainer] = [.ingredientAz,.provenienza(),.conservazione(),.produzione()]
    static var allDishMapCategory: [MapCategoryContainer] = [.categoria(),.base(),.tipologiaPiatto(),.dishAz/*.statusPiatto*/]    
    static var defaultValue:MapCategoryContainer = .reset

    case tipologiaMenu(filter:TipologiaMenu? = nil)
    case giorniDelServizio(filter:GiorniDelServizio? = nil) // collection
    case statusMenu
    
    case conservazione(filter:ConservazioneIngrediente? = nil) // stored
    case produzione(filter:ProduzioneIngrediente? = nil) // stored
    case provenienza(filter:ProvenienzaIngrediente? = nil) // stored
    
    case categoria(filter:CategoriaMenu? = nil) // stored
    case base(filter:OrigineIngrediente? = nil) // stored
    case tipologiaPiatto(filter:TipoDieta? = nil) // collection
    case statusPiatto
    
    case menuAz
    case ingredientAz
    case dishAz
    
    case reset
        
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
        case .reset:
            return "nil"
        }
        
    }
    
    func returnTypeCase() -> MapCategoryContainer {
        
        switch self {
        case .tipologiaMenu(_):
            return .tipologiaMenu()
        case .giorniDelServizio(_):
            return .giorniDelServizio()
        case .statusMenu:
            return .statusMenu
        case .conservazione(_):
            return .conservazione()
        case .produzione(_):
            return .produzione()
        case .provenienza(_):
            return .provenienza()
        case .categoria(_):
            return .categoria()
        case .base(_):
            return .base()
        case .tipologiaPiatto(_):
            return .tipologiaPiatto()
        case .statusPiatto:
            return .statusPiatto
        case .menuAz:
            return .menuAz
        case .ingredientAz:
            return .ingredientAz
        case .dishAz:
            return .dishAz
        case .reset:
            return .reset
        }
        
    }
    
    func imageAssociated() -> String {
        return "eye"
    }
    
    func orderValue() -> Int {
        return 0
    }
    
}
