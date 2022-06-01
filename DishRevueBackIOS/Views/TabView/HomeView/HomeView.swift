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
    @EnvironmentObject var viewModel: AccounterVM
    let backgroundColorView: Color

    @State private var wannaAddNewProperty:Bool = false
    
  //  @State private var isPresentedMenu: Bool = false // duplica la wannaCreateMenu: Necessaria perchè l'isPresented dello sheet non accetta optional
  //  @State private var wannaCreateMenu: Bool? = false {didSet {isPresentedMenu = wannaCreateMenu!}}
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        NavigationView {
      
            CSZStackVB(title:authProcess.userInfo?.userDisplayName ?? "", backgroundColorView: backgroundColorView) {
            
          //  ZStack {
                
              //  backgroundColorView.edgesIgnoringSafeArea(.top)
     
                VStack(alignment: .leading) {
               
                    // Info Proprietario /DisplayName /SignOut / DeletAccount / potremmo inserire qui la verifica dell'account in modo che valga per tutte le properties.
                    
                 //   Text("Box da riempire")
                    
                    HStack {
                       
                        NavigationLink {
                            FastImport_MainView(backgroundColorView: backgroundColorView)
                        } label: {
                        CS_IconaRomboidale(
                            image: "bolt",
                            backgroundColor: Color("BusinessColor_1"),
                            title: "Piatti")
                        }
                    //    .fixedSize()
                        
                        NavigationLink {
                          //  FastImport_MainView(backgroundColorView: backgroundColorView)
                        } label: {
                        CS_IconaRomboidale(
                            image: "bolt",
                            backgroundColor: Color("BusinessColor_1"),
                            title: "Categorie")
                        }
                      //  .fixedSize()
                 
                        Spacer()
                    }
                    
                    
                   

                    
                    Spacer()
    
                    // Box Novità
                    Text("Box Novità")
                    
                    Spacer()
                    
                  /*  VStack(spacing:10.0) {
                        
                        LargeBar_TextPlusButton(placeHolder: "I Miei Menu") {
                            
                            withAnimation {
                                self.wannaCreateMenu = true
                            }
                           
                        }.padding(.horizontal)
                        
                        ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allMenuMapCategory)
                    } */
        
                    
                } // VStack End
                .padding(.horizontal)
               /* if self.wannaCreateMenu! {
                    
                    NuovoMenuMainView(dismissView: $wannaCreateMenu).zIndex(1.0)
                    
                } */
         
            }// chiusa ZStack
          //  .background(backgroundColorView.opacity(0.4))
          //  .navigationTitle("\(Text(authProcess.userInfo?.userDisplayName ?? ""))")
            .navigationBarItems(
                leading: NavigationLink(destination: {
                    
                    AccounterMainView(authProcess: authProcess, backgroundColorView: backgroundColorView)

                }, label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                }),
                trailing: NavigationLink(
                    destination: {
                        
                    PropertyListView(backgroundColorView: backgroundColorView)
                        
                    }, label: {
                        
                        HStack {
                            
                            Text("Proprietà")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .imageScale(.medium)
                                
                        }
                    })
            )
           // .navigationBarTitleDisplayMode(.large)
           /* .fullScreenCover(isPresented: $isPresentedMenu, content: {
              /*  NuovoMenuMainView(dismissView: $wannaCreateMenu) */
                NuovoMenuMainView(backgroundColorView: backgroundColorView)
            
            }) */

           // .navigationViewStyle(StackNavigationViewStyle()) // se non ricordo male mi serve per iPad
          /*  .sheet(isPresented: self.$wannaAddNewProperty) {
                
                NewPropertySheetView(isShowingSheet: self.$wannaAddNewProperty)
              
            }
            .sheet(isPresented: $authProcess.openSignInView) {
                LinkSignInSheetView(authProcess: authProcess)
            } */
            
        }
        .accentColor(Color.white)
        .navigationViewStyle(StackNavigationViewStyle())
        
         // End NavigationView

    }
    
    // Method
    
  /*  private func wannaAddNewPropertyButton() {
        
        if AuthPasswordLess.isUserAuth {
            
            self.wannaAddNewProperty.toggle()
            print("Utente Autenticato, Apertura Sheet NuovaProprietà")
            
        } else {
            
            authProcess.openSignInView = true
            print("Utente NON Auth, Apertura Sheet Authentication")
        }
    } */
}

/*struct HomeView_Previews: PreviewProvider {
 
    static var previews: some View {
        
    HomeView(authProcess: AuthPasswordLess(), backgroundColorView: Color.cyan)
        
      /*  TESTView(accounterVM: AccounterVM(), currentProperty: vm.propertyExample, backgroundColor: Color.cyan)*/
    }
} */


/*struct TESTView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
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
} */

/*  List {
      
      ForEach(dishVM.dishList.filter{$0.restaurantWhereIsOnMenu.contains(currentProperty)}) { dish in
    
          Text(dish.name)
      }
  } */
