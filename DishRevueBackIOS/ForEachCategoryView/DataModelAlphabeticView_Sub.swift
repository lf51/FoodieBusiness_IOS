//
//  DataModelAlphabeticView_Sub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/04/22.
//

import SwiftUI

struct DataModelAlphabeticView_Sub<T:MyModelProtocol>: View {
    
    let dataContainer: [T]
    @Binding var stringSearch: String
    let dataFiltering: () -> [T]
 
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                    ForEach(dataFiltering().sorted{$0.intestazione < $1.intestazione}) { item in
                        
                        HStack {
                           
                            vbSwitchModelRowView(item: item)
                            Spacer() // Possiamo mettere una view di fianco ogni schedina
    
                        }
                    }
                    .id(1)
                    .onAppear {proxy.scrollTo(1, anchor: .top)}
                    
                }
            }
    }
}

/*
struct DataModelAlphabeticView_Sub_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            DataModelAlphabeticView_Sub(dataContainer: [MenuModel()])
        }
    }
}
*/
