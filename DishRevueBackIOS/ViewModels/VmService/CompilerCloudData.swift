//
//  Cloud.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MyFilterPackage

extension CloudDataStore:Codable {
    
     public init(from decoder: Decoder) throws {
        
         self.init()
         
         let values = try decoder.container(keyedBy: CodingKeys.self)
         
         self.allMyIngredients = try values.decode([IngredientModel].self, forKey: .allMyIngredients)
         self.allMyDish = try values.decode([DishModel].self, forKey: .allMyDish)
         self.allMyMenu = try values.decode([MenuModel].self, forKey: .allMyMenu)
         self.allMyProperties = try values.decode([PropertyModel].self, forKey: .allMyProperties)
         
         self.allMyCategories = try values.decode([CategoriaMenu].self, forKey: .allMyCategories)
         self.allMyReviews = try values.decode([DishRatingModel].self, forKey: .allMyReviews)
        // self.allMyReviews = []
         
         let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .otherDocument)
         self.setupAccount = try additionalInfo.decode(AccountSetup.self, forKey: .setupAccount)
         self.inventarioScorte = try additionalInfo.decode(Inventario.self, forKey: .inventarioScorte)
         
         
     }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(allMyIngredients, forKey: .allMyIngredients)
        try container.encode(allMyDish, forKey: .allMyDish)
        try container.encode(allMyMenu, forKey: .allMyMenu)
        try container.encode(allMyProperties, forKey: .allMyProperties)
        try container.encode(allMyCategories, forKey: .allMyCategories)
        try container.encode(allMyReviews, forKey: .allMyReviews) 
        
        var secondLevel = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .otherDocument)
        try secondLevel.encode(setupAccount, forKey: .setupAccount)
        try secondLevel.encode(inventarioScorte, forKey: .inventarioScorte)
       
        
    }
    
} // close extension

enum RestrictionLevel:Codable {
    
    // le restrizioni funzionano per esclusione. Quelle contenute nei livelli sono quelle che verranno bloccate
    
    static let allCases:[RestrictionLevel] = [.listaDellaSpesa,.modificheDiFunzionamento,.creaMod_ing,.creaMod_dish,.creaMod_categorie,.creaMod_menu,.replyReview]
    
    static let allLevel:[String:[RestrictionLevel]] = [
        "Level 1":RestrictionLevel.level_1,
        "Level 2":RestrictionLevel.level_2,
        "Level 3":RestrictionLevel.level_3,
        "Level 4":RestrictionLevel.level_4
    ]
    
    static let level_1:[RestrictionLevel] = [.creaMod_ing,.creaMod_dish,.creaMod_menu,.creaMod_categorie,.replyReview]
    static let level_2:[RestrictionLevel] = [.creaMod_menu,.replyReview]
    static let level_3:[RestrictionLevel] = [.replyReview]
    static let level_4:[RestrictionLevel] = []
    
    case listaDellaSpesa
    case modificheDiFunzionamento // cambio di Status // Livello Scorte
    
    case creaMod_dish
    case creaMod_ing
    
    case creaMod_categorie
    case creaMod_menu
    
    case replyReview
    
    static func namingLevel(allRestriction:[RestrictionLevel]) -> String {
        
        for level in RestrictionLevel.allLevel {
            
            if allRestriction == level.value { return level.key}
            else { continue }
        }
        
        return "Custom"
    }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .listaDellaSpesa:
            return "Abilita modifiche lista della spesa"
        case .modificheDiFunzionamento:
            return "Abilita modifiche di status dei modelli"
        case .creaMod_dish:
            return "Abilita crea e modifica i prodotti"
        case .creaMod_ing:
            return "Abilita crea e modifica gli ingredienti"
        case .creaMod_menu:
            return "Abilita crea e modifica i menu"
        case .replyReview:
            return "Abilita a rispondere alle recensioni"
        case .creaMod_categorie:
            return "Abilita crea e modifica categorie dei Menu"
        }
    }

}

public struct CloudDataCompiler {
    
    private let db_base = Firestore.firestore()
    private var ref_db: DocumentReference?
    private let userAuthUid:String?
   
  //  var profiloUtente:ProfiloUtente = ProfiloUtente()
    
