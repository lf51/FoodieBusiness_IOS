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
import MyPackView_L0

/*
extension PropertyDataObject:Codable {
    
    public init(from decoder: Decoder) throws {
        
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.info = try container.decodeIfPresent(PropertyModel.self, forKey: .info)
        self.db = try container.decode(CloudDataStore.self, forKey: .db)
       
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(info, forKey: .info)
        try container.encode(db, forKey: .db)
        
    }
} // deprecata in futuro

extension CloudDataStore:Codable {
    
    public init(from decoder: Decoder) throws {
        
         self.init()
         
         let values = try decoder.container(keyedBy: CodingKeys.self)
         
        // self.allMyIngredients = try values.decode([IngredientModel].self, forKey: .allMyIngredients)
        // let allIngImage = try values.decode([IngredientModelImage].self, forKey: .allMyIngredientsImage)
        // self.allMyIngredients = try IngredientManager.compiler.getIngredientModel(from: allIngImage)
         print("CLOUDDATASTORE_STEP after allMyIngrediesCOMPILER")
         
         self.allMyDish = try values.decode([DishModel].self, forKey: .allMyDish)
         self.allMyMenu = try values.decode([MenuModel].self, forKey: .allMyMenu)
         self.allMyProperties = try values.decode([PropertyModel].self, forKey: .allMyProperties)//depreca
         self.allMyPropertiesRef = try values.decode([RoleModel:String].self, forKey: .allMyPropertiesRef)
         
         self.allMyCategories = try values.decode([CategoriaMenu].self, forKey: .allMyCategories)
         self.allMyReviews = try values.decode([DishRatingModel].self, forKey: .allMyReviews)
        // self.allMyReviews = []
         
       //  let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .otherDocument)
       //  self.setupAccount = try additionalInfo.decode(AccountSetup.self, forKey: .setupAccount)
       //  self.inventarioScorte = try additionalInfo.decode(Inventario.self, forKey: .inventarioScorte)
         
         
     }
    
    public func encode(to encoder: Encoder) throws {
        
      /*  var container = encoder.container(keyedBy: CodingKeys.self)
            
        let allIngredientImage = self.allMyIngredients.map({$0.retrieveImageFromSelf()})
        
        try container.encode(allIngredientImage, forKey: .allMyIngredients)
       // try container.encode(allMyIngredientsImage, forKey: .allMyIngredientsImage)
        try container.encode(allMyDish, forKey: .allMyDish)
        try container.encode(allMyMenu, forKey: .allMyMenu)
        try container.encode(allMyProperties, forKey: .allMyProperties) // depreca
        try container.encode(allMyPropertiesRef, forKey: .allMyPropertiesRef)
        try container.encode(allMyCategories, forKey: .allMyCategories)
        try container.encode(allMyReviews, forKey: .allMyReviews) 
        
        var secondLevel = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .otherDocument)
        try secondLevel.encode(setupAccount, forKey: .setupAccount)
        try secondLevel.encode(inventarioScorte, forKey: .inventarioScorte) */
       
       // var container = encoder.container(keyedBy: AdditionalInfoKeys.self)
        
       // try container.encode(setupAccount, forKey: .setupAccount)
       // try container.encode(inventarioScorte, forKey: .inventarioScorte)
        
    }
    
   
    
} */ // deprecato Codable // close extension

/*public final class IngredientManager {
    
    static var compiler:IngredientManager = IngredientManager()
    private let db_base = Firestore.firestore().collection("ingredientFromAllUser")
    
    func getIngredientModel(from images:[IngredientModelImage]) throws -> [IngredientModel] {
        print("Start getIngredientModel in IngredientManager")
        
       let allRef = images.map({$0.id})
       var allModel:[IngredientModel] = []
        
        self.db_base
            .whereField(.documentID(), in: allRef)
            .getDocuments { querySnap, error in
                
                guard let query = querySnap else {
                    
                    return
                }
                
                let allIngModel = query.documents.compactMap({try? $0.data(as: IngredientModel.self)})
                let allUpdatedModel = allIngModel.compactMap { ingModel in
                    
                    if let associatedImage = images.first(where: {$0.id == ingModel.id }) {
                        return ingModel.updateModel(from:associatedImage)
                    } else {
                        return nil
                    }
                }
                allModel = allUpdatedModel
            }
        
        print("Ending getIngredientModel in IngredientManager. allRef:\(allRef.count) vs allModel:\(allModel.count)")
        return allModel
        
    }
    
} */


/*
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

}*/ // spostata su FoodiePackage 22.07


/// oggetto di servizio per mostrare le proprietà registrate con informazioni sintetiche da cui recuperare le property scelte dall'utente ed effettuare lo switch
public struct PropertyLocalImage:Decodable,Hashable {
    // inserire lo snap del ref
  // public static var userID:String = ""

   public let propertyID:String
  //public let userRuolo:String
  // public let userRuolo:UserRoleModel
   public let currentUserRole:CurrentUserRoleModel
   public let propertyName:String
   public let adress:String
    
   public var snapShot:QueryDocumentSnapshot?
    
   /* enum CodingKeys:String,CodingKey {
    
        case propertyInfo = "property_info"
  
    }*/
    
