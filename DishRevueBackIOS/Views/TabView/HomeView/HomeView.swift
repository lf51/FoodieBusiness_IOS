//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit

struct HomeView: View {
    
    @ObservedObject var propertyViewModel: PropertyVM 
    @ObservedObject var authProcess: AuthPasswordLess
    @ObservedObject var dishVM: DishVM
    var backGroundColorView: Color

    @State var showAddNewPropertySheet:Bool = false
    
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
                                
                  
                                NavigationLink(destination: ExtractedView(dishVM: dishVM, currentProperty: property)) {
                                        
                                    Text(property.name).bold().foregroundColor(Color.red)
                                    
                                    
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
                    Text("Dati Account - Spostare qui la facoltà di aggiungere una nuova Proprietà (Perchè? -> Perchè a parte le catene che aprono un ristorante al giorno, il 99% dei ristoratori userà questo pulsante solo all'inizio, dunque non è necessario posizionarlo in facile e veloce accesso")
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
        HomeView(propertyViewModel: PropertyVM(), authProcess: AuthPasswordLess(), dishVM: DishVM(), backGroundColorView: Color.cyan)
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

struct ExtractedView: View {
    
    @ObservedObject var dishVM: DishVM
    var currentProperty: PropertyModel
    
    var body: some View {
        
        VStack{
            
            Text("Editing Info Proprietà/ Caricamento Immagini/ Richiesta spunta di Verifica (telefonata, verifica dati, invio codice ricavato dall'uuid da inserire nell'app che lo confronta e crea la spunta blu)/ editing Menu: inserimento/eliminazioni piatti")
            
            Text("Menu for property: \(currentProperty.name)")
            
            List {
                
                ForEach(dishVM.dishList.filter{$0.restaurantWhereIsOnMenu.contains(currentProperty)}) { dish in
                    
                    
                    Text(dish.name)
                    
                
                }
                
                
                
            }
            
            
        }
        
        
        
       
    }
}
