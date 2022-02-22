//
//  CSText_tight.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/02/22.
//

import SwiftUI

struct CSText_tightRectangle: View {
    
    let testo:String
    let fontWeight:Font.Weight
    let textColor:Color
    let strokeColor:Color
    let fillColor:Color

    var body: some View {
        Text(testo)
            .fontWeight(fontWeight)
            .foregroundColor(textColor)
            ._tightPadding()
            .background (
                
                RoundedRectangle(cornerRadius: 5.0)
                    .strokeBorder(strokeColor)
                    .background(RoundedRectangle(cornerRadius: 5.0)
                                    .fill(fillColor.opacity(0.8))
                    .shadow(radius: 3.0)
                               )
                )
    }
}

struct CSText_bigRectangle: View {
    
    let testo:String
    let fontWeight:Font.Weight
    let textColor:Color
    let strokeColor:Color
    let fillColor:Color

    var body: some View {
        Text(testo)
            .fontWeight(fontWeight)
            .foregroundColor(textColor)
            .padding()
            .background (
                
                RoundedRectangle(cornerRadius: 5.0)
                    .strokeBorder(strokeColor)
                    .background(RoundedRectangle(cornerRadius: 5.0)
                                    .fill(fillColor.opacity(0.8))
                    .shadow(radius: 3.0)
                               )
                )
    }
}

/*Uguale al CSText_tightRectangle, l'unica differenza è che in questo come nel rotating (di cui è specchio) abbiamo il testo che scala */

struct CSText_RotatingRectangleStaticFace: View {
    
    let testo: String
    let fontWeight: Font.Weight
    let textColor: Color
    let scaleFactor: CGFloat
    let strokeColor: Color
    let fillColor: Color
   
    let topTrailingImage: String?
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            Text(testo)
                .fontWeight(fontWeight) // .bold
                .lineLimit(1)
                .foregroundColor(textColor) // .white
                .minimumScaleFactor(scaleFactor) // 0.6
                ._tightPadding()
                .background (
                    
                    RoundedRectangle(cornerRadius: 5.0)
                        .strokeBorder(strokeColor) // .blue
                        .background(RoundedRectangle(cornerRadius: 5.0)
                                        .fill(fillColor.opacity(0.8)))
                        .shadow(radius: 3.0)
            )
            
            if topTrailingImage != nil {
                Image(systemName: topTrailingImage!)
                    .frame(width:10, height: 10)
                    .background(Color.clear)
                    .foregroundColor(Color.red)
            }
            
        }
    }
}

struct CSText_RotatingRectangleDynamicDeletingFace: View {
    
    let testo: String
    let fontWeight: Font.Weight
    let textColor: Color
    let scaleFactor: CGFloat
    let strokeColor: Color
    let fillColor: Color
    let showDeleteImage: Bool
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var scaleDimension: CGFloat = 0.1
    @State var rotationAngle: Double = 0.0
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            Text(testo)
                .fontWeight(fontWeight) //.bold
                .lineLimit(1)
                .foregroundColor(textColor) // .white
                .minimumScaleFactor(scaleFactor) // 0.6
                ._tightPadding()
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .strokeBorder(strokeColor) // color.blue
                        .background(RoundedRectangle(cornerRadius: 5.0)
                                        .fill(fillColor.opacity(0.8)))
                        .shadow(radius: 3.0)
                
                )
            
            if showDeleteImage {
                Image(systemName: "x.circle.fill")
                    .frame(width:10, height: 10)
                    .background(Color.white)
                    .foregroundColor(Color.red)
            }
        }
        .rotationEffect(.degrees(rotationAngle))
        .onReceive(timer) { _ in
            
            withAnimation(.easeInOut) {
  
                rotationAngle = rotationAngle == 2.5 ? -2.5 : (rotationAngle + 1.25)
          
            }
        }
    }
}



struct CSText_tight_Previews: PreviewProvider {
    static var previews: some View {
        CSText_tightRectangle(testo:"Pronto Prova", fontWeight: .bold, textColor: Color.mint, strokeColor: Color.clear, fillColor:Color.white)
    }
}
