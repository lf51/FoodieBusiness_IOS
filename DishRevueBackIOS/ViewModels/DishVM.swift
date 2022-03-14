//
//  DishVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/02/22.
//

import Foundation

class DishVM: ObservableObject {
    
    @Published var dishList: [DishModel] = [] // trasversale a tutte le proprietà dello stesso accounter. Contiene tutti i piatti creati, bozze e pubblici
    
    
    init() {
        
        // Test Area
      //  dishList.append(contentsOf: [dish1,dish2,dish3])
        //
    }
    
    func mappedDishList() -> [DishCategoria] {
        
        let firstStepArray = dishList.map({$0.categoria})
        let secondStepSet = Set(firstStepArray)
        let lastStepArray = Array(secondStepSet)
        // trasformiamo il prima array, frutto di un Map, in un Set per eliminare i duplicati, poichè ogni piatto della stessa tipologia ha una tipologia con sempre il medesiomo id che nella mappatura risulta duplicarsi per ogni piatto di quella tipologia EHM???? -> RIPORTIAMO IL set in array di modo da farlo scorrere sineProblema in un foreach loop
        return lastStepArray
        
    }
    
    func filteredDishList(filtro:DishCategoria) -> [DishModel] {
        
        // Utile per mostrare nella DishListView solo i piatti per le tipologie usate // Antipasto, Primo blabla
        
       dishList.filter({$0.categoria == filtro})
        
    }
    
    
    func createNewOrEditOldDish(dish:DishModel) {
        
        guard let oldDishIndex = self.dishList.firstIndex(where: {$0.id == dish.id}) else {
            
            print("Piatto mai Esistito Prima, creato con id: \(dish.id)")
            self.dishList.append(dish)
            return
        }

        self.dishList.remove(at: oldDishIndex)
        self.dishList.insert(dish, at: oldDishIndex)
        
        print("Piatto con id: \(dish.id) modificato con Successo")
        // crea e salva il piatto su firebase
        
    // Matriciana 5CE7F174-1E10-45F4-8387-4139C59E42ED
    // Carbonara 6389FF91-89A4-4458-B336-E00BD96571BF
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