    public init(userAuthUID:String?) {

        if let user = userAuthUID {
    
            self.ref_db = db_base.collection("UID_UtenteBusiness").document(user)
            self.userAuthUid = user
         
           // self.profiloUtente = ProfiloUtente()
            print("CloudDataCompiler inizializzato con uuid:\(user)")
            
        } else {
            self.ref_db = nil
            self.userAuthUid = nil
           // self.profiloUtente = ProfiloUtente()
            print("CloudDataCompiler init con id: NIL)")
        }
        
        
    }
    
     func fetchAllData(handle:@escaping(_ db:CloudDataStore?,_ user:ProfiloUtente?,_ isLoading:Bool) -> ()) {
        
        guard let userUID = self.userAuthUid else {
            handle(nil,nil,false)
            print("No User Auth UID")
            return
        }
        
        self.fetchUserProfile(docRef: userUID) { utenteCorrente in
            // admin o collab
            if let datiUtente = utenteCorrente?.datiUtente {
                // collab
                self.fetchUserProfile(docRef: datiUtente.db_uidRef) { profiloAdmin in
                    
                    if let collaboratorProfile:CollaboratorModel = profiloAdmin?.allMyCollabs?.first(where: {$0.mail == datiUtente.mail}) {
                        // collaboratore esiste
                        let profiloAggiornato = ProfiloUtente(datiUtente:collaboratorProfile)

                        self.compilaCloudDataFromFirebase(newDbRef:datiUtente.db_uidRef) { dbFromAdmin in
                            
                            handle(dbFromAdmin,profiloAggiornato,false)
                            print("Collaboratore esite - aggiornata key database - scaricati dati dall'adim")
                        }
                        
                    } else {
                        // collaboratore non esiste
                        handle(nil,utenteCorrente,false)
                        print("Collaboratoe ha la chiave ma non risulta fra i collaboratori")
                        
                    }
                    
                }
 
            } else {
                // admin
                self.compilaCloudDataFromFirebase { cloudData in
                    handle(cloudData,utenteCorrente,false)
                    print("Compilazione CloudData admin eseguita - profilo: \(utenteCorrente == nil)")
                }
                
            }
            
        }
  
    }
    
    
    func publishOnFirebase<C:Codable>(dbRef:String? = nil,saveData:C) {
       
        let ref:DocumentReference? = {
            if let uuid = dbRef {
                let newRef = self.db_base.collection("UID_UtenteBusiness").document(uuid)
                return newRef
            } else {
                return self.ref_db
            }
        }()
        
       do {
           
           try ref?.setData(from: saveData, merge: true)
          
       } catch let error {
           
           print("\(error.localizedDescription) - Errore nel salvataggio su Firebase")
       }
       
       
   }
    
    func fetchUserProfile(docRef:String,handle: @escaping (_ :ProfiloUtente?) -> () ) { // Validata
       
        let userRef:DocumentReference? = self.db_base.collection("UID_UtenteBusiness").document(docRef)
        
        guard let ref = userRef else {
            handle(nil)
            return }
        
        ref.getDocument(as: ProfiloUtente.self) { result in
            
            switch result {
                
            case .success(let profilo):
                handle(profilo)
                print("Profilo Utente caricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download profiloUtente from Firebase FAIL: \(error)")
            }
        }
        
   }
        
    func firstAuthenticationFuture() {
    // cancella tutti i dati del database lasciando la chiave. Utile se si vuole creare la chiave in una prima autentica o se si vuole cancellare ogni dato mantenendo la chiave. In questo casa occorrerebbe aggiornare l'app per rifetchare i dati e dunque avere un cloudData locale vuoto
        self.ref_db?.setData([:])
    // Va sistemato in chiave collab -admin
        print("firstAuthenticationFuture")

    }
        
    func compilaCloudDataFromFirebase(newDbRef:String? = nil,handle:@escaping(_:CloudDataStore?) -> () ) {
        
        let newRef:DocumentReference? = {
            
            if let docRef = newDbRef {
                // avremo un riferimento esterno al database (collab)
                let db_refNew = self.db_base.collection("UID_UtenteBusiness").document(docRef)
                return db_refNew
                
            } else {
                // avremo il riferimento salvato in fase di init (admin)
                return self.ref_db
            }
               

        }()
        
            guard let docRef = newRef else {
            handle(nil)
            print("errore - ref_db == nil")
            return
        }
        
        docRef.getDocument(as: CloudDataStore.self) { result in
        
            switch result {
                
            case .success(let cloudData):
                handle(cloudData)
                print("CloudDataStore caricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download from Firebase FAIL: \(error)")
            }
            
    
        }
    }
    
   
    /* func publishOnFirebase(dataCloud:CloudDataStore) {
        
        do {
            
            try ref_userDocument?.setData(from: dataCloud, merge: true)
           
        } catch let error {
            
            print("\(error.localizedDescription) - Errore nel salvataggio su Firebase")
        }
        
        
    } */
    
   
    
