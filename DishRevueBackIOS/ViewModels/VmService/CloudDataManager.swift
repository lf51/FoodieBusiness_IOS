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

//@MainActor
public class GlobalDataManager {

    static let shared = GlobalDataManager()
    
   // let gdmQueue:DispatchQueue = DispatchQueue(label: "com.foodiesBusiness.globalDataManager")
    
    let userManager:UserManager = UserManager()
    let propertiesManager:PropertyManager = PropertyManager()
    let cloudDataManager:CloudDataManager = CloudDataManager()
    let ingredientsManager:IngredientManager = IngredientManager()
    let categoriesManager:CategoriesManager = CategoriesManager()
    
    public init() {
        print("[INIT]_GlobalDataManager")
    }
    
} // close GlobalDataManager

public class CategoriesManager {
    
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    
    public init() {
        collectionManaged = self.db_base.collection("dish_categories")
        print("[INIT]_CategoriesManager")
    }
    
    let sharedCategoriesPublisher = PassthroughSubject<[CategoriaMenu]?,Error>()
    
    func retrieveCategoriesFromSharedCollection(filterBy:String?) {
        
        let customDecoder:Firestore.Decoder = {
           
            let decoder = Firestore.Decoder()
            decoder.userInfo[CategoriaMenu.decodingInfo] = CategoriaMenu.DecodingCase.categoriesMainCollection
            return decoder
        }()
        
        collectionManaged
           // .whereField("intestazione", isLessThanOrEqualTo: filterBy)
            .getDocuments { querySnap, error in
                
                guard let querySnap else {
                    // no value to push
                    self.sharedCategoriesPublisher.send(nil)
                    return
                }
                
                let docs = querySnap.documents
                
                let categories = docs.compactMap { snap -> CategoriaMenu? in
                    
                    let categoria = try? snap.data(as: CategoriaMenu.self,decoder: customDecoder)
                    return categoria
                    
                }
                
            // categories shoul be optional ?
                self.sharedCategoriesPublisher.send(categories)

            }
        
    }
    
}

public class IngredientManager {

private let db_base = Firestore.firestore()
private let collectionManaged:CollectionReference

public init() {
    collectionManaged = self.db_base.collection("ingredients_library")
    print("[INIT]_IngredientManager")
}
    
deinit {
        print("[DEINIT]_IngredientManager")
    }

func retrieveModel(from images:[IngredientModelImage]) async -> [IngredientModel] {
    
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
}

} // close IngredientManagar
/// Gestisce la collezione userBusiness
public class UserManager {
   // static var main:UserManager = UserManager()
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    
    public init() {
        collectionManaged = self.db_base.collection("user_business")
        
        print("[INIT]_UserManager.RefCount")
    }
    
    deinit {
            print("[DEINIT]_UserManager")
        }

    
    var userListener:ListenerRegistration?
    let userPublisher = PassthroughSubject<UserCloudData?,Error>()
    
