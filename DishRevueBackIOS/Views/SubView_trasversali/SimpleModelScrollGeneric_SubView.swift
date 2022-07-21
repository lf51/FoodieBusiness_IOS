//
//  SimpleModelScrollGeneric_SubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/07/22.
//

import SwiftUI

struct SimpleModelScrollGeneric_SubView<M:MyModelProtocol>:View {
    
    let modelToShow: [M]
    var fontWeight: Font.Weight? = .bold
    var textColor: Color? = Color.white
    var strokeColor: Color? = Color.blue
    var fillColor: Color? = Color.clear
    
    var body: some View {

        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack {
                
                ForEach(modelToShow) { model in
                       
                    CSText_tightRectangle(
                        testo: model.intestazione,
                        fontWeight: fontWeight!,
                        textColor: textColor!,
                        strokeColor: strokeColor!,
                        fillColor: fillColor!)

                    
                }
            }
        }
    }
}

/*
struct SimpleModelScrollGeneric_SubView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleModelScrollGeneric_SubView()
    }
} */
