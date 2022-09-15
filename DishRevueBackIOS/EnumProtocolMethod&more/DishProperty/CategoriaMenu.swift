//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation

struct CategoriaMenu:MyProStarterPack_L1,MyEnumProtocol,MyEnumProtocolMapConform {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } // forse inutile
    
    static func == (lhs:CategoriaMenu, rhs:CategoriaMenu) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.image == rhs.image
    } // forse inutile
     
    static var allCases: [CategoriaMenu] = [] // Deprecata 02.06 -> Passa i dati ad una published nel viewModel // deprecata definitivamente 13.09
    
    static var defaultValue: CategoriaMenu = CategoriaMenu(intestazione: "", image: "🍽")
    
  //  var id: String { self.createId() }
    var id: String = UUID().uuidString
    
    var intestazione: String = ""
    var image: String = "🍽"
  //  var listPositionOrder: Int
    
    func returnModelTypeName() -> String {
        "Categoria Menu"
    }
    
    func viewModelContainerInstance() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]>, nomeContainer: String, nomeOggetto: String) {
        return (\.categoriaMenuAllCases,"Elenco Categorie Menu", "Categoria Menu")
    }
    
    func createId() -> String { // Deprecata
        self.intestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func simpleDescription() -> String { // Deprecata
        self.intestazione
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
        return CategoriaMenu(intestazione: "", image: "")
    }
    
    func orderValue() -> Int { // Deprecata
       // self.listPositionOrder
        return 0
    }
    
    // method added 13.09
    
    func dishPerCategory(viewModel:AccounterVM) -> (count:Int,array:[DishModel]) {
        
        let dish = viewModel.allMyDish.filter {$0.categoriaMenu == self.id}
        return (dish.count,dish)
    }
    
    
    
    
    // end
    
    
   /* func addNew() {
        
        CategoriaMenu.allCases.insert(self, at: self.listPositionOrder)
       
    
    } */
    
    
    
    
    
}
