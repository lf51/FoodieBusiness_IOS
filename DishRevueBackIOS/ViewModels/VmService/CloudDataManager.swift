//
//  CloudDataManager.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/08/23.
//

import Foundation
import Combine
import SwiftUI

import MyFoodiePackage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MyFilterPackage
import MyPackView_L0

/*
 Controllo Thread
 print(Thread.current)
 
 Product/Scheme/Edit/Thread Sanitazer
 
 */

/*
 
 Buntch // Transaction
 
 • Buntch ci permette di salvare più modifiche a più documenti nello stesso tempo. Questo è utile perchè qualora avvenissero modifiche sugli stessi documenti da altri utenti, non si creerebbero degli ibridi, ma o le mie o le sue
 -> Use Case:
 Quando modifichiamo i vari modelli localmente e poi mandiamo le modifiche tutte insieme invece che one or one
 
 • Transaction is quite similar, ma prima di scrivere le modifiche legge i dati per essere certo che siano up to date
 -> Use Case:
 Quando salviamo una nuova proprietà e creiamo l'admin per lo user. Dobbiamo essere certi che nessuno nello stesso istante stiano facendo lo stesso.
 -> Cambi di Status dei modelli
 
 
 
 */

/// Gestisce la collezione userBusiness - E' un ponte fra l'authentication e il viewModel
public final class UserManager {
   
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    private(set) var currentUserUID:String
    
    public init(userAuthUID:String) {
        
        collectionManaged = self.db_base.collection("user_business")
        self.currentUserUID = userAuthUID
        print("[INIT]_UserManager_forUserUID:\(userAuthUID)")
    }
    
    deinit {
            print("[DEINIT]_UserManager")
        }

    var userListener:ListenerRegistration?
    let userPublisher = PassthroughSubject<UserCloudData?,Error>()
    
    func fetchAndListenUserDataPublisher() {
        
       // let userPublisher = PassthroughSubject<UserCloudData?,Error>()
        print("[CALL]-fetchAndListenUserDataPublisher_THREAD:\(Thread.current)")
        
        let docRef = collectionManaged.document(self.currentUserUID)
        
        self.userListener = docRef
            .addSnapshotListener {[weak self] querySnapshot, errror in
                print("[INSIDE USER_DATA LISTENER]")
                
                guard let document = querySnapshot else {
                    print("[USER_DATA LISTENER FAIL]")
                    self?.userPublisher.send(nil)
                    return
                }
                print("[START USER_DATA LISTENER]")
                // decodifica di default
                let userData = try? document.data(as: UserCloudData.self)
                
                guard let userData else {
                    print("[USER_DATA(as:) FAIL")
                    self?.userPublisher.send(nil)
                    return
                }
                print("[SUCCESS DATA SEND]_fetchAndListenUserDataPublisher/refCount:\(String(describing: userData.propertiesRef?.isEmpty))")
                
                self?.userPublisher.send(userData)
               
            }

       // return userPublisher.eraseToAnyPublisher()
        
    }
    
    func publishUserCloudData(from userData:UserCloudData/*, to customEncoder: Firestore.Encoder = Firestore.Encoder()*/) async throws {
        print("[CALL]_publishUserCloudData")
        
        let document = collectionManaged.document(self.currentUserUID)
        try document.setData(
            from: userData,
            merge: true)
    }
    
    func updatePropertiesRef(user:UserCloudData) async throws {
        print("[CALL]_updatePropertiesRef")
        
        let docRef = collectionManaged.document(self.currentUserUID)
        
        try docRef
            .setData(from: user, mergeFields: ["user_properties_ref"])
      // va rivista perch+ NIck spiega come aggiungere un dato ad un array. Non avremmo bisogno di passare tutto il userData
    }
    
} // close UserManager

public final class PropertyManager {

private let db_base = Firestore.firestore()
private let collectionManaged:CollectionReference
private(set) var currentUserUID:String

public enum PropertyMainCodingKeys:String,CodingKey {
    // le main Key del documento della proprietà su firebase. Utilizzabili fuori. 05.09.23 in uso su PropertyLocalImage
    case propertyInventario = "property_inventario"
    case propertySetup = "property_setup"
    case propertyInfo = "property_info"

}

    public init(userAuthUID:String) {
    print("[INIT]_PropertyManager_userCorrente:\(userAuthUID)")
    self.collectionManaged = self.db_base.collection("properties_registered")
    self.currentUserUID = userAuthUID
   // self.currentUser = currentUser
  //  self.fetchAndListenPropertyImagesPublisher()
    
}
    
deinit {
    print("[DEINIT]_PropertyManager_forUser:\(self.currentUserUID)")
        }

    
var propertyImagesListener:ListenerRegistration?
let propertyImagesPublisher = PassthroughSubject<[PropertyLocalImage]?,Error>()
    /// contiamo i cambiamenti nei documenti per notifiche
let propertyAllDataChanges = PassthroughSubject<Int?,Error>()
    
let currentPropertyPublisher = PassthroughSubject<(PropertyCurrentData?,CurrentUserRoleModel?,QueryDocumentSnapshot?),Error>()

