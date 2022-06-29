//
//  DataModelAlphabeticView_Sub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/04/22.
//

import SwiftUI

struct DataModelAlphabeticView_Sub<T:MyModelStatusConformity>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var stringSearch: String = ""

    let filterCategory: MapCategoryContainer
    let dataPath:ReferenceWritableKeyPath<AccounterVM,[T]>
    let navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    
    init(filterCategory:MapCategoryContainer, dataPath:ReferenceWritableKeyPath<AccounterVM,[T]>,navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) {

        self.filterCategory = filterCategory
        self.dataPath = dataPath
        self.navPath = navPath
    }

    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                    ForEach($viewModel[dynamicMember:dataPath].sorted{$0.wrappedValue.intestazione < $1.wrappedValue.intestazione }){ $item in
                       
                       HStack {
                           csVbSwitchModelRowView(item: $item)
                       
                            Spacer() // Possiamo mettere una view di fianco ogni schedina
    
                        }
                    }
                    .id(1)
                    .onAppear {proxy.scrollTo(1, anchor: .top)}
                    
                }
            }
    }
    
    // Method
    
    @ViewBuilder private func csVbSwitchModelRowView<T:MyModelStatusConformity>(item:Binding<T>) -> some View {
  
        let localItem: T = item.wrappedValue
       
        let isIn: Bool = {
            
            let firstBool = viewModel.deepFiltering(model: localItem, filterCategory: self.filterCategory)
            let secondBool = viewModel.stringResearch(item: localItem, stringaRicerca: self.stringSearch)
            
            return firstBool && secondBool
        
        }()
        
        if isIn {
            
            vbCambioStatusModelList(myModel: item,viewModel: viewModel,navPath: navPath)
     
        } else { EmptyView()}
    
        
     }
 
}


/*
struct DataModelAlphabeticView_Sub_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            DataModelAlphabeticView_Sub(dataContainer: [MenuModel()])
        }
    }
}
*/
