//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI

struct PrincipalTabView: View {
    
    @StateObject var authProcess:AuthPasswordLess = AuthPasswordLess()
    
    var backGroundColorView: Color = Color.cyan
    
    var body: some View {
            
            TabView {
                
                HomeView(authProcess: authProcess, backGroundViewColor: backGroundColorView)
                    .badge(10) // Il pallino rosso delle notifiche !!!
                    
                //SuccessView(authProcess: authProcess)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                    .background(backGroundColorView.opacity(0.4))
                
                NewDishView(backGroundColorView: backGroundColorView)
                    .tabItem {
                        Image (systemName: "plus.circle")
                        Text("NEW Dish")
                    }.tag(1)
                    .background(backGroundColorView.opacity(0.4))
                    
                
                DishesView(backGroundColorView: backGroundColorView)
                    .tabItem {
                        Image (systemName: "list.bullet.rectangle.portrait")
                        Text("All Dishes")
                    }.tag(2)
                    .background(backGroundColorView.opacity(0.4))
                       
                
                
            }.sheet(isPresented: $authProcess.isPresentingSheet) {
                LinkSignInSheetView(authProcess: authProcess)
            }  // riattivare quando abbiamo finito di creare la tabView
            .alert(item: $authProcess.alertItem) { alert -> Alert in
               Alert(
                 title: Text(alert.title),
                 message: Text(alert.message)
               )
             }
            .accentColor(.cyan)
            
        
    }
}

struct PrincipalTabView_Previews: PreviewProvider {
    static var previews: some View {
        PrincipalTabView()
    }
}


