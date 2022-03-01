//
//  CustomLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct CSLabel_1Button: View {
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    @Binding var toggleBottone: Bool?
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, toggleBottone: Binding<Bool?>?) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.backgroundColor = backgroundColor

        _toggleBottone = toggleBottone ?? Binding.constant(nil)
        
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
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
                    .fill(backgroundColor.opacity(0.2))
            )
            
            if toggleBottone != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        toggleBottone!.toggle()
                    }
                    
                } label: {
                     
                    Image(systemName: toggleBottone! ? "minus.circle" : "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(toggleBottone! ? .red : .blue)
                }
            }
            
            Spacer()
        }
    }
}

struct CSLabel_2Button: View {
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    @Binding var toggleBottonePLUS: Bool?
    @Binding var toggleBottoneTEXT: Bool?
    
    var testoBottoneTEXT: String?
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, toggleBottonePLUS: Binding<Bool?>?, toggleBottoneTEXT: Binding<Bool?>?, testoBottoneTEXT: String) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.backgroundColor = backgroundColor

        _toggleBottonePLUS = toggleBottonePLUS ?? Binding.constant(nil)
        _toggleBottoneTEXT = toggleBottoneTEXT ?? Binding.constant(nil)
        
        self.testoBottoneTEXT = testoBottoneTEXT
        
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
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
                    .fill(backgroundColor.opacity(0.2))
                    
            )
            
            Spacer()
            
            if toggleBottonePLUS != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        toggleBottonePLUS!.toggle()
                    }
                    
                } label: {
                     
                    Image(systemName: toggleBottonePLUS! ? "minus.circle" : "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(toggleBottonePLUS! ? .red : .blue)
                    
                }.disabled(toggleBottoneTEXT ?? false)
            }
            
            Spacer()
            
            if toggleBottoneTEXT != nil {
      
                Button {
                    withAnimation(.default) {
                        toggleBottoneTEXT!.toggle()
                    }
                } label: {
                    Text(testoBottoneTEXT ?? "")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .brightness(toggleBottoneTEXT ?? false ? 0.0 : -0.05)
                .disabled(toggleBottonePLUS ?? false)
    
            }
        }
    }
}


/*struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabel()
    }
}*/


/*struct CSLabel_1BACKUP: View {
    
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
                .fill(backgroundColor.opacity(0.2))
        )
  
    }
} */
