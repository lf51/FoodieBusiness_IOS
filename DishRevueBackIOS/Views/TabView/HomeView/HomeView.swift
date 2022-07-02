//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit

enum Destination:Hashable {
    
    case accountSetup
    case propertyList
    
    case nuovoMenu(_ :MenuModel)
    case nuovoPiatto(_ :DishModel)
    case nuovoIngrediente(_ :IngredientModel)
    
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
                        viewModel.homeViewPath.append(Destination.propertyList)
                        viewModel.homeViewPath.append(viewModel.allMyProperties[0])
                    } label: {
                        Text("Gestisci Menu")
                    }.disabled(viewModel.allMyProperties.isEmpty)
                    
                    HStack {
                        
                        Button {
                            viewModel.homeViewPath.append(Destination.nuovoMenu(MenuModel()))
                            
                        } label: {
                            Text("Crea Nuovo Menu")
                        }
                        
                        Button {
                            viewModel.homeViewPath.append(Destination.nuovoPiatto(DishModel()))
                            
                        } label: {
                            Text("Crea Nuovo Piatto")
                        }
                        
                        
                        Button {
                            viewModel.homeViewPath.append(Destination.nuovoIngrediente(IngredientModel()))
                            
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
            .navigationDestination(for: Destination.self, destination: { destination in
                vbDestinationAdress(destination: destination)
            })
            .navigationDestination(for: PropertyModel.self, destination: { property in
                EditingPropertyModel(itemModel: property, backgroundColorView: backgroundColorView)
            })
  
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
   
                    NavigationLink(value: Destination.accountSetup) {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("SeaTurtlePalette_2"))
                    }
           
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(value: Destination.propertyList) {
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
    
    @ViewBuilder private func vbDestinationAdress(destination:Destination) -> some View {
        
        switch destination {
            
        case .accountSetup:
            AccounterMainView(authProcess: authProcess, backgroundColorView: backgroundColorView)
            
        case .propertyList:
            PropertyListView(backgroundColorView: backgroundColorView)
            
        case .nuovoMenu(let menu):
            NuovoMenuMainView(nuovoMenu: menu, backgroundColorView: backgroundColorView)
            
        case .nuovoPiatto(let piatto):
            NewDishMainView(newDish: piatto, backgroundColorView: backgroundColorView)
            
        case .nuovoIngrediente(let ingredient):
            NuovoIngredienteMainView(nuovoIngrediente: ingredient, backgroundColorView: backgroundColorView)
            
        }
        
    }

}

struct HomeView_Previews: PreviewProvider {
 
    static var previews: some View {
        
        NavigationStack {
            
            HomeView(authProcess: AuthPasswordLess(), backgroundColorView: Color("SeaTurtlePalette_1"))
        }

    }
}
