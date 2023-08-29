//
//  PropertyListView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/04/22.
//

import SwiftUI
import MyPackView_L0
import CoreImage.CIFilterBuiltins
import CodeScanner
import MyFoodiePackage
import MyFilterPackage

struct PropertyListView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
 
    let backgroundColorView: Color
    @State private var wannaAddNewProperty: Bool = false
    @State private var wannaCollaborate: Bool = false

    init(backgroundColorView:Color){
        
        self.backgroundColorView = backgroundColorView
        
        print("INIT -> PROPERTYLISTVIEW")
        
    }
    
    var body: some View {
        
        CSZStackVB(title: "Le Mie Proprietà", backgroundColorView: backgroundColorView) {
 
            VStack(alignment:.leading, spacing: 10.0) {
                
                CSLabel_1Button(
                    placeHolder: "Attiva",
                    imageNameOrEmojy: "circle.fill",
                    imageColor: .green,
                    backgroundColor: .seaTurtle_3)
           // CSDivider()
                if let propertyCorrente = self.viewModel.currentProperty.info {
                    
                    VStack {
                        
                        GenericItemModel_RowViewMask(model: propertyCorrente) {
                            propertyCorrente.vbMenuInterattivoModuloCustom(
                                viewModel: viewModel,
                                navigationPath: \.homeViewPath)
                        }
                        CollabsEntryCode(adminUUID: "SISTEMARE: UUID property + Pin / Durata a tempo e poi scompare") // costruire su richiesta con bottone/ sia quello di accoppiamento sia quello del menu
                    }
  
                } else {
                    Text("No Property in")
                        .italic()
                }
                
                CSLabel_1Button(
                    placeHolder: "Others",
                    imageNameOrEmojy: "circle.fill",
                    imageColor: .red,
                    backgroundColor: .seaTurtle_3)

                  ScrollView(showsIndicators: false){
                        
                      if !self.viewModel.allMyPropertiesImage.isEmpty {

                          // Mostra le proprietà registrate
                          ForEach(self.viewModel.allMyPropertiesImage,id:\.self) {  propImage in
                              
                              let isActive:Bool = {
                                  
                                  return self.viewModel.currentProperty.info?.id == propImage.propertyID
                                  
                              }()
                              
                              
                             /* HStack {
                                  
                                  VStack {
                                      
                                      Text(propImage.propertyName)
                                          .font(.largeTitle)
                                          .foregroundStyle(Color.black)
                                      
                                      Text(propImage.adress)
                                          .italic()
                                          .font(.body)
                                      
                                      Text(propImage.userRuolo.ruolo.rawValue)
                                          .italic()
                                          .font(.body)
                                      
                                      
                                  }
                                  
                                  Spacer()
                                  
                                  Button("Go") {
                                      print("Go Action")
                                      
                                      GlobalDataManager.property.estrapolaPropertyData(from: propImage) { propertyCurrentData in
                                          
                                          DispatchQueue.main.async {
                                              // Soluzione errore: make sure to publish values from the main thread (via operators like receive(on:)) on model updates
                                              if let propertyCurrentData {
                                                  self.viewModel.currentProperty = propertyCurrentData
                                              }
                                          }

                                      }
                                 
                                  }
                                  
                              }*/
                              InactivePropertyRow(propImage:propImage,isActive:isActive)
                              .disabled(isActive)
                              .opacity(isActive ? 0.6 : 1.0)

                          }

                      } else {
                          
                          Text("Nessuna proprietà o collaborazione registrata.")
                      }

                  }
               
            }
            .padding(.horizontal)
        }

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
               // let isPremium = AuthenticationManager.userAuthData.isPremium
                let isPremium = self.viewModel.currentUser?.isPremium ?? false
                
                
                HStack(spacing:0) {
                
                    LargeBar_TextPlusButton(
                        buttonTitle: "Collabora",
                        font: .callout,
                        imageBack: isPremium ? Color.yellow : Color.red.opacity(0.6),
                        imageFore: Color.seaTurtle_4) {
                        
                        withAnimation {
                          
                            self.addCollaboration(isPremium: isPremium)
                        }
                    }
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Proprietà",
                        font: .callout,
                        imageBack: isPremium ? Color.seaTurtle_2 : Color.red.opacity(0.6),
                        imageFore: Color.seaTurtle_4) {
                        
                        withAnimation {
                          
                            self.addNewPropertyCheck(isPremium: isPremium) // Abbiamo scelto di sviluppare come SingleProperty, manteniamo però una impostazione da "MultiProprietà" per eventuali sviluppi futuri. Ci limitiamo quindi a bloccare la possibilità di aggiungere altre proprietà dopo la prima.
                        }
                    } // Chiusa LargeButton
 
                }
            }
        }
       /* .fullScreenCover(isPresented: $wannaAddNewProperty, content: {
            AddPropertyMainView(
                showLocalAlert: self.$viewModel.showAlert,
                localAlert: self.$viewModel.alertItem,
                registrationAction: { mapItem in
                    // da compilare quando attiveremo la multiproprietà
                })
        }) */
       .popover(
            isPresented: $wannaAddNewProperty,
            attachmentAnchor: .point(.top),
            arrowEdge: .bottom,
            content: {
           // NewPropertyMainView(isShowingSheet: self.$wannaAddNewProperty)
                AddPropertyMainView(
                    addTopPadding: true,
                    registrationAction: { mapItem in
                        // codice registrazione in multiproprietà
                    })
                    .presentationDetents([.large])
        })
        .popover(isPresented: $wannaCollaborate) {
           CodeScannerView(codeTypes: [.qr], completion: { result in
               // handle l'uuid dell'admin per compilare il view model con il database
               // codice registrazione in multiproprietà
            })
           .presentationDetents([.medium])
        }

    }
    
    // Method
    
  /*  private func handleScan(result:Result<ScanResult,ScanError>) {
         
         // handle QRCode
         isShowingScanner = false
         
         switch result {
         case .success(let success):

             self.viewModel.cloudDataCompiler = CloudDataCompiler(userUID: success.string)
             
             self.viewModel.compilaCloudDataFromFirebase()
             
             print("link:\(success.string) and type:\(success.type.rawValue)")
       
             
         case .failure(let failure):
             print("Scan Failure :\(failure.localizedDescription)")
         }
         
     }*/ // l'handle dell'app client per compilare i menu. Adattare alla business. Dovrà anche inserire la proprietà in allMyProperties e questo garantirà poi il blocco di futuri click su collabora e proprietà. Dovraà accedere al database dell'admin e verificare la presenza della propria mail e scaricare le autorizzazioni
    
    private func addCollaboration(isPremium:Bool ) {
        
        guard isPremium else  {
            
            viewModel.alertItem = AlertModel(
                title: "⛔️ Restrizioni Account",
                message: "Spiacenti. Raggiunto il numero max di collaborazioni.\nNecessario Upgrade ad account Premium")
            
            return
        }
        
       /* guard viewModel.dbCompiler.allMyProperties == nil else {
            
            viewModel.alertItem = AlertModel(
                title: "⛔️ Restrizioni Account",
                message: "Spiacenti. Raggiunto il numero max di collaborazioni.")
            
            return }*/
        
        self.wannaCollaborate = true
       
    }
    
    private func addNewPropertyCheck(isPremium:Bool) {
        
        guard isPremium else  {
            
            viewModel.alertItem = AlertModel(
                title: "⛔️ Restrizioni Account",
                message: "Spiacenti. Raggiunto il numero max di Proprietà.\nNecessario Upgrade ad account Premium")
            
            return
        }
        
        self.wannaAddNewProperty = true
 
    }
    
}

