//
//  MapCategoryContainer.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/03/22.
//

import Foundation

enum MapCategoryContainer {
    
    static var allMenuMapCategory: [MapCategoryContainer] = [.menuAz,.tipologiaMenu(),.giorniDelServizio(),/*.statusMenu*/]
    static var allIngredientMapCategory: [MapCategoryContainer] = [.ingredientAz,.provenienza(),.conservazione(),.produzione()]
    static var allDishMapCategory: [MapCategoryContainer] = [.dishAz,.categoria(),.base(),.tipologiaPiatto(),/*.statusPiatto*/]
    
   // static var defaultCase: MapCategoryContainer = .aZ
   // static var menuDefault: MapCategoryContainer = .tipologiaMenu
   // static var ingredientDefault: MapCategoryContainer = .produzione
   // static var dishDefault: MapCategoryContainer = .categoria
    
    case tipologiaMenu(filter:TipologiaMenu? = nil)
    case giorniDelServizio(filter:GiorniDelServizio? = nil) // collection
    case statusMenu
    
    case conservazione(filter:ConservazioneIngrediente? = nil) // stored
    case produzione(filter:ProduzioneIngrediente? = nil) // stored
    case provenienza(filter:ProvenienzaIngrediente? = nil) // stored
    
    case categoria(filter:DishCategoria? = nil) // stored
    case base(filter:DishBase? = nil) // stored
    case tipologiaPiatto(filter:DishTipologia? = nil)
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
    

    
   /* func associatedArray() -> [some MyEnumProtocolMapConform] {
        
        switch self {
            
        case .tipologiaMenu:
            return TipologiaMenu.allCases
        case .giorniDelServizio:
            return GiorniDelServizio.allCases
        case .statusMenu:
            return []
            
        case .conservazione:
            return ConservazioneIngrediente.allCases
        case .produzione:
            return ProduzioneIngrediente.allCases
        case .provenienza:
            return ProvenienzaIngrediente.allCases
            
        case .categoria:
            return DishCategoria.allCases
        case .base:
            return DishBase.allCases
        case .tipologiaPiatto:
            return DishTipologia.allCases
        case .statusPiatto:
            return []
            
        case .menuAz, .ingredientAz,.dishAz:
            return []
   
        }
    } */
    
    
}
