//
//  EnumAndProtocol.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import Foundation
import SwiftUI

enum ModelList: Equatable, Hashable {
       
    ///Case Predefinito per la relazione Piatto/Ingredienti.
    static var dishIngredientsList: [ModelList] = [
    
        .viewModelContainer("My Ingredients",\.allMyIngredients,.fonte),
        .viewModelContainer("From Community",\.listoneFromListaBaseModelloIngrediente,.fonte),
        .itemModelContainer("Ingredienti Principali",\DishModel.ingredientiPrincipali,.destinazione(Color.mint, grado: .principale)),
        .itemModelContainer("Ingredienti Secondari",\DishModel.ingredientiSecondari,.destinazione(Color.orange, grado: .secondario))
    
    ]
    
   /* static var dishIngredientsList: [ModelList] = [
    
        .viewModelContainer("My Ingredients",\.allMyIngredients,.fonte),
       
        .itemModelContainer("Ingredienti Principali",\DishModel.ingredientiPrincipali,.destinazione(Color.mint, grado: .principale))
    
    ] */
    
    
    ///Case Predefinito per la relazione Piatto/Menu.
    static var dishMenuList: [ModelList] = [ ]
    
    ///Case Predefinito per la relazione Menu/Piatti.
    static var menuDishList: [ModelList] = [
        .viewModelContainer("Tutti i Piatti",\.allMyDish,.fonte),
        .itemModelContainer("Piatti in Menu",\MenuModel.dishIn, .destinazione(Color.brown, grado: .principale))
    ]
    ///Case Predefinito per la relazione Piatto/Proprietà
    static var menuPropertyList: [ModelList] = []
    
    ///Case Predefinito per la relazione Proprietà/Menu.
    static var propertyMenuList: [ModelList] = [
        .viewModelContainer("Menu Disponibili",\.allMyMenu, .fonte),
        .itemModelContainer("Menu In",\PropertyModel.menuIn, .destinazione(Color.yellow, grado: .principale))
    ]
    
    /// utilizzare come Fonte Dati
    case viewModelContainer(String,PartialKeyPath<AccounterVM>,ContainerType)
    /// utilizzare come Destinazione dati
    case itemModelContainer(String,AnyKeyPath,ContainerType)
    
    func returnAssociatedValue() -> (String,AnyKeyPath,ContainerType) {
    
        switch self {
            
        case .viewModelContainer(let string, let partialKeyPath, let containerType):
            return (string,partialKeyPath,containerType)
        case .itemModelContainer(let string, let anyKeyPath, let containerType):
            return (string,anyKeyPath,containerType)
        }
    
    }
    
    enum ContainerType: Hashable {
        
        case fonte
        case destinazione(Color, grado:GradoContainer)
     
        func returnAssociatedValue() -> (Color,GradoContainer) {
            
            switch self {
            case .fonte:
                return (Color.clear,.flat)
            case .destinazione(let color, let grado):
              return (color,grado)

            }
        }
                
        enum GradoContainer:Int {
            
            case principale = 0
            case secondario
            case flat // non rientra in una gerarchia. Usato per standardizzare il case destinazione e per il case Fonte
            
        }
        
    }
}
