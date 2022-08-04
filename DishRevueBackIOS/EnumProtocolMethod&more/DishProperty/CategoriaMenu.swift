//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation

struct CategoriaMenu:MyEnumProtocol,MyEnumProtocolMapConform {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } // forse inutile
    
    static func == (lhs:CategoriaMenu, rhs:CategoriaMenu) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.nome == rhs.nome &&
        lhs.image == rhs.image
    } // forse inutile
     
    static var allCases: [CategoriaMenu] = [
        CategoriaMenu(
            nome: "Antipasti",
            image: "🫒"),
        CategoriaMenu(
            nome: "Primi",
            image: "🍝"),
        CategoriaMenu(
            nome: "Secondi",
            image: "🍴"),
        CategoriaMenu(
            nome: "Contorni",
            image: "🥗"),
        CategoriaMenu(
            nome: "Frutta",
            image: "🍉"),
        CategoriaMenu(
            nome: "Dessert",
            image: "🍰"),
        CategoriaMenu(
            nome: "Bevande",
            image: "🍷")] // Deprecata 02.06 -> Passa i dati ad una published nel viewModel
    
    static var defaultValue: CategoriaMenu = CategoriaMenu(nome: "", image: "🍽")
    
    var id: String { self.createId() }
    
    let nome: String
    var image: String = "🍰"
  //  var listPositionOrder: Int
    
    func createId() -> String { // Deprecata
        self.nome.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func simpleDescription() -> String { // Deprecata
        self.nome
      //  "Dessert"
    }
    
    func extendedDescription() -> String { // Deprecata
        print("Dentro ExtendedDescription in CategoriaMenu")
        return ""
    }
    
    func imageAssociated() -> String { // Deprecata
        self.image
     //   "🍰"
        
    }
    
    func returnTypeCase() -> CategoriaMenu { // Deprecata
        return CategoriaMenu(nome: "", image: "")
    }
    
    func orderValue() -> Int { // Deprecata
       // self.listPositionOrder
        return 0
    }
    
   /* func addNew() {
        
        CategoriaMenu.allCases.insert(self, at: self.listPositionOrder)
       
    
    } */
    
    
    
    
    
}
