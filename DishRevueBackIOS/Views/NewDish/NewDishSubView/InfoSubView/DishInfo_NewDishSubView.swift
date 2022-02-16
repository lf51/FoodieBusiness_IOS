//
//  DishInfo_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct DishInfoRectangle: View {
    
    let data: String
    let baseColor: Color
    
    var body: some View {
        
        Text(data)
            .bold()
            .lineLimit(1)
            .foregroundColor(.white)
            .minimumScaleFactor(0.6)
            ._tightPadding()
            .background (
                
                RoundedRectangle(cornerRadius: 5.0)
                    .strokeBorder(Color.blue)
                    .background(RoundedRectangle(cornerRadius: 5.0)
                                    .fill(baseColor.opacity(0.8)))
                    .shadow(radius: 3.0)
            )
    }
}

struct DishInfoDeletableRectangle: View {
    
    let data: String
    let baseColor: Color
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var scaleDimension: CGFloat = 0.1
    @State var rotationAngle: Double = 0.0
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            Text(data)
                .bold()
                .lineLimit(1)
                .foregroundColor(Color.white)
                .minimumScaleFactor(0.6)
                ._tightPadding()
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .strokeBorder(Color.blue)
                        .background(RoundedRectangle(cornerRadius: 5.0)
                                        .fill(baseColor.opacity(0.8)))
                        .shadow(radius: 3.0)
                
                )
            
            Image(systemName: "x.circle.fill")
                .frame(width:10, height: 10)
                .background(Color.white)
                .foregroundColor(Color.red)

        }
        .rotationEffect(.degrees(rotationAngle))
        .onReceive(timer) { _ in
            
            withAnimation(.easeInOut) {
  
                rotationAngle = rotationAngle == 2.5 ? -2.5 : (rotationAngle + 1.25)
          
            }
        }
    }
}

/*struct DishInfo_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        DishInfo_NewDishSubView()
    }
} */
