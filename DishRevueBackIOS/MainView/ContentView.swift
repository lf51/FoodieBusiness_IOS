//
//  ContentView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import SwiftUI
import MyFoodiePackage

struct ContentView: View {
    
    @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
    
    var body: some View {

        switchAuthCase()
        .id(authProcess.hashValue)
        .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)

    }
    
    // Method
    
   @ViewBuilder private func switchAuthCase() -> some View {
        
       if let authCase = self.authProcess.authCase {
           
           switch authCase {
               
           case .noAuth:
               LinkSignInSheetView(authProcess: self.authProcess)
           case .auth_noUserName:
               UserNameSettingView(authProcess: self.authProcess)
           case .auth:
               SubContentView(authProcess: self.authProcess)
           }
           
       } else {
           
           WaitLoadingView(
            backgroundColorView: .yellow)
       }

    }
}



struct SubContentView:View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    @StateObject var viewModel:AccounterVM
    
    init(authProcess: AuthPasswordLess) {
        
       // let userUID = AuthPasswordLess.userAuthData.id
        let viewModel = AccounterVM()
        
        self.authProcess = authProcess
        _viewModel = StateObject(wrappedValue: viewModel)
       
    }

  // @State private var viewStep:SubViewStep = .openWaitingView
   // @State private var vmServiceObject:InitServiceObjet?
    
    var body: some View {
        
        switchSubView()
            .onAppear {
            // fuori il task va in asincrono. Mettiamo tutte le funzioni in ordine dentro il task. La view della registrazione va diretta in quanto il primo valore dei dati è nil, possiamo coprirla con una loading fin quando il task non ha terminato
            print("[1]Start OnAppear in SubContentView")
                Task {
                  // try await retrieveTask()
                }
       
            print("[6]END OnAppear in SubContentView")
            }.onDisappear {
                print("SUB_CONTENT DISAPPEAR")
            }
            
          
        
    }
    
    // Method
    
   
    
    @ViewBuilder private func switchSubView() -> some View {
         
        switch self.viewModel.stepView {
            
        case .mainView(let loading):
            
            MainView(authProcess: self.authProcess)
                .csModifier(loading) { mainView in
                    
                    mainView
                        .overlay {
                            WaitLoadingView(
                                backgroundColorView: .seaTurtle_1) {
                                    
                                VStack(alignment:.leading) {
                                    
                                    if let user = self.viewModel.currentUser {
                                        
                                        Text("Properties_Ref:\(user.propertiesRef.count)")
                                        Text("PremiumUser:\(user.isPremium.description)")
                                        
                                        Text("Prop_Images:\(self.viewModel.allMyPropertiesImage.count)")
                                        Text("Property_IN:\(self.viewModel.currentProperty.info?.intestazione ?? "DEFAULT PROPERTY")")
                                        
                                    } else {
                                        
                                        Text("NO USER IN")
                                    }

                                }
                            }
                                .opacity(0.6)
                        }
                    
                }
                .environmentObject(self.viewModel)
            
        case .openLandingPage:
            WelcomeLandingPage { serviceObject in
                //self.vmServiceObject = serviceObject
                /* if let serviceObject {
                 self.viewStep = .mainView(serviceObject)
                 }*/
            }
            
        default:
            WaitLoadingView(
                backgroundColorView: .red)
            
        }
     }
    /*
    private func retrieveTask() async throws {
        
        print("[1]IN_retrieveTASK")
        // recuperiamo i ref dello user
        let authData = AuthPasswordLess.userAuthData
        
        let userCloudData = try? await GlobalDataManager.user.retrieveUserPropertyRef(forUser: authData.id)
        // verifichiamo che lo UserCloud sia valido
        guard let userCloudData,
        !userCloudData.propertiesRef.isEmpty else {
            print("Lo UserCloudData è nil o NO REF")
            self.viewStep = .openLandingPage
            return
        }
        
        self.viewStep = .mainView(userCloudData)
  

        
       /*
        // se lo userCloud è valido aggiorniamo l'isPremium
        let isPremium = userCloudData.isPremium
        AuthPasswordLess.userAuthData.isPremium = isPremium
        
        // verifichiamo che i property ref ci siano
        guard !userCloudData.propertiesRef.isEmpty else {
            print("Lo UserCloudData non ha ref")
            self.viewStep = .openLandingPage
            return
        }
        
        // retrieve images e currentProp
       
        GlobalDataManager.property.fetchCurrentProperty(from: userCloudData.propertiesRef) { propImages, currentProperty in

            if let propImages,
               let currentProperty {
               // self.vmServiceObject = InitServiceObjet(allPropertiesImage: propImages, currentProperty: currentProperty)
                let serviceObject = InitServiceObjet(allPropertiesImage: propImages, currentProperty: currentProperty)
                self.viewStep = .mainView(serviceObject)
            } else {
               // self.viewStep = .openLandingPage
            }
        }
 
        print("[5]End_retrieveTASK")*/
    }*/
    
}


/*
struct ContentView: View {
    
    @StateObject var authProcess: AuthPasswordLess = AuthPasswordLess()
   // @State private var isLoading:Bool = false
    
    var body: some View {
    
        Group {
            
            if let user = self.authProcess.utenteCorrente {
                
                let vm = AccounterVM(userAuth: user)
                MainView(authProcess: self.authProcess, viewModel: vm)
                // 28.07.23 Verificare il funzionamento. La Main viene init prima che l'isLoading cambia/ si no? Cosa accade?
                   
            } else {
                
                LinkSignInSheetView(authProcess: self.authProcess)
            }
        }
        .id(authProcess.hashValue)
        .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
       /* .fullScreenCover(isPresented: $authProcess.isLoading, content: {
             WaitLoadingView(backgroundColorView: .seaTurtle_1)
         })*/
       /* .fullScreenCover(isPresented: $isLoading, content: {
            WaitLoadingView(backgroundColorView: .seaTurtle_1)
        }) */
        
        
   /*  MainView(authProcess: authProcess)
            .id(authProcess.hashValue) // Nota 14.11
            .fullScreenCover(isPresented: $authProcess.openSignInView, content: {
                LinkSignInSheetView(authProcess: authProcess)
        })
            .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem) */ // 25.07.23 deprecata per abbandono della skip option
       
    }
    
    // Method

} */// 13.08.23







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
