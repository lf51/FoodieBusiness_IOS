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


struct CS_AlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let item: AlertModel?
    
    func body(content: Content) -> some View {
        
     content
            .alert(Text(item?.title ?? "NoTitle"), isPresented: $isPresented, presenting: item) { alert in
                
                if alert.actionPlus != nil {
                    
                    Button(
                        role: .destructive) {
                            alert.actionPlus?.action()
                        } label: {
                            Text(alert.actionPlus?.title.rawValue.capitalized ?? "")
                        }
                }
          
            } message: { alert in
                Text(alert.message)
            }
        
    }
}
