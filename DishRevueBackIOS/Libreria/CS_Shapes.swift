//
//  Shapes.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/12/22.
//

import Foundation
import SwiftUI

struct CS_VelaShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        Path { path in
 
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.midY, y: rect.midY), radius: rect.midY, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            
        }
    }
}


/*
struct CS_VelaShape2: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        Path { path in
            
            
            // fascetta rettangolare
          /*  path.move(to: CGPoint(x: rect.midX * 0.9, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX , y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY * 0.90)) */
            
            
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
 */

