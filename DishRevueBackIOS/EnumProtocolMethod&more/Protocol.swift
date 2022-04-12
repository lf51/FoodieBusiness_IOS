//
//  Protocolli.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

protocol MyEnumProtocol: /*CaseIterable,*/ Identifiable, Equatable { // Protocollo utile per un Generic di modo da passare differenti oggetti(ENUM) alla stessa View
    
    func simpleDescription() -> String
    func createId() -> String
    func extendedDescription() -> String?

    static var defaultValue: Self { get }
}

protocol MyEnumProtocolMapConform : Hashable { // deve essere conforme ad HAshable per lavorare con i Set
    
   // static var defaultValue: Self { get }
   // static var allCases: [Self] { get set}
    //var id: String { get } // è stata duplicata per averla fra le proprietà del protocollo, utilizzata per mettere in ordine.
    func simpleDescription() -> String
    func imageAssociated() -> String?
    func returnTypeCase() -> Self // In data 23.03.2022 // Ha permesso la risoluzione di un problema nel map dei Model. Il nostro obiettivo era quello di raggruppare i Model per categoria (ENUM). Il problema è sorto lavorando sui Menu, tentando di raggrupparli per Tipologia ci aspettavamo due sole tipologie, fisso e alla carta. Questo non avveniva, in quanto il case fisso ha dei valori associati, il variare di questi valori determinava una nuova tipologia di raggruppamento. Per cui dopo aver provato a risolvere il problema con l'id, infruttuosamente, siamo pervenuti a questa soluzione, che forse ci può tornare utile in chiave Filtri Raggruppamento Custom per l'utente.
    func orderValue() -> Int  // usiamo lo zero per i casi che eventualmente vogliamo escludere. In data 07.04 predisposto come possibilità.
}

protocol MyModelProtocol: Identifiable, Equatable {
    
    var intestazione: String {get set}
    var alertItem: AlertModel? {get set}
    
}

protocol MyModelProtocolMapConform {
    
 //   associatedtype MapProperty:MyEnumProtocol,MyEnumProtocolMapConform
 
  //  var mapCategoryAvaible: MapProperty { get }
  // func filter(mapElement: MapCategoryContainer) -> MyEnumProtocolMapConform
  //  var kp:KeyPath<Self, MapProperty> { get }
    
    var kpFilter: PartialKeyPath<Self> { get } // Il Valore deve essere conforme al MyEnumMapProtocol, anche se non è esplicitato
  //  var kp2: KeyPath<Self,MapProperty> { get }
    
   // func testKP (_ : MapCategoryContainer) -> KeyPath<Self,Any>
   // var allModelFilter: [KpModel] { get }
}



/* protocol MyModelProtocolMapConform {
    
    
    
    
    associatedtype MapProperty1: MyEnumProtocol,MyEnumProtocolMapConform
    associatedtype MapProperty2: MyEnumProtocol,MyEnumProtocolMapConform
    associatedtype MapProperty3: MyEnumProtocol,MyEnumProtocolMapConform
    associatedtype MapProperty4: MyEnumProtocol,MyEnumProtocolMapConform
    associatedtype MapProperty5: MyEnumProtocol,MyEnumProtocolMapConform
    
    var mapProperty_1: MapProperty1 {get}
    var mapProperty_2: MapProperty2 {get}
    var mapProperty_3: MapProperty3 {get}
    var mapProperty_4: MapProperty4 {get}
    var mapProperty_5: MapProperty5 {get}

} */


/*protocol MyEnumProtocolAdvanced: MyEnumProtocol { // in disuso dopo Test generic della DishSpecifiView in data 17.03.2022

    associatedtype ItemModel: MyModelProtocol
    
    static func custom(_ nome: String,_ grammi: String?,_ pax: String,_ prezzo: String) -> Self // può diventare un case
    
    func showAssociatedValue() -> (nome:String,peso:String?,porzioni:String,prezzo:String)
    func isTagliaAlreadyIn(modello: ItemModel) -> Bool
    func isSceltaBloccata(modello: ItemModel) -> Bool
    func qualeComboIsAvaible() -> String
    
    static func isCustomCaseNameOriginal(customName: String) -> Bool
    static func addNewValueToAllCases(customName: String) -> Void
    
} */

