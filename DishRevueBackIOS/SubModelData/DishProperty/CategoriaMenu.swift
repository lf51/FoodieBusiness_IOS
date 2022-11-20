//
//  CategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/06/22.
//

import Foundation
import Firebase

struct CategoriaMenu:MyProStarterPack_L1,MyProEnumPack_L2,MyProDescriptionPack_L0,MyProCloudPack_L1/*,MyEnumProtocol,MyEnumProtocolMapConform */{
   
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]> {
        \.allMyCategories
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
    var id: String
    
    var intestazione: String
    var image: String
    var descrizione: String
  //  var listPositionOrder: Int
    
   /* func returnModelTypeName() -> String {
        "Categoria Menu"
    } */ // deprecata
    
    init(id: String, intestazione: String, image: String, descrizione: String) {
        // Probabilmente Inutile - Verificate
        self.id = id
        self.intestazione = intestazione
        self.image = image
        self.descrizione = descrizione
    }
    
    init() {
        
        self.id = UUID().uuidString
        self.intestazione = ""
        self.image = "🍽"
        self.descrizione = ""
    }
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        self.id = frDoc.documentID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.image = frDoc[DataBaseField.image] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
    }
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.image : self.image
        
        ]
        
        return documentData
    }
    
    struct DataBaseField {
        
        static let intestazione = "intestazione"
        static let descrizione = "descrizione"
        static let image = "image"
        
    }
    
    //
    
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]>, nomeContainer: String, nomeOggetto: String,imageAssociated:String) {
        return (\.allMyCategories,"Elenco Categorie Menu", "Categoria Menu","list.bullet.clipboard")
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
