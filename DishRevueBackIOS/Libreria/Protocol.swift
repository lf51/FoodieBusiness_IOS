//
//  Protocolli.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation
import SwiftUI
//import Firebase

// 14.09 Spazio protocolli MyPro - Nuova generazione
public protocol MyProStarterPack_L0:Identifiable,Equatable,Hashable { // Primo passo per la riorganizzazione dei protocolli. Step by step e per funzioni. L'incipit sarà MyPro seguito dal Pack. ModelPack EnumPack StatusPack per raggruppare le varie funzioni e utilizzi
    
    var id: String { get }
   
}

public protocol MyProStarterPack_L1:MyProStarterPack_L0 {
    
    var id: String { get set } // sovrascrive il livello zero per non crearci problemi con le enum. Dobbiamo chiarire se quei pochi casi in cui sovrasciviamo gli id possono essere risolti diversamente, o altrimenti facciamo un po' di ordine. Proprietà da considerarsi QUI TEMPORANEA
    
    var intestazione: String { get set } // esistono view che richiedono solo questo valore
    
  //  func returnModelTypeName() -> String // deprecata in futuro. inglobata nella viewModelContainerInstance // deprecata 15.09
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM,[Self]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String)
   
    
    /// Stessa funzione di viewModelContainer() Solo che abbiamo l'accesso dal type
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM,[Self]>
}

public protocol MyProDescriptionPack_L0 {

    var descrizione: String { get set }
}

public protocol MyProSearchPack_L0 {
    
    /// StringResearch per le liste
    func modelStringResearch(string: String,readOnlyVM:AccounterVM?) -> Bool
    func modelPropertyCompare(filterProperty:FilterPropertyModel,readOnlyVM:AccounterVM) -> Bool
    
    static func sortModelInstance(lhs:Self,rhs:Self,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool 
}

public protocol MyProStatusPack_L0 {
    
    var status: StatusModel { get set }
    func modelStatusDescription() -> String
}

public protocol MyProStatusPack_L1: MyProStatusPack_L0,MyProStarterPack_L1 {
    
    func pathDestination() -> DestinationPathView
    func manageCambioStatus(nuovoStatus:StatusTransition,viewModel:AccounterVM)
    func conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel:AccounterVM) -> Bool
   
    func conditionToManageMenuInterattivo() -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)
}

/*protocol MyProDestinationPack_L0 {
    func pathDestination() -> DestinationPathView
} */ // Nota 27.09

public protocol MyProVisualPack_L0 {
    
    associatedtype RowView: View
    associatedtype InteractiveMenuContent: View
    
    var id:String { get }
    
    func returnModelRowView(rowSize:RowSize) -> RowView
    /// Bottoni per il menu Interattivo specifici del modello
    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> InteractiveMenuContent
    
    func conditionToManageMenuInterattivo() -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)
}

public protocol MyProVisualPack_L1: MyProVisualPack_L0,MyProStarterPack_L1 {
    
  
}
// NUOVA FASE DI RIORDINO - 15.09

public protocol MyProEnumPack_L0: MyProOrganizerPack_L0 {
    
    func simpleDescription() -> String
    
}

public protocol MyProEnumPack_L1:MyProEnumPack_L0 {
    
    static var defaultValue: Self { get }
}

public protocol MyProEnumPack_L2: MyProEnumPack_L1,MyProStarterPack_L0 {
    
    func imageAssociated() -> String
    
    func extendedDescription() -> String
}

public protocol MyProOrganizerPack_L0: Hashable {
    
    func returnTypeCase() -> Self
    func orderAndStorageValue() -> Int // Usiamo il numero oltre che a ordinare i case, anche come valore di storage in firebase
}

public protocol MyProManagingPack_L0 {
    /// gestisce il delete a livello Model, permettendo di compiere altre operazioni insieme.
    func manageModelDelete(viewModel:AccounterVM)
    func conditionToManageMenuInterattivo() -> (disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat)
   
}

// fine spazio MyPro

public protocol MyProToolPack_L0:MyProStatusPack_L1,MyProVisualPack_L0 { }

public protocol MyProToolPack_L1:MyProToolPack_L0,MyProSearchPack_L0,MyProManagingPack_L0 { }

public protocol MyProCloudPack_L0 {
    /// protocollo per le proprietà, in particolare per le enum, per essere convertite in un valore più facilmente stockabile
          func orderAndStorageValue() -> Int
   static func convertiInCase(fromNumber:Int) -> Self
}