struct InactivePropertyRow:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let propImage:PropertyLocalImage
    let isActive:Bool
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            let value:(image:String,imageColor:Color) = {
               
                if isActive {
                    
                    return ("checkmark.icloud.fill",.green)
                } else {
                    return ("icloud.and.arrow.down",.seaTurtle_3)
                }
                
            }()
            
            HStack {
                
                Text(propImage.userRuolo.ruolo.rawValue)
                    .italic()
                    .font(.callout)
                    .foregroundStyle(Color.black)
                    .opacity(0.75)
                
                Divider()
                
                VStack(alignment:.leading) {
                    
                    Text(propImage.propertyName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black)
                    
                    Text(propImage.adress)
                        .italic()
                        .font(.caption)
                    
                }
                
                Spacer()
                
                Button {
                    
                    GlobalDataManager.property.estrapolaPropertyData(from: propImage) { propertyCurrentData in
                        
                        DispatchQueue.main.async {
                            // Soluzione errore: make sure to publish values from the main thread (via operators like receive(on:)) on model updates
                            if let propertyCurrentData {
                                self.viewModel.currentProperty = propertyCurrentData
                            }
                        }

                    }
                } label: {
                    HStack {
                        Image(systemName: value.image)
                            .imageScale(.large)
                            .foregroundStyle(value.imageColor)
                            
                    }
                }
            }
            Divider()
            
        }
        
        
    }
}

