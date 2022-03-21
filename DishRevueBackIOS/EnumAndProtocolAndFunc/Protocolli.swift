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

protocol MyEnumProtocolMapConform:Hashable { }

protocol MyModelProtocol: Identifiable, Equatable {
    
    var intestazione: String {get set}
    var alertItem: AlertModel? {get set}
    
}

protocol MyModelProtocolMapConform {
    
    associatedtype MapCategory: MyEnumProtocolMapConform
    
    var mapCategoryAvaible: MapCategory {get}
    
}





protocol MyEnumProtocolAdvanced: MyEnumProtocol { // in disuso dopo Test generic della DishSpecifiView in data 17.03.2022

    associatedtype ItemModel: MyModelProtocol
    
    static func custom(_ nome: String,_ grammi: String?,_ pax: String,_ prezzo: String) -> Self // può diventare un case
    
    func showAssociatedValue() -> (nome:String,peso:String?,porzioni:String,prezzo:String)
    func isTagliaAlreadyIn(modello: ItemModel) -> Bool
    func isSceltaBloccata(modello: ItemModel) -> Bool
    func qualeComboIsAvaible() -> String
    
    static func isCustomCaseNameOriginal(customName: String) -> Bool
    static func addNewValueToAllCases(customName: String) -> Void
    
}

