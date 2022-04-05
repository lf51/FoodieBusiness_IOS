//
//  DataModelPickerView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI

struct DataModelPickerView_SubView: View {
    
    @Binding var selectedMapCategory: MapCategoryContainer
    let dataContainer:[MapCategoryContainer]
    
    var body: some View {

                  
        Picker(selection:$selectedMapCategory) {
                      
            ForEach(dataContainer, id:\.self) {filter in
                          
                    Text(filter.simpleDescription())
                          
                      }
                      
                  } label: {Text("")}
                  .pickerStyle(SegmentedPickerStyle())
                  
        
    }
    
}

struct DataModelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DataModelPickerView()
    }
}