    // Fetch dati collaborate/Adim
    

   /* func fetchUserData(handle: @escaping(_ :ProfiloUtente?,_ :CloudDataStore?) -> () ) {
        
        self.fetchUserProfile { profilo in
            
            if let db_ExternalRef = profilo?.datiUtente?.db_uidRef {
                
                if let mailUser = profilo?.datiUtente?.mail {
                    
                    checkCollaborationActive(db_ref: db_ExternalRef, mail: mailUser) { updatedProfile in
                        
                        compilaCloudDataFromFirebase(extRef: db_ExternalRef) { ext_db in
                            handle(updatedProfile,ext_db)
                            print("DataBase esterno scaricato da Firebase")
                        }
  
                    }
                }
   
            } else {
                // admin
                self.compilaCloudDataFromFirebase { dataBase in
                   handle(profilo,dataBase)
                    print("DataBase Interno scaricato da Firebase")
                }
                
            }
            
        }
        
    }*/ // deprecata
    
  /*  func fetchUserProfile(handle: @escaping (_ :ProfiloUtente?) -> () ) { // validato
       
          guard let docRef = self.ref_db else {
           handle(nil)
           print("docRef == nil")
           return
       }
    
        docRef.getDocument(as: ProfiloUtente.self) { result in
            
            switch result {
            case .success(let profilo):
                handle(profilo)
                print("Profilo Utente caricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download profiloUtente from Firebase FAIL: \(error)")
            }
        }
        
   }*/
    
   /* func checkCollaborationActive(db_ref:String,mail:String, handle:@escaping(_:ProfiloUtente) -> () ) { // validato
        
        let newDoc_ref:DocumentReference? = db_base.collection("UID_UtenteBusiness").document(db_ref)

        guard let newRef = newDoc_ref else {
            handle(ProfiloUtente())
            print("Chiave dbEsterno - documento non trovato")
            return
        }
        
        newRef.getDocument(as: ProfiloUtente.self) { result in
            
            switch result {
                
            case .success(let profiloAdmin):
                
                let collabModel:CollaboratorModel? = profiloAdmin.allMyCollabs?.first(where: {$0.mail == mail})
                
                let newCollabProfile = ProfiloUtente(datiUtente: collabModel)
                handle(newCollabProfile)
                print("Profilo collaboratore updated")
                
            case .failure(let error):
                handle(ProfiloUtente())
                print("Profilo dell'admin di riferimento per il collab non scaricato: \(error.localizedDescription)")
            }
        }
        
    }*/ // deprecata
    
}
            
