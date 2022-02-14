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


