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
       //  self.allMyReviews = try values.decode([DishRatingModel].self, forKey: .allMyReviews)
         self.allMyReviews = []
         
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
    

    private func firstAuthenticationFuture() {
        self.ref_userDocument?.setData([:])
        print("firstAuthenticationFuture")
        
    }
    
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
    
}

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
