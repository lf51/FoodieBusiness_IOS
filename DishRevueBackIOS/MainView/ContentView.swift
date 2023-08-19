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
    

        Group {
            
            if let user = self.authProcess.utenteCorrente {
                
              
                
                SubContentView(authProcess: self.authProcess, userAutenticato: user)
                
                
                
                
               /* let vm = AccounterVM(userAuth: user)
                MainView(authProcess: self.authProcess, viewModel: vm)
                // 28.07.23 Verificare il funzionamento. La Main viene init prima che l'isLoading cambia/ si no? Cosa accade? */
                   
            } else {
                
                LinkSignInSheetView(authProcess: self.authProcess)
            }
        }
        .id(authProcess.hashValue)
        .csAlertModifier(isPresented: $authProcess.showAlert, item: authProcess.alertItem)
        

       
    }
    
    // Method
    
  

}

struct SubContentView:View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    let userAutenticato:UserRoleModel
    
    @State private var vmServiceObject:InitServiceObjet?
    
    var body: some View {
        
        Group {
            
            if let vmServiceObject {
                
                // init del viewModel
              /*  let vm = AccounterVM(userAuth: userAutenticato)
                MainView(authProcess: self.authProcess, viewModel: vm) */
                
                let vm = AccounterVM(from: vmServiceObject)
                MainView(authProcess: self.authProcess, viewModel: vm)
                
                Text("Utente Autenticato:\(userAutenticato.id)\n Ref Proprietà trovati")
                
            } else {
                
                // open Registrazione Property // scelta userName
                Text("Utente Autenticato:\(userAutenticato.id)\nNessuna Proprietà In")
                
                
                
            }
        }
        .onAppear {
            // fuori il task va in asincrono. Mettiamo tutte le funzioni in ordine dentro il task. La view della registrazione va diretta in quanto il primo valore dei dati è nil, possiamo coprirla con una loading fin quando il task non ha terminato
            print("[1]Start OnAppear in SubContentView")
            
            Task {
                print("[2]Start Task in OnAppear SubContentView")
                // recuperiamo i ref dello user
                let userPropertyRef = try await GlobalDataManager.user.retrieveUserPropertyRef(forUser: self.userAutenticato.id)
                
                // update userAuth nella static del ViewModel
                AccounterVM.userAuthData = (self.userAutenticato.id,self.userAutenticato.mail,self.userAutenticato.mail)
               
                // recuperiamo le propertyImage
                
               /* let allPropImages = try PropertyManager.main.retrievePropertiesLocalImages(from: userPropertyRef?.propertiesRef) */
                print("[5]PreCall retrievePropertyImages]")
               // try PropertyManager.main.retrievePropertiesLocalImages(from: userPropertyRef?.propertiesRef)
                GlobalDataManager.property.fetchCurrentProperty(from: userPropertyRef?.propertiesRef) { propImages, currentProperty in
                    
                    // [15.08.23] ATTENZIONE spesso trova errore enll'optionalBinding e crasha la build
                    if let propImages,
                       let currentProperty {
                        self.vmServiceObject = InitServiceObjet(allPropertiesImage: propImages, currentProperty: currentProperty)
                    }

                   
                }
                print("[AfterCAll retrievePropertyImages]")
               /* PropertyManager.main.retrievePropertiesLocalImages(from: userPropertyRef!.propertiesRef) { images in
                    // Ritorna le immagini delle prop dove l'user è autorizzato
                    // 14.08.23 Problema: il listener è applicato a tutte le ref, anche a quelle dove non c'è autorizzazione. Risolvere
                    
                    print("images count:\(images?.count ?? 555) vs ref count:\(userPropertyRef?.propertiesRef.count ?? 444)")
                    
                    // tramite le images inizializziamo il vm
                    self.propertiesImages = images
                 
                    
                } */

                
                print("[5]End Task in OnAppear SubContentView")
            }
            print("[6]END OnAppear in SubContentView")
        }
          
        
    }
    
    // Method
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
