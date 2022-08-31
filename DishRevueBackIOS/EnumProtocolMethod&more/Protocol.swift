//
//  Protocolli.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import SwiftUI

protocol MyEnumProtocol: /*CaseIterable,*/ Identifiable, Equatable { // Protocollo utile per un Generic di modo da passare differenti oggetti(ENUM) alla stessa View
    
    func simpleDescription() -> String
    func createId() -> String
    func extendedDescription() -> String
    func imageAssociated() -> String

    static var defaultValue: Self { get }
}

protocol MyEnumProtocolMapConform : Hashable { // deve essere conforme ad HAshable per lavorare con i Set
    
    func simpleDescription() -> String
    func imageAssociated() -> String
    func returnTypeCase() -> Self
    // 21.07 In Sintesi: Deve ritornare il case, ovvero self. Nel caso il case abbiamo valori associati, deve ritornare il case con dei valori associati standard. Questo permetterà il confronto altrimenti non possibile perchè identici case avranno valori associati che li renderanno diversi
    // In data 23.03.2022 // Ha permesso la risoluzione di un problema nel map dei Model. Il nostro obiettivo era quello di raggruppare i Model per categoria (ENUM). Il problema è sorto lavorando sui Menu, tentando di raggrupparli per Tipologia ci aspettavamo due sole tipologie, fisso e alla carta. Questo non avveniva, in quanto il case fisso ha dei valori associati, il variare di questi valori determinava una nuova tipologia di raggruppamento. Per cui dopo aver provato a risolvere il problema con l'id, infruttuosamente, siamo pervenuti a questa soluzione, che forse ci può tornare utile in chiave Filtri Raggruppamento Custom per l'utente.
    func orderValue() -> Int  // usiamo lo zero per i casi che eventualmente vogliamo escludere. In data 07.04 predisposto come possibilità.
}

protocol MyModelProtocol: Identifiable, Equatable {
    
    associatedtype RowView: View
    associatedtype InteractiveMenuContent: View
    
    var intestazione: String {get set}
    var descrizione: String {get set}

    var id: String { get set }
    
    /// Stessa funzione di viewModelContainer() Solo che abbiamo l'accesso dal type
    static func viewModelContainerStatic() -> ReferenceWritableKeyPath<AccounterVM,[Self]>
    
    func viewModelContainerInstance() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM,[Self]>, nomeContainer: String, nomeOggetto:String)
    
    func returnModelRowView() -> RowView
    func returnNewModel() -> (tipo:Self,nometipo:String) // deprecata in futuro il ritorno del Self. al 22.07 usato soltanto il nomeTipo
    
    /// Bottoni per il menu Interattivo specifici del modello
    func customInteractiveMenu(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> InteractiveMenuContent
}

protocol MyModelStatusConformity: MyModelProtocol, Hashable {

    var id: String { get set }
    var status: StatusModel {get set}
    
    func pathDestination() -> DestinationPathView
    func modelStatusDescription() -> String
    
    /// Ideata per avere un accesso dall'esterno su un un possibile ID da verificare ancora prima di creare un Modello
    func creaID(fromValue:String) -> String
    
    /// StringResearch per le liste
    func modelStringResearch(string: String) -> Bool
    
   
}
