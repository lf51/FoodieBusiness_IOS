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

struct CSTextField_3: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            Image(systemName: self.textFieldItem != "" ? "rectangle.and.pencil.and.ellipsis" : "square.and.pencil")
                .imageScale(.large)
                .foregroundColor(self.textFieldItem != "" ? Color.green : Color.black)
                .padding(.leading)
            
            TextField (self.placeHolder, text: $textFieldItem)
                .padding()
                .accentColor(Color.white)
                
            Button(action: self.action) {
                    
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(Color.white)
                        .padding(.trailing)
                }.disabled(self.textFieldItem == "")
        
        }.background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .strokeBorder(Color.blue)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.gray.opacity(self.textFieldItem != "" ? 0.6 : 0.2))
                    
                )
                .shadow(radius: 3.0)
        )
            .onSubmit(self.action)
            .animation(Animation.easeInOut, value: self.textFieldItem)
    }
}

/// Small Custom textfiel con una immagine  e un bottone
struct CSTextField_4: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    let image: String
  
    var body: some View {
        
        HStack {
            
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(self.textFieldItem != "" ? Color.green : Color.black)
                .padding(.leading)
            
            TextField (self.placeHolder, text: $textFieldItem)
                .keyboardType(.numberPad)
                ._tightPadding()
                .accentColor(Color.white)
        
        }.background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .strokeBorder(Color.blue)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.gray.opacity(self.textFieldItem != "" ? 0.6 : 0.2))
                    
                )
                .shadow(radius: 3.0)
        )
            .animation(Animation.easeInOut, value: self.textFieldItem)
    }
}