    func fetchAndListenPropertyImagesPublisher(from ref:[String]?) {
    
    print("[CALL]_fetchAndListenPropertyImagesPublisher/removeListener before listen again_thread:\(Thread.current)")
        
        self.propertyImagesListener?.remove()
    
        guard let ref,
              !ref.isEmpty else { 
            self.propertyImagesPublisher.send(nil)
           // self.currentPropertyPublisher.send((nil,nil,nil,nil))
            return }
    
        self.propertyImagesListener = collectionManaged
            .whereField(.documentID(), in: ref)
            .addSnapshotListener({ [weak self] querySnapshot, error in
                
                print("[START]_LISTENER_PROP_IMAGES/startingRef:\(ref.count)/querCount:\(String(describing: querySnapshot?.documents.count))")
                
            guard let self,
                  let snapShot = querySnapshot else {
                    
                print("Errore nel listener:\(error?.localizedDescription ?? "")")
                // publisher.send(nil)
                self?.propertyImagesPublisher.send(nil)
              //  self?.currentPropertyPublisher.send((nil,nil,nil,nil))
                return
                    
                }
                
                snapShot.documentChanges.forEach { docs in

                    if docs.type == .modified {
                        print("[BETA TEST]_INSIDE DOCUMENTCHANGE")
                        self.propertyAllDataChanges.send(docs.type.rawValue)
                    }

                }
                
                let documents = snapShot.documents

                let decoder = {
                    let dec = Firestore.Decoder()
                    dec.userInfo[UserCloudData.decoderCase] = UserCloudData.DecodingCase.propertyLocalImage(self.currentUserUID)
                    return dec
                }() // temporaneo

                  
            let allImages:[PropertyLocalImage] = documents.compactMap({ snap -> PropertyLocalImage? in
                    
                let image = try? snap.data(as: PropertyLocalImage.self,decoder: decoder)
                
                guard var propImage = image else { return nil }
            
                    propImage.snapShot = snap
                    return propImage

                })
                
                if !allImages.isEmpty {
                    print("[SUCCESS DATA SEND]_fetchAndListenPropertyImagesPublisher")
                    self.propertyImagesPublisher.send(allImages)
                   // fetchCurrentPropertyPublisher(from: allImages)
                } else {
                    print("[FAIL DATA SEND]_fetchAndListenPropertyImagesPublisher")
                    self.propertyImagesPublisher.send(nil)
                 //   self.currentPropertyPublisher.send((nil,nil,nil,nil))
                }
                
                //print("[END]_LISTENER_PROP_IMAGES_endingCount:\(allImages.count) ")
                // publisher.send(allImages)
                
            })
        
        // return publisher.eraseToAnyPublisher()
        // return Self.propertyPublisher.eraseToAnyPublisher()
        
    }
    
