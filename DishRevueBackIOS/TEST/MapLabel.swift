//
//  MapLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/02/23.
//

import SwiftUI
import MyPackView_L0

/*
public struct MapLabel: View {
    
    let label:String
    let image:String
    let rowBoundReduction:CGFloat
    let rowColor:Color
    let shadowColor:Color
    let rowOpacity:Double
    
    private let size:CGFloat
    
    public init(
        label:String,
        imageName:String,
        rowBoundReduction: CGFloat,
        rowColor: Color,
        shadowColor: Color,
        rowOpacity: Double) {
            
            self.label = label
            self.image = imageName
        self.rowBoundReduction = rowBoundReduction
        self.rowColor = rowColor
        self.shadowColor = shadowColor
        self.rowOpacity = rowOpacity
            
        let screenWidth:CGFloat = UIScreen.main.bounds.width - rowBoundReduction
            self.size = screenWidth * 0.11
    }
    
  public var body: some View {

      CSZStackVB_Framed(
        backgroundOpacity: rowOpacity,
        shadowColor: shadowColor,
        rowColor: rowColor,
        cornerRadius: 5.0,
        riduzioneMainBounds: rowBoundReduction) {
            
                Label {
                    Text(label)
                       /*.font(.system(.largeTitle, design: .rounded, weight: .semibold)) */
                        .font(.system(size: size, weight: .semibold, design: .rounded))
                     
                } icon: {
                    Text(image)
                        .font(.system(size: size))
                    // usiamo il text percheè le categorie passano con una Emojy
                        
                }
                
                .padding(.horizontal,5 )
                
  
        }
       // .frame(height:45)

    }
}

struct MapLabel_Previews: PreviewProvider {
    static var previews: some View {
        MapLabel(
            label:"Pizze",
            imageName:"🍕",
            rowBoundReduction: 20,
            rowColor: .seaTurtle_3,
            shadowColor: .clear,
            rowOpacity: 1.0)
    }
} */
