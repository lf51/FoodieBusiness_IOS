//
//  DestinationPath.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/09/22.
//

import SwiftUI
import UIKit

enum DestinationPathView: Hashable {
    
    case accountSetup(_ :AuthPasswordLess)
    case propertyList
    case property(_ :PropertyModel)
    
    case menu(_ :MenuModel)
    case piatto(_ :DishModel)
    case ingrediente(_ :IngredientModel)
    case categoriaMenu
    case moduloImportazioneVeloce
    
    case recensioni(_ :DishModel)
    
    case vistaIngredientiEspansa(_ :DishModel)
    case vistaMenuEspansa(_ :DishModel)
    case vistaPiattiEspansa(_ :MenuModel)
    case vistaCrologiaAcquisti(_ :IngredientModel)
    
    case moduloSostituzioneING(_ : IngredientModel,isPermanente:Bool = false)
    
    case listaDellaSpesa
    
    
    @ViewBuilder func destinationAdress(backgroundColorView: Color, destinationPath: DestinationPath, readOnlyViewModel:AccounterVM) -> some View {
        
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
            
        case .moduloImportazioneVeloce:
            FastImport_MainView(backgroundColorView: backgroundColorView)
            
        case .recensioni(let dish):
            DishRatingListView(dishItem: dish, backgroundColorView: backgroundColorView, readOnlyViewModel: readOnlyViewModel)
            // vedi Nota vocale 13.09
        case .vistaIngredientiEspansa(let dish):
            VistaIngredientiEspansa(currentDish: dish, backgroundColorView: backgroundColorView)
            
        case .vistaMenuEspansa(let dish):
            VistaMenuEspansa(currentDish: dish, backgroundColorView: backgroundColorView,viewModel: readOnlyViewModel)
            
        case .vistaPiattiEspansa(let menu):
            VistaPiattiEspansa(currentMenu: menu, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
            
        case .vistaCrologiaAcquisti(let ingredient):
            VistaCronologiaAcquisti(ingrediente: ingredient, backgroundColorView: backgroundColorView)
            
        case .moduloSostituzioneING(let ingredient,let isPermanente):
            DishListByIngredientView(ingredientModelCorrente: ingredient,isPermanente: isPermanente, destinationPath: destinationPath, backgroundColorView: backgroundColorView)
            
        case .listaDellaSpesa:
            ListaDellaSpesa_MainView(onlyReaderVM: readOnlyViewModel, backgroundColorView: backgroundColorView)
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
