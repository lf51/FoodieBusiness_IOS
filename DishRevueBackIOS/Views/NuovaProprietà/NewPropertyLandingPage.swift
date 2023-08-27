//
//  NewPropertyLandingPage.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/08/23.
//

import SwiftUI
import MyPackView_L0
import MapKit
import MyFoodiePackage


struct UserNameSettingView: View {
    
    @ObservedObject var authProcess:AuthPasswordLess
    @State private var newDisplayName:String = ""
    
    var body: some View {
        
        CSZStackVB(
            title: "Nome Profilo",
            titlePosition:.bodyEmbed([.horizontal], 10) ,
            backgroundColorView: .seaTurtle_1) {

                VStack {
                    
                    Spacer()
                    
                    Image(systemName: "fork.knife.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.seaTurtle_2)
                        .frame(maxWidth:500)
                        .padding(.vertical,60)
                    
                    Spacer()
                    
                    let placeHolder:String = {
                    
                        let split =  self.authProcess.email.split(separator: "@")
                        if let first = split.first {
                            return String(first)
                        } else {
                            return "userName"
                        }
                    }()
      
                    let disableButton:Bool = self.newDisplayName == ""
                    
                    let userNamePreview:String = self.authProcess.normalizzaUserNameString(newDisplayName: self.newDisplayName)
                    
                    VStack(alignment:.leading) {
                        CSTextField_1(
                            text: $newDisplayName,
                            placeholder: placeHolder,
                            symbolName: "at",
                            cornerRadius: 10,
                            keyboardType: .namePhonePad)
                        
                       
                            Text("preview: \(userNamePreview)")
                                .italic()
                                .font(.caption)
                                .foregroundStyle(Color.black)
                                .padding(.vertical,5)
                        
                        CSButton_large(
                            title: "Submit",
                            font: .title2,
                            accentColor: .seaTurtle_4,
                            backgroundColor: .seaTurtle_2,
                            cornerRadius: 10,
                            corners: .allCorners,
                            paddingValue: nil) {
                                
                                self.authProcess.updateDisplayName(newDisplayName: self.newDisplayName)
                                
                            }
                            .opacity(disableButton ? 0.6 : 1.0)
                            .disabled(disableButton)
                            
                           // .padding(.bottom)

                        Text("• Può contenere caratteri alfanumerici;\n• Gli spazi vengono rimossi;\n• Le lettere maiuscole non sono riconosciute;\n• Una volta impostato non può essere modificato;\n• Identifica l'utente nell'organigramma della proprietà;\n• Non è visibile ai clienti, ma solo a eventuali collaboratori.")
                            .font(.subheadline)
                            .foregroundStyle(Color.black)
                            .lineSpacing(5.0)
                            .multilineTextAlignment(.leading)
                           // .frame(maxWidth:.infinity)
                            .padding(.vertical,5)
                           /* .background(
                                Color.gray.opacity(0.20)
                                    .cornerRadius(5.0)
                            )*/
                    }
                      //  .padding(.bottom)
                    Spacer()

                }
                
                
            }
        
       
    }
    
}

struct WelcomeLandingPage: View {
    
    let serviceObjectBack:(_ :InitServiceObjet?) -> ()
    @State var localNavigationPath:NavigationPath = NavigationPath()
    
    @State private var showLocalAlert:Bool = false
    @State private var localAlert:AlertModel? {didSet { showLocalAlert = true} }
    
    var body: some View {
        
        NavigationStack(path: $localNavigationPath) {
            
            CSZStackVB(
                title: "Welcome \(AuthPasswordLess.userAuthData.userName)",
                titlePosition:.bodyEmbed([.horizontal], 10) ,
                backgroundColorView: .seaTurtle_1) {
                    
                   // Spacer()
                    
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
                    }
                    
                  //  Spacer()
                  
                }
                .csAlertModifier(isPresented: $showLocalAlert, item: localAlert)
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
            AddPropertyMainView(showLocalAlert:$showLocalAlert,localAlert:$localAlert) { mapItem in

                do {
                    let serviceObject = try await registrazioneProperty(mkItem: mapItem)
                    serviceObjectBack(serviceObject)
                } catch {
                    self.localAlert = AlertModel(
                        title: "Server Error",
                        message: "Controllare la connessione dati e riprovare.\nIn caso di mancata risoluzione del problema contattare info@foodies.com ")
                }

            }

        case .addCollaboration:
            Color.yellow
        }
        
    }
    
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
    }

    
    private enum LocalDestination:String,Hashable {
        case addProperty
        case addCollaboration

        
    }
}

#Preview {
   /* NavigationStack {
        WelcomeLandingPage{ service in
        }
    }*/
    UserNameSettingView(authProcess: AuthPasswordLess())
}
