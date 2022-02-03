//
//  CustomTextFieldView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI

// TextField SubView riutilizzabili

struct CSTextField_1: View {
    
  @Binding var text: String
  let placeholder: String
  let symbolName: String

  var body: some View {
      
    HStack {
      Image(systemName: symbolName)
        .imageScale(.large)
        .padding(.leading)

      TextField(placeholder, text: $text)
        .padding(.vertical)
        .accentColor(.orange)
        .autocapitalization(.none)
    }
    .background(
      RoundedRectangle(cornerRadius: 16.0, style: .circular)
        .foregroundColor(Color(.secondarySystemFill))
    )
  }
}

struct CSTextField_2: View {
    
  @Binding var text: String
  let placeholder: String
  let symbolName: String
  let accentColor: Color
  let backGroundColor: Color
  let autoCap: UITextAutocapitalizationType
  let cornerRadius:CGFloat

  var body: some View {
      
    HStack {
        
      Image(systemName: symbolName)
        .imageScale(.large)
        .foregroundColor(accentColor)
        .background(backGroundColor.clipShape(Circle()))
        .padding(.leading)

      TextField(placeholder, text: $text)
        .padding(.vertical)
        .accentColor(accentColor)
        .autocapitalization(autoCap)
    }
    .background(
      RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
        .foregroundColor(Color(.secondarySystemFill))
    )
  }
}


/* struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CSTextField(text: <#Binding<String>#>, placeholder: <#String#>, symbolName: <#String#>)
    }
} */
