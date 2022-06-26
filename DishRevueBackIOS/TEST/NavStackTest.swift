//
//  NavStackTest.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 13/06/22.
//

import SwiftUI

enum Destination2 {
    
    case firstPage
    case secondPage
    
    
}

@ViewBuilder private func viewForDestination(destination:Destination2) -> some View {
    
    switch destination {
        
    case .firstPage:
        ZStack {
            
            Color.red.ignoresSafeArea()
           
            NavigationLink("Go to Second page", value: Destination2.secondPage)
        }
    case .secondPage:
        
        ZStack {
            
            Color.orange.ignoresSafeArea()
            Text("This is my Second Page")
                .bold()
            
        }
    }
    
    
}


struct NavStackTest: View {

    var body: some View {
        
           NavigationStack {
               VStack {
                   Text("Navigation stack")
                       .padding()
                   NavigationLink("NavigationLink to enter first page", value: Destination2.firstPage)
                       .padding()
                   NavigationLink("NavigationLink to enter second page", value: Destination2.secondPage)
                       .padding()
                   List(1..<3) { index in
                       NavigationLink("Nav Link \(index)", value: index)
                   }
               }
               .navigationDestination(for: Destination2.self) { destination in
                   viewForDestination(destination: destination)
               }
               .navigationDestination(for: Int.self) { index in
                   Text("index \(index)")
               }
           }
       }
        
        
    }


struct NavStackTest_Previews: PreviewProvider {
    static var previews: some View {
       
            
            NavStackTest()
            
        
    }
}
