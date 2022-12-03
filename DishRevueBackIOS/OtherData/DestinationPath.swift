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
    case vistaCronologiaAcquisti(_ :IngredientModel)
    case vistaRecensioniEspansa
    
    case moduloSostituzioneING(_ :IngredientModel,isPermanente:Bool = false)
    
    case listaDellaSpesa
    
    case listaGenericaMenu(_containerRif:[String], _label:String)
    case listaGenericaIng(_containerRif:[String], _label:String)
    case listaGenericaDish(_containerRif:[String], _label:String)
    
    case elencoModelDeleted
    
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
            NewProductMainView(newDish: piatto, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
           /* NewDishMainView(newDish: piatto, backgroundColorView: backgroundColorView, destinationPath: destinationPath) */
            
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
            
        case .vistaCronologiaAcquisti(let ingredient):
            VistaCronologiaAcquisti(ingrediente: ingredient, backgroundColorView: backgroundColorView)
            
        case .vistaRecensioniEspansa:
            VistaRecensioniEspansa(backgroundColorView: backgroundColorView)
            
        case .moduloSostituzioneING(let ingredient,let isPermanente):
            DishListByIngredientView(ingredientModelCorrente: ingredient,isPermanente: isPermanente, destinationPath: destinationPath, backgroundColorView: backgroundColorView)
            
        case .listaDellaSpesa:
            let inventario = readOnlyViewModel.inventarioIngredienti()
            ListaDellaSpesa_MainView(inventarioIngredienti: inventario, backgroundColorView: backgroundColorView)

        case .listaGenericaMenu(let container,let label):
            VistaEspansaGenerica(container: container, containerPath: \.allMyMenu, label:label, backgroundColorView: backgroundColorView)
        case .listaGenericaIng(let container,let label):
            VistaEspansaGenerica(container:container,containerPath: \.allMyIngredients, label:label, backgroundColorView: backgroundColorView)
        case .listaGenericaDish(let container,let label):
            VistaEspansaGenerica(container: container,containerPath: \.allMyDish, label:label, backgroundColorView: backgroundColorView)
            
        case .elencoModelDeleted:
            ElencoModelDeleted(backgroundColorView: backgroundColorView)
        }
        
    }
    
}

enum DestinationPath {
    
    case homeView
    case menuList
    case dishList
    case ingredientList
}
