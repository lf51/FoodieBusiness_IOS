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
    
    var accountSetup: AccountSetup
    let inventarioScorte: Inventario
    
    var allMyIngredients:[IngredientModel]
    var allMyDish:[DishModel]
    var allMyMenu:[MenuModel]
    var allMyProperties:[PropertyModel]
    
    let allMyCategory: [CategoriaMenu]
    let allMyReviews:[DishRatingModel]
    
    enum CloudCollectionKey:String {
        
        case ingredient = "userIngredients"
        case dish = "userPreparazioniEprodotti"
        case menu = "userMenu"
        case properties =  "userProperties"
        
        
    }
    
    
    init() {
        
        self.accountSetup = AccountSetup()
        self.inventarioScorte = Inventario()
        self.allMyIngredients = [] // vanno inseriti gli ing,dish,menu,property fake
        self.allMyDish = []
        self.allMyMenu = []
        self.allMyProperties = []
        self.allMyCategory = [] // vanno inserite le categorie di default
        self.allMyReviews = [] // vanno inserite review fake
        
    }
    
    init(accountSetup: AccountSetup, inventarioScorte: Inventario, allMyIngredients: [IngredientModel], allMyDish: [DishModel], allMyMenu: [MenuModel], allMyProperties: [PropertyModel], allMyCategory: [CategoriaMenu], allMyReviews: [DishRatingModel]) {
        self.accountSetup = accountSetup
        self.inventarioScorte = inventarioScorte
        self.allMyIngredients = allMyIngredients
        self.allMyDish = allMyDish
        self.allMyMenu = allMyMenu
        self.allMyProperties = allMyProperties
        self.allMyCategory = allMyCategory
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
    
    func cloudDataInstance() -> CloudDataStore {
        
        guard self.userUID != nil else {
            
            let cloudData = fakeCloudData
            
            return cloudData }

      //  return downloadFromFireBase() // va compilato dal firebase
        return fakeCloudData // rimettere il download dal firebase - Usato il fake per i test sul salvataggio
    }
    
   func downloadFromFireBase() -> CloudDataStore {
        
       print("Download data from firebase")
       print("ref_userDocument? = \(ref_userDocument != nil)")
       
       var cloudData = CloudDataStore()
       
           ref_userDocument?.getDocument { document, error in
               
               guard error == nil else { return } // mettere magari un aleert
               print("no error")
               
               guard document?.exists == true else {
                   print("documento non esiste")
                   firstAuthenticationFuture()
                   return }
               
               print("document Exist")
               
               if let time = document?.get("time") as? Int {
                   cloudData.accountSetup.startCountDownMenuAt = AccountSetup.TimeValue.convertiInCase(fromNumber: time)
                   print("time value -> \(time)")
               }
               if let frequenza = document?.get("frequenza") as? Int {
                   cloudData.accountSetup.mettiInPausaDishByIngredient = AccountSetup.ActionValue.convertiInCase(fromNumber: frequenza)
               }
 
           }
           
       
      
       print("cloudData.time = \(cloudData.accountSetup.startCountDownMenuAt.rawValue)")
       return cloudData
    }

    private func firstAuthenticationFuture() {
        self.ref_userDocument?.setData([:])
        print("firstAuthenticationFuture")
        
    }
    
    func publishOnFirebase(dataCloud:CloudDataStore) {
        
        saveSingleCollection(collection: dataCloud[keyPath: \.allMyIngredients], key: .ingredient)
        saveSingleCollection(collection: dataCloud[keyPath: \.allMyDish], key: .dish)
      //  saveSingleCollection(collection: dataCloud[keyPath: \.allMyMenu], key: .menu)
      //  saveSingleCollection(collection: dataCloud[keyPath: \.allMyProperties], key: .properties)
            
        
    }
    
    private func saveSingleCollection<M:MyProCloudPack_L1>(collection:[M],key:CloudDataStore.CloudCollectionKey) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection(key.rawValue) {
            
            for element in collection {
                
                ref_ingredienti.document(element.id).setData(element.creaDocumentDataForFirebase(), merge: true) { error in
                    
                    if error != nil { print("OPS!! Qualcosa non ha funzionato nel salvataggio su Firebase")}
                    else { print("Salvataggio su FireBase avvenuto con Successo - Mettere un Alert")}
                }
                
                
            }
            
        }
    }
    
    
 /*   func publishOnFirebase(dataCloud:CloudDataStore) {
        
        if let ref_ingredienti:CollectionReference = ref_userDocument?.collection("ingredienti") {
            
            for ingredient in dataCloud.allMyIngredients {
                
                ref_ingredienti.document(ingredient.id).setData(ingredient.creaDocumentDataForFirebase(), merge: true) { error in
                    
                    if error != nil { print("OPS!! Qualcosa non ha funzionato nel salvataggio su Firebase")}
                    else { print("Salvataggio su FireBase avvenuto con Successo - Mettere un Alert")}
                }
                
            }
            
            
        }
  
    } */
    
    
    
}


let fakeCloudData = CloudDataStore(
    accountSetup: AccountSetup(startCountDownMenuAt: .novanta, mettiInPausaDishByIngredient: .sempre),
    inventarioScorte: Inventario(
        ingInEsaurimento: [ingredientSample6_Test.id,ingredientSample7_Test.id,ingredientSample8_Test.id],
        ingEsauriti: [ingredientSample2_Test.id,ingredientSample3_Test.id,ingredientSample4_Test.id],
        cronologiaAcquisti: [
        ingredientSample_Test.id:[otherDateString3,otherDateString1,otherDateString,oldDateString,todayString],ingredientSample5_Test.id:[oldDateString,todayString]
    
    ],
        archivioIngInEsaurimento: [todayString:[ingredientSample5_Test.id]]),
    allMyIngredients: [ingredientSample_Test,ingredientSample2_Test,ingredientSample3_Test,ingredientSample4_Test,ingredientSample5_Test,ingredientSample6_Test,ingredientSample7_Test,ingredientSample8_Test,ingredienteFinito],
    allMyDish: [dishItem2_Test,dishItem3_Test,dishItem4_Test,dishItem5_Test,prodottoFinito],
    allMyMenu: [menuSample_Test,menuSample2_Test,menuSample3_Test,menuDelGiorno_Test,menuDelloChef_Test],
    allMyProperties:[property_Test],
    allMyCategory: [cat1,cat2,cat3,cat4,cat5,cat6,cat7],
    allMyReviews: [rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10,rate11,rate12])
