//
//  COLORTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/04/22.
//

import SwiftUI

struct COLORTEST: View {
    
    var body: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            CSLabel_1Button(placeHolder: "Surgelato", backgroundColor: Color.blue, backgroundOpacity: 0.4)
            
        }
        
    }
}

struct COLORTEST_Previews: PreviewProvider {
    static var previews: some View {
        COLORTEST()
    }
}
