//
//  VariousTabStyle.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/01/22.
//

import SwiftUI

struct VariousTabStyle: View {
    var body: some View {

        TabView {
            
            Color.yellow
            Color.cyan
            Color.red
            
            
            
            
            
        }.tabViewStyle(PageTabViewStyle())
        //.tabViewStyle(DefaultTabViewStyle())

    }
}

struct VariousTabStyle_Previews: PreviewProvider {
    static var previews: some View {
        VariousTabStyle()
    }
}
