//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var propertyViewModel: PropertyVM = PropertyVM()
    @ObservedObject var authProcess: AuthPasswordLess
    var backGroundViewColor: Color
    
   // @State var listaProperties: [String] = ["Paninari","FattoriaMorgana"]
    @State var showAddNewPropertySheet:Bool = false
    
    var body: some View {
        
        ZStack {
            
            backGroundViewColor.edgesIgnoringSafeArea(.top)
 
            VStack(alignment: .leading) {
           
                Spacer()
                
                // Info Proprietario /DisplayName /SignOut / DeletAccount / potremmo inserire qui la verifica dell'account in modo che valga per tutte le properties.
                
                
                // Box Novità
                
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


                ScrollView() {
                           
                    VStack(alignment:.leading,spacing:5.0) {
                        
                        ForEach(propertyViewModel.propertiesList) { property in
                            
                            HStack{
                                
                                Text(property.name)
                                Text(property.id)
                                    .padding(.leading)
                                Spacer()
                                
                                NavigationLink(destination: Text("Ciao")) {
                                    Text("Ariciao")
                                }
                                //NavigationLink to PropertyView: Editing Info Proprietà/ Caricamento Immagini/ Richiesta spunta di Verifica (telefonata, verifica dati, invio codice ricavato dall'uuid da inserire nell'app che lo confronta e crea la spunta blu)/ editing Menu: inserimento/eliminazioni piatti
                                
                            }
                            
                        }
                    }
                  
                    // Lista Properties
                    
                }
               .frame(maxWidth:.infinity)
               .frame(maxHeight: 300) // Calcolare altezza in termini %
                
                
                
             
                
                
            }
            
          
           // Text("InfoGenerali + Add New Property + NewReview ")
            //
        }// chiusa ZStack
        .sheet(isPresented: self.$showAddNewPropertySheet) {
            AddNewPropertySheetView(propertyViewModel: propertyViewModel)
        }
        .sheet(isPresented: $authProcess.isPresentingSheet) {
            LinkSignInSheetView(authProcess: authProcess)
        }

        

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(authProcess: AuthPasswordLess(), backGroundViewColor: Color.cyan)
    }
}

/*struct SuccessView: View {
   
    @ObservedObject var authProcess: AuthPasswordLess

  var body: some View {
    /// The first view in this `ZStack` is a `Color` view that expands
    /// to set the background color of the `SucessView`.
    ZStack {
      Color.orange
        .edgesIgnoringSafeArea(.all)

      VStack(alignment: .leading) {
        Group {
          Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.semibold)

            Text(authProcess.displayName.lowercased())
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)

        }
        .padding(.leading)

        Image(systemName: "checkmark.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(0.5)
          
          Spacer()
          
          VStack{
              
              CSTextField_2(text: $authProcess.displayName, placeholder: "Custom Display Name", symbolName: "person.circle.fill",accentColor: .orange,autoCap: .none,cornerRadius: 16.0)
              
              CSButton_2(title: "Change Name",accentColor:.white, backgroundColor: .orange, cornerRadius: 16.0) {
                  authProcess.updateCurrentUserProfile()
              }
          }
          
          
          Spacer()
          
          HStack {
              
              Button {
                  authProcess.deleteCurrentUser()
              } label: {
                  Text("Delete Account").foregroundColor(.red)
              }
              
             Spacer()
              
              Button {
                  authProcess.signOutCurrentUser()
              } label: {
                  Text("SIGN OUT").foregroundColor(.blue)
              }
              
          }.padding()
            
          
      }
      .foregroundColor(.white)
    }
  }
}
*/
