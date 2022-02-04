//
//  DishVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/02/22.
//

import Foundation

class DishVM: ObservableObject {
    
    @Published var dishList: [DishModel] = []
    
    init() {
        
        // Test Area
      //  dishList.append(contentsOf: [dish1,dish2,dish3])
        //
    }
    
    func createDish() {
        
        // crea un nuovo piatto
    }
    
    func saveDish(dish:DishModel) {
        
        // crea e salva il piatto su firebase
        
        dishList.append(dish)
    }

    func loadDishes() {
        // carichiamo i piatti da firebase e riempiamo la dishlist
    }
    
    func deleteDish() {
        
        // cancelliamo il piatto da firebase
    }
    
    
    
    
    // TEST AREA
    
 /*   var dish1 = DishModel(name: "Pasta Carbonara", ingredientiPrincipali: ["Spaghetti, Uova, Guangiale, Pecorino, Pepe Nero"], ingredientiSecondari: ["Grasso del Guanciale", "Olio EVO", "prezzemolo"], quantità: 120, type: [.carne], category: .primo, allergeni: [.uova_e_derivati,.latte_e_derivati])
    
    var dish2 = DishModel(name: "Pasta Aglio e Oglio", ingredientiPrincipali: ["Linguine","Olio EVO","aglio","Peperoncino","Parmigiano"], ingredientiSecondari: ["Semi di Chia","Prezzemolo"], quantità: 80, type: [.vegetariano], category: .primo, allergeni: [.latte_e_derivati])
    
    var dish3 = DishModel(name: "Filetto Alla Wellington", ingredientiPrincipali: ["Filetto di Manzo", "Pepe Verde"], ingredientiSecondari: ["Olio EVO"], quantità: 180, type: [.carne,.milkFree], category: .secondo, allergeni: []) */
    
    //
    
}