     enum PropertyModelKeys:String,CodingKey {
        
        case id
        case intestazione
        case cityName
        case streetAdress
        case numeroCivico
        case organigramma
        
    }
    
    public init(userRuolo:CurrentUserRoleModel,propertyName:String,propertyRef:String,propertyAdress:String) {
        
        self.currentUserRole = userRuolo
        self.propertyID = propertyRef
        self.propertyName = propertyName
        self.adress = propertyAdress
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PropertyManager.PropertyMainCodingKeys.self)//try decoder.container(keyedBy: CodingKeys.self)
        let road = try container.nestedContainer(keyedBy: PropertyModelKeys.self, forKey: .propertyInfo)
        
        // verifichiamo in decodifica che lo user è autorizzato
        
        let organigramma = try road.decode([UserCloudData].self, forKey: .organigramma)//.first(where: { $0.id == CloudDataCompiler.userAuthUid})
        
        print("[ORGANIGRAMMA]_count:\(organigramma.count)_MUST BE ONE")
        
        guard let user = organigramma.first,
              let propertyRole = user.propertyRole else {
            // questo guard in teoria non è mai eseguito. L'organigramma della proprietà, decodificato sopra, avrà sempre un solo user autorizzato. A differenza della vecchia impostazione, se lo user non è autorizzato l'organigramma soprà sarà vuoto e in realtà farà il throw di un errore. Quindi qui non si arriverà mai, ne in caso di mancata autorizzazione, ne in presenza di autorizzazione
            let context = DecodingError.Context(codingPath: [Self.PropertyModelKeys.organigramma], debugDescription: "User Non Trovato in Organigramma")
            print("errore di decoding di una ref: \(context.debugDescription)")
            throw DecodingError.valueNotFound(String.self, context)
        }
        
        /*
        print("[DECODE ORGANIGRAMMA]_isEmpty:\(organigramma.isEmpty)")
        
        guard let user = organigramma.first(where: {$0.id == AuthenticationManager.userAuthData.id}),
              let role = user.propertyRole else {
            // User Non Autorizzato
            let context = DecodingError.Context(codingPath: [Self.PropertyModelKeys.organigramma], debugDescription: "User Non Autorizzato")
            print("errore di decoding di una ref: \(context.debugDescription)")
            throw DecodingError.valueNotFound(String.self, context)
        } */

        // user Autorizzato
        let city = try road.decode(String.self, forKey: .cityName)
        let street = try road.decode(String.self, forKey: .streetAdress)
        let numeroCivico = try road.decode(String.self, forKey: .numeroCivico)
            
        self.propertyID = try road.decode(String.self, forKey: .id)
        self.propertyName = try road.decode(String.self, forKey: .intestazione)
        self.adress = street + " " + numeroCivico + "," + " " + city
        
        self.currentUserRole = propertyRole

    }

    
   /* public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let road = try container.nestedContainer(keyedBy: PropertyModelKeys.self, forKey: .propertyInfo)
        
        let organigramma = try road.decode([UserRoleModel].self, forKey: .organigramma)
        // verifichiamo in decodifica che lo user è autorizzato
        if let user = organigramma.first(where: {$0.id == CloudDataCompiler.userAuthUid}) {
            
            let city = try road.decode(String.self, forKey: .cityName)
            let street = try road.decode(String.self, forKey: .streetAdress)
            let numeroCivico = try road.decode(String.self, forKey: .numeroCivico)
            
            self.adress = street + " " + numeroCivico + "," + " " + city
            self.userRuolo = user.ruolo.rawValue
            self.propertyID = try road.decode(String.self, forKey: .id)
            self.propertyName = try road.decode(String.self, forKey: .intestazione)
            
           // self.snapShot = snap
            
        } else {

            self.adress = "VIA DEI GIGLI"
            self.propertyID = "IDMINE"
            self.propertyName = "MINEKRAFT"
            self.userRuolo = "ORESTE"
            return
        }

    } */
    
}
/// oggetto di servizio per salvare i riferimenti delle proprietà dello User
/*public struct UserCloudData:Codable {
    
    public var id:String
    public var email:String
    public var userName:String
    
    public var isPremium:Bool
    public var propertiesRef:[String]?

    public enum CodingKeys:String,CodingKey {
        
        case id = "user_id"
        case email = "user_email"
        case userName = "user_name"
        
        case isPremium = "user_is_premium"
        case propertiesRef = "user_properties_ref"
    }
}*/ // spostata in MyFoodiePackage

