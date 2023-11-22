//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI
import MyFoodiePackage

struct MainView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @ObservedObject var authProcess: AuthenticationManager
    @State private var tabSelector: DestinationPath = .homeView
    
    private let backgroundColorView: Color = Color.seaTurtle_1
    
    @State private var ingChanged:Int = 0 // serve per il count dall'import veloce. Ancora 01.12 non settato
    
    init(authProcess: AuthenticationManager) {
        self.authProcess = authProcess
        print("[INIT]_MainView - for userUID:\(AuthenticationManager.userAuthData.id)")
    }

    var body: some View {
            
        TabView(selection:$tabSelector.csOnUpdate { oldValue, newValue in
            
            if oldValue == newValue {
                self.viewModel.refreshPathAndScroll(tab: self.tabSelector)
            }
            
        } ) { // Deprecata da Apple / Sostituire
                
            Group {
                HomeView(
                    authProcess: authProcess,
                    tabSelection: tabSelector,
                    backgroundColorView: backgroundColorView)
                       // .badge(dishChange)
                        .badge(0) // Il pallino rosso delle notifiche !!!
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }.tag(DestinationPath.homeView)
                        // .tag(1)
                   
                MenuListView(tabSelection: tabSelector, backgroundColorView: backgroundColorView)
                    .badge(viewModel.remoteStorage.menu_countModificheIndirette)
                    .tabItem {
                        Image (systemName: "menucard")//scroll.fill
                        Text("Menu")
                    }.tag(DestinationPath.menuList)
                
                DishListView(tabSelection: tabSelector, backgroundColorView: backgroundColorView)
                    .badge(viewModel.remoteStorage.dish_countModificheIndirette)
                        .tabItem {
                            Image (systemName: "fork.knife.circle")
                            Text("Prodotti")
                        }
                        .tag(DestinationPath.dishList)
                      
                ListaIngredientiView(tabSelection: tabSelector, backgroundColorView: backgroundColorView)
                   
                    .badge(self.ingChanged)
                    .tabItem {
                        
                            Image (systemName: "leaf")
                            Text("Ingredienti")
                          
                        
                    }.tag(DestinationPath.ingredientList)
                    
            }
            .csOverlayMessage($viewModel.logMessage)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.seaTurtle_1.opacity(0.9), for: .tabBar)
                
            }
        .onChange(of: self.tabSelector) { _, newValue in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
              
               // let tabCase = CS_TabSelector(rawValue: newValue)
                
                switch newValue {
                
                case .menuList: self.viewModel.remoteStorage.menu_countModificheIndirette = 0
                case .dishList: self.viewModel.remoteStorage.dish_countModificheIndirette = 0
                    
                default: return
                }
                
            }
        }
        .onAppear {
            // popoliamo il viewModel con una property
            print("MAIN VIEW ON APPEAR")
           // self.viewModel.retrieveDataWithListener()
        }
        
        .onDisappear {
            print("MAIN VIEW ON DISAPPEAR")
            
        }
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
        .accentColor(.seaTurtle_3)
    }
}

enum CS_TabSelector:Hashable {
    
    case home
    case ing
    case dish
    case menu
    
} // 24.02 Deprecata in quanto duplicazione del DestinationPath

/*
struct MainView_Previews: PreviewProvider {
    static var user: UserRoleModel = UserRoleModel()
  
    static var previews: some View {
        MainView(
            authProcess: AuthPasswordLess(),
            viewModel: AccounterVM(from: initServiceObject), errorAction: ((_:Bool) -> ()) )
    }
}*/





