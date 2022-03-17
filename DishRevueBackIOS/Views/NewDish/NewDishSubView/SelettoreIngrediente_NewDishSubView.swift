//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

// Creare un selettore che può inserire, rimuovere e ordinare gli ingredienti

struct SelettoreIngrediente_NewDishSubView: View {
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    @ObservedObject var propertyVM: PropertyVM
    @Binding var newDish: DishModel

    @State private var listaDaMostrare: ElencoListeIngredienti = .allFromCommunity

    @State private var temporarySelectionIngredients: [String:[IngredientModel]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]

    private var isAggiungiButtonDisabled: Bool {
        
        listaDaMostrare == .ingredientiPrincipali || listaDaMostrare == .ingredientiSecondari || (temporarySelectionIngredients["IngredientiPrincipali"]!.isEmpty && temporarySelectionIngredients["IngredientiSecondari"]!.isEmpty)
  
    }
    
    var body: some View {

        VStack(alignment: .leading) {
            
            SwitchListeIngredientiPiatto(newDish: $newDish, listaDaMostrare: $listaDaMostrare)
                .padding(.horizontal)
                .padding(.top)
            
            SwitchListeIngredienti(listaDaMostrare: $listaDaMostrare)
                .padding()
                .background(Color.cyan.opacity(0.5))

            ListaIngredienti_ConditionalView(propertyVM: propertyVM, newDish: $newDish, listaDaMostrare: $listaDaMostrare, temporarySelectionIngredients: $temporarySelectionIngredients)
            // .refreshable -> per aggiornare
            
            CSButton_large(title: "Aggiungi", accentColor: Color.white, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                self.aggiungiNewDishIngredients()
                
                }.disabled(isAggiungiButtonDisabled)
        }
        .background(Color.white.cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
  
    }
    
    // Methodi & Oggetti
    
    private func aggiungiNewDishIngredients() {

        self.newDish.ingredientiPrincipali.append(contentsOf: self.temporarySelectionIngredients["IngredientiPrincipali"]!)
        
        self.newDish.ingredientiSecondari.append(contentsOf: self.temporarySelectionIngredients["IngredientiSecondari"]!)
        
        self.temporarySelectionIngredients["IngredientiPrincipali"]! = []
        self.temporarySelectionIngredients["IngredientiSecondari"]! = []
      
    }
         
}

struct SelettoreIngrediente_NewDishSubView_Previews: PreviewProvider {
    
    static var propertyVM: PropertyVM = PropertyVM()
    
    static var previews: some View {
        
        ZStack {
            Color.cyan.opacity(0.8)
            Group{
                VStack{
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                }
                .padding()
                .foregroundColor(Color.white)
        
            }
        
            SelettoreIngrediente_NewDishSubView(propertyVM: propertyVM, newDish: .constant(DishModel()))

        }.onTapGesture {
            SelettoreIngrediente_NewDishSubView_Previews.test()
        }
       
    }
    
    static func test() {
        
        for x in 1...20 {
            
        var ingrediente = IngredientModel()
            
            ingrediente.intestazione = "\(x.description)' ingredient"
            
            propertyVM.listaMyIngredients.append(ingrediente)
            
        }
        
    }
    
}
