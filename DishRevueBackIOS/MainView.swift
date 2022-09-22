//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI

/* // Sviluppi:
 1. Property Info -> Nota vocale 22.09
 
 */

struct MainView: View {
    
    @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
    @StateObject var viewModel: AccounterVM = AccounterVM()
 
    let backgroundColorView: Color = Color("SeaTurtlePalette_1")
    @State var tabSelector: Int = 0
        
    var body: some View {
            
        TabView(selection:$tabSelector) { // Deprecata da Apple / Sostituire
                
            HomeView(authProcess: authProcess, backgroundColorView: backgroundColorView)
                    .badge(0) // Il pallino rosso delle notifiche !!!
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)

            MenuListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .badge(0)
                .tabItem {
                    Image (systemName: "menucard")//scroll.fill
                    Text("Menu")
                }.tag(1)
            
            DishListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .badge(0)
                    .tabItem {
                        Image (systemName: "fork.knife.circle")
                        Text("Piatti")
                    }.tag(2)
    
            ListaIngredientiView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .badge(0)
                .tabItem {
                    Image (systemName: "leaf")
                    Text("Ingredienti")
                }.tag(3)
            }
        .fullScreenCover(isPresented: $authProcess.openSignInView, content: {
            LinkSignInSheetView(authProcess: authProcess)
        })
       
        .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
        .environmentObject(viewModel)
       // .accentColor(.cyan)
        .accentColor(Color("SeaTurtlePalette_3"))
  
    }
}

struct PrincipalTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}



