//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI

struct MainView: View {
    
  //  @StateObject var authProcess: AuthPasswordLess
    @ObservedObject var authProcess: AuthPasswordLess
    @StateObject private var viewModel: AccounterVM
    @State private var isLoading: Bool
  /* init() {
        
        let auth = AuthPasswordLess()
        let vm = AccounterVM(userUID: auth.currentUser?.userUID)
        _authProcess = StateObject(wrappedValue: auth)
        _viewModel = StateObject(wrappedValue: vm )
        
    } */
    init(authProcess:AuthPasswordLess) {
        
        self.isLoading = true
        self.authProcess = authProcess
        let vm = AccounterVM(userUID: authProcess.currentUser?.userUID)
        _viewModel = StateObject(wrappedValue: vm)
        
        print("init MainView - userUID:\(authProcess.currentUser?.userUID ?? "nil")")
    }

    private let backgroundColorView: Color = Color.seaTurtle_1
    @State private var tabSelector: DestinationPath = .homeView
   // @State private var controlProxyReset:Bool = false
    // innesto 01.12.22
 
    @State private var ingChanged:Int = 0 // serve per il count dall'import veloce. Ancora 01.12 non settato
    
    var body: some View {
            
        TabView(selection:$tabSelector.csOnUpdate { oldValue, newValue in
            
            if oldValue == newValue {
                self.viewModel.refreshPathAndScroll(tab: self.tabSelector)
            }
            
        } ) { // Deprecata da Apple / Sostituire
                
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
                        Text("Piatti")
                    }
                    .tag(DestinationPath.dishList)
                  
            ListaIngredientiView(tabSelection: tabSelector, backgroundColorView: backgroundColorView)
               
                .badge(self.ingChanged)
                .tabItem {
                    
                        Image (systemName: "leaf")
                        Text("Ingredienti")
                    
                }.tag(DestinationPath.ingredientList)
                
            }
        .onChange(of: self.tabSelector) { newValue in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
              
               // let tabCase = CS_TabSelector(rawValue: newValue)
                
                switch newValue {
                
                case .menuList: self.viewModel.remoteStorage.menu_countModificheIndirette = 0
                case .dishList: self.viewModel.remoteStorage.dish_countModificheIndirette = 0
                    
                default: return
                }
                
            }
        }
      /*  .onTapGesture(count: 2, perform: {
            
            self.viewModel.refreshPathAndScroll(tab: self.tabSelector)
            
        }) */
        .fullScreenCover(isPresented: $viewModel.isLoading, content: {
           WaitLoadingView(backgroundColorView: backgroundColorView)
        })
        
        .onAppear {
         
               // print("1.Task.beforeFetch")
              //  self.viewModel.fetchDataFromFirebase()
               // print("4.Task.afeterFetch")
              //  self.isLoading = false
              //  print("5.Task.END")
                
            

        }
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
        .environmentObject(viewModel)
        .accentColor(.seaTurtle_3)
  
    }
}

enum CS_TabSelector:Hashable {
    
    case home
    case ing
    case dish
    case menu
    
} // 24.02 Deprecata in quanto duplicazione del DestinationPath

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authProcess: AuthPasswordLess())
    }
}





