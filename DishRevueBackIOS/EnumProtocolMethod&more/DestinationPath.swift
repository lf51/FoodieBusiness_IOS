//
//  DestinationPath.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/09/22.
//

import SwiftUI
import UIKit

enum DestinationPathView:Hashable {
    
    case accountSetup(_ :AuthPasswordLess)
    case propertyList
    
    case property(_ :PropertyModel)
    case menu(_ :MenuModel)
    case piatto(_ :DishModel)
    case ingrediente(_ :IngredientModel)
    
    case categoriaMenu
    case recensioni(_ :DishModel)
    
    case moduloSostituzioneING(_ : IngredientModel)
    
    @ViewBuilder func destinationAdress(backgroundColorView: Color, destinationPath: DestinationPath) -> some View {
        
        switch self {

        case .accountSetup(let authProcess):
            AccounterMainView(authProcess: authProcess, backgroundColorView: backgroundColorView)
            
        case .propertyList:
            PropertyListView(backgroundColorView: backgroundColorView)
            
        case .property(let property):
            EditingPropertyModel(itemModel: property, backgroundColorView: backgroundColorView)
            
        case .menu(let menu):
            NuovoMenuMainView(nuovoMenu: menu, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
            
        case .piatto(let piatto):
            NewDishMainView(newDish: piatto, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
            
        case .ingrediente(let ingredient):
            NuovoIngredienteMainView(nuovoIngrediente: ingredient, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
            
        case .categoriaMenu:
            NuovaCategoriaMenu(backgroundColorView: backgroundColorView)
            
        case .recensioni(let dish):
            DishRatingListView(dishItem: dish, backgroundColorView: backgroundColorView)
            
        case .moduloSostituzioneING(let ingredient):
            DishListByIngredientView(ingredientModelCorrente: ingredient,destinationPath: destinationPath, backgroundColorView: backgroundColorView) 
          /*  SostituzioneING_MainView(ingredientModelCorrente: ingredient,destinationPath: destinationPath, backgroundColorView: backgroundColorView) */

        }
        
    }
    
}

enum DestinationPath {
    
    case homeView
    case menuList
    case dishList
    case ingredientList
}
