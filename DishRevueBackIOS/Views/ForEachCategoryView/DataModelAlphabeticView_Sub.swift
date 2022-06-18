//
//  DataModelAlphabeticView_Sub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/04/22.
//

import SwiftUI




struct DataModelAlphabeticViewTEST_Sub<T:MyModelProtocol>: View {
    
  //  let dataContainer: [T] // Non Serve a nulla ?
  //  @Binding var dataContainer: [T]
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var stringSearch: String
   // let dataFiltering: () -> [T]
    @Binding var dataFiltering: [T]
    let filterCategory: MapCategoryContainer
    
    init(stringSearch: Binding<String>,filterCategory:MapCategoryContainer, dataFiltering: Binding<[T]>) {
        _stringSearch = stringSearch  
        _dataFiltering = dataFiltering
        self.filterCategory = filterCategory
    }

    
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                    
                 //   csVbSwitchModelRowViewTEST(item: &dataFiltering)
                   // ForEach(dataFiltering().sorted{$0.intestazione < $1.intestazione})
                    ForEach($dataFiltering.sorted{$0.wrappedValue.intestazione < $1.wrappedValue.intestazione }){ $item in
                        
                       
                        
                       HStack {
                           csVbSwitchModelRowViewTEST(item: $item)
                       
                            Spacer() // Possiamo mettere una view di fianco ogni schedina
    
                        }
                    }
                    .id(1)
                    .onAppear {proxy.scrollTo(1, anchor: .top)}
                    
                }
            }
    }
    
    // Method
    
    @ViewBuilder private func csVbSwitchModelRowViewTEST<T:MyModelProtocol>(item:Binding<T>) -> some View {
  
        let localItem: T = item.wrappedValue
        
        let isIn: Bool = {
            
            let firstBool = viewModel.deepFiltering(model: localItem, filterCategory: self.filterCategory)
            let secondBool = viewModel.stringResearch(item: localItem, stringaRicerca: self.stringSearch)
            
            return firstBool && secondBool
        
        }()
        
        if isIn {
            
            switch item.self {
                 
             case is Binding<MenuModel>:
             
                    MenuModel_RowLabelMenu(menuItem: item as! Binding<MenuModel>, backgroundColorView: Color("SeaTurtlePalette_1")) {
                        
                        Text("Modifica Piano")
                 
                    }
                           
             case is Binding<DishModel>:
                
                Text("Da Settare - Dish: \(localItem.intestazione)")
             //   DishModel_RowView(item: item as! Binding<DishModel>)
         
             case is Binding<IngredientModel>:
                Text("Da Setttare - Ingrediente: \(localItem.intestazione)")
               //  IngredientModel_RowView(item: item as! Binding<IngredientModel>)
                 
             default:  Text("item is a notListed Type")
                 
             }
            
            
            
            
        } else { EmptyView()}
        
        
        
        
        
     }
 
}




struct DataModelAlphabeticView_Sub<T:MyModelProtocol>: View {
    
    let dataContainer: [T] // Non Serve a nulla ?
  //  @Binding var dataContainer: [T]
    @Binding var stringSearch: String
    let dataFiltering: () -> [T]
  //  @Binding var dataFiltering: [T]
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                   ForEach(dataFiltering().sorted{$0.intestazione < $1.intestazione}) { item in
                        
                        HStack {
                         //  csVbSwitchModelRowViewTEST(item: $item)
                            csVbSwitchModelRowView(item: item)
                            Spacer() // Possiamo mettere una view di fianco ogni schedina
    
                        }
                    }
                    .id(1)
                    .onAppear {proxy.scrollTo(1, anchor: .top)}
                    
                }
            }
    }
}  // BACKUP 17.06 -> Trasformazione da let a Binding

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
