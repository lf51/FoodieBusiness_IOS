//
//  Conferma.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import SwiftUI

struct Conferma: View {
    
    @State var title: Int = 2
    @State var showDialog: Bool = false
    
    var body: some View {
    
        
        VStack {
            
            Text("\(title)")
                .padding()
                .background(Color.white.cornerRadius(5.0))
            
            Button {
                self.showDialog = true
              //  test()
            } label: {
                Text("Conferma")
                    .bold()
                    .foregroundColor(Color.white)
        }
            .padding()
            
            
            
        }
        .padding()
        .background(Color.red.cornerRadius(5.0))
        .confirmationDialog(Text("Ciao"), isPresented: $showDialog, titleVisibility: .hidden) {
            
            Button("Conferma", role: .none) {
                          test()
                       }
        }

        
    }
    
    func test() {
        
        self.title *= 2
        
        print("Ciao")
    }
}

struct Conferma_Previews: PreviewProvider {
    static var previews: some View {
        Conferma()
    }
}
