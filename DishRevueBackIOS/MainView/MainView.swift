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

    private let backgroundColorView: Color = Color("SeaTurtlePalette_1")
    @State private var tabSelector: Int = 0
            
    // innesto 01.12.22
 
    @State private var ingChanged:Int = 0 // serve per il count dall'import veloce. Ancora 01.12 non settato
    
    
    var body: some View {
            
        TabView(selection:$tabSelector) { // Deprecata da Apple / Sostituire
                
            HomeView(authProcess: authProcess, backgroundColorView: backgroundColorView)
                   // .badge(dishChange)
                    .badge(0) // Il pallino rosso delle notifiche !!!
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(CS_TabSelector.home.rawValue)

            MenuListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .badge(viewModel.remoteStorage.menu_countModificheIndirette)
                .tabItem {
                    Image (systemName: "menucard")//scroll.fill
                    Text("Menu")
                }.tag(CS_TabSelector.menu.rawValue)
            
            DishListView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .badge(viewModel.remoteStorage.dish_countModificheIndirette)
                    .tabItem {
                        Image (systemName: "fork.knife.circle")
                        Text("Piatti")
                    }.tag(CS_TabSelector.dish.rawValue)
    
            ListaIngredientiView(tabSelection: $tabSelector, backgroundColorView: backgroundColorView)
                .badge(self.ingChanged)
                .tabItem {
                    Image (systemName: "leaf")
                    Text("Ingredienti")
                }.tag(CS_TabSelector.ing.rawValue)
            }
        .onChange(of: self.tabSelector) { newValue in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
              
                let tabCase = CS_TabSelector(rawValue: newValue)
                
                switch tabCase {
                
                case .menu: self.viewModel.remoteStorage.menu_countModificheIndirette = 0
                case .dish: self.viewModel.remoteStorage.dish_countModificheIndirette = 0
                    
                default: return
                }
                
            }
        }
     //   .csOnChangeModelStatus(modelArray: viewModel.changeStore.dishRif_modified, valueCount: $dishChanged)
       // .csOnChangeModelStatus(modelArray: viewModel.allMyDish, valueCount: $dishChanged)
      //  .csOnChangeModelStatus(modelArray: viewModel.allMyMenu, valueCount: $menuChanged)
        
        
 
           /* .fullScreenCover(isPresented: $authProcess.openSignInView, content: {
                LinkSignInSheetView(authProcess: authProcess)
        })*/
      /*  .fullScreenCover(isPresented: $viewModel.instanceDBCompiler.isDownloading, content: {
            Text("OnLoading")
     }) */
        .fullScreenCover(isPresented: $viewModel.isLoading, content: {
           WaitLoadingView(backgroundColorView: backgroundColorView)
        })
        
        .onAppear {
         
                print("1.Task.beforeFetch")
                self.viewModel.fetchDataFromFirebase()
                print("4.Task.afeterFetch")
                self.isLoading = false
                print("5.Task.END")
                
            

        }
       // .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
        .environmentObject(viewModel)
       // .accentColor(.cyan)
        .accentColor(Color("SeaTurtlePalette_3"))
  
    }
    
    private enum CS_TabSelector:Int {
        
        case home = 0
        case ing
        case dish
        case menu
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authProcess: AuthPasswordLess())
    }
}