/*
public struct CloudDataCompiler {
    
    private let db_base = Firestore.firestore()
    private let ref_userDocument: DocumentReference?
   // private let userUID: String? // quando nil passiamo un accounterVM fake
    
   public init(UID:String?) {

      //  self.userUID = UID
        
        if let user = UID {
    
            self.ref_userDocument = db_base.collection("UID_UtenteBusiness").document(user)
            // 14.07.23 Nota// prima di accedere al documento deve essere verificato il profilo di questo UID. Se è admin si scarica il database, se non è admin si verifica la collaborazione e si scarica il database associato all'uid dell'admin che ha richiesto la collaborazione
    
        } else { self.ref_userDocument = nil }
        
        
    }
    

     func firstAuthenticationFuture() {
         // cancella tutti i dati del database lasciando la chiave. Utile se si vuole creare la chiave in una prima autentica o se si vuole cancellare ogni dato mantenendo la chiave. In questo casa occorrerebbe aggiornare l'app per rifetchare i dati e dunque avere un cloudData locale vuoto
        self.ref_userDocument?.setData([:])
         
        print("firstAuthenticationFuture")
        
    } // deprecare in futuro / non in uso 16.07.2023
    
    // Scarico Dati
    
    func compilaCloudDataFromFirebase(handle: @escaping (_ :CloudDataStore?) -> () ) {
        
        guard let docRef = ref_userDocument else {
            handle(nil)
            return
        }
     
        docRef.getDocument(as: CloudDataStore.self) { result in
        
            switch result {
                
            case .success(let cloudData):
                handle(cloudData)
                print("CloudDataStore caricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download from Firebase FAIL: \(error)")
            }
            
    
        }

    }
      
    
    // Salvataggio Dati
    
    func publishOnFirebase(dataCloud:CloudDataStore) {
        
        do {
            
            try ref_userDocument?.setData(from: dataCloud, merge: true)
           
        } catch let error {
            
            print("\(error.localizedDescription) - Errore nel salvataggio su Firebase")
        }
        
        
    }
    
    
    
    
  /*  func publishOnFirebaseDEPRECATA(dataCloud:CloudDataStore) {
        
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyIngredients], collection: .ingredient)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyDish], collection: .dish)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyMenu], collection: .menu)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyProperties], collection: .properties)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyCategories], collection: .categories, retrieveElementIndex: true)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyReviews], collection: .reviews)
        
        saveSingleDocument(doc: dataCloud[keyPath: \.setupAccount], collection: .anyDocument)
        saveSingleDocument(doc: dataCloud[keyPath: \.inventarioScorte], collection: .anyDocument)
        
    } */
    
    /// La usiamo per salvare un singolo documento in una collezione che può essere eterogenea.
  /*  private func saveSingleDocument<M:MyProCloudPack_L1>(doc:M,collection:CloudDataStore.CloudCollectionKey) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection(collection.rawValue) {
                            
            saveElement(document: ref_ingredienti.document(doc.id), element: doc)
   
        }
        
    } */
    
    /// La usiamo per salvare un array di documenti omogenei (solo ingredienti, o solo piatti ecc) in una collezione MonoTono. Il retrieve serve a recuperare la posizione nell'array, per salvarla nel firebase. Creato appositamente le per le categorieMenu
   /* private func saveMultipleDocuments<M:MyProCloudUploadPack_L1>(docs:[M],collection:CloudDataStore.CloudCollectionKey,retrieveElementIndex:Bool = false) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection(collection.rawValue) {
            
            for element in docs {
                
                let index:Int?
                if retrieveElementIndex { index = docs.firstIndex(where:{ $0.id == element.id }) }
                else { index = nil }
                
                saveElement(document: ref_ingredienti.document(element.id), element: element,elementIndex: index)

            }
        }
    } */
    
   /* private func saveElement<M:MyProCloudUploadPack_L1>(document:DocumentReference?,element:M,elementIndex:Int? = nil) {
        
        document?.setData(element.documentDataForFirebaseSavingAction(positionIndex: elementIndex), merge: true) { error in
                
                if error != nil { print("OPS!! Qualcosa non ha funzionato nel salvataggio su Firebase")}
                else { print("Salvataggio su FireBase avvenuto con Successo - Mettere un Alert")}
        }
        
    } */
    
}*/ // Backup 16.07.23 Pre sviluppo autorizzazioni

/*
let fakeCloudData = CloudDataStore(
    accountSetup: AccountSetup(),
    inventarioScorte: Inventario(
        id:"userInventario",
        ingInEsaurimento: [ingredientSample6_Test.id,ingredientSample7_Test.id,ingredientSample8_Test.id],
        ingEsauriti: [ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id],
        archivioNotaAcquisto: [:],
        cronologiaAcquisti: [
        ingredientSample_Test.id:[otherDateString3,otherDateString1,otherDateString,oldDateString,todayString],ingredientSample5_Test.id:[oldDateString,todayString]
    
    ],
        lockedId: [:],
        archivioIngInEsaurimento: [todayString:[ingredientSample5_Test.id]]),
    allMyIngredients: [ingredientSample_Test,ingredientSample2_Test,ingredientSample3_Test,ingredientSample4_Test,ingredientSample5_Test,ingredientSample6_Test,ingredientSample7_Test,ingredientSample8_Test,ingredienteFinito],
    allMyDish: [dishItem2_Test,dishItem3_Test,dishItem4_Test,dishItem5_Test,prodottoFinito],
    allMyMenu: [menuSample_Test,menuSample2_Test,menuSample3_Test,menuDelGiorno_Test,menuDelloChef_Test],
    allMyProperties:[property_Test],
    allMyCategory: [cat1,cat2,cat3,cat4,cat5,cat6,cat7],
    allMyReviews: [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12]) */
