//
//  CategoriaMenuExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation
import MyFoodiePackage

extension CategoriaMenu:
    MyProStarterPack_L1,
    MyProEnumPack_L2,
    MyProDescriptionPack_L0,
    MyProCloudUploadPack_L1 {
    
    public typealias VM = AccounterVM
    
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]> {
        \.allMyCategories
    }
    
    public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.image : self.image,
            /// nel caso di errore, se il valore passato non è valido, salviamo una stringa vuota, di modo che al ritorno non trovando un Int imposti l'index su Nil.
            DataBaseField.listIndex: positionIndex ?? ""
        
        ]
        
        return documentData
    }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [CategoriaMenu]>, nomeContainer: String, nomeOggetto: String,imageAssociated:String) {
        return (\.allMyCategories,"Elenco Categorie Menu", "Categoria Menu","list.bullet.clipboard")
    }
    
    public func dishPerCategory(viewModel:AccounterVM) -> (count:Int,array:[DishModel]) {
        
        let dish = viewModel.allMyDish.filter {$0.categoriaMenu == self.id}
        return (dish.count,dish)
    }
    
} // end struct