 func fetchCurrentPropertyPublisher(from images:[PropertyLocalImage]) {

    print("[CALL]_fetchCurrentPropertyPublisher_thread:\(Thread.current)")
        
        self.retrievePropertyTransitionData(from: images) { [weak self] currentProperty, currentUserRole, propertyDocRef in

            guard let self,
            let propertyDocRef,
            let currentProperty,
            let currentUserRole else {
                print("[ERROR]_Retrieve transitionData FAIL")
                // publisher.send(nil)
                self?.currentPropertyPublisher.send((nil,nil,nil))
               // self?.currentPropertyPublisher.send((nil,nil,nil,nil))
                return
            }
            
            self.currentPropertyPublisher.send((currentProperty,currentUserRole,propertyDocRef))

        }

    }
    
private func retrievePropertyTransitionData(from images:[PropertyLocalImage],handle:@escaping(_ currentProperty:PropertyCurrentData?,_ currentUserRole:CurrentUserRoleModel?,_ propertyDocRef:QueryDocumentSnapshot?) -> ()) {
        
        let userDecoder = {
            let decoder = Firestore.Decoder()
            decoder.userInfo[UserCloudData.decoderCase] = UserCloudData.DecodingCase.organigramma
            return decoder
        }()
        
        
        if let lastRef = UserDefaults.standard.string(forKey: "DefaultProperty"),
            let associatedImage = images.first(where: {$0.propertyID == lastRef}) {
            // case default
            print("Recuperiamo l'immagine di default dell'ultima prop usata")
            
            if let propertyData = try? associatedImage.snapShot?.data(as: PropertyCurrentData.self,decoder: userDecoder) {

                handle(propertyData,associatedImage.currentUserRole,associatedImage.snapShot)
                
            } else { handle(nil,nil,nil) }
            

        } else if let first = images.first {
            // case nodDefault - pick first
            print("Recuperiamo la prima Immagine delle prop")
            
            if let propertyData = try? first.snapShot?.data(as: PropertyCurrentData.self,decoder:userDecoder) {
                
                print("Decodificata la prop: \(String(describing: propertyData.info?.intestazione))")
                
                handle(propertyData,first.currentUserRole,first.snapShot)
                
            } else {
                print("Prop NON Decodificata")
                handle(nil,nil,nil)
            }
            
        } else {
            // Caso raro.
            print("No DefaultProp - Error to pik the first - No Value handle")
            handle(nil,nil,nil)
        }
    }

func checkPropertyExist(for id:String) async throws -> Bool {
    
    let document = collectionManaged.document(id)
    
    let alreadyExist = try await document.getDocument().exists
    print("[2]Verifica unicità. Property exist?:\(alreadyExist.description)")
    return alreadyExist
    
}

func propertyFirstRegistration(
    property:PropertyModel,
    userEncoder:Firestore.Encoder) async throws {
    print("[CALL]_propertyFirstRegistration")
        
    let document = collectionManaged.document(property.id)
      
    try document.setData(
        from: property,
        encoder: userEncoder)
 
    }
    
    
// Multi Property

/// Utile nella goAction per estrapolare una currentProperty da uno Snap

func estrapolaPropertyData(from propertyImage:PropertyLocalImage) {

    guard let snap = propertyImage.snapShot else {
        self.currentPropertyPublisher.send((nil,nil,nil))
        return
    }
    
    let userDecoder = {
        let decoder = Firestore.Decoder()
        decoder.userInfo[UserCloudData.decoderCase] = UserCloudData.DecodingCase.organigramma
        return decoder
    }()
    
    print("[CALL]_estrapolaPropertyData_from:Snap_Valido")
    
    let propertyData = try? snap.data(as: PropertyCurrentData.self,decoder: userDecoder)
    
    guard let propertyData else {
        self.currentPropertyPublisher.send((nil,nil,nil))
        return }
    
    let currentUserRole = propertyImage.currentUserRole
    
    let propertyID = propertyImage.propertyID
    UserDefaults.standard.set(propertyID,forKey: "DefaultProperty")
    
    self.currentPropertyPublisher.send((propertyData,currentUserRole,snap))

}

} // close propertyManager

class SubSyncroManager<Item:Codable> {
    
    var listener:ListenerRegistration?
    var main = PassthroughSubject<[Item]?,Error>()
 
    init() { }
}

public final class SubCollectionManager {
 
    private let db_base = Firestore.firestore()
    var currentPropertySnap:QueryDocumentSnapshot?

    public init() {
        
        print("[INIT]_CloudDataManager")
    }
    deinit {
            print("[DEINIT]_CloudDataManagerManager")
        }

    public enum CollectionKey:String {
        
         case propertyCollection = "properties_registered" // properties_library
         case businessUser = "user_business" // user_business_library
         case ingredientCollection = "ingredients_library"
         case categoriesCollection = "categories_library" // -> categories_library
     }

    var allMyProductsPublisher:SubSyncroManager<DishModel> = SubSyncroManager()
    var allMyIngredientsPublisher:SubSyncroManager<IngredientModel> = SubSyncroManager()
    var allMyMenuPublisher:SubSyncroManager<MenuModel> = SubSyncroManager()
    var allMyCategoriesPublisher:SubSyncroManager<CategoriaMenu> = SubSyncroManager()
    var allMyReviewsPublisher:SubSyncroManager<DishRatingModel> = SubSyncroManager()
    
    var news = PassthroughSubject<String?,Error>()
    var modified = PassthroughSubject<String?,Error>()
    var removed = PassthroughSubject<String?,Error>()
    
