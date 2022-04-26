//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

// SVILUPPARE CREAZIONE VARIANTI CON LO STESSO NOME

struct NuovoIngredienteMainView: View {

  //  @ObservedObject var propertyVM: PropertyVM
    @EnvironmentObject var viewModel: AccounterVM
    let backgroundColorView: Color
    @Binding var dismissButton: Bool? // se passiamo nil viene usato il dismiss dell'enviroment e la view è diversa
    
    @State var nuovoIngrediente: IngredientModel = IngredientModel() // ogni volta che parte la view viene creato un ingrediente vuoto, lo modifichiamo e lo aggiungiamo alla listaIngredienti.
    
    init(backgroundColorView: Color, dismissButton: Binding<Bool?>? = nil) {
        
      //  self.propertyVM = propertyVM
       // self.accounterVM = accounterVM
        self.backgroundColorView = backgroundColorView
        _dismissButton = dismissButton ?? Binding.constant(nil)
    }
    
    var body: some View {
        
       ZStack {

           if self.dismissButton == nil {backgroundColorView.opacity(0.9).ignoresSafeArea()}
                  
        VStack { // VStack Madre
               
            if self.dismissButton == nil {
                
                TopBar_3BoolPlusDismiss(title: nuovoIngrediente.intestazione != "" ? nuovoIngrediente.intestazione : "Nuovo Ingrediente", enableEnvironmentDismiss:true)
                    .padding()
                    .background(Color.cyan)
                // questo background riguarda la parte alta della View occupata dall'HStack e serve a dare uno stacco di tono
                
            } else {
                
                TopBar_3BoolPlusDismiss(title: nuovoIngrediente.intestazione != "" ? nuovoIngrediente.intestazione : "Nuovo Ingrediente", exitButton: $dismissButton)
                    .padding()
            }
            
                VStack(alignment:.leading) {

                IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Ingrediente", imageLabel: "doc.badge.plus", coloreContainer: Color.orange, itemModel: $nuovoIngrediente).padding(.horizontal)
                   
                SelectionPropertyIngrediente_NewDishSubView(nuovoIngrediente: $nuovoIngrediente)
                            
            if self.dismissButton == nil { Spacer() }
                    
                CSButton_large(title: "Crea Ingrediente", accentColor: .black, backgroundColor: .black.opacity(0.2), cornerRadius: 10.0) {
                                    
                                    test(ingrediente: &nuovoIngrediente)
                                    print("CREARE Ingrediente SU FIREBASE-Modificare in NuovoIngredienteView")
                           
                            }.padding()
                    }
            } // End VSTACK MADRE
        .background(self.dismissButton == nil ? RoundedRectangle(cornerRadius: 20.0).fill(Color.clear).shadow(radius: 0.0) : RoundedRectangle(cornerRadius: 20.0).fill(Color.cyan.opacity(0.9)).shadow(radius: 5.0))
        .contrast(self.dismissButton == nil ? 1.0 : 1.2)
        .brightness(self.dismissButton == nil ? 0.0 : 0.08)
       
           // end ZStack
       }
    }
    
    func test(ingrediente: inout IngredientModel) {
        
        for x in 0...100 {
            
            ingrediente.intestazione = String(x)
            
            viewModel.allMyIngredients.append(ingrediente)
            
        }
        
    }
    
}

struct NuovoIngredienteView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            VStack {
                
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                
                
                
                
            }
            
            
            NuovoIngredienteMainView(backgroundColorView: Color.cyan, dismissButton: nil)
              // .cornerRadius(20.0)
                //.padding(.vertical)
                
        }
     
    }
}


















