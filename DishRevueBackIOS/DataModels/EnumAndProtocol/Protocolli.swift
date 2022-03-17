//
//  Protocolli.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

protocol MyEnumProtocol: CaseIterable, Identifiable, Equatable { // Protocollo utile per un Generic di modo da passare differenti oggetti(ENUM) alla stessa View
      
    func simpleDescription() -> String
    func createId() -> String
    
    static var defaultValue: Self { get }
}

/*protocol IngredientConformation: Identifiable, Equatable { // Protocollo creato per uniformare BaseMOdelloIngrediente con ModelloIngrediente. Caduto in disuso in data 09.03.2022
    
    var nome:String {get}
} */

protocol CustomGridAvaible: Identifiable, Equatable {
    
    var intestazione: String {get set}
    
}
