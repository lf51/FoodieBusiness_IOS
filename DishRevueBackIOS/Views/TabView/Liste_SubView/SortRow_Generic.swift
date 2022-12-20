//
//  SortRow_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/11/22.
//

import SwiftUI
import MyPackView_L0
import MyFilterPackage

struct SortRow_Generic<M:MyProFilter_L0>: View {
    
    @Binding var sortCondition:M.SortCondition?
    let localSortCondition:M.SortCondition
    
    var body: some View {

        let isConditionSelected = sortCondition == localSortCondition
        
        CSLabel_conVB(
            placeHolder: localSortCondition.simpleDescription(),
            placeHolderColor: isConditionSelected ?  Color("SeaTurtlePalette_2") : Color.black,
            imageNameOrEmojy: localSortCondition.imageAssociated(),
            backgroundColor: Color.black,
            backgroundOpacity: 0.03) {
                
                HStack {
                    
                    Spacer()
                    
                    CSButton_image(
                        activationBool: isConditionSelected,
                        frontImage: "arrow.up.arrow.down.circle.fill",
                        backImage: "circle",
                        imageScale: .large,
                        backColor: Color("SeaTurtlePalette_2"),
                        frontColor: Color.gray) {
                            self.action()
                        }
                    
                }
            }
        
    }
    
    func action() {
        
        if self.sortCondition == nil { self.sortCondition = self.localSortCondition }
        else if self.sortCondition == self.localSortCondition { self.sortCondition = nil }
        else { self.sortCondition = self.localSortCondition }
        
    }
}
/*
struct SortRow_Generic: View {
    
    @Binding var sortCondition:FilterPropertyModel.SortCondition?
    let localSortCondition:FilterPropertyModel.SortCondition
    
    var body: some View {

        let isConditionSelected = sortCondition == localSortCondition
        
        CSLabel_conVB(
            placeHolder: localSortCondition.simpleDescription(),
            placeHolderColor: isConditionSelected ?  Color("SeaTurtlePalette_2") : Color.black,
            imageNameOrEmojy: localSortCondition.imageAssociated(),
            backgroundColor: Color.black,
            backgroundOpacity: 0.03) {
                
                HStack {
                    
                    Spacer()
                    
                    CSButton_image(
                        activationBool: isConditionSelected,
                        frontImage: "arrow.up.arrow.down.circle.fill",
                        backImage: "circle",
                        imageScale: .large,
                        backColor: Color("SeaTurtlePalette_2"),
                        frontColor: Color.gray) {
                            self.action()
                        }
                    
                }
            }
        
    }
    
    func action() {
        
        if self.sortCondition == nil { self.sortCondition = self.localSortCondition }
        else if self.sortCondition == self.localSortCondition { self.sortCondition = nil }
        else { self.sortCondition = self.localSortCondition }
        
    }
}*/ // Deprecata 19.12.22

/*
struct SortRow_Generic_Previews: PreviewProvider {
    static var previews: some View {
        SortRow_Generic()
    }
} */
