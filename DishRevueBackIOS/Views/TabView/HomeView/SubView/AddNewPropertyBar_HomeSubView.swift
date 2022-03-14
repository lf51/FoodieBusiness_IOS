//
//  AddNewPropertyBar_HomeSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/03/22.
//

import SwiftUI

/* struct AddNewPropertyBar_HomeSubView: View {
    
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
} */ // in disuso dal 14.03

/*struct AddNewPropertyBar_HomeSubView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPropertyBar_HomeSubView()
    }
} */

struct LargeMiddleBar_PlusButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading)
            
            Spacer()
            
            Button(action: {action()}, label: { // Se l'utente non è autenticato deve riaprire lo sheet dell'Auth
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                    .background(Color.blue.clipShape(Circle()))
                    .foregroundColor(.white)
                    .padding(.trailing)
            })
            
        }
    }
}
