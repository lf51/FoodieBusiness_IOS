//
//  ClockSyncroVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/10/22.
//

import Foundation
import SwiftUI
import Firebase

struct CloudDataStore {
    
    var setupAccount: AccountSetup // caricato
    var inventarioScorte: Inventario // caricato
    
    var allMyIngredients:[IngredientModel] // caricato
    var allMyDish:[DishModel] // caricato
    var allMyMenu:[MenuModel] // caricato
    var allMyProperties:[PropertyModel] // caricato
    
    var allMyCategories: [CategoriaMenu] // caricato
    var allMyReviews:[DishRatingModel] // caricato
    
  /*  let pathDictionary:[String:PartialKeyPath<CloudDataStore>] = [
    
        CloudCollectionKey.ingredient.rawValue:\CloudDataStore.allMyIngredients,
        CloudCollectionKey.dish.rawValue:\CloudDataStore.allMyDish
    
    ] */
    
    enum CloudCollectionKey:String {
        
      /*  static var allOmoCollection:[CloudCollectionKey] = [.ingredient,.dish,.menu,.properties,.categories,.reviews] */
        
        case ingredient = "userIngredients"
        case dish = "userPreparazioniEprodotti"
        case menu = "userMenu"
        case properties =  "userProperties"
        case categories = "userCategories"
        case reviews = "userReviews"
                
        case anyDocument = "datiDiFunzionamento"
    
        
      /*  func retrieveCloudDataKP(doc:QueryDocumentSnapshot,cloudDataInstance: inout CloudDataStore) {
            
            switch self {
                
            case .ingredient:
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyIngredients)
            case .dish:
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyDish)
            case .menu:
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyMenu)
            case .properties:
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyProperties)
            case .categories:
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyCategories)
            case .reviews:
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyReviews)

            default:
                print("Retrieve cloudData default value - need to be setted")
                genericDocSnapRetrieve(doc: doc, cloudDataInstance: &cloudDataInstance, cloudDataKP: \.allMyIngredients)
            }
        }
        
        private func genericDocSnapRetrieve<M:MyProCloudPack_L1>(doc:QueryDocumentSnapshot,cloudDataInstance: inout CloudDataStore,cloudDataKP:WritableKeyPath<CloudDataStore,[M]>) {
            
            let element = M.init(frDoc: doc)
            cloudDataInstance[keyPath: cloudDataKP].append(element)
            print("retrieve generic element from id: \(element.id)")
            
        } */ // deprecato 22.11
        
        
    }
    
    
    init() {
        
        self.setupAccount = AccountSetup()
        self.inventarioScorte = Inventario()
        self.allMyIngredients = [] // vanno inseriti gli ing,dish,menu,property fake
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategories = [] // vanno inserite le categorie di default
        self.allMyReviews = [] // vanno inserite review fake
        
    }
    
    init(accountSetup: AccountSetup, inventarioScorte: Inventario, allMyIngredients: [IngredientModel], allMyDish: [DishModel], allMyMenu: [MenuModel], allMyProperties: [PropertyModel], allMyCategory: [CategoriaMenu], allMyReviews: [DishRatingModel]) {
        self.setupAccount = accountSetup
        self.inventarioScorte = inventarioScorte
        self.allMyIngredients = allMyIngredients
        self.allMyDish = allMyDish
        self.allMyMenu = allMyMenu
        self.allMyProperties = allMyProperties
        self.allMyCategories = allMyCategory
        self.allMyReviews = allMyReviews
    }
    
    
    
}


struct CloudDataCompiler {
    
    private let db_base = Firestore.firestore()
    private let ref_userDocument: DocumentReference?
    private let userUID: String? // quando nil passiamo un accounterVM fake
    
    init(UID:String?) {

        self.userUID = UID
        
        if let user = UID {
    
            self.ref_userDocument = db_base.collection("UID_UtenteBusiness").document(user)
    
        } else { self.ref_userDocument = nil }
        
        
    }
    

    private func firstAuthenticationFuture() {
        self.ref_userDocument?.setData([:])
        print("firstAuthenticationFuture")
        
    }
    
