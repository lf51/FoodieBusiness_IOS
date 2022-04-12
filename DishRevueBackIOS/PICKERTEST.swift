//
//  PICKERTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 12/04/22.
//

import SwiftUI

struct PICKERTEST: View {
    
    @State var selection:GiorniDelServizio = .lunedi
    @State var mainSelection:String = "casa"
    let data = ["casa","home","hous"]
    
    var body: some View {
        
        Menu {
            
            ForEach(data,id:\.self) { data in
                
                Text(data)
                    .onTapGesture {
                        mainSelection = data 
                    }
                
                
            }
            
            
        } label: {
            Text(mainSelection)
        }


    }
}

struct PICKERTEST_Previews: PreviewProvider {
    static var previews: some View {
        PICKERTEST()
    }
}
