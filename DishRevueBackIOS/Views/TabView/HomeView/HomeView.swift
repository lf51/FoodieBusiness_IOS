//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit

struct HomeView: View {
    
    @ObservedObject var authProcess: AuthPasswordLess
    @EnvironmentObject var accounterVM: AccounterVM
    var backGroundColorView: Color

    @State private var wannaAddNewProperty:Bool = false
    @State private var wannaCreateMenu: Bool? = false
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    
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
                    
                    LargeBar_TextPlusButton(placeHolder: "I Miei Menu") {
                        
                        withAnimation {
                            self.wannaCreateMenu = true
                        }
                       
                    }.padding(.horizontal)
            
                    ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allMenuMapCategory)
                   // allCases(filtro: .tipologiaMenu)
                    
                    // POSIZIONE PROVVISORIA
                    

                    
                   /* Picker(selection:$selectedMapCategory) {
                        
                        ForEach(MapCategoryContainer.allMenuMapCategory, id:\.self) {category in
                            
                            Text(category.simpleDescription())
                            
                        }
                        
                    } label: {Text("")}
                    .pickerStyle(SegmentedPickerStyle()) */
                    
                    
                    // Lista Properties
               /*     ScrollView {
                               
                        VStack(alignment:.leading,spacing:5.0) {
                            
                          //  ForEach(accounterVM.mappingModelList(modelType: MenuModel.self)) { categoriaMap in
                            ForEach(accounterVM.mappingModelList(modelType:MenuModel.self)) { categoriaMap in
                                
                                Text(categoriaMap.simpleDescription()).bold().foregroundColor(Color.red)
                                    
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                          
                                       ForEach(accounterVM.filteredModelList(modelType: MenuModel.self, filtro: categoriaMap )) { menu in
                        
                                            Text(menu.intestazione)
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                   .frame(maxWidth:.infinity)
                   .frame(maxHeight: screenHeight * 0.40) // Calcolare altezza in termini %
                */
                    
                 /*   ScrollView() { // Lista Properties per TEST
                               
                        VStack(alignment:.leading,spacing:5.0) {
                            
                            ForEach(accounterVM.allMyProperties) { property in
                                
                  
                                NavigationLink(destination: TESTView(currentProperty: property, backgroundColor: backGroundColorView)) {
                                        
                                    Text(property.intestazione).bold().foregroundColor(Color.red)
                                    
                                    
                                }
                                
                            }
                        }
                    }
                   .frame(maxWidth:.infinity)
                   .frame(maxHeight: 300) */
                    
                    
                    
                } // VStack End

                if self.wannaCreateMenu! {
                    
                    NuovoMenuMainView(dismissView: $wannaCreateMenu).zIndex(1.0)
                    
                }
                
                
                
            }// chiusa ZStack
            .background(backGroundColorView.opacity(0.4))
            .navigationTitle("Hi, Nome Utente \(Text(authProcess.displayName))")
            .navigationBarItems(
                leading: NavigationLink(destination: {
                    Text("Dati Account - Spostare qui la facoltà di aggiungere una nuova Proprietà (Perchè? -> Perchè a parte le catene che aprono un ristorante al giorno, il 99% dei ristoratori userà questo pulsante solo all'inizio, dunque non è necessario posizionarlo in facile e veloce accesso")
                }, label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                }),
                trailing: LargeBar_TextPlusButton(buttonTitle: "Registra Proprietà",font: .callout, imageBack: Color.mint, imageFore: Color.white) {
                    self.wannaAddNewPropertyButton()
                }
                    )
            
            .navigationBarTitleDisplayMode(.automatic)
            .navigationViewStyle(.stack) // se non ricordo male mi serve per iPad
            .sheet(isPresented: self.$wannaAddNewProperty) {
                
                NewPropertySheetView(isShowingSheet: self.$wannaAddNewProperty)
              
            }
            .sheet(isPresented: $authProcess.isPresentingSheet) {
                LinkSignInSheetView(authProcess: authProcess)
        }
            
        }
       
         // End NavigationView
       

        

    }
    
    // Method
    
    private func wannaAddNewPropertyButton() {
        
        if AuthPasswordLess.isUserAuth {
            
            self.wannaAddNewProperty.toggle()
            print("Utente Autenticato, Apertura Sheet NuovaProprietà")
            
        } else {
            
            authProcess.isPresentingSheet = true
            print("Utente NON Auth, Apertura Sheet Authentication")
        }
    }
    
      
}

struct HomeView_Previews: PreviewProvider {
 
    static var previews: some View {
        
    HomeView(authProcess: AuthPasswordLess(), backGroundColorView: Color.cyan)
        
      /*  TESTView(accounterVM: AccounterVM(), currentProperty: vm.propertyExample, backgroundColor: Color.cyan)*/
    }
}



struct TESTView: View {
    
    @EnvironmentObject var accounterVM: AccounterVM
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
                LargeBar_TextPlusButton(placeHolder: "Menu") {
                    self.wannaCreateMenu = true
                }.padding(.horizontal)
                
                
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





/*  List {
      
      ForEach(dishVM.dishList.filter{$0.restaurantWhereIsOnMenu.contains(currentProperty)}) { dish in
    
          Text(dish.name)
      }
  } */
