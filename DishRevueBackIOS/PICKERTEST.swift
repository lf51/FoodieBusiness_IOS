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
    @State var data = ["casa","Home","myHouse"]
    
    var body: some View {
        
        List {
            
            ForEach(data,id:\.self) { data in
                
                Text(data)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black.cornerRadius(5.0))
                    .swipeActions {
                        Button {
                            self.data.append("Ciao")
                        } label: {
                            Text("Ciao")
                        }

                    }

                
            }
            
            
        }.listStyle(PlainListStyle())


    }
}

struct PICKERTEST_Previews: PreviewProvider {
    static var previews: some View {
        PICKERTEST()
    }
}
