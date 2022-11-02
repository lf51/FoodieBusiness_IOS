//
//  FilterRowContainer.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/11/22.
//

import SwiftUI

struct FilterRowContainer<Content:View>:View {
    
    let backgroundColorView:Color

    let resetAction: () -> Void
    @ViewBuilder var content: Content
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.top)
                .zIndex(0)
            
            VStack(alignment:.leading) {
                
                Text("Filter")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .foregroundColor(Color.black)

                VStack(alignment:.leading,spacing: 8.0) {
 
             
                    content // le row dei filtri
                    
                }
                    Spacer()
                    
                    CSButton_tight(
                        title: "Azzera Filtri",
                        fontWeight: .semibold,
                        titleColor: Color.red.opacity(0.8),
                        fillColor: Color.clear) {
                            withAnimation {
                                resetAction()
                            }
                                
                        }
                }
                .padding(.horizontal)
                .padding(.vertical,10)
                
                
            }
            .background(backgroundColorView.opacity(0.6))
            
        }
    }