public protocol MyProCloudPack_L1 {
    /// versione per i modelli che vanno salvati su firebase
    var id: String { get }
    func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String:Any] // Nota 24.11
    
    init(frDoc:QueryDocumentSnapshot)
    associatedtype DataBaseField
}



/*
protocol MyEnumProtocol: MyProStarterPack_L0/*, /*CaseIterable,*/ Identifiable*//*, Equatable*/ { // Protocollo utile per un Generic di modo da passare differenti oggetti(ENUM) alla stessa View
    
   // var id: String { get } // 13.09 deprecato per conformità al MyProStarterPAck
    
    func simpleDescription() -> String // riallocata
  //  func createId() -> String
    func extendedDescription() -> String // riallocata
    func imageAssociated() -> String // riallocata

    static var defaultValue: Self { get } // riallocata
} */ // deprecato 16.09

/*
protocol MyEnumProtocolMapConform : Hashable { // deve essere conforme ad HAshable per lavorare con i Set
    static var defaultValue: Self { get } // riallocata
    
    func simpleDescription() -> String // riallocata
    func imageAssociated() -> String // riallocata
    func returnTypeCase() -> Self // riallocata
    // 21.07 In Sintesi: Deve ritornare il case, ovvero self. Nel caso il case abbiamo valori associati, deve ritornare il case con dei valori associati standard. Questo permetterà il confronto altrimenti non possibile perchè identici case avranno valori associati che li renderanno diversi
    // In data 23.03.2022 // Ha permesso la risoluzione di un problema nel map dei Model. Il nostro obiettivo era quello di raggruppare i Model per categoria (ENUM). Il problema è sorto lavorando sui Menu, tentando di raggrupparli per Tipologia ci aspettavamo due sole tipologie, fisso e alla carta. Questo non avveniva, in quanto il case fisso ha dei valori associati, il variare di questi valori determinava una nuova tipologia di raggruppamento. Per cui dopo aver provato a risolvere il problema con l'id, infruttuosamente, siamo pervenuti a questa soluzione, che forse ci può tornare utile in chiave Filtri Raggruppamento Custom per l'utente.
    func orderValue() -> Int // riallocata  // usiamo lo zero per i casi che eventualmente vogliamo escludere. In data 07.04 predisposto come possibilità.
} */ // deprecato 16.09


/*
/// Also Know MyModelProtocol
protocol MyProModelPack_L0:MyProStarterPack_L1/*, Identifiable*//*, Equatable*/ {
    
    associatedtype RowView: View // riallocata
    associatedtype InteractiveMenuContent: View // riallocata
    
   // var intestazione: String {get set} // derivata dallo starterPackL1
    var descrizione: String {get set} // riallocata

    var id: String { get set } // 13.09 deprecato per conformità al MyProStarterPAck - Vedi NotaVocale 13.09 // Sovrascrive il protocollo, poichè il protocollo lo vuole solo get
   
    
    /// Stessa funzione di viewModelContainer() Solo che abbiamo l'accesso dal type
    static func viewModelContainerStatic() -> ReferenceWritableKeyPath<AccounterVM,[Self]> // riallocata
    
   /* func viewModelContainerInstance() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM,[Self]>, nomeContainer: String, nomeOggetto:String) */ //14.09 derivata dallo StarterPAckL1
    
    func returnModelRowView() -> RowView // riallocata
  //  func returnNewModel() -> (tipo:Self,nometipo:String) // deprecata in futuro il ritorno del Self. al 22.07 usato soltanto il nomeTipo --> derivata la nuova versione dallo starterPackL1
    
    /// Bottoni per il menu Interattivo specifici del modello
    func customInteractiveMenu(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> InteractiveMenuContent // riallocata
} */ // deprecato 16.09



/*
/// MyProModelPack-L2
protocol MyModelStatusConformity: MyProModelPack_L1, MyProStatusPack_L0, Hashable {

   // var id: String { get set } // 13.09 deprecato per conformità al MyProStarterPAck indiretta da MyModelProtocol
   // var status: StatusModel {get set} /* Deprecata perchè derivata dal MymModelProtocol throw MyProStatusPack */
    
    func pathDestination() -> DestinationPathView // riallocata in statusPAckL1
    func modelStatusDescription() -> String // riallocata in statusPackL0
    
    /// Ideata per avere un accesso dall'esterno su un un possibile ID da verificare ancora prima di creare un Modello
    //func creaID(fromValue:String) -> String // Deprecata 15.09
    
  /*  /// StringResearch per le liste
    func modelStringResearch(string: String) -> Bool */
    
   
} */ // deprecato 16.09







