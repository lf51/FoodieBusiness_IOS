//
//  CSButton.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI

// SubView Button Riutilizzabili

// Usare il .buttomStyle per semplificare lo stile dei bottoni

/// Plain Image Button. Use rotationDegree quando activeImage == DeactiveImage e la si vuole ruotare. ActivationBool gestisce Switch front/back Image.)
struct CSButton_image: View {
  
  var activationBool: Bool? = true
    
  let frontImage: String
  var backImage: String? = nil
  let imageScale: Image.Scale
  var backColor: Color? = nil
  let frontColor: Color
  var rotationDegree: Double? = nil
  let action: () -> Void

  var body: some View {
      
    Button(action: action) {
    
        Image(systemName: activationBool! ? frontImage : backImage ?? frontImage)
            .imageScale(imageScale)
            .foregroundColor(activationBool! ? backColor ?? frontColor : frontColor)
            .rotationEffect(.degrees(activationBool! ? rotationDegree ?? 0.0 : 0.0))

            }
        }
    }


struct CSButton_tight: View {
    
  let title: String
  let fontWeight: Font.Weight
  let titleColor: Color
  let fillColor: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
    
        Text(title)
            .fontWeight(fontWeight)
            ._tightPadding()
            .foregroundColor(titleColor)
            .background(fillColor)
            .cornerRadius(5.0) // 5.0
            }
        }
    }

struct CSButton_large: View {
    
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
