//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
    @StateObject var viewModel: AccounterVM = AccounterVM()
 
    let backgroundColorView: Color = Color("BusinessColor_1")
    @State var tabSelector: Int = 0
    
    var body: some View {
            
        TabView(selection:$tabSelector) {
                
            HomeView(authProcess: authProcess, backgroundColorView: backgroundColorView)
                    .badge(10) // Il pallino rosso delle notifiche !!!
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)

            MenuListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .tabItem {
                    Image (systemName: "menucard")//scroll.fill
                    Text("Menu")
                }.tag(1)
            
            
            DishListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                    .tabItem {
                        Image (systemName: "fork.knife.circle")
                        Text("Piatti")
                    }.tag(2)
    
            ListaIngredientiView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
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
        .accentColor(.cyan)
  
    }
}

struct PrincipalTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}



