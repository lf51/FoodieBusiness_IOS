//
//  CustomTextFieldView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

// TextField SubView riutilizzabili

struct CSTextField_1: View {
    
  @Binding var text: String
  let placeholder: String
  let symbolName: String
  var symbolColor:Color = .yellow
  var backgroundColor:UIColor = .secondarySystemFill
  var cornerRadius:CGFloat = 16.0
  let keyboardType: UIKeyboardType

  var body: some View {
      
    HStack {
      Image(systemName: symbolName)
        .imageScale(.large)
        .foregroundStyle(text == "" ? Color.black : symbolColor)
        .padding(.leading)

      TextField(placeholder, text: $text)
        .padding(.vertical)
        .accentColor(symbolColor)
        .autocapitalization(.none)
        .keyboardType(keyboardType)
    }
    .background(
      RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
        .foregroundStyle(Color(backgroundColor))
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
        .foregroundStyle(accentColor)
        .background(backGroundColor.clipShape(Circle()))
        .padding(.leading)

      TextField(placeholder, text: $text)
        .padding(.vertical)
        .accentColor(accentColor)
        .autocapitalization(autoCap)
    }
    .background(
      RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
        .foregroundStyle(Color(.secondarySystemFill))
    )
  }
}

/// Small Custom textfiel con una immagine e una Action
struct CSTextField_3: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            Image(systemName: self.textFieldItem != "" ? "rectangle.and.pencil.and.ellipsis" : "square.and.pencil")
                .imageScale(.large)
                .foregroundStyle(self.textFieldItem != "" ? Color.green : Color.black)
                .padding(.leading)
            
            TextField (self.placeHolder, text: $textFieldItem)
                .padding()
                .accentColor(Color.white)
                
            Button(action: self.action) {
                    
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color.white)
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

/// Identico al TextField3 + un visualCheck del Contenuto
struct CSTextField_3b<VisualContent:View>: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    @ViewBuilder var visualConten: VisualContent
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            let condition = self.textFieldItem == ""
            
            visualConten
                .padding(.leading)
            
            TextField (self.placeHolder, text: $textFieldItem)
                .padding()
              //  .accentColor(Color.white)
                
            Button(action: self.action) {
                    
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color.white)
                        .padding(.trailing)
                }
            .opacity(condition ? 0.5 : 1.0)
            .disabled(condition)
        
        }
        .background(
            Color.white.opacity(0.05)
                
        )
        .cornerRadius(5.0)
        
        /*.background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .strokeBorder(Color.blue)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.gray.opacity(self.textFieldItem != "" ? 0.6 : 0.2))
                    
                )
                .shadow(radius: 3.0)
        )*/
            .onSubmit(self.action)
            .animation(Animation.easeInOut, value: self.textFieldItem)
    }
}

/// Small Custom textfield con una immagine, il TightPadding, e una action on Submit
struct CSTextField_5: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    let image: String
    let showDelete: Bool
    let keyboardType: UIKeyboardType
    let action: () -> Void
    
    init(textFieldItem:Binding<String>,placeHolder:String,image:String,showDelete:Bool = false, keyboardType: UIKeyboardType = .default, action: @escaping () -> Void ) {
        
        _textFieldItem = textFieldItem
        self.placeHolder = placeHolder
        self.image = image
        self.showDelete = showDelete
        self.keyboardType = keyboardType
        self.action = action
        
    }
    
    var body: some View {
        
        CSTextField_4(textFieldItem: $textFieldItem, placeHolder: placeHolder, image: image, showDelete: showDelete, keyboardType: keyboardType)
            .onSubmit(self.action)
        
    }
}

/// Texfield4 con SubmitAction, CheckConformitàTesto Visuale
struct CSTextField_6: View {
    
    @Binding var textFieldItem: String
    let placeHolder: String
    let image: String
    let showDelete: Bool
    let keyboardType: UIKeyboardType
    let conformeA: ConformitàTextField
    let action: () -> Void
    
    init(
        textFieldItem:Binding<String>,
        placeHolder:String,
        image:String,
        showDelete:Bool = false,
        keyboardType: UIKeyboardType = .default,
        conformeA:ConformitàTextField,
        action: @escaping () -> Void ) {
        
        _textFieldItem = textFieldItem
        self.placeHolder = placeHolder
        self.image = image
        self.showDelete = showDelete
        self.keyboardType = keyboardType
        self.conformeA = conformeA
        self.action = action
        
    }
    
    var body: some View {
        
        CSTextField_4b(
            textFieldItem: $textFieldItem,
            placeHolder: placeHolder,
            showDelete: showDelete,
            keyboardType: keyboardType) {
            csVisualCheck(
                testo: self.textFieldItem,
                staticImage: self.image,
                editingImage: self.image,
                conformeA: conformeA)
            .padding(.leading,5)
            
        }
            .onSubmit(self.action)
            .onChange(of: textFieldItem) { _, newValue in
                
                let delay = 2.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    if newValue == textFieldItem {
                        print("dentro OnChangeDispatch in CSTextField_6")
                        csHideKeyboard()
                        self.action() }
                }
                
            }
    } // Chiusa Body
    
    
  /*  private func visualCheck() -> some View {
        
        guard self.textFieldItem != "" else {
            
            return Image(systemName: self.image).imageScale(.medium).foregroundStyle(Color.gray)
                       
        }
        
       let isConforme = csCheckConformitaTextField(testo: self.textFieldItem, conformeA: self.conformeA)
        
        if isConforme {
            
            return Image(systemName: self.image)
                .imageScale(.medium)
                .foregroundStyle(Color.green)
            
            
        } else {
            
            return Image(systemName: "exclamationmark.circle")
                .imageScale(.medium)
                .foregroundStyle(Color.red)
        }
    } */ // Deprecated
    

    
} // Chiusa Struct



/* struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CSTextField(text: <#Binding<String>#>, placeholder: <#String#>, symbolName: <#String#>)
    }
} */
