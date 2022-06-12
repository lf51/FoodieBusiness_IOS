//
//  CS_Shape.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/06/22.
//

import SwiftUI

/// Nasconde una immagine all'interno di una piramide aprile e chiudibile al Tap
struct CS_CircleSnakeView: View {
    
    let imageBehind: String
    let imageColor: Color
    let piramidColor: Color
    let shadowColor: Color
    let borderColor: Color
    @State private var openGrade: Bool = false
    
    var body: some View {
        
        VStack { // temporaneo
            ZStack {
                
                Color("SeaTurtlePalette_1")
                
                csVbSwitchImageText(string: imageBehind, size: .large)
                    .foregroundColor(imageColor)
                    .zIndex(1.0)
                
                CS_CircleSnake(openGrade: openGrade, colorBase: piramidColor, shadowColor: shadowColor)
                    .border(borderColor, width: openGrade ? 1.0 : 0.0)
                    .cornerRadius(20.0)
                    .onTapGesture {
                       
                        withAnimation(.easeIn(duration: 2.0)) {
                            self.openGrade.toggle()
                        }
                        
                }
                    .zIndex(2.0)
            }
            
            Text("Attiva")
                .onTapGesture {
                   
                    withAnimation(.easeIn(duration: 3.0)) {
                        self.openGrade.toggle()
                    }
                    
            }
            
        }
          
    }
}

struct CS_CircleSnakeView_Previews: PreviewProvider {
    static var previews: some View {
        
       
            CS_CircleSnakeView(
                imageBehind: "circle.fill",
                imageColor: Color.yellow,
                piramidColor: Color.red,
                shadowColor: Color.gray,
                borderColor: Color.green)
            
            
        
        
       
        
       /* CS_CircleSnake(
            openGrade: false,
            colorBase: Color.blue,
            shadowColor: Color.gray)  */
        
        /*CS_SquarePiramidView(imageBehind: "trash.fill", imageColor: Color.red, piramidColor: Color("SeaTurtlePalette_2"),shadowColor: Color("SeaTurtlePalette_2"),borderColor: Color("SeaTurtlePalette_3")) */
    }
}

/// Unisce 4Triangoli per formare un'apertura'
struct CS_CircleSnake: View {
    
    var openGrade: Bool
    let colorBase: Color
    let shadowColor: Color
 
    var body: some View {
        
        ZStack {
            
            CS_TriangleIsoscele(misuraApertura: openGrade ? 100 : 5)
                
                .foregroundColor(colorBase.opacity(1.0))
                .frame(width: 100, height: 100)
              // .border(Color.black, width: openGrade ? 2.5 : 5.0)
               .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: 0, y: 5)
                .zIndex(3.0)
            
            CS_TriangleIsoscele(misuraApertura: openGrade ? 100: 5)
                .rotation(Angle(degrees: 90))
                .foregroundColor(colorBase.opacity(1.0))
                .frame(width: 100, height: 100)
                .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: 0, y: -5)
                .zIndex(3.0)
            
           CS_TriangleIsoscele(misuraApertura: openGrade ? 100 : 5)
                .rotation(Angle(degrees: 180))
                .foregroundColor(colorBase.opacity(1.0))
                .frame(width: 100, height: 100)
                .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: -5, y: 0)
               // .shadow(color: Color.blue.opacity(0.7), radius: 15.0, x: -50, y: 0)
                .zIndex(4.0)
            
             
            CS_TriangleIsoscele(misuraApertura: openGrade ? 100 : 5)
                .rotation(Angle(degrees: 270))
                .foregroundColor(colorBase.opacity(1.0))
                .frame(width: 100, height: 100)
               .shadow(color: openGrade ? shadowColor : Color.clear, radius: 7.0, x: 5, y: 0)
                .zIndex(3.0)
             
        }
        .clipShape(
            Rectangle()
             //  Circle()
        )
 
    }
}

/// Triangolo Isoscele
struct CS_TriangleIsoscele:Shape {
    
    var misuraApertura: CGFloat
    var animatableData: CGFloat {
        
        get { misuraApertura }
        set { misuraApertura = newValue }
        
    }
    
    func path(in rect: CGRect) -> Path {
            
            Path { path in
                
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - misuraApertura))

            }
        
    }
  
}

