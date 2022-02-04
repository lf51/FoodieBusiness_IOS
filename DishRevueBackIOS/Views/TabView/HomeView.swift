//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit

struct HomeView: View {
    
    @StateObject var propertyViewModel: PropertyVM = PropertyVM()
    @ObservedObject var authProcess: AuthPasswordLess
    var backGroundColorView: Color

    @State var showAddNewPropertySheet:Bool = false
    
    let appearance: UINavigationBarAppearance = {
        
        let setColor = UINavigationBarAppearance()
        setColor.configureWithOpaqueBackground()
        setColor.backgroundColor = .red
        return setColor
        
    }()
  
    
    var body: some View {
        
        NavigationView {

            
            ZStack {
                
                backGroundColorView.edgesIgnoringSafeArea(.top)
     
                VStack(alignment: .leading) {
               
                    // Info Proprietario /DisplayName /SignOut / DeletAccount / potremmo inserire qui la verifica dell'account in modo che valga per tutte le properties.
                    
                    Text("Box da riempire")
                    
                    
                    Spacer()
    
                    // Box Novità
                    Text("Box Novità")
                    
                    Spacer()
                    
                    AddNewPropertyBar(authProcess: authProcess, showAddNewPropertySheet: $showAddNewPropertySheet)

                    // Lista Properties
                    ScrollView() {
                               
                        VStack(alignment:.leading,spacing:5.0) {
                            
                            ForEach(propertyViewModel.propertiesList) { property in
                                
                  
                                    NavigationLink(destination: Text("Editing Info Proprietà/ Caricamento Immagini/ Richiesta spunta di Verifica (telefonata, verifica dati, invio codice ricavato dall'uuid da inserire nell'app che lo confronta e crea la spunta blu)/ editing Menu: inserimento/eliminazioni piatti")) {
                                        
                                        Text("Ariciao").bold().foregroundColor(Color.red)
                                    
                                    
                                }
                                
                            }
                        }
                    }
                   .frame(maxWidth:.infinity)
                   .frame(maxHeight: 300) // Calcolare altezza in termini %
                
                } // VStack End

            }// chiusa ZStack
            .background(backGroundColorView.opacity(0.4))
            .navigationTitle("Hi, Nome Utente \(Text(authProcess.displayName))")
            .navigationBarItems(
                leading: NavigationLink(destination: {
                    Text("Dati Account")
                }, label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                })
     
                    )
            
            .navigationBarTitleDisplayMode(.automatic)
            .navigationViewStyle(.stack) // se non ricordo male mi serve per iPad
            /*.toolbar(content: {
                HStack {
                    Text("Ciao!")
                    Spacer()
                    Text("Hello!")
                }
            })*/
           
            .sheet(isPresented: self.$showAddNewPropertySheet,onDismiss: {
                propertyViewModel.onDismissSearchPropertySheet()
            }) {
                NewPropertySheetView(vm: propertyViewModel, isShowingSheet: self.$showAddNewPropertySheet)
            }
            .sheet(isPresented: $authProcess.isPresentingSheet) {
                LinkSignInSheetView(authProcess: authProcess)
        }
            
        }
       
         // End NavigationView
       

        

    }
      
}

struct HomeViewBeta_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(authProcess: AuthPasswordLess(), backGroundColorView: Color.cyan)
    }
}

struct AddNewPropertyBar: View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    @Binding var showAddNewPropertySheet: Bool
    
    var body: some View {
        HStack {
            
            Text("Properties")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading)
            
            Spacer()
            
            Button(action: {
                
                //    self.listaProperties.append("Osteria del Vicolo")
                if AuthPasswordLess.isUserAuth {
                    
                    self.showAddNewPropertySheet.toggle()
                    // Comando per creare Nuova Property
                } else {
                    authProcess.isPresentingSheet = true
                }
         
                // Se l'utente non è autenticato deve riaprire lo sheet dell'Auth
                
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                    .background(Color.blue.clipShape(Circle()))
                    .foregroundColor(.white)
                    .padding(.trailing)
            })
            
        }
    }
}
