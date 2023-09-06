//
//  FirstAddingPropertyView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/08/23.
//

import SwiftUI
import MyPackView_L0
import MapKit
import MyFoodiePackage
import FirebaseFirestore

struct WelcomeLandingPage: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var authProcess:AuthenticationManager

    @State var localNavigationPath:NavigationPath = NavigationPath()

    var body: some View {
        
        NavigationStack(path: $localNavigationPath) {

            CSZStackVB(
                title: "Welcome \(viewModel.currentUser?.userName ?? "NO USERNAME")",
                titlePosition:.bodyEmbed([.horizontal], 10) ,
                backgroundColorView: .seaTurtle_1) {

                    VStack(spacing:20) {
                        
                        Spacer()
                        
                        Image(systemName: "fork.knife.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.seaTurtle_2)
                            .frame(maxWidth:500)
                            .padding(.vertical,60)
                        
                        Spacer()
                        
                        NavigationLink(value: LocalDestination.addProperty) {
                            
                            HStack {
                                Spacer()
                                Image(systemName: "house")
                                    .imageScale(.large)
                                    .tint(.seaTurtle_1)
                               
                                Text("Registra Proprietà")
                                    .bold()
                                    .font(.title2)
                                    .foregroundStyle(Color.seaTurtle_1)
                                Spacer()
                            }
                            .padding()
                            .background {
                                Color.seaTurtle_4
                                    .cornerRadius(10.0)
                            }
                            
                        }
                        
                        NavigationLink(value: LocalDestination.addCollaboration) {

                            HStack {
                                Spacer()
                                Image(systemName: "person.2.fill")
                                    .imageScale(.large)
                                    .tint(.seaTurtle_1)
                                
                                Text("Registra Collaborazione")
                                    .bold()
                                    .font(.title2)
                                    .foregroundStyle(Color.seaTurtle_4)
                                Spacer()
                            }
                            .padding()
                            .background {
                                Color.seaTurtle_2
                                    .cornerRadius(10.0)
                            }
                            
                           
                        
                        }
                        Spacer()
                        
                        Button("Elimina Account", role: .destructive) {
                            self.authProcess.eliminaAccount()
                        }
                        .padding(.bottom)
                    }
                    
                  //  Spacer()
                  
                }
                .csAlertModifier(isPresented: self.$viewModel.showAlert, item: self.viewModel.alertItem)
                .navigationDestination(for: LocalDestination.self,destination: { localDestination in
                    associatedDestination(for:localDestination)
                })
               // .csAlertModifier(isPresented: $showLocalAlert, item: localAlert)
        }
          
           // .navigationDe
    }
    // Method
    @ViewBuilder private func associatedDestination(for destination:LocalDestination) -> some View {
        
        switch destination {
            
        case .addProperty:
            
            AddPropertyMainView() //{ mapItem in
/*
                do {
                    try await registrazioneProperty(mkItem: mapItem)
                    // registrazione andata a buon fine
                   // self.localNavigationPath.removeLast()
                   // self.viewModel.stepView = .mainView // non necessario
                    
                } catch {
                    
                    self.viewModel.alertItem = AlertModel(
                        title: "Server Error",
                        message: "Controllare la connessione dati e riprovare.\nIn caso di mancata risoluzione del problema contattare info@foodies.com ")
                } */

          //  }

        case .addCollaboration:
            ZStack {
                Color.yellow
                Text("DA CONFIGURARE")
            }
        }
        
    }
    
   /* private func registrazioneProperty(mkItem:MKMapItem) async throws {
        
       /* let userRole = self.viewModel.currentUser.map { user -> UserRoleModel in
            
            var local = UserRoleModel(uid: user.id, userName: user.userName, mail: user.email)
            local.ruolo = .admin
            local.inizioCollaborazione = .now
            local.restrictionLevel = nil
            
            return local
        } */
        
      /*  guard let userRole else {
            print("[EPIC_FAIL]_NO CURRENT USER IN VIEWMODEL, WHILE SUPPOSING SHOULD BE")
            // throw error
          //  throw URLError(.badServerResponse)
            return
        } */
        
        guard var user = self.viewModel.currentUser else {
            
              print("[EPIC_FAIL]_NO CURRENT USER IN VIEWMODEL, WHILE SUPPOSING SHOULD BE")
              // throw error
            //  throw URLError(.badServerResponse)
           // fatalError()
              return
          }
        
        user.propertyRole = CurrentUserRoleModel(ruolo: .admin)
    
        let mkCity = mkItem.placemark.locality ?? "NOLOCALITY"
        let mkCoordinate = mkItem.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)

        // genera un propertyModel
       let modelProperty = PropertyModel(
         intestazione: mkItem.name ?? "",
         cityName: mkCity,
         coordinates: mkCoordinate,
         webSite: mkItem.url?.absoluteString ?? "",
         phoneNumber: mkItem.phoneNumber ?? "",
         streetAdress: mkItem.placemark.thoroughfare ?? "",
         numeroCivico: mkItem.placemark.subThoroughfare ?? "",
         admin: user )
        
      //  let uuidFromMap = mkItem.placemark
        // salvare solo il field dei ref
        let ref = modelProperty.id
        
       /* let customEncoder:Firestore.Encoder = {
            // creiamo un custom Encode per codificare lo UserCloudData nell'organigramma
            let encoder = Firestore.Encoder()
            encoder.userInfo[user.codeForBusinessCollection] = false
            return encoder
        }() */
        
        // publish property first registration
        
        let userEncoder = user.customEncoding(forBusiness: false)
        
        try await GlobalDataManager
            .shared
            .propertiesManager
            .propertyFirstRegistration(
                property: modelProperty,
                userEncoder: userEncoder)
        
      /*  try await GlobalDataManager
                    .shared
                    .propertiesManager
                    .publishPropertyData(propertyRef: ref, element: modelProperty, to: customEncoder) */
        
        print("[DATA_SETTED]_registrazioneProperty_propertyModel")
        
        // salviamo il ref nello user che fa partire ul subscriber nel viewModel
        try await GlobalDataManager.shared.userManager.updatePropertiesRef(ref: ref, userId: user.id)
        
       

    }*/
    
    /*
    private func registrazioneProperty(mkItem:MKMapItem) async throws -> InitServiceObjet? {
        
        // userRoleModel derivato da quello corrente
        let authData = AuthPasswordLess.userAuthData
        let mkCity = mkItem.placemark.locality ?? "NOLOCALITY"
        let mkCoordinate = mkItem.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)
        
        let localUser:UserRoleModel = {
  
            var user = UserRoleModel(
                uid: authData.id,
                userName: authData.userName,
                mail: authData.mail)
             
             user.ruolo = .admin
             user.inizioCollaborazione = Date.now
             user.restrictionLevel = nil
             
             return user
         }()
        
        // genera un propertyModel
       let modelProperty = PropertyModel(
         intestazione: mkItem.name ?? "",
         cityName: mkCity,
         coordinates: mkCoordinate,
         webSite: mkItem.url?.absoluteString ?? "",
         phoneNumber: mkItem.phoneNumber ?? "",
         streetAdress: mkItem.placemark.thoroughfare ?? "",
         numeroCivico: mkItem.placemark.subThoroughfare ?? "",
         admin: localUser )

        let adress = modelProperty.streetAdress + " " + modelProperty.numeroCivico + "," + " " + modelProperty.cityName
        // crea Immagine proprietà
        let propertyImage = PropertyLocalImage(
            userRuolo: localUser,
            propertyName: modelProperty.intestazione,
            propertyRef: modelProperty.id,
            propertyAdress: adress)
        
        // Init array allImages per init ViewModel
        let allPropImages = [propertyImage] // 1/initServiceObject
 
        // Init Properties ref per l'utenteCorrente
        // tutto da riscrivere in chiave: 1. multiproprietà 2.modificare sul firebase solo i ref senza qui toccare l'isPremium
        let allRef = [modelProperty.id]
        let userCloud = UserCloudData(isPremium: authData.isPremium, propertiesRef: allRef)
        // {}
        
        print("[1]Pre Publish UserCloudData")
       try await GlobalDataManager.user.publishUserCloudData(forUser: authData.id, from: userCloud)
        
        
        
        print("[4]Post Publish UserCloudData")
        
        print("[1]PRE Pubblicazione su firebase del PropertyModel")
        try await GlobalDataManager.property.publishPropertyData(propertyRef: modelProperty.id, element: modelProperty)
        print("[4]POST Pubblicazione su firebase del PropertyModel")
       // print("Throw Error")
       // throw URLError(.badServerResponse)
        // creiamo un propertyCurrentData
        let propCurrentData = PropertyCurrentData(userRole: localUser, propertyModel: modelProperty) // 2/initServiceObject
        // creiamo un initServiceObject
        let serviceObject = InitServiceObjet(allPropertiesImage: allPropImages, currentProperty: propCurrentData)
        
        return serviceObject
    }*/// deprecata

    
    private enum LocalDestination:String,Hashable {
        case addProperty
        case addCollaboration

        
    }
}
