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
        .viewModelIngredientContainer("allMyIngredients", \.allMyIngredients),
        .viewModelIngredientContainer("allFromCommunity", \.listoneFromListaBaseModelloIngrediente),
        .dishModelIngredientContainer("IngredientiPrincipali", \.ingredientiPrincipali),
        .dishModelIngredientContainer("IngredientiSecondary", \.ingredientiSecondari)
            ]
    
    ///Case Predefinito per la relazione Piatto/Menu.
    static var dishMenuList: [ModelList] = [ ]
    
    ///Case Predefinito per la relazione Menu/Piatti.
    static var menuDishList: [ModelList] = []
    ///Case Predefinito per la relazione Piatto/Proprietà
    static var menuPropertyList: [ModelList] = []
    ///Case Predefinito per la relazione Proprietà/Menu.
    static var propertyMenuList: [ModelList] = [] 
    
    /// Container da cui attingere dati.
  //  case viewModelContainer(String,KeyPath<AccounterVM,[IngredientModel]>)
    /// Container in cui riversare nuovi dati.
  //   case itemModelContainer(String,AnyKeyPath)
    
     case viewModelDishContainer(String,KeyPath<AccounterVM,[DishModel]>)
     case viewModelIngredientContainer(String,KeyPath<AccounterVM,[IngredientModel]>)
     case viewModelMenuContainer(String,KeyPath<AccounterVM,[MenuModel]>)
     case viewModelPropertyContainer(String,KeyPath<AccounterVM,[PropertyModel]>)
     
     case dishModelIngredientContainer(String,WritableKeyPath<DishModel,[IngredientModel]>)
     case dishModelMenuContainer(String,WritableKeyPath<DishModel,[MenuModel]>)
     
     case menuModelDishContainer(String,WritableKeyPath<MenuModel,[DishModel]>)
     case menuModelPropertyContainer(String,WritableKeyPath<MenuModel,[PropertyModel]>)
     
     case propertyModelMenuContainer(String,WritableKeyPath<PropertyModel,[MenuModel]>)

    func returnAssociatedValue() -> (String,AnyKeyPath,ContainerListType) {
        
        switch self {
            
        case .viewModelDishContainer(let string, let keyPath):
            return (string,keyPath,.fonte)
        case .viewModelIngredientContainer(let string, let keyPath):
            return (string,keyPath,.fonte)
        case .viewModelMenuContainer(let string, let keyPath):
            return (string,keyPath,.fonte)
        case .viewModelPropertyContainer(let string, let keyPath):
            return (string,keyPath,.fonte)
        case .dishModelIngredientContainer(let string, let writableKeyPath):
            return (string,writableKeyPath,.destinazione)
        case .dishModelMenuContainer(let string, let writableKeyPath):
            return (string,writableKeyPath,.destinazione)
        case .menuModelDishContainer(let string, let writableKeyPath):
            return (string,writableKeyPath,.destinazione)
        case .menuModelPropertyContainer(let string, let writableKeyPath):
            return (string,writableKeyPath,.destinazione)
        case .propertyModelMenuContainer(let string, let writableKeyPath):
            return (string,writableKeyPath,.destinazione)
        }
        
    }
    
    enum ContainerListType { // Lo usiamo per distinguere i due Case del ModelList senza utilizzare la returnTypeCase usata per altre enum. Perchè con i keypath non sappiamo che valore standard passare per uniformare i case.
        
        case fonte
        case destinazione
        
        
    }
}
