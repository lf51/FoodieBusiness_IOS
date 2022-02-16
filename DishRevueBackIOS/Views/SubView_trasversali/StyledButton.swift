//
//  CSButton.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI

// SubView Button Riutilizzabili

struct CSButton_1: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      /// Embed in an HStack to display a wide button with centered text.
      HStack {
        Spacer()
        Text(title)
          .padding()
          .accentColor(.white)
        Spacer()
      }
    }
    .background(Color.orange)
    .cornerRadius(16.0)
  }
}

struct CSButton_2: View {
    
    let title: String
    let accentColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void

  var body: some View {
    Button(action: action) {
      /// Embed in an HStack to display a wide button with centered text.
      HStack {
        Spacer()
        Text(title)
              .bold()
          .padding()
          .accentColor(accentColor)
        Spacer()
      }
    }
    .background(backgroundColor)
    .cornerRadius(cornerRadius)
  }
}

/*struct CSButton_Previews: PreviewProvider {
    static var previews: some View {
        CSButton_1()
    }
} */
