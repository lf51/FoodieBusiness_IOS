//
//  CustomLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct CSLabel_1: View {
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    var body: some View {
        
        Label {
            Text(placeHolder)
                .fontWeight(.medium)
                .font(.system(.subheadline, design: .monospaced))
        } icon: {
            Image(systemName: imageName)
        }
        ._tightPadding()
        .background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.black.opacity(0.2))
        )
  
    }
}

/*struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabel()
    }
}*/
