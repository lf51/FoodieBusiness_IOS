//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI

struct PrincipalTabView: View {
    
    @StateObject var authProcess:AuthPasswordLess = AuthPasswordLess()
    @StateObject var dishVM: DishVM = DishVM()
    @StateObject var propertyVM: PropertyVM = PropertyVM()
    
    var backGroundColorView: Color = Color.cyan
    @State var tabSelector: Int = 0
    
    var body: some View {
            
        TabView(selection:$tabSelector) {
                
            HomeView(propertyViewModel: propertyVM, authProcess: authProcess, dishVM: dishVM, backGroundColorView: backGroundColorView)
                    .badge(10) // Il pallino rosso delle notifiche !!!
                    
                //SuccessView(authProcess: authProcess)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)// tag serve a selezionare la tab attraverso il selection a cui passare una @State var
                  //  .background(backGroundColorView.opacity(0.4)) // Una volta inserita la navigationView nella destinazione, il background della tab da qui non lavora più e lo abbiamo spostasto nella all'interno delle view, nello stack più alto sotto la NavigationView
                
           /* NewDishView(dishVM: dishVM, backGroundColorView: backGroundColorView)
                    .tabItem {
                        Image (systemName: "plus.circle")
                        Text("NEW Dish")
                    }.tag(1)
                   // .background(backGroundColorView.opacity(0.4)) */
            // 07.02.22 Abbiamo trasformato la creazione di un piatto in uno sheet che viene fuori della DishListView
                    
                
            DishListView(dishVM: dishVM, propertyVM: propertyVM, tabSelection: $tabSelector, backGroundColorView: backGroundColorView)
                    .tabItem {
                        Image (systemName: "list.bullet.rectangle.portrait")
                        Text("All Dishes")
                    }.tag(2)
                   // .background(backGroundColorView.opacity(0.4))
                       
                
            ListaIngredientiView(dishVM: dishVM, propertyVM: propertyVM, tabSelection: $tabSelector, backGroundColorView: backGroundColorView)
                .tabItem {
                    Image (systemName: "list.bullet")
                    Text("Lista Ingredienti")
                }.tag(3)
            
                
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