/*public class CloudDataCompiler { // 11.08.23 in deprecazione in favore di CloudDataManager
    
   private let db_base = Firestore.firestore()
 // private var ref_db: DocumentReference // probabile deprecazione
   static var userAuthUid:String = ""
    
 //  public var userData:UserCloudData? // deprecata
 //  public var allMyProperties:[PropertyLocalImage]? // deprecata
    private var listenerPropertyRef:ListenerRegistration? = nil
    
   public enum CollectionKey:String {
        case propertyCollection = "properties_registered"
        case businessUser = "user_business"
        case ingredientCollection = "ingredients_library"
    }
    
   public init(userAuthUID:String) {
        
            Self.userAuthUid = userAuthUID
            //PropertyLocalImage.userID = userAuthUID // impostiamo le imagini delle prop sull'utente autenticato. Utile in decodifica per decodificare solo le prop dove l'user è autorizzato
          
            print("CloudDataCompiler inizializzato con uuid:\(userAuthUID)")
  
    }
    
    // Nuovo Corso
    
    
  /*  private func fetchPropertyRef(handle:@escaping(_ allRef:[String]) -> () ){
        
      let key = self.db_base.collection(CollectionKey.businessUser.rawValue).document(Self.userAuthUid)

        self.listenerPropertyRef = key.addSnapshotListener { snapShot, error in
        print("Dentro LISTENER fetchPropertyREF")
            guard let doc = snapShot else {
                print("Scarico UserCloudData FAIL")
                handle([])
                return
            }
            
            let allRef:[String]? = try? doc.data(as: UserCloudData.self).propertiesRef
            
            if let ref = allRef {
                
                print("Scarico UserCloudData OK")
                handle(ref)
                
            }
            else {
                print("Scarico UserCloudData FAIL")
                handle([]) }
            
        }
       
        
      /*  key.getDocument(as: UserCloudData.self) { result in

            switch result {
                
            case .success(let cloudData):
                print("Scarico UserCloudData OK")
                handle(cloudData.propertiesRef)

            case .failure(let failure):
                print("Scarico UserCloudData FAIL: \(failure.localizedDescription)")
                handle([])
 
            }

        }*/

    } */
    
    /*
    func firstFetchLISTNERDASVILUPPARE(handle:@escaping(_ propertiesImage:[PropertyLocalImage]?,_ propertyDataModel:PropertyDataObject?,_ userRoleModel:UserRoleModel?,_ isLoading:Bool) -> () ) {
        
        self.fetchPropertyRef { allRef in
            // caso_0 nessun ref
            guard !allRef.isEmpty else {
                print("Utente non ha ref di proprietà")
                self.listenerPropertyRef?.remove()
                handle(nil,nil,nil,false)
                return
            }
            // individuiamo i documenti corrispondenti alle ref
             self.db_base.collection(CollectionKey.propertyCollection.rawValue)
                .whereField(.documentID(), in: allRef)
                .addSnapshotListener({ querySnapshot, error in
                    
                    print("DENTRO IL LISTENER delle property")
                    
                    guard let documents = querySnapshot?.documents else {
                        
                        print("Errore nel listener:\(error?.localizedDescription ?? "")")
                        handle(nil,nil,nil,false)
                        return
                        
                    }
                  //  querySnapshot?.documentChanges // Mandare alert o visualizzare punti rossi
                    // convertiamo ciascun documento in una PropertyLocalImage tramide il decoding dell'oggetto che verifica l'autorizzazione dell'utente
                    let allImages:[PropertyLocalImage] = documents.compactMap({ snap -> PropertyLocalImage? in
                        
                        let image = try? snap.data(as: PropertyLocalImage.self)
                        
                        guard var propImage = image else {
                            
                            return nil
                        }
                        
                        propImage.snapShot = snap
                        return propImage
  
                        
                    }) // chiusa compactMap
                    
                    // aggiorniamo i ref dello user // blocca i ref dalla nuova Init e non in realTime
                    guard allRef.count == allImages.count else {
                        print("Upodate propertyRef")
                        let newRef = allImages.map({$0.propertyID})
                        let newUserCloud = UserCloudData(propertiesRef: newRef)
                        let userID = AccounterVM.userAuthData.id
                        self.publishGenericOnFirebase(collection: .businessUser, refKey:userID, element: newUserCloud)
                        return
                        
                    }
                    
                    // Analizziamo le images
                    // Caso -Vuoto o Nil- (ci sono i ref nell'utente ma non decodifica nulla perchè mancano le autorizzazioni)
                    guard !allImages.isEmpty else {
                        print("Nessun documento è stato convertito in PropertyLocalImage.Ref:\(allRef.count) vs Image:\(allImages.count)")
                        
                        handle(nil,nil,nil,false)
                        return
                    }
                    
                    // Caso -Default_1Prop-
                    // Caso -MultiProp-
                    if let lastRef = UserDefaults.standard.string(forKey: "DefaultProperty"),
                       let associatedImage = allImages.first(where: {$0.propertyID == lastRef}) {
                        print("Recuperiamo l'immagine di default dell'ultima prop usata")
                        let propertyDataObject = try? associatedImage.snapShot?.data(as: PropertyDataObject.self)
                        handle(allImages,propertyDataObject,associatedImage.userRuolo,false)
           
                    } else if let first = allImages.first {
                        print("Recuperiamo la prima Immagine delle prop")
                        let propertyDataObject = try? first.snapShot?.data(as: PropertyDataObject.self)
                        handle(allImages,propertyDataObject,first.userRuolo,false)
                        
                    } else {
                        print("StranoPRINT - questo else in teoria non dovrebbe mai essere eseguito")
                        handle(nil,nil,nil,false)
                    }
                    
                }) // chiusa getDocuments
            
        } // chiusa fetchAllRef
        
    } */
    /*
    func firstFetch(handle:@escaping(_ propertiesImage:[PropertyLocalImage]?,_ propertyDataModel:PropertyDataObject?,_ userRoleModel:UserRoleModel?,_ isLoading:Bool) -> () ) {
        
        self.fetchPropertyRef { allRef in
            
            // caso_0 nessun ref
            
            guard !allRef.isEmpty else {
                print("Utente non ha ref di proprietà")
                handle(nil,nil,nil,false)
                return
            }
            // individuiamo i documenti corrispondenti alle ref
            self.db_base.collection(CollectionKey.propertyCollection.rawValue)
                .whereField(.documentID(), in: allRef)
                .getDocuments { querySnapshot, error in
                    
                    guard let query = querySnapshot,
                          error == nil else {
                        
                        print("Errore nel get multiplo:\(error?.localizedDescription ?? "")")
                        handle(nil,nil,nil,false)
                        return
                    }
                    // convertiamo ciascun documento in una PropertyLocalImage tramide il decoding dell'oggetto che verifica l'autorizzazione dell'utente
                    let propImages:[PropertyLocalImage]? = query.documents.compactMap({ snap -> PropertyLocalImage? in
                        
                        let image = try? snap.data(as: PropertyLocalImage.self)
                        
                        guard var propImage = image else {
                            return nil
                        }
                        
                        propImage.snapShot = snap
                        return propImage
  
                        
                    }) // chiusa compactMap
                    
                    // Analizziamo le images
                    // Caso -Vuoto o Nil- (ci sono i ref nell'utente ma non decodifica nulla perchè mancano le autorizzazioni)
                    
                    guard let allImages = propImages else {
                        print("Nessun documento è stato convertito in PropertyLocalImage.Ref:\(allRef.count) vs Image:\(propImages?.count ?? 0)")
                        
                        handle(nil,nil,nil,false)
                        return
                    }
                    
                    // Caso -Default_1Prop-
                    // Caso -MultiProp-
                    if let lastRef = UserDefaults.standard.string(forKey: "DefaultProperty"),
                       let associatedImage = allImages.first(where: {$0.propertyID == lastRef}) {
                        print("Recuperiamo l'immagine di default dell'ultima prop usata")
                        let propertyDataObject = try? associatedImage.snapShot?.data(as: PropertyDataObject.self)
                        handle(allImages,propertyDataObject,associatedImage.userRuolo,false)
           
                    } else if let first = allImages.first {
                        print("Recuperiamo la prima Immagine delle prop")
                        let propertyDataObject = try? first.snapShot?.data(as: PropertyDataObject.self)
                        handle(allImages,propertyDataObject,first.userRuolo,false)
                        
                    } else {
                        print("StranoPRINT - questo else in teoria non dovrebbe mai essere eseguito")
                        handle(nil,nil,nil,false)
                    }
                    
                } // chiusa getDocuments
            
        } // chiusa fetchAllRef
        
    }*/
    
   /* func firstFetchDeprecata(handle:@escaping(_ propertiesImage:[PropertyLocalImage]?,_ propertyDataModel:PropertyDataModel?,_ isLoading:Bool) -> () ) {
        
        self.fetchPropertyRef { allRef in
            
            // caso_0 nessun ref
            
            guard !allRef.isEmpty else {
                print("Utente non ha ref di proprietà")
                handle(nil,nil,false)
                return
            }
            // individuiamo i documenti corrispondenti alle ref
            self.db_base.collection(CollectionKey.propertyCollection.rawValue)
                .whereField(.documentID(), in: allRef)
                .getDocuments { querySnapshot, error in
                    
                    guard let query = querySnapshot,
                          error == nil else {
                        
                        print("Errore nel get multiplo:\(error?.localizedDescription ?? "")")
                        handle(nil,nil,false)
                        return
                    }
                    // convertiamo ciascun documento in una PropertyLocalImage tramide il decoding dell'oggetto che verifica l'autorizzazione dell'utente
                    let propImages:[PropertyLocalImage]? = query.documents.compactMap({ snap -> PropertyLocalImage? in
                        
                        let image = try? snap.data(as: PropertyLocalImage.self)
                        
                        guard var propImage = image else {
                            return nil
                        }
                        
                        propImage.snapShot = snap
                        return propImage
  
                        
                    }) // chiusa compactMap
                    
                    // Analizziamo le images
                    // Caso -Vuoto o Nil- (ci sono i ref nell'utente ma non decodifica nulla perchè mancano le autorizzazioni)
                    
                    guard let allImages = propImages else {
                        print("Nessun documento è stato convertito in PropertyLocalImage.Ref:\(allRef.count) vs Image:\(propImages?.count ?? 0)")
                        
                        handle(nil,nil,false)
                        return
                    }
                    
                    // Caso -Default_1Prop-
                    // Caso -MultiProp-
                    if let lastRef = UserDefaults.standard.string(forKey: "DefaultProperty"),
                       let associatedImage = allImages.first(where: {$0.propertyID == lastRef}) {
                        print("Recuperiamo l'immagine di default dell'ultima prop usata")
                        let propertyData = try? associatedImage.snapShot?.data(as: PropertyDataModel.self)
                        handle(allImages,propertyData,false)
           
                    } else if let first = allImages.first {
                        print("Recuperiamo la prima Immagine delle prop")
                        let propertyData = try? first.snapShot?.data(as: PropertyDataModel.self)
                        handle(allImages,propertyData,false)
                        
                    } else {
                        print("StranoPRINT - questo else in teoria non dovrebbe mai essere eseguito")
                        handle(nil,nil,false)
                    }
                    
                } // chiusa getDocuments
            
        } // chiusa fetchAllRef
        
    } */
        
    
   /* func firstFetchDEPRECATA(handle:@escaping(_ propertiesImage:[PropertyLocalImage],_ propUserRole:UserRoleModel?,_ currentProp:PropertyModel?,_ propDB:CloudDataStore?,_ isLoading:Bool) -> () ) {
                
        // propertyRef dell'utente
        self.fetchPropertyRef { allRef in
            
            // caso_0 nessun ref
            
            guard !allRef.isEmpty else {
                print("Utente non ha ref di proprietà")
                handle([],nil,nil,nil,false)
                return
                
            }
            // recuperiamo gli snap delle property di tutti i ref
            self.db_base.collection(CollectionKey.propertyCollection.rawValue)
                .whereField(.documentID(), in: allRef)
                .getDocuments { (query,error) in
                
                if let err = error {
                    
                    print("Errore nel get multiplo:\(err.localizedDescription)")
                    handle([],nil,nil,nil,false)
                    
                } else {
                
                   let propertyCloudData:[PropertyCloudData]? = query?.documents.compactMap({ (snap) -> PropertyCloudData? in
                        do {
                            let prop = try snap.data(as: PropertyCloudData.self)
                            return prop
                        } catch let error {
                            print(error.localizedDescription)
                            return nil
                        }
                    })
                    
                    guard let allProp = propertyCloudData,
                    !allProp.isEmpty else {
                        
                        print("Riferimento a proprietà non esistente")
                        handle([],nil,nil,nil,false)
                        return
                    }
                    
                    if allProp.count == 1,
                       let theOnlyOne = allProp.first,
                       let roleUser = theOnlyOne.propertyInfo.organigramma.first(where: {$0.id == Self.userAuthUid}){
                        // default con una proprietà

                        let propertyImage = PropertyLocalImage(
                            userRuolo: roleUser.ruolo.rawValue,
                            propertyName: theOnlyOne.propertyInfo.intestazione,
                            propertyRef: theOnlyOne.propertyInfo.id)
                        
                        let db = theOnlyOne.propertyData
                        let model = theOnlyOne.propertyInfo
                        print("Estrapolati dati dell'unica prop registrata")
                        handle([propertyImage],roleUser,model,db,false)
                        
                    } else if allProp.count > 1 {
                        // contiene più di una prop. Il caso vuoto è nel guard
                        // 03.08.23 update da fare -> occorre caricare l'ultima prop salvata nello userDefualt
                        let images = allProp.compactMap({ propData in
                            
                            if let roleUser = propData.propertyInfo.organigramma.first(where: {$0.id == self.userAuthUid}) {
                                // user Autorizzato
                                let image = PropertyLocalImage(
                                    userRuolo: roleUser.ruolo.rawValue,
                                    propertyName: propData.propertyInfo.intestazione,
                                    propertyRef: propData.propertyInfo.id)
                                
                                return image
                            } else {
                                // User non autorizzato
                                return nil
                            }

                        })
                        print("Estrapolate le image di tutte le prop registrate")
                        handle(images,nil,nil,nil,false)
                    }
                    else {
                        print("Qualche errore e non è stato eseguito ne il codice della singola ne della multi proprietà")
                        handle([],nil,nil,nil,false)
                        
                    }
   
                } // chiusa else no error
 
            }// chiusa getQuery
 
        }

    } */ // end first Fetch

    
   /* private func internalFetch(handle:@escaping(_ allProp:[PropertyLocalImage]?) -> ()) {
        
        let key = self.db_base.collection(CollectionKey.businessUser.rawValue).document(self.userAuthUid)
        
        key.getDocument(as: UserCloudData.self) { result in
            
            switch result {
                
            case .success(let userCloud):
                
                self.userData = userCloud
                
               // var userRefConfirmed:[String] = userCloud.propertiesRef
                var values:[PropertyLocalImage] = []
                
                for ref in userCloud.propertiesRef {
                    
                    self.fetchDocument(collection: .propertyCollection, docRef: ref, modelSelf: PropertyCloudData.self) { modelData in
                        
                        if let property = modelData?.propertyInfo,
                           let userRoleModel = property.organigramma.first(where: {$0.id == self.userAuthUid}) {
                            
                            let ruolo = userRoleModel.ruolo.rawValue
                            let nameProp = property.intestazione
                            
                            let propertyImage = PropertyLocalImage(
                                userRuolo: ruolo,
                                propertyName: nameProp,
                                propertyRef: ref)
                            
                            values.append(propertyImage)
   
                        } else {
                            // utente non autorizzato o property rimossa // eliminiamo riferimento
                            print("Autorizzazione non trovata per user:\(self.userAuthUid) in propertyRef:\(ref) - Procediamo a rimozione automatica")
                            self.userData?.propertiesRef.removeAll(where: {$0 == ref})
                        }
   
                    }
                }
                
                if userCloud.propertiesRef.count != self.userData?.propertiesRef.count {
                    
                   do {
                       try key.setData(from: self.userData, merge: true)
                        print("Riferimenti proprietà aggiornati per utente:\(self.userAuthUid)")
                   } catch let error {
                       
                       print("Errore [\(error.localizedDescription)] nell'update dei rif per l'utente:\(self.userAuthUid)")
                   }

                }
                
                print("Compilato role:Prop per l'Utente")
                if values.isEmpty {
                    handle(nil)
                } else {
                    handle(values)
                }
                
 
            case .failure(_):
                print("No PropertyRef per l'Utente")
                handle(nil)
            }
            
            
        }
        
        
    }*/

   /* func firstFetch(handle:@escaping(_ propUserRole:UserRoleModel?,_ currentProp:PropertyModel?,_ propDB:CloudDataStore?,_ isLoading:Bool) -> ()) {
        
        if let propImage = self.allMyProperties,
           propImage.count == 1 {
            
            let value = propImage.first
            self.estrapolaDatiFromPropImage(propertyImage: value) { user, prop, db in
                handle(user,prop,db,false)
            }

        } else {
            print("PropertyImage contiene un numero di elementi diverso da 1. Esattamente:\(self.allMyProperties?.count ?? nil)")
            handle(nil,nil,nil,false)
        }

    }*/ // deprecata
    /*
    func estrapolaDatiFromPropImage(propertyImage:PropertyLocalImage,handle:@escaping(_ propertyData:PropertyDataObject?) -> () ) {
             
        self.fetchDocument(collection: .propertyCollection, docRef: propertyImage.propertyID, modelSelf: PropertyDataObject.self) { modelData in
            print("fetch property da propertyImag succed: \(modelData != nil)")
            handle(modelData)
            
        }
    }*/  // 06.08.23 deprecata
    
    
    // database
    /// fetch document generico
  /*  func fetchDocument<D:Codable>(collection:CollectionKey,docRef:String,modelSelf:D.Type,handle:@escaping(_ modelData:D?) ->()) {
        
        let documentRef = self.db_base.collection(collection.rawValue).document(docRef)
    
        documentRef.getDocument(as:modelSelf.self) { result in
            
            switch result {
                
            case .success(let element):
                handle(element)
                print("Dato generico scaricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download dato generico from Firebase FAIL: \(error)")
            }
        }
        
     
    } */
    
   /* func fetchAllData(userAuthMail:String,handle:@escaping(_ db:CloudDataStore?,_ userRoleUpdate:UserRoleModel?,_ propertyMod:PropertyModel?,_ isLoading:Bool) -> ()) {
        
       /* guard let userUID = self.userAuthUid else {
            handle(nil,nil,nil,false)
            print("No User Auth UID")
            return
        } */
        
        self.fetchDocument(collection: .businessUser, docRef: self.userAuthUid, modelSelf: CloudDataStore.self) { modelData in
            
            let propertyRef = modelData?.allMyPropertiesRef
            
            guard let ref = propertyRef,
                  let collab = ref.first(where: {$0.key == .collab}) else {
                // admin or nessuna registrazione/collaborazione
                handle(modelData,nil,nil,false)
                print("UserAuth senza registrazione/collaborazione")
                
            }
            
            let refProprieta = collab.value
 
            // collab
            // verifica autorizzazioni
            self.fetchDocument(collection: .propertyCollection, docRef: refProprieta, modelSelf: PropertyModel.self) { modelData2 in
                
               // let dbRef = modelData2?.organigramma.admin.id
                let collabs = modelData2?.organigramma.allAdminCollabs
                let collabModel = collabs?.first(where: {$0.mail == userAuthMail})
                
                guard let collabUserRole = collabModel,
                let dbRef = modelData2?.organigramma.admin.id else {
                    // collaboratore non autorizzato // o proprietà registrata senza admin
                    handle(modelData,nil,nil,false)
                    print("Collaboratore non autorizzato O proprietà senza riferimento admin")
                    return
                }
                // collaboratore Autorizzato
               
                self.fetchDocument(collection: .businessUser, docRef: dbRef, modelSelf:CloudDataStore.self) { modelData3 in
                   
                    handle(modelData3,collabUserRole,modelData2,false)
                    print("Collaboratore Autorizzato - scarico db esterno/UpdateRoleMode/UpdateProperty")
                }
                
            }
        }
    } */ // deprecata

    
  /*  func publishGenericOnFirebase<Element:Codable>(collection:CollectionKey,refKey:String,element:Element) {
        
        let key = self.db_base.collection(collection.rawValue).document(refKey)
        
        do {
            try key.setData(from: element,merge: true)
            print("Publish generic on Firebase Succed")
            
        } catch let error {
            print("\(error.localizedDescription) - Errore nel salvataggio Generico su Firebase")
        }
        
    }*/
    
    /*
    func publishOnFirebase<C:Codable>(dbRef:String? = nil,saveData:C,handle:@escaping(_ errorIn:Bool) ->() ) {
        
        let ref:DocumentReference? = {
            if let uuid = dbRef {
                let newRef = self.db_base.collection(CollectionKey.businessUser.rawValue).document(uuid)
                return newRef
            } else {
                return self.ref_db
            }
        }()
        
        do {
            try ref?.setData(from: saveData, merge: true)
            handle(false)
            
        } catch let error {
            handle(true)
            print("\(error.localizedDescription) - Errore nel salvataggio su Firebase")
        }
        
        
    } */

    
   /* func firstAuthenticationFuture() {
        // cancella tutti i dati del database lasciando la chiave. Utile se si vuole creare la chiave in una prima autentica o se si vuole cancellare ogni dato mantenendo la chiave. In questo casa occorrerebbe aggiornare l'app per rifetchare i dati e dunque avere un cloudData locale vuoto
        self.ref_db.setData([:])
        // Va sistemato in chiave collab -admin
        print("firstAuthenticationFuture")
        
    }*/ // private
    
    // Property Manager
    
    /// Registrazione nella collezione delle proprietà
    func checkPropertyOnFirebase(propertyID:String,handle:@escaping(_ registrabile:Bool) -> () ) {
        
        let docRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyID)
        
        // verifica esistenza su firebase
        docRef.getDocument { (document,error) in
            
            if let doc = document,
                doc.exists {
                // Non registrabile
                print("Property \(propertyID) già esistente")
                handle(false)
                
            } else {
                // registrabile
                print("Property \(propertyID) NON esistente")
                handle(true)

            }
            
        }

    }

    
    func deRegistraProprietà(propertyUID:String,handle:@escaping(_ deleteSuccess:Bool) -> () ) {
        
        let docRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyUID)
        
        docRef.delete() { error in
            
            if let _ = error {
                // eliminazione non avvenuta
                handle(false)
                print("Proprietà NON deRegistrata")
            } else {
                // eliminazione success
                handle(true)
                print("Proprietà deRegistrata con Successo")
            }
            
            
        }
    }
    
    
    
    
}*/ // deprecata


