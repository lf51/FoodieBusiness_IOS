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
        
      //  VStack(alignment:.leading) {
            
            ScrollView(showsIndicators: false) {
                
                ForEach(dataMapping, id:\.self) { category in
                    
                    CSLabel_1Button(placeHolder: category.simpleDescription(), imageName: category.imageAssociated(), backgroundColor: Color.blue, backgroundOpacity: 0.3)
 
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                         HStack {
                            
                            ForEach(dataFiltering(category)) { item in
                                
                                switchModelDataRowView(item: item)
                                
                            }
                        }
                    }
                }
            }
       // }
    }
}

struct DataModelCategoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            Group {
                
                MenuModel_RowView(item: MenuModel(nome: "SomeDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi]))
                
            }
        }
    }
}
