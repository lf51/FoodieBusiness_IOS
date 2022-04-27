//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit
/*
struct HomeView: View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    @ObservedObject var accounterVM: AccounterVM
    var backgroundColorView: Color

    @State private var showAddNewPropertySheet:Bool = false
    
    var body: some View {
        
        NavigationView {
      
            ZStack {
                
                backgroundColorView.edgesIgnoringSafeArea(.top)
     
                VStack(alignment: .leading) {
               
                    // Info Proprietario /DisplayName /SignOut / DeletAccount / potremmo inserire qui la verifica dell'account in modo che valga per tutte le properties.
                    
                    Text("Box da riempire")
                    
                    
                    Spacer()
    
                    // Box Novità
                    Text("Box Novità")
                    
                    Spacer()
                    
                 /*   AddNewPropertyBar_HomeSubView(authProcess: authProcess, showAddNewPropertySheet: $showAddNewPropertySheet) */
                    LargeMiddleBar_PlusButton(title: "Proprietà") {
                        
                        if AuthPasswordLess.isUserAuth {
                            
                            self.showAddNewPropertySheet.toggle()
                            print("Siamo nell'If in LargeMiddleBar action")
                        } else {
                            authProcess.openSignInView = true
                            print("Siamo nell'else dell'action in LargeMiddleBar")
                        }
                    }
                    
                    // Lista Properties
                    ScrollView() {
                               
                        VStack(alignment:.leading,spacing:5.0) {
                            
                            ForEach(accounterVM.allMyProperties) { property in
                                
                  
                                NavigationLink(destination: TESTView(accounterVM: accounterVM, currentProperty: property, backgroundColor: backgroundColorView)) {
                                        
                                    Text(property.intestazione).bold().foregroundColor(Color.red)
                                    
                                    
                                }
                                
                            }
                        }
                    }
                   .frame(maxWidth:.infinity)
                   .frame(maxHeight: 300) // Calcolare altezza in termini %
                
                } // VStack End

            }// chiusa ZStack
            .background(backgroundColorView.opacity(0.4))
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
           
            .sheet(isPresented: self.$showAddNewPropertySheet) {
                
                NewPropertySheetView(accounterVM: accounterVM, isShowingSheet: self.$showAddNewPropertySheet)
              
            }
            .sheet(isPresented: $authProcess.openSignInView) {
                LinkSignInSheetView(authProcess: authProcess)
        }
            
        }
       
         // End NavigationView
       

        

    }
      
}

struct HomeView_Previews: PreviewProvider {
 
    static var previews: some View {
        
    HomeView(authProcess: AuthPasswordLess(), accounterVM: AccounterVM(), backgroundColorView: Color.cyan)
        
      /*  TESTView(accounterVM: AccounterVM(), currentProperty: vm.propertyExample, backgroundColor: Color.cyan)*/
    }
}



struct TESTView: View {
    
    @ObservedObject var accounterVM: AccounterVM
    var currentProperty: PropertyModel
    let backgroundColor: Color
    
    @State private var wannaCreateMenu: Bool? = false
    
    var body: some View {
        
        ZStack {
            
            backgroundColor.edgesIgnoringSafeArea(.top)
            
            VStack {
                
                Text(currentProperty.cityName)
                
                
                
                
                Text("Editing Info Proprietà/ Caricamento Immagini/ Richiesta spunta di Verifica (telefonata, verifica dati, invio codice ricavato dall'uuid da inserire nell'app che lo confronta e crea la spunta blu)/ editing Menu: inserimento/eliminazioni piatti")
                
                Spacer()
                // Metà schermo
                LargeMiddleBar_PlusButton(title: "Menu") {
                    self.wannaCreateMenu = true
                }
                
                
                ScrollView {
                    
                  //  Text("Menu for property: \(currentProperty.name)")
                    
                    
                    ForEach(currentProperty.menuIn) { menu in
                        
                        HStack {
                            Text(menu.intestazione)
                           // Text(menu.extendedDescription().orario)
                           // Text(menu.extendedDescription().dayIn, format: .list(type: .and))
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            if wannaCreateMenu! {
                
              //  SchedulePropertyService(dismissView: $wannaCreateMenu)

              NuovoMenuMainView(dismissView: $wannaCreateMenu)
       
              
            }
            
            
            
        }
        .navigationTitle("\(currentProperty.intestazione)")
        .background(backgroundColor.opacity(0.4))
        
        
        
       
    }
}



*/

/*  List {
      
      ForEach(dishVM.dishList.filter{$0.restaurantWhereIsOnMenu.contains(currentProperty)}) { dish in
    
          Text(dish.name)
      }
  } */
