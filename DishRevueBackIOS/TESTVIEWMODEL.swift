//
//  Conferma.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import SwiftUI
import MapKit // per creare una proprietà di esempio

struct TESTVIEWMODEL: View {
    
    @StateObject var viewModel: AccounterVM = AccounterVM()
    
    let dish: DishModel = {
        
        var dishOne = DishModel()
        dishOne.categoria = .dessert
        dishOne.tipologia = .vegano
        dishOne.intestazione = "Spaghetti alla Carbonara"
        return dishOne
    }()
    
    let ingrediente: IngredientModel = {
        
        var dish = IngredientModel()
        dish.intestazione = "Guanciale"
        return dish
    }()
    
    let menu: MenuModel = {
        
        var dish = MenuModel()
        dish.intestazione = "Pranzo"
        return dish
    }()
    
    let propertyExampleBis: PropertyModel = PropertyModel(nome: "Osteria Favelas")
    
    var body: some View {
    
        VStack {
            
            Button("Lista Piatti") {viewModel.createOrEditItemModel(itemModel: self.dish) }
                
            ForEach(viewModel.mappingModelList(modelType: DishModel.self)) { category in
                
                Text(category.simpleDescription())
                
                HStack {
                    
                    ForEach(viewModel.filteredModelList(modelType: DishModel.self, filtro: category)) { item in
                        
                        Text(item.intestazione)
                        
            
                        
                    }
                    
                    
                }
                
            }
            
            
            /*  ForEach(viewModel.allMyDish) { dish in

                    Text(dish.intestazione)
             
                } */
            
            Divider()
            
            Button("Lista Menu"){viewModel.createOrEditItemModel(itemModel: self.menu) }
            
            ForEach(viewModel.allMyMenu) { dish in
                
                Text(dish.intestazione)
         
            }
            Divider()
            
            Group {
                
                Button("Lista Ingredienti"){viewModel.createOrEditItemModel(itemModel: self.ingrediente) }
                
                ForEach(viewModel.allMyIngredients) { dish in
                    
                    Text(dish.intestazione)
             
                }
                Divider()

                Button("Lista Properties"){viewModel.createOrEditItemModel(itemModel: self.propertyExampleBis) }
                
                ForEach(viewModel.allMyProperties) { dish in
                    
                    Text(dish.intestazione)
             
                }
                
            }

            
            
            
            
            
        }
      

        
    }
    

}

/*struct Conferma_Previews: PreviewProvider {
    static var previews: some View {
        Conferma()
    }
} */
