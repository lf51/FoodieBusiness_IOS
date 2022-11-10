//
//  FilterButton.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/11/22.
//

import SwiftUI

struct FilterSortMap_Bar:View {
    
    @Binding var open: Bool
    @Binding var openSort: Bool

    let filterCount:Int
    let sortActive:Bool
    
    let thirdButtonAction: () -> Void
    @State private var isThirdButtonActive: Bool = false
    
    var body: some View {
        
        HStack(spacing:20) {

            CSButton_image(frontImage: "slider.horizontal.3", imageScale: .large, frontColor: Color("SeaTurtlePalette_3")) {
                self.open.toggle()
            }
         //   .padding([.top,.trailing],5)
            .padding(0)
            .overlay(alignment: .topTrailing) {
                
                if filterCount != 0 {
                    
                    Text("\(filterCount)")
                        .fontWeight(.bold)
                        .font(.caption)
                        .foregroundColor(Color.white)
                        .padding(4)
                        .background {
                           Color("SeaTurtlePalette_1")
                                //.clipShape(Circle())
                        }
                        .clipShape(Circle())
                        .offset(x: 2, y: -3)
                }
                    
            }
            
            CSButton_image(frontImage: "arrow.up.arrow.down", imageScale: .medium, frontColor: Color("SeaTurtlePalette_3")) {
                self.openSort.toggle()
            }
          //  .padding([.top,.trailing],5)
            .overlay(alignment: .topTrailing) {
                
                if sortActive {
                    
                    Text("\(1)")
                        .fontWeight(.bold)
                        .font(.caption)
                        .foregroundColor(Color.white)
                        .padding(4)
                        .background {
                           Color("SeaTurtlePalette_1")
                                //.clipShape(Circle())
                        }
                        
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
                    
            }
         
            CSButton_image(frontImage: self.isThirdButtonActive ? "rectangle.3.group.fill" : "rectangle.3.group", imageScale: .medium, frontColor: Color("SeaTurtlePalette_3")) {
              
                self.thirdButtonAction()
                self.isThirdButtonActive.toggle()
                
            }
          // .padding([.top,.trailing],5)
            
        }
       // .padding(.horizontal)
      /*  .background {
            Color("SeaTurtlePalette_3")
                .cornerRadius(5.0)
                .opacity(0.1)
        } */
        
    }
}
