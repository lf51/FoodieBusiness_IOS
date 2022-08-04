//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
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
        }
        
    }
    
}

enum DestinationPath {
    
    case homeView
    case menuList
    case dishList
    case ingredientList
}

struct HomeView: View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    @EnvironmentObject var viewModel: AccounterVM
    let backgroundColorView: Color

    @State private var wannaAddNewProperty:Bool = false
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        NavigationStack(path:$viewModel.homeViewPath) {
      
            CSZStackVB(title:authProcess.userInfo?.userDisplayName ?? "Home", backgroundColorView: backgroundColorView) {

                VStack(alignment: .leading) {
                    
                    CS_BoxContainer {
                        FastImport_MainView(backgroundColorView: backgroundColorView)
                    } smallBoxUp: {
                        NuovaCategoriaMenu(backgroundColorView: backgroundColorView)
                    } smallBoxMiddle: {
                        Text("Box Vuoto")
                    } smallBoxDown: {
                        Text("Box Vuoto")
                    }
          
                    Button {
                        viewModel.homeViewPath.append(DestinationPathView.propertyList)
                        viewModel.homeViewPath.append(viewModel.allMyProperties[0])
                    } label: {
                        Text("Gestisci Menu")
                    }.disabled(viewModel.allMyProperties.isEmpty)
                    
                    HStack {
                        
                        Button {
                            viewModel.homeViewPath.append(DestinationPathView.menu(MenuModel()))
            
                        } label: {
                            Text("Crea Nuovo Menu")
                        }
                        
                        Button {
                            viewModel.homeViewPath.append(DestinationPathView.piatto(DishModel()))
                            
                        } label: {
                            Text("Crea Nuovo Piatto")
                        }
                        
                        
                        Button {
                            viewModel.homeViewPath.append(DestinationPathView.ingrediente(IngredientModel()))
                            
                        } label: {
                            Text("Crea Nuovo Ingrediente")
                        }
                     
                    }
                                    
                    Spacer()
                    // Box Novità
                    Text("Box Novità")
                    
                    Spacer()
                    
                } // VStack End
                .padding(.horizontal)
            }// chiusa ZStack
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .homeView)
            })
         /*  .navigationDestination(for: PropertyModel.self, destination: { property in
                EditingPropertyModel(itemModel: property, backgroundColorView: backgroundColorView)
            }) */
           
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
   
                    NavigationLink(value: DestinationPathView.accountSetup(authProcess)) {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("SeaTurtlePalette_2"))
                    }
           
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(value: DestinationPathView.propertyList) {
                        HStack {
                            Text("Proprietà")
                                .fontWeight(.bold)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .imageScale(.medium)
                        }
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                    }
                    
                    
                }
            }
          
        }
  
    }
    // Method


}

struct HomeView_Previews: PreviewProvider {
 
    static var previews: some View {
        
        NavigationStack {
            
            HomeView(authProcess: AuthPasswordLess(), backgroundColorView: Color("SeaTurtlePalette_1"))
        }

    }
}
