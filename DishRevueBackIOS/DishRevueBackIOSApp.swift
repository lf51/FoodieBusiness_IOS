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
    
    init() {
        
        FirebaseApp.configure()
        // disattivare raccolta dati
    }
    
    var body: some Scene {
        WindowGroup {
        
           PrincipalTabView()
          //  DishSpecificView(newDish:.constant(DishModel()))
            
        }
    }
}


/*
 
 Importare libreria KeypathKit dello sviluppatore francese, swift Heroes
 utile per lavorare con gli array tramite keypath
 
 
 */
