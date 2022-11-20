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
           /* .fullScreenCover(isPresented: $authProcess.openSignInView, content: {
                LinkSignInSheetView(authProcess: authProcess)
        })*/
      /*  .fullScreenCover(isPresented: $viewModel.instanceDBCompiler.isDownloading, content: {
            Text("OnLoading")
     }) */
        .fullScreenCover(isPresented: $isLoading, content: {
            Text("OnLoading")
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
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authProcess: AuthPasswordLess())
    }
}



