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
    
    init(authProcess: AuthenticationManager) {
        print("[START]INIT MAIN_VIEW")
        self.authProcess = authProcess
        print("[END] INIT MainView - for userUID:\(AuthenticationManager.userAuthData.id)")
    }
    
    
    
   // @StateObject private var viewModel: AccounterVM
    
   // let errorAction:(_ mainViewMustDeinit:Bool) -> ()
   // @Binding var value:SubViewStep
   // @State private var isLoading: Bool

   /* init(authProcess: AuthPasswordLess, viewModel: AccounterVM,/*value:Binding<SubViewStep>,*/errorAction:@escaping (_ errorIn:Bool) -> ()) {
        print("[START]INIT MAIN_VIEW")
        self.authProcess = authProcess
        _viewModel = StateObject(wrappedValue: viewModel) // 11.08 closed for test
      //  _viewModel = StateObject(wrappedValue: testAccount) // test
        
        self.errorAction = errorAction
      //  _value = value
        
        print("[END] INIT MainView - for userUID:\(authProcess.utenteCorrente?.id ?? "nil") and IMAGES:\(viewModel.allMyPropertiesImage.count)")
    } */
   /* init(authProcess:AuthPasswordLess) {
        
      //  self.isLoading = true
        self.authProcess = authProcess
        
        let vm = AccounterVM(userUID: authProcess.utenteCorrente?.id)
        _viewModel = StateObject(wrappedValue: vm)
        
        print("init MainView - userUID:\(authProcess.currentUser?.userUID ?? "nil")")
    } */

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
       /* .onReceive(viewModel.$mainViewMustDeinit) { value in
            print("MAIN_VIEW_RECEIVER PERFORM")
            if let value {
               // self.viewModel.cancellables.removeAll()
                self.viewModel.mainViewMustDeinit = nil
               // self.value = .openLandingPage
               // errorAction(true)
                print("MAIN_VIEW_RECEIVER get VALID VALUE")
            }
            
        }*/
        .onAppear {
            // popoliamo il viewModel con una property
            print("MAIN VIEW ON APPEAR")
           // self.viewModel.retrieveDataWithListener()
        }
        
        .onDisappear {
            print("MAIN VIEW ON DISAPPEAR")
            
        }
        
      /*  .onTapGesture(count: 2, perform: {
            
            self.viewModel.refreshPathAndScroll(tab: self.tabSelector)
            
        }) */
       /* .fullScreenCover(isPresented: $viewModel.isLoading, content: {
           WaitLoadingView(backgroundColorView: backgroundColorView)
        })*/ // 28.07.23 Collocata male dovrebbe spiegare lo schermo bianco
        
      /*  .onAppear {
         
               // print("1.Task.beforeFetch")
              //  self.viewModel.fetchDataFromFirebase()
               // print("4.Task.afeterFetch")
              //  self.isLoading = false
              //  print("5.Task.END")
                
            

        }*/
     
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
        
       // .environmentObject(viewModel)
        .accentColor(.seaTurtle_3)
       // .accentColor(.seaTurtle_4)
  
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





