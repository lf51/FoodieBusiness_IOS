//
//  ContentView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/01/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct ContentView: View {
    
    @StateObject var authProcess: AuthenticationManager = AuthenticationManager()
    
    var body: some View {

        switchAuthCase()
       // .id(authProcess.hashValue)
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
            backgroundColorView: .yellow,
            image: "fork.knife.circle",
            imageColor: Color.seaTurtle_2)
       }

    }
}

struct SubContentView:View {
    
    @ObservedObject var authProcess: AuthenticationManager
    @StateObject private var viewModel:AccounterVM
    
    init(authProcess: AuthenticationManager) {
        
        print("""
              [START_INIT]_SubContentView
              
              UserManager refCount:\(CFGetRetainCount(authProcess.userManager))
              
              """)
       // let userUID = AuthenticationManager.userAuthData.id
        // se siamo qui lo userManager è stato inizializzato
        let viewModel = AccounterVM(userManager: authProcess.userManager!)
        
        self.authProcess = authProcess
        _viewModel = StateObject(wrappedValue: viewModel)
       
        print("""
[END_INIT]_SubContentView

UserManager refCount:\(CFGetRetainCount(authProcess.userManager))
""")
    }

    var body: some View {
        
        switchSubView()
            .environmentObject(self.viewModel)
            .overlay(content: {
                
                if let isLoading = self.viewModel.isLoading,
                isLoading {

                    WaitLoadingView(
                        backgroundColorView: .seaTurtle_1,
                        image: "fork.knife.circle",
                        imageColor: Color.seaTurtle_2, 
                        loadingInfo: {
                            
                            VStack(alignment:.leading,spacing:10) {
                                let refIn = self.viewModel.currentUser?.propertiesRef?.count
                                let autHIn = self.viewModel.allMyPropertiesImage.count
                                
                                Text("PUBLISHER IN:_\(self.viewModel.cancellables.count)")
                                    .font(.largeTitle)
                                
                                HStack {

                                    Text("Loading User data...")
                                        .fontDesign(.monospaced)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .bold()
                                        .foregroundStyle(self.viewModel.currentUser != nil ? Color.green : Color.gray)
                                       
                                }
                                HStack {
                                    Text("Properties In... \(refIn ?? 0)")
                                        .fontDesign(.monospaced)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .bold()
                                        .foregroundStyle(self.viewModel.currentUser?.propertiesRef?.isEmpty ?? true ? Color.gray : Color.green)
                                }
                                HStack {
                                    Text("Autorization In... \(autHIn)/\(refIn ?? 0)")
                                        .fontDesign(.monospaced)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .bold()
                                        .foregroundStyle(self.viewModel.allMyPropertiesImage.isEmpty ? Color.gray : Color.green)
                                }
                                HStack {
                                    Text("Loading default Property...")
                                        .fontDesign(.monospaced)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .bold()
                                        .foregroundStyle(self.viewModel.currentProperty.info?.cityName != "TEST" ? Color.green : Color.gray)
                                }

                            }    
                            .padding()
                            .background {
                                Color.seaTurtle_2
                                    .cornerRadius(5.0)
                                    .opacity(0.8)
                                    
                            }
                    })
                    .opacity(0.6)
                } else {
                    
                    VStack(alignment:.leading) {
                        
                        Spacer()
                        
                        Text("PUBLISHER IN:_\(self.viewModel.cancellables.count)")
                        Text("Reference ViewModel:\(CFGetRetainCount(self.viewModel))")
                        
                       /* Button("TEST ACTION") {
                            print("[ACTION]_testChangeuserName()")
                            self.viewModel.currentUser?.userName = "TEST" + UUID().uuidString
                            
                        }*/
                            
                    }.font(.caption)

                }
            })
           /* .overlay(alignment: .bottom, content: {
                if let logMessage = self.viewModel.logMessage {
                    
                    VStack(alignment:.leading) {
                        
                        Text(logMessage)
                            .font(.title2)
                            .fontWidth(.compressed)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                            .multilineTextAlignment(.leading)
                        
                    }
                   
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .background {
                        Color.seaTurtle_4.opacity(0.15)
                            
                    }
                    .offset(y: -50)
                    
                }
            })*/
            .onAppear {
                print("[APPEAR]_SubContentView")
            }.onDisappear {
                print("[DISAPPEAR]_SubContentView")
                
            /*    print("""
                
        Are Listener active when call [DISAPPEAR]_SubContentView :

        UserListener is active: \(GlobalDataManager.shared.userManager.userListener != nil),
        PropertyImagesListener is active: \(GlobalDataManager.shared.propertiesManager.propertyImagesListener != nil)
        
        Active ref when call [DISAPPEAR]_SubContentView :
        
        ViewModel reference Count: \(CFGetRetainCount(self.viewModel))
        PropertyManager refCount:\(CFGetRetainCount(GlobalDataManager.shared.propertiesManager))
        UserManager refCount:\(CFGetRetainCount(GlobalDataManager.shared.userManager))
        CloudDataManager refCount:\(CFGetRetainCount(GlobalDataManager.shared.cloudDataManager))

        """)*/
            }
 
    }
    
    // Method
        

    private func manageBackToAutentication() {
        
       /* print("""
        
Are Listener active when call manageBackToAutentication :

UserListener is active: \(GlobalDataManager.shared.userManager.userListener != nil),

PropertyImagesListener is active: \(GlobalDataManager.shared.propertiesManager.propertyImagesListener != nil)

ViewModel reference Count: \(CFGetRetainCount(self.viewModel))

""")*/
        
        withAnimation {
            self.authProcess.authCase = .auth_noUserName
        }
        
        self.authProcess.alertItem = AlertModel(
            title: "⚠️ Dati Corrotti ⚠️", message: "Collegamento al Database fallito. Inserire lo userName per ricreare un collegamento valido. E' possibile la perdita dei vecchi dati, proprietà, piatti, menu ecc...\n Per evitare la perdita dei dati, non procedere al submit, controllare la connessione e riavviare l'app.\nSe il problema non si risolve contattare info@foodies.com")
        

        
        
    }
   
    
    @ViewBuilder private func switchSubView() -> some View {
         
        switch self.viewModel.stepView {
            
        case .mainView:
            MainView(authProcess: self.authProcess)
            
        case .openLandingPage:
            WelcomeLandingPage(authProcess:self.authProcess)
            
        case .backToAuthentication:
            
            WaitLoadingView(
                backgroundColorView: .green,
                image: "fork.knife.circle",
                imageColor: Color.seaTurtle_2,
                onAppearAction:  {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // il delay da togliere
                        self.manageBackToAutentication()
                    }
            })
 
        default: WaitLoadingView(
            backgroundColorView: .red,
            image: "fork.knife.circle",
            imageColor: Color.seaTurtle_2)
                
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
