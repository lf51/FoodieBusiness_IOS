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
 
    let backgroundColorView: Color = Color.cyan
    @State var tabSelector: Int = 0
    
    var body: some View {
            
        TabView(selection:$tabSelector) {
                
            HomeView(authProcess: authProcess, backgroundColorView: backgroundColorView)
                    .badge(10) // Il pallino rosso delle notifiche !!!
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)

            DishListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                    .tabItem {
                        Image (systemName: "list.bullet.rectangle.portrait")
                        Text("All Dishes")
                    }.tag(1)
    
            ListaIngredientiView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .tabItem {
                    Image (systemName: "list.bullet")
                    Text("Lista Ingredienti")
                }.tag(2)
            }
        .fullScreenCover(isPresented: $authProcess.isPresentingSheet, content: {
            LinkSignInSheetView(authProcess: authProcess)
        })
        .alert(item: $authProcess.alertItem) { alert -> Alert in
               Alert(
                 title: Text(alert.title),
                 message: Text(alert.message)
               )
             }
        .environmentObject(viewModel)
        .accentColor(.cyan)
  
    }
}

struct PrincipalTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


