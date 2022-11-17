//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation

struct CategoriaMenu:MyProStarterPack_L1,MyProEnumPack_L2,MyProDescriptionPack_L0,MyProCloudPack_L1/*,MyEnumProtocol,MyEnumProtocolMapConform */{
   
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]> {
        \.categoriaMenuAllCases
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } // forse inutile
    
    static func == (lhs:CategoriaMenu, rhs:CategoriaMenu) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.image == rhs.image &&
        lhs.descrizione == rhs.descrizione
    } // forse inutile
     
    static var allCases: [CategoriaMenu] = [] // Deprecata 02.06 -> Passa i dati ad una published nel viewModel // deprecata definitivamente 13.09
    
    static var defaultValue: CategoriaMenu = CategoriaMenu()
    
  //  var id: String { self.createId() }
    var id: String = UUID().uuidString
    
    var intestazione: String = ""
    var image: String = "🍽"
    var descrizione: String = ""
  //  var listPositionOrder: Int
    
   /* func returnModelTypeName() -> String {
        "Categoria Menu"
    } */ // deprecata
    
    func creaDocumentDataForFirebase() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            "intestazione":self.intestazione,
            "descrizione":self.descrizione,
            "image":self.image
        
        ]
        
        return documentData
    }
    
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]>, nomeContainer: String, nomeOggetto: String,imageAssociated:String) {
        return (\.categoriaMenuAllCases,"Elenco Categorie Menu", "Categoria Menu","list.bullet.clipboard")
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
    
    func returnTypeCase() -> CategoriaMenu {
        return self
    }
    
    func orderAndStorageValue() -> Int { // Deprecata
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
