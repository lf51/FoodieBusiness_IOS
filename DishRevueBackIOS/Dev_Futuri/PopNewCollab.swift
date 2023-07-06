//
//  PopNewCollab.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/11/22.
//

import SwiftUI

/*
struct PopNewCollab:View {
    
   // @ObservedObject var auth:AuthPasswordLess
    @EnvironmentObject var viewModel:AccounterVM
    
    @State private var newCollab:CollaboratorModel
    let backgroundColorView:Color
    
    init(newCollab:CollaboratorModel,backgroundColor:Color) {
        
        _newCollab = State(wrappedValue: newCollab)
        self.backgroundColorView = backgroundColor
    }
    
    var body: some View {
        
        ZStack {

            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.top)
                .zIndex(0)
            
            VStack(alignment:.leading) {
                
                Text("Nuovo Collaboratore")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                    .padding(.top,10)
                
                Spacer()
                
                VStack(alignment:.trailing) {
                    
                    let disableSave:Bool = {
                       
                        self.newCollab.userEmail == "" ||
                        self.newCollab.livelloAutorità == ""
                        
                    }()
                    
                    CSTextField_4(textFieldItem: $newCollab.userEmail, placeHolder: "email", image: "at", showDelete: true, keyboardType: .default)
                        

                    CSTextField_4(textFieldItem: $newCollab.livelloAutorità, placeHolder: "livello Autorizzazione", image: "at", showDelete: true, keyboardType: .default)
                    
                  //  Spacer()
                    Button {
                        self.viewModel.allMyCollabs.append(newCollab) //31.10 Valutare in seguito se spostare l'elenco collaboratori nel viewModel -> Vediamo quando salviamo i dati come viene meglio organizzarsi
                    } label: {
                        Text("Salva")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.seaTurtle_3)
                            .opacity(disableSave ? 0.4 : 1.0)
                    }
                   
                    .disabled(disableSave)
                }
                    Spacer()
                            
            }
            .padding(.horizontal,10)
            .zIndex(1)
            
        }
        .background(backgroundColorView.opacity(0.6))
       
    
        
    }
} */

/*
struct PopNewCollab_Previews: PreviewProvider {
    static var previews: some View {
        PopNewCollab()
    }
} */

/*
struct CollaboratorModel:Identifiable {
    
    let id:String = UUID().uuidString
    
    var userEmail: String // la mail con cui si autentica
  //  let userUID: String
  //  let userProviderID: String
 //   var userDisplayName: String // lo sceglie l'utente
  //  let userEmailVerified: Bool // lo diamo Noi e in alcuni casi possiamo renderlo automatico o semiAutomatico
    
    var livelloAutorità: String // creare una enum
    
    init(userEmail: String,livelloAutorità: String) {
        self.userEmail = userEmail
        self.livelloAutorità = livelloAutorità
    }
    // let isUserIdentityVerified: Bool
    
    enum AccessAuthorizazionLevel {
        
        case admin
        case delete
        case write
        case read

    }
} */ // 24.11 -> Sviluppo Futuri
