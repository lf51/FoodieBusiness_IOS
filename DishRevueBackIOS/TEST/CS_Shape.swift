//
//  CS_Shape.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/06/22.
//

import SwiftUI

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
                                        .foregroundColor(.blue)
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
        CS_Shape()
    }
}


struct CS_Octagon:Shape {
    
    func path(in rect: CGRect) -> Path {
        
        Path { path in
            
            path.move(to: CGPoint(x: rect.midX / 2, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX * 1.5, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY / 2))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY * 1.5))
            path.addLine(to: CGPoint(x: rect.midX * 1.5, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX / 2, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY * 1.5))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY / 2))
            
            
            
        }
        
    }
  
}


struct CS_Exagon: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        Path { path in
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
          //  path.addLine(to: CGPoint(x: rect.midX * 1.5, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY / 2))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY * 1.5))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
          //  path.addLine(to: CGPoint(x: rect.midX / 2, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY * 1.5))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY / 2))
            
            
            
        }
        
    }
    
    
    
}
