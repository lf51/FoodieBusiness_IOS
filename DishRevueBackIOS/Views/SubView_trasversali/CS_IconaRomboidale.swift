//
//  HomeIcon.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 31/05/22.
//

import SwiftUI

/// Icona Romboidale con imaggine e testo. Orientamento verticale
struct CS_IconaRomboidale: View {
    
    let image:String
    let backgroundColor: Color
    let title: String
    
    var body: some View {
                    
            VStack(spacing:0.0) {
                
                Image(systemName: image)
                    .imageScale(.large)
                    .foregroundColor(Color.seaTurtle_4)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5.0)
                        .foregroundColor(backgroundColor)
                        .shadow(color: Color.seaTurtle_4, radius: 1.0)
                        .frame(width: 40, height: 40, alignment: .center)
                        .rotationEffect(Angle(degrees: 45.0))
                    )
            
                Text(title)
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(Color.seaTurtle_4)
                
            }

        
    }
}

struct HomeIcon_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.seaTurtle_1.ignoresSafeArea()
            CS_IconaRomboidale(image: "bolt", backgroundColor: Color.seaTurtle_1, title: "Crea Veloce")
        }
        
    }
}