/*
struct PropertyListView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let userAuth:UserModel? = UserModel(userEmail: "", userUID: "", userProviderID: "", userDisplayName: "", userEmailVerified: true) //28.07.23 deprecata perchè lo user è preso dal viewModel
    let backgroundColorView: Color
    @State private var wannaAddNewProperty: Bool = false
    @State private var wannaCollaborate: Bool = false

    init(backgroundColorView:Color){
        
        self.backgroundColorView = backgroundColorView
        
        print("INIT -> PROPERTYLISTVIEW")
        
    }
    
    var body: some View {
        
        CSZStackVB(title: "Le Mie Proprietà", backgroundColorView: backgroundColorView) {
 
            VStack(alignment:.leading, spacing: 10.0) {
   
            CSDivider()
                
                  ScrollView(showsIndicators: false){
                        
                         // ForEach(viewModel.cloudData.allMyProperties) { property in
                                    
                      if let property = self.viewModel.currentProperty {
                          
                          VStack {
                              GenericItemModel_RowViewMask(
                                model: property) {
                                   // non usiamo il modulo TrashEDit perchè richiede una conformità che la propertyModel non ha
                                    property.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.homeViewPath)

                                    
                                }
                              
                              CollabsEntryCode(adminUUID: property.id) // qui passiamo l'UUid dell'admin
                              
                          }
                      }
                         // } // chiusa ForEach
                  }
               
            }
            .padding(.horizontal)
        }
        .onAppear {
            
            guard self.viewModel.currentProperty == nil else { return }
            
            let propertyRef = self.viewModel.cloudData.allMyPropertiesRef.values
            let refArray:[String] = Array(propertyRef)
            guard let propRef = refArray.first else { return }
            
            self.viewModel.dbCompiler.fetchDocument(
                collection: .propertyCollection,
                docRef: propRef,
                modelSelf:PropertyModel.self) { modelData in
                self.viewModel.currentProperty = modelData
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                HStack(spacing:0) {
                
                    LargeBar_TextPlusButton(
                        buttonTitle: "Collabora",
                        font: .callout,
                        imageBack: viewModel.cloudData.allMyProperties.isEmpty ? Color.yellow : Color.red.opacity(0.6),
                        imageFore: Color.seaTurtle_4) {
                        
                        withAnimation {
                          
                            self.addCollaboration()
                        }
                    }
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Proprietà",
                        font: .callout,
                        imageBack: viewModel.cloudData.allMyProperties.isEmpty ? Color.seaTurtle_2 : Color.red.opacity(0.6),
                        imageFore: Color.seaTurtle_4) {
                        
                        withAnimation {
                          
                            self.addNewPropertyCheck() // Abbiamo scelto di sviluppare come SingleProperty, manteniamo però una impostazione da "MultiProprietà" per eventuali sviluppi futuri. Ci limitiamo quindi a bloccare la possibilità di aggiungere altre proprietà dopo la prima.
                        }
                    }
                    
                }
            }
        }
        .popover(isPresented: $wannaAddNewProperty, content: {
            NewPropertyMainView(userAuth: userAuth, isShowingSheet: self.$wannaAddNewProperty)
        })
        .popover(isPresented: $wannaCollaborate) {
           CodeScannerView(codeTypes: [.qr], completion: { result in
               // handle l'uuid dell'admin per compilare il view model con il database
            })
        }

    }
    
    // Method
    
  /*  private func handleScan(result:Result<ScanResult,ScanError>) {
         
         // handle QRCode
         isShowingScanner = false
         
         switch result {
         case .success(let success):

             self.viewModel.cloudDataCompiler = CloudDataCompiler(userUID: success.string)
             
             self.viewModel.compilaCloudDataFromFirebase()
             
             print("link:\(success.string) and type:\(success.type.rawValue)")
       
             
         case .failure(let failure):
             print("Scan Failure :\(failure.localizedDescription)")
         }
         
     }*/ // l'handle dell'app client per compilare i menu. Adattare alla business. Dovrà anche inserire la proprietà in allMyProperties e questo garantirà poi il blocco di futuri click su collabora e proprietà. Dovraà accedere al database dell'admin e verificare la presenza della propria mail e scaricare le autorizzazioni
    
    private func addCollaboration() {
        
        guard viewModel.cloudData.allMyProperties.isEmpty else {
            
            viewModel.alertItem = AlertModel(
                title: "⛔️ Restrizioni Account",
                message: "Spiacenti. Raggiunto il numero max di collaborazioni.")
            
            return }
        
        self.wannaCollaborate = true
       
    }
    
    private func addNewPropertyCheck() {
        
        guard viewModel.cloudData.allMyProperties.isEmpty else {
            
            viewModel.alertItem = AlertModel(
                title: "⛔️ Restrizioni Account",
                message: "Spiacenti. Raggiunto il numero max di proprietà registrabili.")
            
            return }
        
        self.wannaAddNewProperty = true
        
    }
    
}*/ // 28.07.23 Backup


struct PropertyListView_Previews: PreviewProvider {
    static var user:UserRoleModel = UserRoleModel()
    static var previews: some View {
        NavigationView {
            PropertyListView(backgroundColorView: Color.seaTurtle_1)
                .environmentObject(AccounterVM(from: initServiceObject))
        }
    }
}

///https://www.hackingwithswift.com/books/ios-swiftui/generating-and-scaling-up-a-qr-code
struct CollabsEntryCode:View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let adminUUID:String?
    
    var body: some View {
        
        if let uuid = adminUUID {
            
            Image(uiImage: generateQRCode(from: uuid)) // genera un qrcode dall'UID dell'admin. Qualunque sia la proprietà. Nel caso dovessimo permettere le multiproprietà quest'architettura andrebbe cambiata.
                .interpolation(.none)
                .resizable()
                .scaledToFit()
            
        } else { EmptyView() }
        
    }
    
    // Method
    
    func generateQRCode(from string:String) -> UIImage {
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
            
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
