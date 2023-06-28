//
//  CSViewModifier.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/05/22.
//

import Foundation
import SwiftUI
import MyPackView_L0

/// Un overlay custom che contiene la logica per comprendere se trattasi di una modifica o una creazione al modello
struct CS_RemoteModelChange:ViewModifier {
    
    @EnvironmentObject var viewModel:AccounterVM
    let rifModel:String
   
    func body(content: Content) -> some View {

        content
            .overlay {
                
              //  Group {
                    if viewModel.remoteStorage.modelRif_modified.contains(rifModel) {
                        
                        CS_VelaShape()
                        .foregroundColor(Color.black)
                        .cornerRadius(15.0)
                        .opacity(0.8)
                        
                    } else if viewModel.remoteStorage.modelRif_newOne.contains(rifModel) {
                        
                            CS_VelaShape()
                            .foregroundColor(.seaTurtle_4)
                            .cornerRadius(15.0)
                            .opacity(0.8)
            
                    }
               // }
            }
    }
}

struct CustomHpadding: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal,10)
    }
}







