//
//  GemotryReaderTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import SwiftUI

struct GemotryReaderTEST: View {
    var body: some View {
        NavigationView {
            GeometryReader { gp in
                ScrollView {
                    ZStack(alignment: .top) {
                        Rectangle().fill(Color.red) // << background

                      // ... your content here, internal alignment might be needed

                    }.frame(minHeight: gp.size.height)

                }
                .navigationBarTitle("Gallery")
            }
        }
    }
}

struct GemotryReaderTEST_Previews: PreviewProvider {
    static var previews: some View {
        GemotryReaderTEST()
    }
}