    func fetchAndListenUserDataPublisher(from id:String) {
        
       // let userPublisher = PassthroughSubject<UserCloudData?,Error>()
        print("[CALL]-fetchAndListenUserDataPublisher_THREAD:\(Thread.current)")
        
        let docRef = collectionManaged.document(id)
        
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
    
    func publishUserCloudData(forUser id:String, from userData:UserCloudData, to customEncoder: Firestore.Encoder = Firestore.Encoder()) async throws {
        print("[CALL]_publishUserCloudData")
        
        let document = collectionManaged.document(id)
        try document.setData(
            from: userData,
            merge: true,
            encoder: customEncoder)
    }
    
    func updatePropertiesRef(user:UserCloudData) async throws {
        print("[CALL]_updatePropertiesRef")
        
        let docRef = collectionManaged.document(user.id)
        
        try docRef
            .setData(from: user, mergeFields: ["user_properties_ref"])
      
    }
    
} // close UserManager

public class PropertyManager {

private let db_base = Firestore.firestore()
private let collectionManaged:CollectionReference

public enum PropertyMainCodingKeys:String,CodingKey {
    // le main Key del documento della proprietà su firebase. Utilizzabili fuori. 05.09.23 in uso su PropertyLocalImage
    case propertyInventario = "property_inventario"
    case propertySetup = "property_setup"
    case propertyInfo = "property_info"

}


public init() {
    collectionManaged = self.db_base.collection("properties_registered")
    print("[INIT]_PropertyManager")
    
}
    
deinit {
        print("[DEINIT]_PropertyManager")
        }

    
var propertyImagesListener:ListenerRegistration?
let propertyImagesPublisher = PassthroughSubject<[PropertyLocalImage]?,Error>()
    /// contiamo i cambiamenti nei documenti per notifiche
let propertyAllDataChanges = PassthroughSubject<Int?,Error>()
    
let currentPropertyPublisher = PassthroughSubject<(PropertyCurrentData?,CurrentUserRoleModel?,QueryDocumentSnapshot?),Error>() // deprecata

func fetchAndListenPropertyImagesPublisher(from ref:[String],for userUID:String) {
    
    print("[CALL]_fetchAndListenPropertyImagesPublisher/removeListener before listen again_thread:\(Thread.current)")
        
        self.propertyImagesListener?.remove()
        
        self.propertyImagesListener = collectionManaged
            .whereField(.documentID(), in: ref)
            .addSnapshotListener({ [weak self] querySnapshot, error in
                
                print("[START]_LISTENER_PROP_IMAGES/startingRef:\(ref.count)/querCount:\(String(describing: querySnapshot?.documents.count))")
                
            guard let self,
                  let snapShot = querySnapshot else {
                    
                print("Errore nel listener:\(error?.localizedDescription ?? "")")
                // publisher.send(nil)
                self?.propertyImagesPublisher.send(nil)
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
                    dec.userInfo[UserCloudData.decoderCase] = UserCloudData.DecodingCase.propertyLocalImage(userUID)
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
                } else {
                    print("[FAIL DATA SEND]_fetchAndListenPropertyImagesPublisher")
                    self.propertyImagesPublisher.send(nil)
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

            guard let propertyDocRef,
            let currentProperty,
            let currentUserRole else {
                print("[ERROR]_Retrieve transitionData FAIL")
                // publisher.send(nil)
                self?.currentPropertyPublisher.send((nil,nil,nil))
                return
            }
            
            self?.currentPropertyPublisher.send((currentProperty,currentUserRole,propertyDocRef))

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

public class CloudDataManager {
   // static var shared:CloudDataManager = CloudDataManager()
    private let db_base = Firestore.firestore()
    
    public init() {
        print("[INIT]_CloudDataManager")
    }
    deinit {
            print("[DEINIT]_CloudDataManagerManager")
        }

    public enum CollectionKey:String {
         case propertyCollection = "properties_registered"
         case businessUser = "user_business"
         case ingredientCollection = "ingredients_library"
     }
    
    let cloudDataPublisher = PassthroughSubject<CloudDataStore?,Error>()
    
    func retrieveCloudData(from propertyDocSnap:QueryDocumentSnapshot) {
        
        print("[CALL]_retrieveCloudData_thread:\(Thread.current)")
        
        let mainRef = propertyDocSnap.reference
        
        Task { // Nota 07.09.23
            
           // print("[TASK]_retrieveCloudData_thread:\(Thread.current)")
            var currentData = CloudDataStore()
            
            print("PreINGimages Count")
            
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
                type: DishRatingModel.self)
            
            print("PreCategories:Count\(currentData.allMyCategories.count)-After Reviews:Count:\(currentData.allMyReviews.count)")
            
            currentData.allMyCategories = await retrieveSubCollection(
                from: mainRef,
                for: .allMyCategories,
                type: CategoriaMenu.self)
            
            print("Pre handle-After Categories:Count:\(currentData.allMyCategories.count)")
            
            self.cloudDataPublisher.send(currentData)
        }
 
    }
    
    func retrieveSubCollection<Item:MyProStarterPack_L0 & Codable>(from propertyRef:DocumentReference, for subKey:CloudDataStore.SubCollectionKey,type:Item.Type) async -> [Item] {
     
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
        
    }
    
    func publishIngOnLibrary(model:[IngredientModel]) async throws {
        
        // filtra gli ingredient per quelli che hanno modifiche significative
        // salva nella library gli ing modificati come nuovi Ing
        
        let collection = self.db_base.collection(CollectionKey.ingredientCollection.rawValue)

        for ing in model {
            try collection.document(ing.id)
                .setData(from: ing)
            print("[SingleING] inside loop for ing:\(ing.intestazione)")
        }

        print("[] End publishIngOnLibrary")
    }
    
    func publishCloudData(for propertyId:String,from data:CloudDataStore) async throws {
        
        let propertyRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyId)
        
       try await publishMultipleSubCollection(in: propertyRef, from: data)
        
    }
    
    private func publishMultipleSubCollection(in propertyDocRef:DocumentReference,from cloudData:CloudDataStore) async throws {
        
        let ingImage = cloudData.allMyIngredients.map({$0.retrieveImageFromSelf()})
        
        try await publishSubCollection(in: propertyDocRef, sub: .allMyIngredients, as: ingImage)
        
        try await publishSubCollection(in: propertyDocRef, sub: .allMyDish, as: cloudData.allMyDish)
        try await publishSubCollection(in: propertyDocRef, sub: .allMyMenu, as: cloudData.allMyMenu)
        try await publishSubCollection(in: propertyDocRef, sub: .allMyCategories, as: cloudData.allMyCategories)
        try await publishSubCollection(in: propertyDocRef, sub: .allMyReviews, as: cloudData.allMyReviews)
        
        
    }
    
    private func publishSubCollection<Item:MyProStarterPack_L0 & Codable>(in propertyRef:DocumentReference,sub collectionKey:CloudDataStore.SubCollectionKey, as items:[Item]) async throws {
        
        let collectionRef = propertyRef.collection(collectionKey.rawValue)
        
        for element in items {
            
           try collectionRef
                .document(element.id)
                .setData(from: element, merge:true)
            
        }
    }


} // close cloudDataManager

// service struct

/// oggetto per transitare i dati salvati su firebase nel PropertyCurrentData che non è codable per via del CloudDataStore, il quale non è più conforme in quanto contenitore di subCollection
/*public struct PropertyTransitionData:Codable {
    
  /*  public var userRole:UserRoleModel?
    public var info:PropertyModel
    public var inventario:Inventario
    public var setup:AccountSetup */
    
    public var userRole:UserRoleModel?
    
    public var info:PropertyModel?
    public var inventario:Inventario?
    public var setup:AccountSetup?
   
  /*  public enum MainCodingKeys:String,CodingKey {
    case propertyInventario = "property_inventario"
    case propertySetup = "property_setup"
    case propertyInfo = "property_info"
    } */
    /*
    public enum SubCodingKeys:String,CodingKey {
        case propertyInventario = "property_inventario"
        case propertySetup = "property_setup"
    } */
    
    public init(from decoder: Decoder) throws {
        print("Dentro_decodifica PropertyTransitionData")
        let container = try decoder.container(keyedBy: PropertyManager.PropertyMainCodingKeys.self) //try decoder.container(keyedBy: MainCodingKeys.self)
        print("PropertyTransitionData/created container ")
        self.info = try container.decodeIfPresent(PropertyModel.self, forKey: .propertyInfo)
        print("PropertyTransitionData/decoded info ")
        self.inventario = try container.decodeIfPresent(Inventario.self, forKey: .propertyInventario)
        print("PropertyTransitionData/decoded inventario ")
        self.setup = try container.decodeIfPresent(AccountSetup.self, forKey: .propertySetup)
        print("PropertyTransitionData/decoded setup ")
      //  self.inventario = Inventario()
       // self.setup = AccountSetup()
       // let subContainer = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .propertyData)
        
      //  self.inventario = try subContainer.decode(Inventario.self, forKey: .propertyInventario)
      //  self.setup = try subContainer.decode(AccountSetup.self, forKey: .propertySetup)
    }
    
}*/



