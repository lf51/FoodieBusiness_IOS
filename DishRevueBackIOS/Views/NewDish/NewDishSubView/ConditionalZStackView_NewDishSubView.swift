//
//  ConditionalZStack_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//

import SwiftUI

struct ConditionalZStackView_NewDishSubView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    
    @Binding var newDish: DishModel
    @Binding var openAddingIngredientePrincipale: Bool?
    @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var openCreaNuovoIngrediente: Bool?
    @Binding var openProgrammaEPubblica: Bool
    
    var backGroundColorView: Color
    
    var body: some View {
        
        if openCreaNuovoIngrediente! {
                    
        NuovoIngredienteMainView(propertyVM: propertyVM, backGroundColorView: backGroundColorView, dismissButton: $openCreaNuovoIngrediente)

                }
        
        if openProgrammaEPubblica {
                    
           Text("Scheda Pubblicazione e Programmazione Piatto")

                }
   
        if openAddingIngredientePrincipale! {
            
            SelettoreIngrediente_NewDishSubView(propertyVM: propertyVM, newDish: $newDish)
            
          
            
        }
        
        
     /*   if openAddingIngredienteSecondario! {
                        
            SelettoreIngrediente_NewDishSubView(propertyVM: propertyVM, newDish: $newDish)
            
          /*  SelettoreIngrediente_NewDishSubView(propertyVM:propertyVM, newDish: $newDish) { ingrediente in

            self.addIngrediente(ingrediente: ingrediente)
          
            }*/
             .padding(.leading)
         
                    } */
    
    }
    // Method
  private func addIngrediente(ingrediente: ModelloIngrediente) {

        if openAddingIngredientePrincipale! {
            
            self.newDish.ingredientiPrincipali.append(ingrediente)
            print("\(ingrediente.nome) in")
        }
        
        else if openAddingIngredienteSecondario! {
            
            self.newDish.ingredientiSecondari.append(ingrediente)
            print("\(ingrediente.nome) in")
        }
        
        else {print("ERRORE DI CHIAMATA nel Metodo AddIngrediente(). CHIAMATA NON POSSIBILE. ")}

    }
    
}

/*struct ConditionalZStackView_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionalZStackView_NewDishSubView()
    }
}
*/
