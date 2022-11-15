//
//  ContentView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
    
    var body: some View {
        
     MainView(authProcess: authProcess)
            .id(authProcess.hashValue) // Nota 14.11
            .fullScreenCover(isPresented: $authProcess.openSignInView, content: {
                LinkSignInSheetView(authProcess: authProcess)
        })
            .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
