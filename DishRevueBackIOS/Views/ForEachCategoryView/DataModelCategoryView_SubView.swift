//
//  DataModelCategoryView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI

struct DataModelCategoryView_SubView<M:MyModelStatusConformity,G:MyEnumProtocolMapConform>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var stringSearch: String = ""

    let filterCategory: MapCategoryContainer
    let path:KeyPath<M,G>?
    let collectionPath:KeyPath<M,[G]>?
    let dataPath:ReferenceWritableKeyPath<AccounterVM,[M]>
    let navPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    let dataMapping:[G]?
    
    /// Necessita di un Keypath (alias path) che conduce ad una proprietà singola G. Il Mapping è implicito, avviene sull'array del dataPath attraverso la proprietà G del path.
    init(filterCategory: MapCategoryContainer, path: KeyPath<M,G>, dataPath:ReferenceWritableKeyPath<AccounterVM,[M]>, navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) {

        self.dataMapping = nil
        self.filterCategory = filterCategory
        self.path = path
        self.collectionPath = nil
        self.dataPath = dataPath
        self.navPath = navPath
    }
    /// Necessita un Keypath (alias collectionPath) che conduce ad un array [G]. Il Mapping avviene su un array passato esplicitamente, il dataMapping.
    init(dataMapping:[G],filterCategory: MapCategoryContainer, collectionPath:KeyPath<M,[G]>, dataPath:ReferenceWritableKeyPath<AccounterVM,[M]>,navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) {

        self.dataMapping = dataMapping
        self.filterCategory = filterCategory
        self.path = nil
        self.collectionPath = collectionPath
        self.dataPath = dataPath
        self.navPath = navPath

    }
     
    
    var body: some View {
  
           ScrollView(showsIndicators: false){
                
               ScrollViewReader { proxy in
                   CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
                   
                   ForEach(csDataMapping(), id:\.self) { category in
                       
                       CSLabel_1Button(placeHolder: category.simpleDescription(), imageNameOrEmojy: category.imageAssociated(), backgroundColor: Color.blue, backgroundOpacity: 0.3)
    
                       ScrollView(.horizontal,showsIndicators: false) {
                           
                            HStack {

                                ForEach($viewModel[dynamicMember:dataPath].sorted{$0.wrappedValue.intestazione < $1.wrappedValue.intestazione }) { $item in
                                   
                                    csVbSwitchModelRowView(item: $item, element: category)
                                   
                               }
                           }
                       }
                   }
                   .id(1)
                   .onAppear {proxy.scrollTo(1, anchor: .top)}
                   
               }
            }

    }
    
    // Method
    private func csDataMapping() -> [G] {
        
        if self.path != nil {
            
            let dataMapped = viewModel[keyPath: dataPath].map({$0[keyPath: path!]})
            let dataCleaned = csRipulisciArray(array: dataMapped)
            return dataCleaned
        }
        else { return self.dataMapping!}
        
    }
    
    @ViewBuilder private func csVbSwitchModelRowView(item:Binding<M>, element: G) -> some View {
  
        let localItem: M = item.wrappedValue
        
        let isIn: Bool = {
            
            let firstBool:Bool 
            
            if self.path != nil {
                firstBool = localItem[keyPath: self.path!].returnTypeCase() == element
            } else { firstBool = localItem[keyPath: self.collectionPath!].contains(element) }

            let secondBool = viewModel.deepFiltering(model: localItem, filterCategory: self.filterCategory)
            let thirdBool = viewModel.stringResearch(item: localItem, stringaRicerca: self.stringSearch)
             
            return firstBool && secondBool && thirdBool
        
        }()
        
        if isIn {
            
            vbCambioStatusModelList(myModel: item, viewModel: viewModel,navPath: navPath)
   
        } else { EmptyView()}

     }
}


struct DataModelCategoryView_Previews: PreviewProvider {
    
    @State static var menuItem:MenuModel = MenuModel()
    
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            Group {
                
                MenuModel_RowView(menuItem:menuItem )
                
            }
        }
    }
}