    func retrieveCloudData() {
        
        print("[CALL]_retrieveCloudData_thread:\(Thread.current)")
        
        guard let currentPropertySnap else {
          //  self.cloudDataPublisher.send(nil)
            return }
        
        let mainRef = currentPropertySnap.reference
      
        
     //   Task { // Nota 07.09.23
            
           listenAndPublishSubCollection(
                from: mainRef,
                for: .allMyCategories,
                type: CategoriaMenu.self,
                syncroWith: \.allMyCategoriesPublisher)
  
            
            print("[END_CALL]_listenAndPublishSubCollection(.allMyCategories)")
        
        listenAndPublishSubCollection(
             from: mainRef,
             for: .allMyIngredients,
             type: IngredientModel.self,
             syncroWith: \.allMyIngredientsPublisher)

          /*  DispatchQueue.main.async {
                self[keyPath: \.allMyCategoriesManager].publisher.send(completion: .finished)
              //  self.allMyCategoriesManager.publisher.send(completion: .finished) // qua non funzia
            }*/
            
           /* let allMyCategories = await retrieveSubCollection(
                from: mainRef,
                for: .allMyCategories,
                type: CategoriaMenu.self) */
            
          //  currentData.allMyCategories = await GlobalDataManager.shared.categoriesManager.joinCategories(from: allMyCategories)
            
         /*   print("After Categories:Count:\(currentData.allMyCategories.count)_PreINGimages Count")

            let ingredientsImages:[IngredientModelImage] = await retrieveSubCollection(
                from: mainRef,
                for: .allMyIngredients,
                type: IngredientModelImage.self)
            
            print("PreIngredientsManager:Count\(currentData.allMyIngredients.count) -After INGImages:Count:\(ingredientsImages.count)")

            currentData.allMyIngredients = await GlobalDataManager.shared.ingredientsManager.retrieveModel(from: ingredientsImages)

            print("PreDish:Count\(currentData.allMyDish.count)-After ING:Count:\(currentData.allMyIngredients.count)")
            
            currentData.allMyDish = await retrieveSubCollection(
                from: mainRef,
                for: .allMyDish,
                type: DishModel.self)
            
            print("PreMenu:Count\(currentData.allMyMenu.count)-After dish:Count:\(currentData.allMyDish.count)")
            
            currentData.allMyMenu  = await retrieveSubCollection(
                from: mainRef,
                for: .allMyMenu,
                type: MenuModel.self)
            
            print("PreReview:Count\(currentData.allMyReviews.count)-After Menu:Count:\(currentData.allMyMenu.count)")
            
            currentData.allMyReviews = await retrieveSubCollection(
                from: mainRef,
                for: .allMyReviews,
                type: DishRatingModel.self) */
            
          /*  print("PreCategories:Count\(currentData.allMyCategories.count)-After Reviews:Count:\(currentData.allMyReviews.count)")
            
            currentData.allMyCategories = await retrieveSubCollection(
                from: mainRef,
                for: .allMyCategories,
                type: CategoriaMenu.self)*/
            
          //  print("Pre handle-After Categories:Count:\(currentData.allMyCategories.count)")
            
           // self.cloudDataPublisher.send(currentData)
      //  }
 
    }
    
    func listenAndPublishSubCollection<Item:MyProStarterPack_L0 & Codable>(
        from propertyRef:DocumentReference,
        for subKey:CloudDataStore.SubCollectionKey,
        type:Item.Type,
        syncroWith:ReferenceWritableKeyPath<SubCollectionManager,SubSyncroManager<Item>>)
{
     // Mettiamo un listener alle subCollection. Per categorie e Ingredienti il decoder delle sub deve essere impostato come valore di default nelle loro struct
        
     //   print("[CALL]_retrieveSubCollection_thread:\(Thread.current)")
        
        let subCollection = propertyRef.collection(subKey.rawValue)
        
        // creiamo il listener

            self[keyPath: syncroWith].listener = subCollection.addSnapshotListener(includeMetadataChanges: true, listener: { [weak self] querySnap, error in

             guard let self,
                   let snapShot = querySnap else {
                 
                 print("[ERROR]_listenAndPublishSubCollection")
                 
                // self?[keyPath: syncroWith].main.send(nil)
                 self?[keyPath: syncroWith].main.send(nil)
                // self?[keyPath: syncroWith].publisher.send(completion: .finished)
                 return
             }
                
             // read MetaData
                    
        let source = snapShot.metadata.isFromCache
        let pending = snapShot.metadata.hasPendingWrites
                
        guard !pending else {
                    print("[PENDING]_cambiamenti locali. In attesa di snap dal server")
                    return
                }
                print("[METADATA_SOURCE]_hasPendingWrite:\(pending.description)\n_isFromCache:\(source.description)\nModelType:\(type)")
               
        let documents = snapShot.documents
                    
        guard !documents.isEmpty else {
         print("[Error] SubCollection fail to get Documents or there are not Documents")
                      //  self[keyPath: syncroWith].main.send(nil)
            self[keyPath: syncroWith].main.send(nil)
           /* self[keyPath: syncroWith].news.send(completion: .finished)
            self[keyPath: syncroWith].modified.send(completion: .finished)
            self[keyPath: syncroWith].removed.send(completion: .finished)*/
                        return
                    }
                    
            snapShot.documentChanges.forEach { doc in
                        
                if doc.type == .modified {
                    print("[Doc_Change]_modified")
                    //let item = try? doc.document.data(as: CategoriaMenu.self)
                    self.modified.send(doc.document.documentID)
                    }
                        
                else if doc.type == .added { 
                    print("[Doc_Change]_added")
                    // in primo avvio me li da tutti added. Non mi garba per il discorso di segnalare visivamente modifiche e nuovi arrivi
                    self.news.send(doc.document.documentID)
                }
                        
                else if doc.type == .removed { 
                    print("[Doc_Change]_removed")
                    self.removed.send(doc.document.documentID)
                }
                        
                else { 
                    print("[Doc_Change]_noOperation")
                    // no operation Occur
                }

            }
 
           /* for snap in documents {
                
                let item = try? snap.data(as: Item.self)
                
                self[keyPath: pathPublisher].send(item)
                print("[SNAP_LOOP]_listenAndPublishSubCollection_item:\(item?.id ?? "n/a")")
            }
            print("[END_CALL]_listenAndPublishSubCollection")
            print("SYNCRO_EXIST:\(self[keyPath: pathPublisher].values)")
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self[keyPath: pathPublisher].send(completion: .finished)
                    print("[END_CALL]_listenAndPublishSubCollection_afterCompletion")
                } */

                
                let allItems:[Item] = documents.compactMap { snap -> Item?  in
                    
                    let item = try? snap.data(as: Item.self)
                    return item
                    
                }
                
                print("[END]_listenAndPublishSubCollection_allItems:\(allItems.count)")
                
                self[keyPath: syncroWith].main.send(allItems)
           
                
            }) // chiusa listener
            
    }
    
