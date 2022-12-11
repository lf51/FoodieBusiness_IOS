//
//  Cloud.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/12/22.
//

import Foundation
import SwiftUI
import Firebase
import MyFoodiePackage

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
    func downloadFromFirebase_allMyElement<M:MyProCloudDownloadPack_L1>(collectionKP:WritableKeyPath<CloudDataStore,[M]>,cloudCollectionKey:CloudDataStore.CloudCollectionKey,handler: @escaping (_ allMyElements: [M],_ isDone:Int) -> ()) {
        
        var cloudData:CloudDataStore = CloudDataStore()

        let ref = ref_userDocument?.collection(cloudCollectionKey.rawValue)
            
            ref?.getDocuments { queryDoc, error in
                
            guard error == nil, queryDoc?.documents != nil else { return }
                
            for doc in queryDoc!.documents {

                let element = M.init(frDocID: doc.documentID, frDoc: doc as! [String:Any])
                cloudData[keyPath: collectionKP].append(element)
                    }
               // handler(cloudData[keyPath: collectionKP],1) // Chiudiamo per test (08.12.22)
                handler(fakeCloudData[keyPath: collectionKP],1) // carichiamo dati fake per test
            }
    }
    
    /// esegue il download dei  singoli documenti contenuti in una collection Eterogenea
    func downloadFromFirebase_singleElement<M:MyProCloudDownloadPack_L1>(singleKP:WritableKeyPath<CloudDataStore,M>,cloudCollectionKey:CloudDataStore.CloudCollectionKey,handler: @escaping (_ singleElement: M,_ isDone:Int) -> ()) {
        
        var cloudData:CloudDataStore = CloudDataStore()

        let ref = ref_userDocument?.collection(cloudCollectionKey.rawValue)
            
            ref?.getDocuments { queryDoc, error in
                
            guard error == nil, queryDoc?.documents != nil else { return }
                
            for doc in queryDoc!.documents {
               
                let element = M.init(frDocID: doc.documentID, frDoc: doc as! [String:Any])
                cloudData[keyPath: singleKP] = element
                    }
               // handler(cloudData[keyPath: singleKP],1) // pausa per test
                handler(fakeCloudData[keyPath: singleKP],1)
            }
    }
  
    
    // Salvataggio Dati
    
    func publishOnFirebase(dataCloud:CloudDataStore) {
        
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyIngredients], collection: .ingredient)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyDish], collection: .dish)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyMenu], collection: .menu)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyProperties], collection: .properties)
        saveMultipleDocuments(docs: dataCloud[keyPath: \.allMyCategories], collection: .categories, retrieveElementIndex: true)
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
    
    /// La usiamo per salvare un array di documenti omogenei (solo ingredienti, o solo piatti ecc) in una collezione MonoTono. Il retrieve serve a recuperare la posizione nell'array, per salvarla nel firebase. Creato appositamente le per le categorieMenu
    private func saveMultipleDocuments<M:MyProCloudUploadPack_L1>(docs:[M],collection:CloudDataStore.CloudCollectionKey,retrieveElementIndex:Bool = false) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection(collection.rawValue) {
            
            for element in docs {
                
                let index:Int?
                if retrieveElementIndex { index = docs.firstIndex(where:{ $0.id == element.id }) }
                else { index = nil }
                
                saveElement(document: ref_ingredienti.document(element.id), element: element,elementIndex: index)

            }
        }
    }
    
    private func saveElement<M:MyProCloudUploadPack_L1>(document:DocumentReference?,element:M,elementIndex:Int? = nil) {
        
        document?.setData(element.documentDataForFirebaseSavingAction(positionIndex: elementIndex), merge: true) { error in
                
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
