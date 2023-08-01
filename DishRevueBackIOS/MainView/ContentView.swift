//
//  ContentView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import SwiftUI
import MyFoodiePackage

struct ContentView: View {
    
    @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
   // @State private var isLoading:Bool = false
    
    var body: some View {
    
        Group {
            if let user = self.authProcess.utenteCorrente {
                
                let vm = AccounterVM(userAuth: user)
                MainView(authProcess: self.authProcess, viewModel: vm)
                // 28.07.23 Verificare il funzionamento. La Main viene init prima che l'isLoading cambia/ si no? Cosa accade?
                   
            } else {
                
                LinkSignInSheetView(authProcess: self.authProcess)
            }
        }
        .id(authProcess.hashValue)
        .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
       /* .fullScreenCover(isPresented: $authProcess.isLoading, content: {
             WaitLoadingView(backgroundColorView: .seaTurtle_1)
         })*/
       /* .fullScreenCover(isPresented: $isLoading, content: {
            WaitLoadingView(backgroundColorView: .seaTurtle_1)
        }) */
        
        
   /*  MainView(authProcess: authProcess)
            .id(authProcess.hashValue) // Nota 14.11
            .fullScreenCover(isPresented: $authProcess.openSignInView, content: {
                LinkSignInSheetView(authProcess: authProcess)
        })
            .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem) */ // 25.07.23 deprecata per abbandono della skip option
       
    }
    
    // Method

}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
