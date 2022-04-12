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

/*protocol MyModelProtocolMapConform {
    
    associatedtype MapProperty:MyEnumProtocol,MyEnumProtocolMapConform
 
    var staticMapCategory: MapProperty { get }
  
} */


