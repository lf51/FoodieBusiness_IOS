//
//  FilterButton.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/11/22.
//

import SwiftUI

struct FilterButton:View {
    
    @Binding var open:Bool
    @Binding var openSort:Bool
    let filterCount:Int
    let sortActive:Bool
    
    var body: some View {
        
        HStack(spacing:0) {

            CSButton_image(frontImage: "slider.horizontal.3", imageScale: .large, frontColor: Color("SeaTurtlePalette_3")) {
                self.open.toggle()
            }
            .padding([.top,.trailing],5)
            .overlay(alignment: .topTrailing) {
             //   let count = filterProperty.countChange
                
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
                }
                    
            }
            
            CSButton_image(frontImage: "arrow.up.arrow.down", imageScale: .medium, frontColor: Color("SeaTurtlePalette_3")) {
                self.openSort.toggle()
            }
            .padding([.top,.trailing],5)
            .overlay(alignment: .topTrailing) {
             //   let count = filterProperty.countChange
                
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
                }
                    
            }
            
        }
        
    }
}
