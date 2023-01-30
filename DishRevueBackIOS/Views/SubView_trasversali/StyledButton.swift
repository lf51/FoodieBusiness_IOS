//
//  CSButton.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MyPackView_L0
// SubView Button Riutilizzabili

// Usare il .buttomStyle per semplificare lo stile dei bottoni


/*
struct CSButton_tight: View { // Spostato MyPackView
    
  let title: String
  let fontWeight: Font.Weight
  let titleColor: Color
  let fillColor: Color
  let imageName: String? = nil
  let action: () -> Void

  var body: some View {
      
    Button(action: action) {
    
        HStack {
            
            if let imageName = imageName {
                
                Image(systemName: imageName)
                    .imageScale(.medium)
                    .foregroundColor(titleColor)
            }
      
            Text(title)
                .fontWeight(fontWeight)
                .font(.system(.body, design: .rounded))
                ._tightPadding()
                .foregroundColor(titleColor)
                .background(fillColor)
                .cornerRadius(5.0) // 5.0
            
                }
            }
        }
    } */




/*struct CSButton_tight: View {
    
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
    } */

/// Di default il cornerRadius se specificato va su tutti gli angoli. Il padding è di default verticale. il PaddingValue modifica il valore del paddingBottom. Lo spazio in orizzontale è erditato dagli spacer.
struct CSButton_large: View {
    
    let title: String
    let accentColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    var corners: UIRectCorner = .allCorners
    var paddingValue:CGFloat? = nil
    let action: () -> Void

  var body: some View {
      
    Button(action: action) {
     
        HStack {
        Spacer()
            Text(title)
          .bold()
          .padding(.top)
          .padding(.bottom,paddingValue)
          .accentColor(accentColor)
        Spacer()
      }
    }
    .background(backgroundColor)
    .csCornerRadius(cornerRadius, corners: corners)
    
  }
}

/*struct CSButton_Previews: PreviewProvider {
    static var previews: some View {
        CSButton_1()
    }
} */
