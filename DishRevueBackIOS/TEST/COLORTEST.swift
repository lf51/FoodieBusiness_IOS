//
//  COLORTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/04/22.
//

import SwiftUI

struct COLORTEST: View {
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    var colorScale = 0...9
    var brightness = 0.0
    
    var value: [Double] = [0.0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.6,-0.7,-0.8,-0.9]
    
    
    var body: some View {
        
        VStack {
            
            ForEach(colorScale, id:\.self) { scale in
                
                HStack {
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(maxWidth:.infinity)
                        .frame(height:50)
                        .foregroundColor(Color.cyan)
                        .brightness(value[scale])
                    
                    Text("\(value[scale])")
                }
                    
                
            }.clipped()
            
            
        }
        
    }
}

struct COLORTEST_Previews: PreviewProvider {
    static var previews: some View {
        COLORTEST()
    }
}
