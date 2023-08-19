//
//  PropertiesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/01/22.
//

/* 03.02.2022 --> Bozza Definitiva */

import SwiftUI
import MapKit
import MyFoodiePackage
import MyPackView_L0
// 17/06/2023 Maps di Apple -> tentiamo di scriverne un altra con maps di Google. TENTATIVO FALLITO

struct NewPropertyMainView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @Binding var isShowingSheet:Bool
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var newProperty: MKMapItem?
    
    @State private var queryRequest: String = ""
    @State private var queryResults: [MKMapItem] = [] // viene riempita dalla query di ricerca
    
    @State private var currentRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @State private var showActivityInfo:Bool = false // deprecata
    
    var body: some View {
        
        ZStack {
                
            MapView(currentRegion: $currentRegion, queryResults: queryResults)
                .ignoresSafeArea()
                .zIndex(0)
                
            VStack(alignment: .trailing) {
                
                Button("Dismiss") {self.isShowingSheet.toggle()}.padding(.trailing).padding(.top)
           
                CSTextField_2(text: $queryRequest, placeholder: "nome attività, indirizzo, città", symbolName: "location.circle", accentColor: .green, backGroundColor: .white, autoCap:.words, cornerRadius: 5.0).padding(.horizontal,5)
                
                QueryScrollView_NewPropertySubView(
                    queryResults: queryResults,
                    queryRequest: queryRequest,
                    screenHeight: screenHeight){ propertyItem in
                   
                        self.showPlaceData(mkItem: propertyItem)
                    
                }
                    .zIndex(1)
                
                Spacer()
                
                if let property = self.newProperty {
                    
                    ChoiceInfoView_NewPropertySubView(
                        newProperty: property,
                        screenWidth: screenWidth,
                        frameHeight: screenHeight * 0.20) {
                            
                        //self.registrazioneProperty(mkItem: property)
                        try await checkProperty(mkItem: property)
                    }
                        .padding(.vertical, screenHeight * 0.05 )
                    
                }
      
            }
            
        }
        .onChange(of: queryRequest) { newValue in
            // Searching Place...
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                if newValue == queryRequest { queryResearch() }
            }
        }
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

    }
    
    // Method
    
    private func checkProperty(mkItem:MKMapItem) async throws {
        
        // verifichiamo che la prop non esiste
        let mkItemCoordinate = mkItem.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434)
        let mkCity = mkItem.placemark.locality ?? "NOLOCALITY"
        let idToCheck = PropertyModel.creaID(coordinates: mkItemCoordinate, cityName: mkCity)
        print("[1]Procediamo al check della unicità della proprietà")
        let alreadyExist = try await GlobalDataManager.cloudData.checkPropertyExist(for: idToCheck)
        
        guard !alreadyExist else {
            // proprietà già esistente / mandiamo un alert
            self.viewModel.alertItem = AlertModel(
                title: "Proprietà già registrata",
                message: "Per reclami e/o errori contattare info@foodies.com.",
                actionPlus: nil)
            return
        }
        print("[3]PropertyDoesNot exist. Procediamo alla registrazione")
        try await registrazioneProperty(
                mkItem: mkItem,
                mkCity: mkCity,
                mkCoordinate: mkItemCoordinate)
        
        print("[7]Registrazione terminata. Chiudiamo lo sheet della mappa")
        self.isShowingSheet.toggle()

        
    }
    
    private func registrazioneProperty(mkItem:MKMapItem,mkCity:String,mkCoordinate:CLLocationCoordinate2D) async throws {
        
        // userRoleModel derivato da quello corrente
        
        let localUser:UserRoleModel = {
            // id + email + usernam sono sempre gli stessi per tutte le prop e le collab dell'utente corrente
           // var user = self.viewModel.currentUserRoleModel
            var user = self.viewModel.currentProperty.userRole // c'è sempre uno user
            
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
        
        // aggiorna lista imaggini le dbCompiler
        
        self.viewModel.allMyPropertiesImage.append(propertyImage)
        
        // registra property sul firebase
        // verifichiamo la presenza di un databaseCorrente non associato ad una proprietà
       /* let involucro:PropertyDataObject = PropertyDataObject(registra: modelProperty, dataBase: nil)*/ // non associamo più in nessun caso nessun database alla proprietà in registrazione
        let allRef = self.viewModel.allMyPropertiesImage.map({$0.propertyID})
        let userCloud = UserCloudData(propertiesRef: allRef)
        
     
        
       // try await CloudDataManager.shared.publishMainCollection(in: .propertyCollection, idDoc: modelProperty.id, as: involucro)
        print("[4]Procediamo alla Pubblicazione su firebase")
      /*  try await CloudDataManager.shared.firstPropertyRegistration(idDoc: modelProperty.id, as: involucro)*/
        print("[5]Pubblicazione terminata. Procediamo all'update dello user ref")
        // aggiornare i riferimenti nella chiave utente in firebase

        try await GlobalDataManager.cloudData.publishMainCollection(in: .businessUser, idDoc: localUser.id, as: userCloud)
        print("[6]Update User Ref terminato")
       /* self.viewModel.dbCompiler.publishGenericOnFirebase(
            collection: .businessUser,
            refKey: localUser.id,
            element: userCloud) */
 
    }
    /*
    private func registrazionePropertyDEPRECATA(newProperty:PropertyModel) {
        
        // registra prop nel firebase propCollection
        self.viewModel.dbCompiler.registraPropertyOnFirebase(property: newProperty) { alert in
            
            if let problem = alert {
                //  proprietà gia' esistente
                self.viewModel.alertItem = problem
                
            } else {
                // salva CloudData Locale
               // self.viewModel.createItemModel(itemModel: newProperty)
                self.viewModel.creaPropertyRef(propertyRef: newProperty.id, role: .admin)
                
                if self.viewModel.cloudData.allMyPropertiesRef.isEmpty { // è un check di errore di salvataggio nel viewMODEL locale
                    // reset
                    self.viewModel.dbCompiler.deRegistraProprietà(propertyUID: newProperty.id) { deleteSuccess in
                        
                        if deleteSuccess {
                            self.viewModel.alertItem = AlertModel(title: "Server Message", message: "Salvataggio locale Fallito - deRegistrazione dal Server Success")
                        } else {
                            self.viewModel.alertItem = AlertModel(title: "Server Message", message: "Salvataggio locale Fallito - deRegistrazione dal server Fallita")
                        }
                        
                    }
                } else {
                    // salva cloudDataServer
                    self.viewModel.publishOnFirebase() { errorIn in
                        if errorIn {
                            // reset
                            self.viewModel.dbCompiler.deRegistraProprietà(propertyUID: newProperty.id) { deleteSuccess in
                                print("Errore nella registrazione del Ref nel cloud Data. DeRegistrazione property dalla propertyCollection avvenuta con successo? :\(deleteSuccess.description)")
                               // self.viewModel.deleteProperty(property: newProperty)
                                self.viewModel.cloudData.allMyPropertiesRef = [:]
                            }
                           
                            
                        } else {
                            // Success
                            self.queryRequest = ""
                            self.queryResults = []
                           // self.showActivityInfo = false
                            self.newProperty = nil
                            self.isShowingSheet = false
                        }
                    }
                }
            }
        }
    }*/ // 29.07.23 Deprecata
    
   private func showPlaceData(mkItem:MKMapItem) {
        
       self.currentRegion = MKCoordinateRegion(center: mkItem.placemark.coordinate , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.newProperty = mkItem
       // withAnimation { self.showActivityInfo = true }
       // self.showActivityInfo = true
    }
    
   private func queryResearch() {

       withAnimation(.linear(duration: 0.5)) {
           self.queryResults.removeAll()
         //  self.showActivityInfo = false
           self.newProperty = nil 
       }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.queryRequest
        // Fetch..
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else { return }
        
            self.queryResults = result.mapItems
          /*  self.queryResults = result.mapItems.compactMap({ (item) -> PropertyModel? in
  
         
              return PropertyModel(
                
                intestazione: item.name ?? "",
                cityName: item.placemark.locality ?? "",
                coordinates: item.placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.510977, longitude: 13.041434),
                webSite: item.url?.absoluteString ?? "",
                phoneNumber: item.phoneNumber ?? "",
                streetAdress: item.placemark.thoroughfare ?? "",
                numeroCivico: item.placemark.subThoroughfare ?? "",
                admin: self.viewModel.currentUserRoleModel // da cambiare
              )
            }) */ // 29.07.23 deprecata
        }
    }
}

// Preview
/*struct NewPropertySheetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewPropertySheetView(vm: PropertyVM(), isShowingSheet: .constant(true))
    
       /* PropertyChoiceInfoView(vm: PropertyVM(),screenWidth: UIScreen.main.bounds.width,frameHeight:  UIScreen.main.bounds.height * 0.15)*/
    }
} */
