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
            VStack {
                
                CSLabel_1Button(placeHolder: "Surgelato", backgroundColor: Color.blue, backgroundOpacity: 0.4)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(height: 5.0)
                    .foregroundColor(Color.black)

                
            }
            
            
        }
        
    }
}

struct COLORTEST_Previews: PreviewProvider {
    static var previews: some View {
        COLORTEST()
    }
}
