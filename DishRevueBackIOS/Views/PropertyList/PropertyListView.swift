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
   
            CSDivider()
                
                  ScrollView(showsIndicators: false){
                        
                          ForEach(viewModel.cloudData.allMyProperties) { property in
                                    
                              GenericItemModel_RowViewMask(
                                model: property) {
                                   // non usiamo il modulo TrashEDit perchè richiede una conformità che la propertyModel non ha
                                    property.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.homeViewPath)
   
                                    
                                }
                              
                              CollabsEntryCode(adminUUID: "UUID") // qui passiamo l'UUid dell'admin
                              
                          } // chiusa ForEach
                  }
               
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                HStack(spacing:0) {
                
                    LargeBar_TextPlusButton(
                        buttonTitle: "Collabora",
                        font: .callout,
                        imageBack: viewModel.cloudData.allMyProperties.isEmpty ? Color.mint : Color.red.opacity(0.6),
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
        /*.sheet(isPresented: self.$wannaAddNewProperty) {
            
            NewPropertyMainView(isShowingSheet: self.$wannaAddNewProperty)
          
        }*/
        .popover(isPresented: $wannaAddNewProperty, content: {
            NewPropertyMainView(isShowingSheet: self.$wannaAddNewProperty)
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
    
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PropertyListView(backgroundColorView: Color.seaTurtle_1).environmentObject(AccounterVM())
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
