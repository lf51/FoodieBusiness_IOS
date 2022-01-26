//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct NewDishView: View {
    
    var backGroundColorView: Color
    
    var body: some View {
        
        ZStack {
            
            backGroundColorView.ignoresSafeArea()
            
            Text("Creiamo un nuovo piatto")
            
        }
        
        
    }
}

struct NewDishView_Previews: PreviewProvider {
    static var previews: some View {
        NewDishView(backGroundColorView: Color.cyan)
    }
}