    // Scarico Dati
    
    /// esegue il download di una collezione di documenti contenuti in una collection Omogenea  (tutti gli ingredienti, i piatti ecc)
    func downloadFromFirebase_allMyElement<M:MyProCloudPack_L1>(collectionKP:WritableKeyPath<CloudDataStore,[M]>,cloudCollectionKey:CloudDataStore.CloudCollectionKey,handler: @escaping (_ allMyElements: [M],_ isDone:Int) -> ()) {
        
        var cloudData:CloudDataStore = CloudDataStore()

        let ref = ref_userDocument?.collection(cloudCollectionKey.rawValue)
            
            ref?.getDocuments { queryDoc, error in
                
            guard error == nil, queryDoc?.documents != nil else { return }
                
            for doc in queryDoc!.documents {

                let element = M.init(frDoc: doc)
                cloudData[keyPath: collectionKP].append(element)
                    }
                handler(cloudData[keyPath: collectionKP],1)
            }
    }
    
    /// esegue il download dei  singoli documenti contenuti in una collection Eterogenea
    func downloadFromFirebase_singleElement<M:MyProCloudPack_L1>(singleKP:WritableKeyPath<CloudDataStore,M>,cloudCollectionKey:CloudDataStore.CloudCollectionKey,handler: @escaping (_ singleElement: M,_ isDone:Int) -> ()) {
        
        var cloudData:CloudDataStore = CloudDataStore()

        let ref = ref_userDocument?.collection(cloudCollectionKey.rawValue)
            
            ref?.getDocuments { queryDoc, error in
                
            guard error == nil, queryDoc?.documents != nil else { return }
                
            for doc in queryDoc!.documents {

                let element = M.init(frDoc: doc)
                cloudData[keyPath: singleKP] = element
                    }
                handler(cloudData[keyPath: singleKP],1)
            }
    }
    
    
  /*  func downloadFromFirebase(handler: @escaping (_ cloudData: CloudDataStore) -> ()) {
        
       // print("Download data from firebase \(Thread.current)")
        print("ref_userDocument? = \(ref_userDocument != nil)")
        
       let userSetup_doc = ref_userDocument?.collection(CloudDataStore.CloudCollectionKey.anyDocument.rawValue).document("userSetup")

         userSetup_doc?.getDocument { docSnapshot, error in
               
               guard
                error == nil,
                docSnapshot?.exists == true else {
                   handler(fakeCloudData)
                   return } // mettere magari un aleert
               print("no error: \(Thread.current)")
               print("document Exist")
     
               handler(self.getDataFromSnapshot(docSnapshot: docSnapshot))
                
           }
        
    }
    
    
   private func getDataFromSnapshot(docSnapshot:DocumentSnapshot?) -> CloudDataStore {

      var cloudData = CloudDataStore()
    
       if let document = docSnapshot {
           
               if let value_1 = document.get("mettiInPausaDishByING") as? Int {
                   
                   cloudData.setupAccount.mettiInPausaDishByIngredient = AccountSetup.ActionValue.convertiInCase(fromNumber: value_1)
                   
               }
               
               if let value_2 = document.get("startCountDownValue") as? Int {
                   
                   cloudData.setupAccount.startCountDownMenuAt = AccountSetup.TimeValue.convertiInCase(fromNumber: value_2)
               }
               
           
       } else {
           
           cloudData = fakeCloudData
       }
       
       print("cloudData.time = \(cloudData.setupAccount.startCountDownMenuAt.rawValue)")
       return cloudData
    } */ // deprecato 22.11

    
   /* func downloadIngredientFirebase(handler: @escaping (_ cloudData: CloudDataStore) -> ()) {
        
       var cloudData:CloudDataStore = CloudDataStore()
        
       let userSetup_doc = ref_userDocument?.collection(CloudDataStore.CloudCollectionKey.ingredient.rawValue)

         userSetup_doc?.getDocuments { docsSnapshot, error in
               
             guard error == nil, docsSnapshot?.documents != nil else { return }
             
             for doc in docsSnapshot!.documents {
                 let ing = IngredientModel(frDoc: doc)
                 cloudData.allMyIngredients.append(ing)
                 
             }
              handler(cloudData)
           }
        
    } */
    