    /// deprecata
   /* func retrieveSubCollection<Item:MyProStarterPack_L0 & Codable>(
        from propertyRef:DocumentReference,
        for subKey:CloudDataStore.SubCollectionKey,
        type:Item.Type) async -> [Item] {
     // Mettiamo un listener alle subCollection. Per categorie e Ingredienti il decoder delle sub deve essere impostato come valore di default nelle loro struct
        
     //   print("[CALL]_retrieveSubCollection_thread:\(Thread.current)")
        
        let subCollection = propertyRef.collection(subKey.rawValue)
        
        let documents = try? await subCollection.getDocuments().documents
        
        guard let documents,
              !documents.isEmpty else {
            print("[Error] SubCollection fail to get Documents or there are not Documents")
            return []
        }
        
        let allItem = documents.compactMap ({ snap -> Item? in
            
            let item = try? snap.data(as: Item.self)
            return item
            
        })
        
        print("[End] retrieveSubCollection. IsEmpty?:\(allItem.isEmpty)")
        return allItem
        
    }*/
    
  /* func publishIngOnLibrary(model:[IngredientModel]) async throws {
        
        // filtra gli ingredient per quelli che hanno modifiche significative
        // salva nella library gli ing modificati come nuovi Ing
        
        let collection = self.db_base.collection(CollectionKey.ingredientCollection.rawValue)

        for ing in model {
            try collection.document(ing.id)
                .setData(from: ing)
            print("[SingleING] inside loop for ing:\(ing.intestazione)")
        }

        print("[] End publishIngOnLibrary")
    }*/
    
   /* func publishCloudData(for propertyId:String,from data:CloudDataStore) async throws {
        
        let propertyRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyId)
        
       try await publishMultipleSubCollection(in: propertyRef, from: data)
        
    }*/
    
   /* private func publishMultipleSubCollection(in propertyDocRef:DocumentReference,from cloudData:CloudDataStore) async throws {
        
        let ingImage = cloudData.allMyIngredients.map({$0.retrieveImageFromSelf()})
        
        try await publishSubCollection(in: propertyDocRef, sub: .allMyIngredients, as: ingImage)
        
        try await publishSubCollection(in: propertyDocRef, sub: .allMyDish, as: cloudData.allMyDish)
        try await publishSubCollection(in: propertyDocRef, sub: .allMyMenu, as: cloudData.allMyMenu)
        try await publishSubCollection(in: propertyDocRef, sub: .allMyCategories, as: cloudData.allMyCategories)
        try await publishSubCollection(in: propertyDocRef, sub: .allMyReviews, as: cloudData.allMyReviews)
        
        
    }*/
    
  /*  private func publishSubCollection<Item:MyProStarterPack_L0 & Codable>(in propertyRef:DocumentReference,sub collectionKey:CloudDataStore.SubCollectionKey, as items:[Item]) async throws {
        
        let collectionRef = propertyRef.collection(collectionKey.rawValue)
                
        for element in items {
            
           try collectionRef
                .document(element.id)
                .setData(from: element, merge:true)
            
        }
    }*/
    
     func publishSubCollection<Item:MyProStarterPack_L0 & Codable>(
        sub collectionKey:CloudDataStore.SubCollectionKey,
        as items:[Item]) async throws {
        
        guard let currentPropertySnap else {
                return
            }
        let propertyID = currentPropertySnap.documentID
            
        let batch = self.db_base.batch()
            
        let collectionRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue)
             .document(propertyID)
             .collection(collectionKey.rawValue)
            
            print("[COLLECTION]_\(collectionKey.rawValue)_exist:\(collectionRef.description)")
            
        for element in items {
            
              let ref = collectionRef.document(element.id)
              try batch.setData(from: element, forDocument: ref, merge: true)
            
        }
         
