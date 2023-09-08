//
//  DestinationPath.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/09/22.
//

import SwiftUI
import UIKit
import MyFoodiePackage

/*
/// Struct di servizio per incapsulare una label string con una azione
public struct WrapLabelAction:Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.label)
    }
    
    public static func == (lhs: WrapLabelAction, rhs: WrapLabelAction) -> Bool {
        lhs.label == rhs.label &&
        lhs.action() == rhs.action()
    }

    let label:String
    let action:() -> Void
}
*/
public enum DestinationPathView: Hashable {
 
    case accountSetup/*(_ :AuthenticationManager)*/
    case propertyList
    case property(_ :PropertyModel)
    
    case menu(_ menuModel:MenuModel,_ saveDialogType:SaveDialogType = .completo)
    case piatto(_ dishModel:DishModel,_ saveDialogType:SaveDialogType = .completo)
    case ingrediente(_ :IngredientModel)
    case categoriaMenu
    case moduloImportazioneVeloce
    
    case recensioni(_ :String)
    
    case vistaIngredientiEspansa(_ :DishModel)
    case vistaMenuEspansa(_ :DishModel)
    case vistaPiattiEspansa(_ :MenuModel,_ :RowSize = .normale())
    
    case vistaCronologiaAcquisti(_ :IngredientModel)
    case vistaRecensioniEspansa
    
    case moduloSostituzioneING(_ :IngredientModel,isPermanente:Bool = false)
    
    case listaDellaSpesa
    
    case listaGenericaMenu(_containerRif:[String],_label:String)
    case listaGenericaIng(_containerRif:[String], _label:String)
    case listaGenericaDish(_containerRif:[String], _label:String)
    
    case listaMenuPerAnteprima(rifMenuOn:[String],rifDishOn:[String],label:String)
    case anteprimaPiattiMenu(rifDishes:[String],label:String)

    case elencoModelDeleted
    
    case monitorServizio_vistaEspansaDish(containerRif:[String],label:String)
    case monitorServizio_vistaEspansaIng(containerRif:[String],label:String)
    case monitorServizio_vistaEspansaPF(containerRif:[String],label:String)
    
    @ViewBuilder func destinationAdress(backgroundColorView: Color, destinationPath: DestinationPath, readOnlyViewModel:AccounterVM) -> some View {
        
        switch self {

        case .accountSetup/*(let authProcess)*/:
            EmptyView()
          //  AccounterMainView(authProcess: authProcess, backgroundColorView: backgroundColorView)
            
        case .propertyList:
            PropertyListView(backgroundColorView: backgroundColorView)
            
        case .property(let property):
            EditingPropertyModel(itemModel: property, backgroundColorView: backgroundColorView)
            
        case .menu(let menu,let dialogType):
            NuovoMenuMainView(
                nuovoMenu: menu,
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath,
                saveDialogType: dialogType)
            
        case .piatto(let piatto,let dialogType):
            NewProductMainView(
                newDish: piatto,
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath,
                saveDialogType: dialogType)
           /* NewDishMainView(newDish: piatto, backgroundColorView: backgroundColorView, destinationPath: destinationPath) */
            
        case .ingrediente(let ingredient):
            NuovoIngredienteGeneralView(nuovoIngrediente: ingredient, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
            
        case .categoriaMenu:
           // NuovaCategoriaMenu(backgroundColorView: backgroundColorView)
            CloudImportCategoriesView(backgroundColor: backgroundColorView)
            
        case .moduloImportazioneVeloce:
          //  FastImport_MainView(backgroundColorView: backgroundColorView)
            Switch_ImportObject(backgroundColorView: backgroundColorView)
            
        case .recensioni(let rifDish):
           // DishRatingListView(dishItem: dish, backgroundColorView: backgroundColorView, readOnlyViewModel: readOnlyViewModel)
            VistaRecensioniEspansa_SingleDish(backgroundColorView: backgroundColorView, rifDish: rifDish, navigationPath: destinationPath)
            
            // vedi Nota vocale 13.09
        case .vistaIngredientiEspansa(let dish):
            VistaIngredientiEspansa(currentDish: dish, backgroundColorView: backgroundColorView)
            
        case .vistaMenuEspansa(let dish):
            VistaMenuEspansa(currentDish: dish, backgroundColorView: backgroundColorView,viewModel: readOnlyViewModel)
            
        case .vistaPiattiEspansa(let menu,let rowSize):
            PreCallVistaPiattiEspansa(
                currentMenu: menu,
                rowViewSize: rowSize,
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath)
           /* VistaPiattiEspansa(currentMenu: menu, backgroundColorView: backgroundColorView, destinationPath: destinationPath) */
            
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
            VistaEspansaGenerica(
                container: container,
                containerPath: \.db.allMyMenu,
                label:label,
                backgroundColorView: backgroundColorView)
            
        case .listaGenericaIng(let container,let label):
            VistaEspansaGenerica(
                container:container,
                containerPath: \.db.allMyIngredients,
                label:label,
                backgroundColorView: backgroundColorView)
            
        case .listaGenericaDish(let container,let label):
            VistaEspansaGenerica(
                container: container,
                containerPath: \.db.allMyDish,
                label:label,
                backgroundColorView: backgroundColorView)
            
        case .listaMenuPerAnteprima(let rifMenuOn,let rifDishOn, let label):
            VistaEspansaMenuPerAnteprima(
               // viewModel:readOnlyViewModel,
                rifMenuOn: rifMenuOn,
                rifDishOn: rifDishOn,
                //containerPath: \.cloudData.allMyMenu,
                label: label,
                destinationPath: destinationPath,
                backgroundColorView: backgroundColorView)
            
        case .anteprimaPiattiMenu(let rifDishes,let label):
            AnteprimaPiattiMenu(
                rifDishes: rifDishes,
                label: label,
                destinationPath: destinationPath,
                backgroundColorView: backgroundColorView)
            
        case .elencoModelDeleted:
            ElencoModelDeleted(backgroundColorView: backgroundColorView)
            
        case .monitorServizio_vistaEspansaDish(let container, let label):
            VistaEspansaDish_MonitorServizio(
                container: container,
                label: label,
                backgroundColorView: backgroundColorView)
            
        case .monitorServizio_vistaEspansaIng(let container, let label):
            VistaEspansaIng_MonitorServizio(
                container: container,
                label: label,
                backgroundColorView: backgroundColorView)
            
        case .monitorServizio_vistaEspansaPF(let container, let label):
            VistaEspansaPF_MonitorServizio(
                container: container,
                label: label,
                backgroundColorView: backgroundColorView)
        }
        
    }
    
}

enum DestinationPath:Hashable {
    
    case homeView
    case menuList
    case dishList
    case ingredientList
    
    func vmPathAssociato() -> ReferenceWritableKeyPath<AccounterVM,NavigationPath> {
        
        switch self {
        case .homeView:
            return \.homeViewPath
        case .menuList:
            return \.menuListPath
        case .dishList:
            return \.dishListPath
        case .ingredientList:
            return \.ingredientListPath
        }
        
        
    }
}
