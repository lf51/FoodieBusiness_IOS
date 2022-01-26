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
                //SuccessView(authProcess: authProcess)
                    .tabItem {
                        // Image
                        Text("Home")
                    }.tag(0)
                
                NewDishView(backGroundColorView: backGroundColorView)
                    .tabItem {
                        //Image
                        Text("NEWDish")
                    }.tag(1)
                
                DishesView(backGroundColorView: backGroundColorView)
                    .tabItem {
                        //Image
                        Text("ListaDish")
                    }.tag(2)
                       
                
                
            }.sheet(isPresented: $authProcess.isPresentingSheet) {
                LinkSignInSheetView(authProcess: authProcess)
            }
            .alert(item: $authProcess.alertItem) { alert -> Alert in
               Alert(
                 title: Text(alert.title),
                 message: Text(alert.message)
               )
             }
        
    }
}

struct PrincipalTabView_Previews: PreviewProvider {
    static var previews: some View {
        PrincipalTabView()
    }
}


