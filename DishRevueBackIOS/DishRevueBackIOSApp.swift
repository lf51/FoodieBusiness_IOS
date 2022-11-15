//
//  DishRevueBackIOSApp.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import SwiftUI
import Firebase

@main
struct DishRevueBackIOSApp: App {
            
   // @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
    
    init() {
        
        FirebaseApp.configure()
        // disattivare raccolta dati

    }
    
    var body: some Scene {

        WindowGroup {

        //   MainView()
        ContentView()
            
        }
        
    }
    
    // Method
    
}


/*
 
 Importare libreria KeypathKit dello sviluppatore francese, swift Heroes
 utile per lavorare con gli array tramite keypath
 
 
 */