            try await batch.commit()
    }
    
    func publishBatchSubCollection<Item:MyProStarterPack_L0 & Codable>(
       sub collectionKey:CloudDataStore.SubCollectionKey,
       newOrEdited items:[Item],
       removed:[String]) async throws {
           
           guard let currentPropertySnap else {
                   return
               }
           let propertyID = currentPropertySnap.documentID
               
           let batch = self.db_base.batch()
           
           let collectionRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue)
                .document(propertyID)
                .collection(collectionKey.rawValue)
           
           for element in items {
               // salva
                 let ref = collectionRef.document(element.id)
                 try batch.setData(from: element, forDocument: ref, merge: true)
               
           }
           
           for id in removed {
               // rimuove
               let ref = collectionRef.document(id)
               batch.deleteDocument(ref)
               
           }
           
          try await batch.commit()
       }
    
    
    /// Metodo valido per Categorie e Ingredienti quando modifchiamo un oggetto esistente. Eliminiamo il vecchio e salviamo il nuovo
    func setDataSubCollectionSingleDocument<Item:MyProStarterPack_L0 & Codable>(
        forPropID propertyID:String,
        sub collectionKey:CloudDataStore.SubCollectionKey,
        save newItem:Item) async throws {
           
        let subCollection = self.db_base
                .collection(CollectionKey
                    .propertyCollection
                    .rawValue)
                .document(propertyID)
                .collection(collectionKey.rawValue)
            
        try subCollection
                .document(newItem.id)
                .setData(from: newItem, merge: true)

    }
    
    func deleteDataFromSubCollection(
        forPropID propertyID:String,
        sub collectionKey:CloudDataStore.SubCollectionKey,
        delete itemsId:[String]) async throws {
        
        let subCollection = self.db_base
                .collection(CollectionKey
                    .propertyCollection
                    .rawValue)
                .document(propertyID)
                .collection(collectionKey.rawValue)
            
            for item in itemsId {
                
                try await subCollection
                    .document(item)
                    .delete()
                
            }
                
        
    }
    
   /* func setDataSubCollectionAndLibrary<Item:MyProStarterPack_L0 & Codable>(
        forPropID propertyID:String,
        sub collectionKey:CloudDataStore.SubCollectionKey,
        libraryPath mainCollection:ReferenceWritableKeyPath<CloudDataManager,AnyClass>,
        as item:Item) throws {
            
            
            Task {
                
               // categoriesManager
                  //  .publishSingleCategoryInSharedLibrary(categoria:item)
                    
                
                
                try await setDataSubCollectionSingleDocument(
                    forPropID: propertyID,
                    sub: collectionKey,
                    as: item)
                
            }
            
            
           
            
            
            
            
        } */
    


} // close cloudDataManager

public final class CategoriesManager {
    
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    
   // private var cancellables = Set<AnyCancellable>()
    
    public init() {
        collectionManaged = self.db_base.collection("categories_library")
       // publishJoinedCategoriesFromSubscriber()
        print("[INIT]_CategoriesManager")
    }
    
    deinit {
            print("[DEINIT]_CategoriesManager")
        }
    
    /// publisher ascoltato per lavorare con la libreria delle categorie
    let sharedCategoriesPublisher = PassthroughSubject<([CategoriaMenu]?,QueryDocumentSnapshot?),Error>()
    
    func publishCategoriesFromSharedCollection(filterBy:String) {
        
        let customDecoder:Firestore.Decoder = {
           
            let decoder = Firestore.Decoder()
            decoder.userInfo[CategoriaMenu.codingInfo] = MyCodingCase.mainCollection
            return decoder
        }()
        
        collectionManaged
            .whereField("intestazione", isGreaterThanOrEqualTo:filterBy)
            .order(by: "intestazione", descending: false)
            .getDocuments { querySnap, error in
                
                guard let querySnap else {
                    // no value to push
                    print("[ERROR SNAP]_QueryNonValida")
                    self.sharedCategoriesPublisher.send((nil,nil))
                    return
                }
                
                let docs = querySnap.documents
                
                let categories = docs.compactMap { snap -> CategoriaMenu? in
                    
                    let categoria = try? snap.data(as: CategoriaMenu.self,decoder: customDecoder)
                    return categoria
                    
                }
                
            // categories shoul be optional ?
                self.sharedCategoriesPublisher.send((categories,nil))

            }
        
    }
    
  /*  let joinedCategoriesPubliher = PassthroughSubject<[CategoriaMenu]?,Error>()
    func addCategoriesSubscriberAndRepublish() {
        
        GlobalDataManager
            .shared
            .cloudDataManager
            .allMyCategoriesPublisher
            .sink { error in
                //
            } receiveValue: { [weak self] myCategories in
                
                guard let self,
                      let myCategories else {
                    
                    self?.joinedCategoriesPubliher.send(nil)
                    return
                }
                
                Task {
                    let joinedCategories = try? await self.joinCategories(from: myCategories)
                    self.joinedCategoriesPubliher.send(joinedCategories)
                }
                
            }.store(in: &cancellables)

    }*/
    
