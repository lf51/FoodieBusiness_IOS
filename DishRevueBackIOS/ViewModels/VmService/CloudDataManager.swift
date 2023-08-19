//
//  CloudDataManager.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/08/23.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MyFilterPackage
import MyPackView_L0


@MainActor
public class GlobalDataManager {
    
    static let user:UserManager = UserManager()
    static let property:PropertyManager = PropertyManager()
    static let cloudData:CloudDataManager = CloudDataManager()
    static let ingredients:IngredientManager = IngredientManager()
   
}

public class IngredientManager {
    
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    
    public init() {
        collectionManaged = self.db_base.collection("ingredients_library")
    }
    
    func retrieveModel(from images:[IngredientModelImage]) async -> [IngredientModel] {
        print("Inside IngredientManager.retrieveModel")
        
      let allIngRef = images.map({$0.id})
        
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
    
}
/// Gestisce la collezione userBusiness
public class UserManager {
    
   // static var main:UserManager = UserManager()
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    
    public init() {
        collectionManaged = self.db_base.collection("user_business")
    }
    
    func retrieveUserPropertyRef(forUser id:String) async throws -> UserCloudData? {
        print("[3]Start retrieveUserPropertyRef")
        let docRef = collectionManaged.document(id)
        let userData = try? await docRef.getDocument(as: UserCloudData.self)
        print("[4]End retrieveUserPropertyRef")
        return userData
        
    }
    
}

public class PropertyManager {
    
   // static var main:PropertyManager = PropertyManager()
    private let db_base = Firestore.firestore()
    private let collectionManaged:CollectionReference
    
    
    public init() {
        collectionManaged = self.db_base.collection("properties_registered")
        
    }
    
    func fetchCurrentProperty(from ref:[String]?,handle:@escaping(_ propImages:[PropertyLocalImage]?,_ currentProperty:PropertyCurrentData?) -> () ) {
        
        self.retrievePropertiesLocalImages(from: ref) { allImages in
            
            guard let allImages,
            !allImages.isEmpty else {
                print("Nessuna immagine di proprietà")
                handle(nil,nil)
                return
            }
            
            // le allImages hanno il listener
            // [15.08.23]Problema da risolvere: il listener è applicato al ref della proprietà a prescindere se lo user è autorizzato o meno
            
            // selezioniamo l'image di default
            
            self.retrievePropertyTransitionData(from: allImages) { currentPropTransitionData, propertyDocRef in
                // dati in: setup/inventario/info/userRole
                // dato mancante: cloudData
                
                guard let propertyDocRef,
                let currentPropTransitionData else {
                    handle(nil,nil)
                    return
                }
                
                GlobalDataManager.cloudData.retrieveCloudData(from: propertyDocRef) { cloudData in
                
               // CloudDataManager.shared.retrieveCloudData(from: propertyDocRef) //{ cloudData in
                    // controlliamo lo userRole perchè è impostato come optional nel transitionData
                    guard let cloudData,
                    let userRole = currentPropTransitionData.userRole else {
                        print("[ERROR] - NoCloudData or No UserRole")
                        handle(nil,nil)
                        return}
                    // dato in:CloudData
    
                    let propertyCurrentData = PropertyCurrentData(
                        userRole: userRole,
                        info: currentPropTransitionData.info,
                        inventario: currentPropTransitionData.inventario,
                        setup: currentPropTransitionData.setup,
                        db: cloudData)
                    
                    handle(allImages,propertyCurrentData)
                } // chiuda cloudData
                
            }//chiusa TransitionObject
  
        }// chiusa localImages
    } // chiusa retrieve
    
    private func retrievePropertyTransitionData(from images:[PropertyLocalImage],handle:@escaping(_ currentPropTransitionData:PropertyTransitionData?,_ propertyDocRef:QueryDocumentSnapshot?) -> ()) {
        
        if let lastRef = UserDefaults.standard.string(forKey: "DefaultProperty"),
           let associatedImage = images.first(where: {$0.propertyID == lastRef}) {
            // case default
            print("Recuperiamo l'immagine di default dell'ultima prop usata")
            
            if var propertyTransitionData = try? associatedImage.snapShot?.data(as: PropertyTransitionData.self) {
                
                propertyTransitionData.userRole = associatedImage.userRuolo
                handle(propertyTransitionData,associatedImage.snapShot)
            } else { handle(nil,nil) }
            
            

        } else if let first = images.first {
            // case nodDefault - pick first
            print("Recuperiamo la prima Immagine delle prop")
            if var propertyTransitionData = try? first.snapShot?.data(as: PropertyTransitionData.self) {
                
                propertyTransitionData.userRole = first.userRuolo
                handle(propertyTransitionData,first.snapShot)
            } else {
                handle(nil,nil)
            }
           
            
        } else {
            // Caso raro.
            print("No DefaultProp - Error to pik the first - No Value handle")
            handle(nil,nil)
        }
    }
    
    
    private func retrievePropertiesLocalImages(from ref:[String]?,handle:@escaping(_ allImages:[PropertyLocalImage]?) -> ())  {
        print("[6]Dentro retrievePropertyImages]")
        
        guard let ref,
            !ref.isEmpty else {
            
            print("[Error]_No ref properties")
          /*  let context = DecodingError.Context(
                codingPath: [UserCloudData.CodingKeys.propertiesRef],
                debugDescription: "Nessuna proprietà registrata o nessuna collaborazione avviata")*/
            handle(nil)
         //  throw DecodingError.valueNotFound(String.self, context)
            return
        }
        
        print("[7]PreCall_Listener/allRef count:\(ref.count)")

        collectionManaged
            .whereField(.documentID(), in: ref)
            .addSnapshotListener({ querySnapshot, error in
                
                print("[START]_Retrieve images ")
                
            guard let documents = querySnapshot?.documents else {
                    
                print("Errore nel listener:\(error?.localizedDescription ?? "")")
            
                handle(nil)
                return
                    
                }
                
            let allImages:[PropertyLocalImage] = documents.compactMap({ snap -> PropertyLocalImage? in
                    
                let image = try? snap.data(as: PropertyLocalImage.self)
                
                guard var propImage = image else {
                        
                    return nil
                                }
            
                    propImage.snapShot = snap
                    return propImage

                })
                
                print("[END]_Retrieve images.ImagesCount:\(allImages.count) ")
                handle(allImages)
                
                
 
            })
        
        print("[8]AfterCall_Listener")
  
    }


}

public class CloudDataManager { // 11.08.23 deve rimpiazzare il cloudDataCompiler nella gestione del database
    
