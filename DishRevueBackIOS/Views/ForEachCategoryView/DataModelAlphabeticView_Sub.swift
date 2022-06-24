//
//  DataModelAlphabeticView_Sub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/04/22.
//

import SwiftUI




struct DataModelAlphabeticView_Sub<T:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var stringSearch: String = ""

    let filterCategory: MapCategoryContainer
    let dataPath:ReferenceWritableKeyPath<AccounterVM,[T]>
    
    init(filterCategory:MapCategoryContainer, dataPath:ReferenceWritableKeyPath<AccounterVM,[T]>) {

        self.filterCategory = filterCategory
        self.dataPath = dataPath
    }

    
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                    
                 //   csVbSwitchModelRowViewTEST(item: &dataFiltering)
                   // ForEach(dataFiltering().sorted{$0.intestazione < $1.intestazione})
                    //ForEach($dataFiltering.sorted{$0.wrappedValue.intestazione < $1.wrappedValue.intestazione })
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
    
    @ViewBuilder private func csVbSwitchModelRowView<T:MyModelProtocol>(item:Binding<T>) -> some View {
  
        let localItem: T = item.wrappedValue
        
        let isIn: Bool = {
            
            let firstBool = viewModel.deepFiltering(model: localItem, filterCategory: self.filterCategory)
            let secondBool = viewModel.stringResearch(item: localItem, stringaRicerca: self.stringSearch)
            
            return firstBool && secondBool
        
        }()
        
        if isIn {
            
            
            GenericItemModel_RowViewMask(
                model: item,
                backgroundColorView: Color("SeaTurtlePalette_1")) {
                    Text("New Modifica Piano -> \(localItem.intestazione)")
                }
            
         /*   switch item.self {
                 
             case is Binding<MenuModel>:
             
                    MenuModel_RowLabelMenu(menuItem: item as! Binding<MenuModel>, backgroundColorView: Color("SeaTurtlePalette_1")) {
                        
                        Text("Modifica Piano")
                 
                    }
                           
             case is Binding<DishModel>:
                
                DishModel_RowView(item: item as! Binding<DishModel>)
                
              //  Text("Da Settare - Dish: \(localItem.intestazione)")
             //   DishModel_RowView(item: item as! Binding<DishModel>)
         
             case is Binding<IngredientModel>:
              //  Text("Da Setttare - Ingrediente: \(localItem.intestazione)")
                 IngredientModel_RowView(item: item as! Binding<IngredientModel>)
                 
             default:  Text("item is a notListed Type")
                 
             } */
            
            
            
            
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