    func joinCategories(from myCategories:[CategoriaMenu]) async throws ->  [CategoriaMenu] {
        
        guard !myCategories.isEmpty else { return [] }
        
        let allCategoriesID = myCategories.map({$0.id})
       // guard !allCategoriesID.isEmpty else { return [] }
        
       let allSharedSnap = try? await collectionManaged
            .whereField(.documentID(), in: allCategoriesID)
            .getDocuments()
        
        guard let allSharedSnap else {
            print("[ERROR]_No Shared Docs for myCategories")
            return []
        }
        
        let sharedCategoryDecode:Firestore.Decoder = {
           
            let decoder = Firestore.Decoder()
            decoder.userInfo[CategoriaMenu.codingInfo] = MyCodingCase.mainCollection
            return decoder
            
        }()
        
        let fullCategories = allSharedSnap.documents.compactMap { snap -> CategoriaMenu? in
            
            let sharedCategory = try? snap.data(as: CategoriaMenu.self,decoder: sharedCategoryDecode)
            
            guard var sharedCategory else {
                return nil
            }
            
            if let myCategorieAssociated = myCategories.first(where: {$0.id == sharedCategory.id}) {
                
                sharedCategory.descrizione = myCategorieAssociated.descrizione
                sharedCategory.listIndex = myCategorieAssociated.listIndex
                return sharedCategory
            } else { return nil }
            
        }
        
        return fullCategories.sorted(by: {$0.listIndex ?? 999 < $1.listIndex ?? 999})
        
    }
    
    func publishSingleCategoryInSharedLibrary(categoria:CategoriaMenu) async throws {
        
        let customEncoder:Firestore.Encoder = {
            let encoder = Firestore.Encoder()
            encoder.userInfo[CategoriaMenu.codingInfo] = MyCodingCase.mainCollection
            return encoder
        }()
        
       try collectionManaged
            .document(categoria.id)
            .setData(from: categoria,encoder: customEncoder)
        
    } // obsoleta
    
    func publishInMainCollection(items:[CategoriaMenu]) async throws {
 
       let batch = self.db_base.batch()
 
       let customEncoder:Firestore.Encoder = {
            let encoder = Firestore.Encoder()
            encoder.userInfo[CategoriaMenu.codingInfo] = MyCodingCase.mainCollection
            return encoder
        }()
        
       for element in items {
           
             let ref = collectionManaged.document(element.id)
             try batch.setData(from: element, forDocument: ref, encoder: customEncoder)
           
       }
        
        try await batch.commit()
   }
    
    
    func checkCategoryAlreadyExistInLibrary(categoria:CategoriaMenu) async throws -> String? {
        
        // trattasi di una categoria creata dall'utente che potrebbe esistere con diverso id, ma con uguale nome ed mojy
     
       let query = collectionManaged
            .whereField(CategoriaMenu.CodingKeys.intestazione.rawValue, isEqualTo: categoria.intestazione)
            .whereField(CategoriaMenu.CodingKeys.emoji.rawValue, isEqualTo: categoria.image)
           
        let docs = try await query.getDocuments()
        
        if let doc = docs.documents.first {
            
            return doc.documentID
            
        } else {
            return nil
        }

    }
    /// salva la categoria nella subCollection della proprietà corrente
   /* func publishCategoryInPropertySubCollection(propertyID:String,categoria:CategoriaMenu) async throws {
        
        let subCollection = self.db_base.collection("properties_registered").document(propertyID).collection("all_my_categories")
        
       try subCollection
            .document(categoria.id)
            .setData(from: categoria, merge: true,encoder: Firestore.Encoder())

    }*/ // forse non serve 11.09.23 non usata
    
} // close CategoriesManager

public final class IngredientManager {

private let db_base = Firestore.firestore()
private let collectionManaged:CollectionReference

public init() {
    collectionManaged = self.db_base.collection("ingredients_library")
    print("[INIT]_IngredientManager")
}
    
deinit {
        print("[DEINIT]_IngredientManager")
    }

    /// publisher ascoltato per lavorare con la libreria degli Ingredienti
    let ingredientLibraryPublisher = PassthroughSubject<([IngredientModel]?,QueryDocumentSnapshot?),Error>()
    
    var lastQuery:Query?
    
    func libraryCount() async throws -> Int {
        
       print("[CALL]_libraryCount_ingredientManager")
        
       let snap = try await collectionManaged.count.getAggregation(source: .server)
        return Int(truncating: snap.count)
    }
    