    /// esegue un download per documenti omogenei contenuti in una collection
  /*  func downloadFromFirebase_allMyElement(handler: @escaping (_ cloudData: CloudDataStore) -> ()) {
        
        var cloudData:CloudDataStore = CloudDataStore()
        
        let allCollectionKey_omo = CloudDataStore.CloudCollectionKey.allOmoCollection
        let allCollection_ref = allCollectionKey_omo.map({ref_userDocument?.collection($0.rawValue)})
        
        for ref in allCollection_ref {
            
            let refID = ref?.collectionID ?? ""
            let collectionCase = CloudDataStore.CloudCollectionKey(rawValue: refID)
            
            ref?.getDocuments { queryDoc, error in
                
            guard error == nil, queryDoc?.documents != nil else { return }
                
            print("ref?.getDocuments space")
            for doc in queryDoc!.documents {
                print("single doc space")
                if collectionCase != nil  {
                    
                    collectionCase!.retrieveCloudDataKP(doc: doc, cloudDataInstance: &cloudData)
                    
                    }
                }
            }
        }
        print("Handler CloudData Line")
        handler(cloudData)
        // update and handle cloudData
    } */ // deprecata 22.11
    
    
        
   /* private func genericDocSnapRetrieve<M:MyProCloudPack_L1>(doc:QueryDocumentSnapshot,cloudDataInstance: inout CloudDataStore,cloudDataKP:WritableKeyPath<CloudDataStore,[M]>?) {
        
        let element = M.init(frDoc: doc)
        cloudDataInstance[keyPath: cloudDataKP!].append(element)
        print("retrieve generic element from id: \(element.id)")
        
    } */
    
    /*
        
       let userSetup_doc = ref_userDocument?.collection(CloudDataStore.CloudCollectionKey.ingredient.rawValue)

         userSetup_doc?.getDocuments { docsSnapshot, error in
               
             guard error == nil, docsSnapshot?.documents != nil else { return }
             
             for doc in docsSnapshot!.documents {
                 let ing = IngredientModel(frDoc: doc)
                 cloudData.allMyIngredients.append(ing)
                 
             }
              handler(cloudData)
           }
        
    */
   
    
    // Salvataggio Dati
    
    func publishOnFirebase(dataCloud:CloudDataStore) {
        
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyIngredients], collection: .ingredient)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyDish], collection: .dish)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyMenu], collection: .menu)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyProperties], collection: .properties)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyCategories], collection: .categories)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyReviews], collection: .reviews)
        
        saveSingleDocument(doc: dataCloud[keyPath: \.setupAccount], collection: .anyDocument)
        saveSingleDocument(doc: dataCloud[keyPath: \.inventarioScorte], collection: .anyDocument)
        
    }
    
    /// La usiamo per salvare un singolo documento in una collezione che può essere eterogenea.
    private func saveSingleDocument<M:MyProCloudPack_L1>(doc:M,collection:CloudDataStore.CloudCollectionKey) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection(collection.rawValue) {
                            
            saveElement(document: ref_ingredienti.document(doc.id), element: doc)
   
        }
        
    }
    
    /// La usiamo per salvare un array di documenti omogenei (solo ingredienti, o solo piatti ecc) in una collezione MonoTono
    private func saveMultipleDocuments<M:MyProCloudPack_L1>(docs:[M],collection:CloudDataStore.CloudCollectionKey) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection(collection.rawValue) {
            
            for element in docs {
                
                saveElement(document: ref_ingredienti.document(element.id), element: element)

            }
        }
    }
    
    private func saveElement<M:MyProCloudPack_L1>(document:DocumentReference?,element:M) {
        
        document?.setData(element.documentDataForFirebaseSavingAction(), merge: true) { error in
                
                if error != nil { print("OPS!! Qualcosa non ha funzionato nel salvataggio su Firebase")}
                else { print("Salvataggio su FireBase avvenuto con Successo - Mettere un Alert")}
        }
        
    }
    
}


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
    allMyReviews: [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12])
