//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct DishesView: View {
    
    var backGroundColorView: Color
    
    var body: some View {
        
        ZStack {
            
            backGroundColorView.edgesIgnoringSafeArea(.top)
            
            Text("Elenco Piatti Creati + ModificaPiattiEsistenti + Visualizza/rispondi recensioni")
        }
    }
}

struct DishesView_Previews: PreviewProvider {
    static var previews: some View {
        DishesView(backGroundColorView: Color.cyan)
    }
}
