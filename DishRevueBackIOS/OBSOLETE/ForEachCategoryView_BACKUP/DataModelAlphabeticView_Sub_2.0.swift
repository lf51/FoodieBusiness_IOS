//
//  DataModelAlphabeticView_Sub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/04/22.
//

/* // INIZIO BACKUP 18.06


import SwiftUI

@ViewBuilder func csVbSwitchModelRowViewTEST<T:MyModelProtocol>(item:T) -> some View {
     
    switch item.self {
         
     case is MenuModel:
     
            Text("MenuModel")
            
        // MenuModel_RowView(menuItem: $item as! Binding<MenuModel>)
     case is DishModel:
        
        Text("Ciao")
      //   DishModel_RowView(item: item as! DishModel)
 
     case is IngredientModel:
        Text("Ciao")
       //  IngredientModel_RowView(item: item as! IngredientModel)
         
     default:  Text("item is a notListed Type")
         
     }
 }


struct DataModelAlphabeticViewTEST_Sub<T:MyModelProtocol>: View {
    
  //  let dataContainer: [T] // Non Serve a nulla ?
  //  @Binding var dataContainer: [T]
    @Binding var stringSearch: String
   // let dataFiltering: () -> [T]
    @Binding var dataFiltering: [T]
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                    
                 //   csVbSwitchModelRowViewTEST(item: &dataFiltering)
                   // ForEach(dataFiltering().sorted{$0.intestazione < $1.intestazione})
                    ForEach($dataFiltering){ $item in
                        
                        HStack {
                            MenuModel_RowLabelMenu(menuItem: $item as! Binding<MenuModel>, backgroundColorView: Color.seaTurtle_1) {
                                
                                Text("Modifica Piano")
                                Button("Rimuovi") {
                                    let index = dataFiltering.firstIndex(of: item)
                                    dataFiltering.remove(at: index!)
                                }
                            }
                          // MenuModel_RowView(menuItem: $item as! Binding<MenuModel>)
                          //  csVbSwitchModelRowViewTEST(item: item)
                            Spacer() // Possiamo mettere una view di fianco ogni schedina
    
                        }
                    }
                    .id(1)
                    .onAppear {proxy.scrollTo(1, anchor: .top)}
                    
                }
            }
    }
    
    // Method
    
   

    
    
    
}




struct DataModelAlphabeticView_Sub<T:MyModelProtocol>: View {
    
    let dataContainer: [T] // Non Serve a nulla ?
  //  @Binding var dataContainer: [T]
    @Binding var stringSearch: String
   // let dataFiltering: () -> [T]
    var dataFiltering: () -> [T]
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    
                    CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
              
                    ForEach(dataFiltering().sorted{$0.intestazione < $1.intestazione}) { item in
                        
                        HStack {
                           
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



 */ // FINE BACKUP 18.06
