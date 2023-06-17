//
//  WaitLoadingView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/11/22.
//

import SwiftUI

struct WaitLoadingView: View {
    
    let backgroundColorView:Color
    
    var body: some View {
    
        ZStack {
            
            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
           
            Image(systemName: "fork.knife.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.seaTurtle_2)
                .frame(maxWidth:500)
                .padding(.horizontal)
                .zIndex(0)
            
            
        }
       // .background(backgroundColorView.opacity(0.6))
    }
}

struct WaitLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitLoadingView(backgroundColorView: .seaTurtle_1)
    }
}
