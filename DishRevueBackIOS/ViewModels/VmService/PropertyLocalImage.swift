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


/// oggetto di servizio per mostrare le proprietà registrate con informazioni sintetiche da cui recuperare le property scelte dall'utente ed effettuare lo switch
public struct PropertyLocalImage:Decodable,Hashable {

   public let propertyID:String
   public let propertyName:String
   public let adress:String
    
    public let currentUserRole:CurrentUserRoleModel
    /// proprietà optional perchè decodifichiamo l'oggetto dalla propertyInfo che non conosce il suo snap. E quindi lo aggiungiamo successivamente.
   public var snapShot:QueryDocumentSnapshot?

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
        
        let container = try decoder.container(keyedBy: PropertyManager.PropertyMainCodingKeys.self)
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

        // user Autorizzato
        let city = try road.decode(String.self, forKey: .cityName)
        let street = try road.decode(String.self, forKey: .streetAdress)
        let numeroCivico = try road.decode(String.self, forKey: .numeroCivico)
            
        self.propertyID = try road.decode(String.self, forKey: .id)
        self.propertyName = try road.decode(String.self, forKey: .intestazione)
        self.adress = street + " " + numeroCivico + "," + " " + city
        
        self.currentUserRole = propertyRole

    }

}
