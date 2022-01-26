//
//  LogoAppBackEndView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/01/22.
//

import SwiftUI

struct LogoAppBackEndView: View {
    var body: some View {
        
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            Image("LogoAppBACKEND")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .scaledToFit()
            
        }
        
        
    }
}

struct LogoAppBackEndView_Previews: PreviewProvider {
    static var previews: some View {
        LogoAppBackEndView()
    }
}
