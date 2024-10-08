//
//  CSBadgeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 21/09/22.
//

import SwiftUI

struct CSEtichetta: View { // 21.09 --> Rimpiazza parecchio codice simile qua e la uniformando i badge
    
    let text:String
    var fontStyle:Font.TextStyle = .caption2
    var fontWeight:Font.Weight = .black
    var fontDesign:Font.Design = .monospaced
    let textColor: Color
    let image:String
    let imageColor:Color?
    let imageSize:Image.Scale
    let backgroundColor:Color
    let backgroundOpacity:CGFloat
    
    var body: some View {
        
        HStack(alignment: .center,spacing:2) {
            
            csVbSwitchImageText(string: image, size: imageSize)
                .foregroundColor(imageColor)
            Text(text)
                .font(.system(fontStyle, design: fontDesign, weight: fontWeight))
                .foregroundColor(textColor)
          
        }
      //  .padding(1) // mi crea una distanza dal testo al margine ma anche dal margine a fuori (quest'ultima cosa in tante circostanze non m piace) 
        .padding(.trailing,4)
        .background(content: {
            RoundedRectangle(cornerRadius: 5.0)
                .fill(backgroundColor.opacity(backgroundOpacity))
        })
    }
}

/*
struct CSBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        CSBadgeView()
    }
} */
