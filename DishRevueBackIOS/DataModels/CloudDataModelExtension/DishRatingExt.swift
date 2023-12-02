//
//  DishRatingExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/10/23.
//

import Foundation
import MyFoodiePackage

extension DishRatingModel:MyProStarterPack_L1 {
    
    public var intestazione: String { // va uniformata. Nel modello l'intestazione è messa optional
        get {
            return ""
        }
        set(newValue) {
            //
        }
    }
    
    
    public typealias VM = AccounterVM
   
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [MyFoodiePackage.DishRatingModel]>, nomeContainer: String, nomeOggetto: String, imageAssociated: String) {
        
        return (\.db.allMyReviews,"Recensioni Clienti","Recensione","")
        
    }
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [MyFoodiePackage.DishRatingModel]> {
        return \.db.allMyReviews
    }
    
   
    

    public func isEqual(to rhs: MyFoodiePackage.DishRatingModel) -> Bool {
        self.id == rhs.id
    }

}

extension DishRatingModel:MyProSubCollectionPack {
    
    public typealias Sub = CloudDataStore.SubCollectionKey
    
    public func subCollection() -> MyFoodiePackage.CloudDataStore.SubCollectionKey {
        .allMyReviews
    }
    public func sortCondition(compare rhs: DishRatingModel) -> Bool {
        self.voto.generale > rhs.voto.generale
    }
}
