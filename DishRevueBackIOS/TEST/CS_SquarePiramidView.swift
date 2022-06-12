//
//  CS_Shape.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/06/22.
//

import SwiftUI

/// Nasconde una immagine all'interno di una piramide aprile e chiudibile al Tap
struct CS_SquarePiramidView: View {
    
    let imageBehind: String
    let imageColor: Color
    let piramidColor: Color
    let shadowColor: Color
    let borderColor: Color
    @State private var openGrade: Bool = false
    
    var body: some View {
        
        ZStack {
            
            csVbSwitchImageText(string: imageBehind, size: .large)
                .foregroundColor(imageColor)
                .zIndex(1.0)
            
            CS_Piramid(openGrade: openGrade, colorBase: piramidColor, shadowColor: shadowColor)
                .border(borderColor, width: openGrade ? 0.5 : 1.0)
                .cornerRadius(10.0)
                .onTapGesture {
                   
                    withAnimation(.easeIn(duration: 2.0)) {
                        self.openGrade.toggle()
                    }
                    
            }
                .zIndex(2.0)
        }
          
    }
}

struct CS_SquarePiramidView_Previews: PreviewProvider {
    static var previews: some View {
        CS_SquarePiramidView(imageBehind: "trash.fill", imageColor: Color.red, piramidColor: Color("SeaTurtlePalette_2"),shadowColor: Color("SeaTurtlePalette_2"),borderColor: Color("SeaTurtlePalette_3"))
    }
}

/// Unisce 4Triangoli per formare una piramide
struct CS_Piramid: View {
    
    var openGrade: Bool
    let colorBase: Color
    let shadowColor: Color
 
    var body: some View {
        
        ZStack {
            
            CS_Triangle(misuraApertura: openGrade ? 20 : 0)
                
                .foregroundColor(colorBase.opacity(0.8))
                .frame(width: 100, height: 100)
              // .border(Color.black, width: openGrade ? 2.5 : 5.0)
                .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: 0, y: 5)
                .zIndex(3.0)
            CS_Triangle(misuraApertura: openGrade ? 20 : 0)
                .rotation(Angle(degrees: 180))
                .foregroundColor(colorBase.opacity(0.8))
                .frame(width: 100, height: 100)
                .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: 0, y: -5)
                .zIndex(3.0)
            
            CS_Triangle(misuraApertura: openGrade ? 20 : 0)
                .rotation(Angle(degrees: 90))
                .foregroundColor(colorBase.opacity(0.7))
                .frame(width: 100, height: 100)
                .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: -5, y: 0)
               // .shadow(color: Color.blue.opacity(0.7), radius: 15.0, x: -50, y: 0)
                .zIndex(4.0)
            
            CS_Triangle(misuraApertura: openGrade ? 20 : 0)
                .rotation(Angle(degrees: 270))
                .foregroundColor(colorBase.opacity(0.9))
                .frame(width: 100, height: 100)
                .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: 5, y: 0)
                .zIndex(3.0)
            
        }
      //  .clipShape(RoundedRectangle(cornerRadius: 10.0))
 
    }
}

/// Triangolo Equilatero
struct CS_Triangle:Shape {
    
    var misuraApertura: CGFloat
    var animatableData: CGFloat {
        
        get { misuraApertura }
        set { misuraApertura = newValue }
        
    }
    
    func path(in rect: CGRect) -> Path {
            
            Path { path in
                
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - misuraApertura))

            }
        
    }
  
}