   // static var shared:CloudDataManager = CloudDataManager()
    private let db_base = Firestore.firestore()
    
    public init() { }
    
    public enum CollectionKey:String {
         case propertyCollection = "properties_registered"
         case businessUser = "user_business"
         case ingredientCollection = "ingredients_library"
     }
    
    
    func retrieveCloudData(from propertyDocSnap:QueryDocumentSnapshot,handle:@escaping(_ cloudData:CloudDataStore?) -> () ) {
        
        let mainRef = propertyDocSnap.reference
        
        Task {
            
            var currentData = CloudDataStore()
            
            print("PreINGimages:Count)")
            
            let ingredientsImages:[IngredientModelImage] = await retrieveSubCollection(
                from: mainRef,
                for: .allMyIngredients,
                type: IngredientModelImage.self)
            
            print("PreIngredientsManager:Count\(currentData.allMyIngredients.count) -After INGImages:Count:\(ingredientsImages.count)")
            
            currentData.allMyIngredients = await GlobalDataManager.ingredients.retrieveModel(from: ingredientsImages)
            
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
            
            handle(currentData)
        }
 
    }
    
   /* func retrieveCloudDataStore(from propertyRef:String) async throws -> CloudDataStore {
        
        let mainRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyRef)
                
       // var emptyData = CloudDataStore()
        
        let allMyDish = try await retrieveSubCollection(
            from: mainRef,
            for: .allMyDish,
            type: DishModel.self)
       // emptyData.allMyMenu = //
       // emptyData.allMyCategories = //
       // emptyData.allMyReviews = //
       // emptyData.allMyIngredients = //
        
    
        
        
        return CloudDataStore()
    } */
    
    func retrieveSubCollection<Item:MyProStarterPack_L0 & Codable>(from propertyRef:DocumentReference, for subKey:CloudDataStore.SubCollectionKey,type:Item.Type) async -> [Item] {
        
        let subCollection = propertyRef.collection(subKey.rawValue)
                
        let documents = try? await subCollection.getDocuments().documents
        
        guard let documents else {
            print("[Error] SubCollection fail to get Documents")
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
    /*
    func publishCloudData(from currentProperty:PropertyDataObject) async throws {
        
        guard let propertyId = currentProperty.info?.id else {
            print("No Property IN")
            return }

        // end test area
        
        // salvataggio ingredienti nella library (se vi sono di nuovi)
        let allIngredients = currentProperty.db.allMyIngredients
        try await publishIngOnLibrary(model: allIngredients)
        
        print("[4] After publishIngOnLibrary - Prepublish cloudData")
        
        let collection = self.db_base.collection(CollectionKey.propertyCollection.rawValue)
        
        // Salviamo info e setting
        let propertyDocRef = collection.document(propertyId)
        
        try propertyDocRef
            .setData(from: currentProperty)
        
        // salviamo subCollection
        try await publishMultipleSubCollection(in: propertyDocRef,from: currentProperty.db)

        print("[5]End publishCloudData")
    } */
    
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
    
    func publishMainCollection<Element:Codable>(in collection:CollectionKey,idDoc ref:String,as element:Element) async throws {
        
        let document = self.db_base.collection(collection.rawValue).document(ref)
        
        try document.setData(from: element,merge: true)
 
    }
    
  /*  func firstPropertyRegistration(idDoc ref:String,as element:PropertyDataObject) async throws {
        
        let document = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(ref)

        try await publishMainCollection(in: .propertyCollection, idDoc: ref, as: element)
        
    }*/
    
    func checkPropertyExist(for id:String) async throws -> Bool {
        
        let document = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(id)
        
        let alreadyExist = try await document.getDocument().exists
        print("[2]Verifica unicità. Property exist?:\(alreadyExist.description)")
        return alreadyExist
        
    }
    
  

}

// service struct

/// oggetto per transitare i dati salvati su firebase nel PropertyCurrentData che non è codable per via del CloudDataStore, il quale non è più conforme in quanto contenitore di subCollection
public struct PropertyTransitionData:Codable {
    
    public var userRole:UserRoleModel?
    public var info:PropertyModel
    public var inventario:Inventario
    public var setup:AccountSetup
   
    public enum MainCodingKeys:CodingKey {
        case propertyData
        case propertyInfo
    }
    public enum SubCodingKeys:String,CodingKey {
        case propertyInventario = "property_inventario"
        case propertySetup = "property_setup"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        
        self.info = try container.decode(PropertyModel.self, forKey: .propertyInfo)
        
        let subContainer = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .propertyData)
        
        self.inventario = try subContainer.decode(Inventario.self, forKey: .propertyInventario)
        self.setup = try subContainer.decode(AccountSetup.self, forKey: .propertySetup)
    }
    
}