    func fetchFromSharedCollection(useCoreFilter filterCore:CoreFilter<IngredientModel>,startAfter:DocumentSnapshot?) {
        
        print("[CALL]_fetchIngredientFromSharedCollection")
        
        let letter:String = {
            
            filterCore.stringaRicerca == "" ? "A" : filterCore.stringaRicerca.lowercased()
            
        }()
        
        let properties = filterCore.filterProperties
       
        let currentQuery = collectionManaged
            .whereField("intestazione", isGreaterThanOrEqualTo:letter)
            .csWhereField(isEqualTo: properties.provenienzaING, in: .provenienza)
            .csWhereField(isEqualTo: properties.produzioneING, in: .produzione)
            .csWhereField(isEqualTo: properties.origineING, in: .origine)
            .csWhereField(contain: properties.allergeniIn, in: .allergeni)
                    
        guard self.lastQuery != currentQuery else {
            // la query è stata ripetuta
            self.ingredientLibraryPublisher.send((nil,nil))
            return
            
        }
        
        let count = currentQuery.count.getAggregation(source: .server) { result, error in
            
            guard let result else { return }
            
            
        }
        
            // nuova query
            self.lastQuery = currentQuery
            executiveFetchFromSharedCollection(startAfter: startAfter)
        
      
        
    }
    
    func executiveFetchFromSharedCollection(startAfter:DocumentSnapshot?) {
        
        let customDecoder:Firestore.Decoder = {
           
            let decoder = Firestore.Decoder()
            decoder.userInfo[IngredientModel.codingInfo] = MyCodingCase.mainCollection
            return decoder
        }()
        
       guard let lastQuery else {
           self.ingredientLibraryPublisher.send((nil,nil))
           return
       }
       
       lastQuery
            .limit(to: 3)
            .csStartAfter(document: startAfter)
           // .order(by: "intestazione", descending: false)
            .getDocuments { querySnap, error in
                
                guard let querySnap else {
                    // no value to push
                    print("[ERROR SNAP]_QueryNonValida")
                    self.ingredientLibraryPublisher.send((nil,nil))
                    return
                }
                
                let docs = querySnap.documents
                var lastSnap:QueryDocumentSnapshot?
  
                let allIng = docs.compactMap { snap -> IngredientModel? in
                    
                    let ing = try? snap.data(as: IngredientModel.self,decoder: customDecoder)

                    if docs.last == snap {
                        lastSnap = snap
                    }
                    
                    return ing
                    
                }

                self.ingredientLibraryPublisher.send((allIng,lastSnap))

            }
    }
    
    
    func joinIngredients(from myIngredients:[IngredientModel]) async throws -> [IngredientModel] {
        
        guard !myIngredients.isEmpty else { return [] }
        
        let allIngID = myIngredients.compactMap({$0.id})
        
        let allIngSnap = try? await collectionManaged
            .whereField(.documentID(), in: allIngID)
            .getDocuments()
        
        guard let allIngSnap else {
            print("NESSUN DOCUMENTS DAL getDocument()")
            return [] }
        
        let decodeFromLibrary:Firestore.Decoder = {
           
            let decoder = Firestore.Decoder()
            decoder.userInfo[IngredientModel.codingInfo] = MyCodingCase.mainCollection
            return decoder
            
        }()
        
        let joinedING = allIngSnap.documents.compactMap { snap -> IngredientModel? in
            
            let sharedING = try? snap.data(as: IngredientModel.self,decoder: decodeFromLibrary)
            
            guard var sharedING else {
                print("[ERROR]_ING non ricavato dallo snap")
                return nil }
            
            if let associatedING = myIngredients.first(where: {$0.id == sharedING.id }) {
                
                print("[JOIN_ING_SUCCESS]:\(associatedING.id)")
                
                sharedING.descrizione = associatedING.descrizione
                sharedING.status = associatedING.status
                return sharedING
                
            } else { return nil }
        }
        
        return joinedING.sorted(by: {$0.intestazione < $1.intestazione})
    }
    
/*func retrieveModel(from images:[IngredientModelImage]) async -> [IngredientModel] {
    
    print("Inside IngredientManager.retrieveModel")
    
    let allIngRef = images.map({$0.id})
    
    guard !allIngRef.isEmpty else { return [] }
    
    let allIngSnap = try? await collectionManaged
        .whereField(.documentID(), in: allIngRef)
        .getDocuments()
    
    guard let allIngSnap else {
        print("NESSUN DOCUMENTS DAL getDocument()")
        return [] }
    
    let allModel = allIngSnap.documents.compactMap { snap -> IngredientModel? in
        
        let model = try? snap.data(as: IngredientModel.self)
        
        guard var model else {
            print("ingredientModel non ricavato dallo snap")
            return nil }
        
        guard let associatedImage = images.first(where: {$0.id == model.id }) else {
            print("Ingredient Model:\(model.id) != da images associated")
            return nil }
        
        model.descrizione = associatedImage.descrizione
        model.status = associatedImage.status
        
        return model
        
    }
    print("END IngredientManager.retrieveModel.Count \(allModel.count)")
    return allModel
}*/

} // close IngredientManagar
