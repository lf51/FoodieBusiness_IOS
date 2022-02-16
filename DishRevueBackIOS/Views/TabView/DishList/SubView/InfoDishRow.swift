//
//  InfoDishRaw.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/02/22.
//

import SwiftUI

struct InfoDishRow: View {
    
    @ObservedObject var dishVM: DishVM
    let currentDishIndexPosition: Int
    
    var body: some View {
        Text(dishVM.dishList[currentDishIndexPosition].name)
    }
}

struct InfoDishRow_Previews: PreviewProvider {
    
    static var dishVM:DishVM = {
        
        var dishViewModel = DishVM()
        dishViewModel.dishList.append(InfoDishRow_Previews.testDish)
        return dishViewModel
    }()
    
    static var previews: some View {
        InfoDishRow(dishVM: dishVM, currentDishIndexPosition: 0)
    }
    
   static var testDish:DishModel = {
        
        var dish = DishModel()
        dish.name = "Spaghetti alla Carbonara"
        dish.ingredientiPrincipali = ["Pasta di grano Duro","Guanciale","Pecorino Romano DOP", "Tuorlo d'Uovo BIO",]
        dish.ingredientiSecondari = ["Pepe Nero", "Prezzemolo"]
        dish.type = .primo
        dish.aBaseDi = .carne
        dish.metodoCottura = .padella
        dish.allergeni = [.latte_e_derivati,.uova_e_derivati]
        dish.category = [.milkFree,.glutenFree]
        dish.tagliaPiatto = [.unico(80, 1, 12.5)]
        
        return dish
    }()
    
    
}
