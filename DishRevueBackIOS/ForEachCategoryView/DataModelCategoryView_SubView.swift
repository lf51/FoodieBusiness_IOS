//
//  DataModelCategoryView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI

struct DataModelCategoryView_SubView<M:MyModelProtocol,G:MyEnumProtocolMapConform>:View {
    
    let dataMapping:[G]
    let dataFiltering: (_ element:G) -> [M]
    
    var body: some View {
        
        
        VStack(alignment:.leading) {
            
            ScrollView {
                
                ForEach(Array(Set(dataMapping)), id:\.self) { category in
                    
                    CSLabel_1Button(placeHolder: category.simpleDescription(), imageName: "pencil", backgroundColor: Color.green)
 
                    
                    ScrollView(.horizontal) {
                        
                         HStack {
                            
                            ForEach(dataFiltering(category)) { item in
                                
                                Text(item.intestazione)
                            }
                            
                        }
                        
                        
                    }
                    
                }
            
            }
            
        }
        .padding(.horizontal)
    
    }
  
}

struct DataModelCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        DataModelCategoryView()
    }
}
