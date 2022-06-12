//
//  AddNewPropertyBar_HomeSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/03/22.
//

import SwiftUI

/// Ritorna un HStack con testo(optional) + Button(Image(optional) + testo(optionale))
struct LargeBar_TextPlusButton: View {
    
    var buttonTitle: String? = nil
    var placeHolder: String? = nil
    var font: Font? = .largeTitle
    var imageBack: Color? = Color.blue
    var imageFore: Color? = Color.white
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            Text(placeHolder ?? "")
                .font(font)
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
               // .padding(.leading)
            
            Spacer()
        
            Button(action: {self.action()}, label: {
                
                HStack {
                    
                    Image(systemName: "plus.circle")
                        .font(font)
                        .background(imageBack.clipShape(Circle()))
                        .foregroundColor(imageFore)
                      //  .padding(.trailing)
                    
                    Text(buttonTitle ?? "")
                        .font(font)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                       // .padding(.leading)
                }
            })
            
        }
    }
}

/// Ritorna un HStack con Image(due immagini sovrapposte e clipshaped in Circle customizzabili) + Testo(optional)
struct LargeBar_Text: View {
    
    var title: String? = nil
    var font: Font? = .largeTitle
    var imageBack: Color? = Color.blue
    var imageFore: Color? = Color.white
    
    var body: some View {
                
            HStack {
                    
                    Image(systemName: "plus.circle")
                        .font(font)
                        .background(imageBack.clipShape(Circle()))
                        .foregroundColor(imageFore)
                     
                    
                    Text(title ?? "")
                        .font(font)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                   
                }
    }
}
