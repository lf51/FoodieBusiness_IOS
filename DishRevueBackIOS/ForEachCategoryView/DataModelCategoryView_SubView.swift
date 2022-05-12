//
//  DataModelCategoryView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI

struct DataModelCategoryView_SubView<M:MyModelProtocol,G:MyEnumProtocolMapConform>:View {
    
    let dataMapping:[G]
    @Binding var stringSearch: String
    let dataFiltering: (_ element:G) -> [M]
    
    var body: some View {
  
           ScrollView(showsIndicators: false){
                
               ScrollViewReader { proxy in
                   CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
                   
                   ForEach(dataMapping, id:\.self) { category in
                       
                       CSLabel_1Button(placeHolder: category.simpleDescription(), imageNameOrEmojy: category.imageAssociated(), backgroundColor: Color.blue, backgroundOpacity: 0.3)
    
                       ScrollView(.horizontal,showsIndicators: false) {
                           
                            HStack {
                               
                                ForEach(dataFiltering(category).sorted{$0.intestazione < $1.intestazione}) { item in
                                   
                                   csVbSwitchModelRowView(item: item)
                                   
                               }
                           }
                       }
                   }
                   .id(1)
                   .onAppear {proxy.scrollTo(1, anchor: .top)}
                   
               }
            }

    }
}




/* struct DataModelCategoryView_SubView<M:MyModelProtocol,G:MyEnumProtocolMapConform>:View {
    
    let dataMapping:[G]
    @State var stringSearch: String = ""
    let dataFiltering: (_ element:G) -> [M]
    
    @State var showSearchBar: Bool = false
    
    var body: some View {
        
      //  VStack(alignment:.leading) {
        
        
           ScrollView(showsIndicators: false){
                
              if showSearchBar { CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass") }
    
                ForEach(dataMapping, id:\.self) { category in
                    
                    CSLabel_1Button(placeHolder: category.simpleDescription(), imageName: category.imageAssociated(), backgroundColor: Color.blue, backgroundOpacity: 0.3)
 
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                         HStack {
                            
                             ForEach(dataFiltering(category).sorted{$0.intestazione < $1.intestazione}) { item in
                                
                                vbSwitchModelRowView(item: item)
                                
                            }
                        }
                    }
                }
            }
           
           
       // }
    }
} */ // BACKUP 17.04








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
