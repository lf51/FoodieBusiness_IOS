//
//  CS_Shape.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/06/22.
//

import SwiftUI
import MyPackView_L0

struct CS_Shape: View {

    let line: Int
    
    init () {
        
        let screenHeight: CGFloat = UIScreen.main.bounds.height * 0.85
        let exagonFrame: CGFloat = 75.0
        
        self.line = Int(screenHeight / exagonFrame)
        
    }
    
    var body: some View {
        
        VStack(spacing:-18) {

                ForEach(0..<10) { line in
                    
                    HStack(spacing:1) {
                        
                        if ((line % 2) != 0) {
                            CS_Exagon()
                                .trim(from: 0, to: 0.6)
                                .frame(width: 75, height: 75)
                            
                            ForEach(0..<4) {_ in
                                
                                CS_Exagon()
                                      .frame(width: 75, height: 75)
                                
                                
                            }
                            
                            CS_Exagon()
                                .trim(from: 0, to: 0.6)
                                .rotation(Angle(degrees: 180))
                                .frame(width: 75, height: 75)

                            
                        } else {
                            
                            ForEach(0..<5) { _ in

                                    CS_Exagon()
                                        .foregroundStyle(Color.blue)
                                        .frame(width: 75, height: 75)
                                       // .offset(x: 0, y: 18)
          
                            }
                            
                        }
      
                    }
                
                    
                    
                }
               
            
            
            
        }
        
        
      
    }
}

struct CS_Shape_Previews: PreviewProvider {
    static var previews: some View {
        CS_VelaShape2()
    }
}



struct CS_VelaShape2: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        Path { path in
            
            
            // fascetta rettangolare
            path.move(to: CGPoint(x: rect.midX * 0.9, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX , y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY * 0.90))
            
            
            // triangolo sul corner
          /*  path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midY * 0.9 , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY * 0.9)) */

            // arco verso l'esterno
        /*    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.minX, y: rect.minY), radius: rect.midY * 0.9, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false) */

        }
    }
}


