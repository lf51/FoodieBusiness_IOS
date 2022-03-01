//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

// Creare un selettore che può inserire, rimuovere e ordinare gli ingredienti


struct SelettoreIngrediente_NewDishSubView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @Binding var newDish: DishModel // nON SERVe
   
    
    var testArray:[ModelloIngrediente] = [
        ModelloIngrediente(nome: "Guanciale", provenienza: .Italia, metodoDiProduzione: .naturale),
        ModelloIngrediente(nome: "Peperoncino", provenienza: .custom("Messico"), metodoDiProduzione: .selvatico),
        ModelloIngrediente(nome: "Prezzemolo", provenienza: .custom("Sicilia"), metodoDiProduzione: .naturale)
    ]
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    let action: (_ ingrediente: ModelloIngrediente) -> Void
    
    var body: some View {
       
               // Titolo Lista
                
                   ScrollView {
                        
                        VStack(alignment:.leading) {
                            
                           // Text("Ingredienti in: \(propertyVM.listaIngredienti.count)")
                            
                            if propertyVM.listaIngredienti.isEmpty {
                               
                                Text("Lista Ingredienti Vuota")
                                    .bold()
                                
                            } else {
                                
                                ForEach(propertyVM.listaIngredienti) { ingrediente in

                                    HStack {
                                        
                                        Text(ingrediente.nome)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                                
                                        
                                       Spacer()
                                        Image(systemName: self.isIngredienteAlreadyIn(ingrediente: ingrediente) ? "nosign" : "checkmark.circle" )
                                            .padding(.trailing)
                                        
                                        
                                    }
                                    ._tightPadding()
                                    .onTapGesture {
                                            self.action(ingrediente)
                                        }.disabled(self.isIngredienteAlreadyIn(ingrediente: ingrediente))
  
                                    Divider()
                            
                                }
                            }
                        }.padding(.horizontal)
                   }
                    .background(Color.white.opacity(0.8).cornerRadius(20.0))
                    .frame(width: (screenHeight * 0.35))
                    .frame(height: screenHeight * 0.40 )
                
  
            
        
        
        
    }
    
    func isIngredienteAlreadyIn(ingrediente: ModelloIngrediente) -> Bool {
    
      if self.newDish.ingredientiPrincipali.contains(ingrediente) ||
            self.newDish.ingredientiSecondari.contains(ingrediente) { return true }
        else { return false }
        
    }
    
}

struct SelettoreIngrediente_NewDishSubView_Previews: PreviewProvider {
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
        
            SelettoreIngrediente_NewDishSubView(propertyVM: PropertyVM(), newDish: .constant(DishModel())) { ingrediente in
                //
            }
        }
       
    }
}