/*
public struct CloudDataCompiler {
    
    private let db_base = Firestore.firestore()
    private var ref_db: DocumentReference
    private let userAuthUid:String
    
   public enum CollectionKey:String {
        case propertyCollection = "UID_PropertyRegistered"
        case businessUser = "UID_UtenteBusiness"
    }
    
   public init(userAuthUID:String) {
        
       // if let user = userAuthUID {
            
            self.ref_db = db_base.collection(CollectionKey.businessUser.rawValue).document(userAuthUID) // rif al proprio UID
            self.userAuthUid = userAuthUID
            
            print("CloudDataCompiler inizializzato con uuid:\(userAuthUID)")
            
      /*  } else {
            self.ref_db = nil
            self.userAuthUid = nil
            print("CloudDataCompiler init con id: NIL)")
        } */
        
        
    }
    
    // database
    /// fetch document generico
    func fetchDocument<D:Codable>(collection:CollectionKey,docRef:String,modelSelf:D.Type,handle:@escaping(_ modelData:D?) ->()) {
        
        let documentRef = self.db_base.collection(collection.rawValue).document(docRef)
    
        documentRef.getDocument(as:modelSelf.self) { result in
            
            switch result {
                
            case .success(let element):
                handle(element)
                print("Dato generico scaricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download dato generico from Firebase FAIL: \(error)")
            }
        }
        
    }
    
    func fetchAllData(userAuthMail:String,handle:@escaping(_ db:CloudDataStore?,_ userRoleUpdate:UserRoleModel?,_ propertyMod:PropertyModel?,_ isLoading:Bool) -> ()) {
        
       /* guard let userUID = self.userAuthUid else {
            handle(nil,nil,nil,false)
            print("No User Auth UID")
            return
        } */
        
        self.fetchDocument(collection: .businessUser, docRef: self.userAuthUid, modelSelf: CloudDataStore.self) { modelData in
            
            let propertyRef = modelData?.allMyPropertiesRef
            
            guard let ref = propertyRef,
                  let collab = ref.first(where: {$0.key == .collab}) else {
                // admin or nessuna registrazione/collaborazione
                handle(modelData,nil,nil,false)
                print("UserAuth senza registrazione/collaborazione")
                
            }
            
            let refProprieta = collab.value
 
            // collab
            // verifica autorizzazioni
            self.fetchDocument(collection: .propertyCollection, docRef: refProprieta, modelSelf: PropertyModel.self) { modelData2 in
                
               // let dbRef = modelData2?.organigramma.admin.id
                let collabs = modelData2?.organigramma.allAdminCollabs
                let collabModel = collabs?.first(where: {$0.mail == userAuthMail})
                
                guard let collabUserRole = collabModel,
                let dbRef = modelData2?.organigramma.admin.id else {
                    // collaboratore non autorizzato // o proprietà registrata senza admin
                    handle(modelData,nil,nil,false)
                    print("Collaboratore non autorizzato O proprietà senza riferimento admin")
                    return
                }
                // collaboratore Autorizzato
               
                self.fetchDocument(collection: .businessUser, docRef: dbRef, modelSelf:CloudDataStore.self) { modelData3 in
                   
                    handle(modelData3,collabUserRole,modelData2,false)
                    print("Collaboratore Autorizzato - scarico db esterno/UpdateRoleMode/UpdateProperty")
                }
                
            }
        }
    }
    /*
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
        
    }*/ // deprecata 23.07.23
    
    func publishGenericOnFirebase<Element:Codable>(collection:CollectionKey,refKey:String,element:Element) {
        
        let key = self.db_base.collection(collection.rawValue).document(refKey)
        
        do {
            try key.setData(from: element,merge: true)
            
        } catch let error {
            print("\(error.localizedDescription) - Errore nel salvataggio Generico su Firebase")
        }
        
    }
    
    func publishOnFirebase<C:Codable>(dbRef:String? = nil,saveData:C,handle:@escaping(_ errorIn:Bool) ->() ) {
        
        let ref:DocumentReference? = {
            if let uuid = dbRef {
                let newRef = self.db_base.collection(CollectionKey.businessUser.rawValue).document(uuid)
                return newRef
            } else {
                return self.ref_db
            }
        }()
        
        do {
            try ref?.setData(from: saveData, merge: true)
            handle(false)
            
        } catch let error {
            handle(true)
            print("\(error.localizedDescription) - Errore nel salvataggio su Firebase")
        }
        
        
    }
    /*
    private func fetchUserProfile(docRef:String,handle: @escaping (_ :ProfiloUtente?) -> () ) { // Validata
        
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
        
    }*/ // deprecata
    
    func firstAuthenticationFuture() {
        // cancella tutti i dati del database lasciando la chiave. Utile se si vuole creare la chiave in una prima autentica o se si vuole cancellare ogni dato mantenendo la chiave. In questo casa occorrerebbe aggiornare l'app per rifetchare i dati e dunque avere un cloudData locale vuoto
        self.ref_db.setData([:])
        // Va sistemato in chiave collab -admin
        print("firstAuthenticationFuture")
        
    } // private
    
    /*
    private func compilaCloudDataFromFirebase(newDbRef:String? = nil,handle:@escaping(_:CloudDataStore?) -> () ) {
        
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

    } */// deprecata // chiusa metodo
    
    // Property Manager
    
    /// Registrazione nella collezione delle proprietà
    func registraPropertyOnFirebase(property:PropertyModel, handle:@escaping(_ alert:AlertModel?) -> () ) {
        
        let docRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(property.id)
        
        // verifica esistenza su firebase
        docRef.getDocument { (document,error) in
            
            if let doc = document, doc.exists {
                // già registrata
                handle(AlertModel(
                    title: "Proprietà già registrata",
                    message: "Per reclami e/o errori contattare info@foodies.com.",
                    actionPlus: nil))
                
            } else {
                // registrabile
              //  handle(nil)
                do {
                    try docRef.setData(from: property, merge: true)
                    handle(nil)
                    
                } catch let error {
                    handle(AlertModel(
                        title: "Server Error",
                        message: "\(error.localizedDescription)\nRiprovare. Se il problema persiste contattare info@foodies.com"))
                    print("\(error.localizedDescription) - Errore nel salvataggio su Firebase")
                }

            }
            
        }

    }
    /*
    func registraPropertyOnFirebase(propertyUID:String, handle:@escaping(_ alert:AlertModel?) -> () ) {
        
        let docRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyUID)
        
        // verifica esistenza su firebase
        docRef.getDocument { (document,error) in
            
            if let doc = document, doc.exists {
                // già registrata
                handle(AlertModel(
                    title: "Proprietà già registrata",
                    message: "Per reclami e/o errori contattare info@foodies.com.",
                    actionPlus: nil))
                
            } else {
                // registrabile
              //  handle(nil)
                docRef.setData(["adminUID":self.userAuthUid ?? ""],merge:false) { err in
                    if let error = err {
                        handle(AlertModel(
                            title: "Server Error",
                            message: "\(error.localizedDescription)\nRiprovare. Se il problema persiste contattare info@foodies.com"))
                        print("\(error.localizedDescription) - Errore nella registrazione della Proprietà")
                    } else {
                        
                        handle(nil)
                        print("- Registrazione della Proprietà avvenuta con successo")
                    }
                }
                
            }
            
        }

    }*/ // deprecata 23.07.23
    
    func deRegistraProprietà(propertyUID:String,handle:@escaping(_ deleteSuccess:Bool) -> () ) {
        
        let docRef = self.db_base.collection(CollectionKey.propertyCollection.rawValue).document(propertyUID)
        
        docRef.delete() { error in
            
            if let _ = error {
                // eliminazione non avvenuta
                handle(false)
                print("Proprietà NON deRegistrata")
            } else {
                // eliminazione success
                handle(true)
                print("Proprietà deRegistrata con Successo")
            }
            
            
        }
    }
    
    
    
    
} */ // backup 26.07.23 - pre trasformazione in class
            
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
