//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

/* Passiamo nelle SubView l'indice del dish da editare/visuallizare in modo da poter effettuare modifiche direttamente sull'oggetto senza passarlo. In questa maniera le modifiche sono visualizzate in realTime. Passando l'oggetto (essendo il DishModel una struttura) abbiamo invece gli stessi problemi di sincronia avuti con FantaBid (dove non abbiamo risolto in modo efficace), perchè le modifiche vengono effettuate su un "Nuovo" oggetto*/


/* In questa View sono Mostrati in sintesi tutti i piatti creati dal Ristoratore. Info da mostrare:

 • Nome del Piatto
 • Tagli del Piatto ( + modifica Veloce)
 • Stato del Piatto - Pubblico / Bozza  ( + modifica Veloce)
 • Se Pubblico, proprietà su cui è caricato (+ modifica Veloce)
 • Voto delle recensioni (+ accesso Veloce alle recensioni)

 Da Valutare:
 -- I piatti devono provenire: O da un publisher locale preventivamente riempito dal server, o da un'iterazione diretta sui dati nel Server
 -- Le modifiche vengono fatte: O localmente e poi salvate sul server, o direttamente sul dato nel server
 
*/

struct ListaIngredientiView: View {
    
    @ObservedObject var dishVM: DishVM // non sembra servire
    
    @ObservedObject var propertyVM: PropertyVM
    @Binding var tabSelection: Int
    var backGroundColorView: Color
    
    @State private var openNuovoIngrediente: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                backGroundColorView.edgesIgnoringSafeArea(.top)
                
                VStack(alignment:.leading) {
                    
                //    Text("Lista Ingredienti")
                    
                    ScrollView {
                        
                        ForEach(propertyVM.listaMyIngredients) { ingrediente in
                            
                            Text(ingrediente.nome)
                          //  Text(ingrediente.cottura.simpleDescription())
                            Text("Provenienza Ingrediente")
                            Text("Metodo di Produzione")
                            
                          // Text(ingrediente.provenienza)
                          //  Text(ingrediente.metodoDiProduzione)
                            
                            
                        }
                    }
                
                }

            }
            .navigationTitle(Text("Lista Ingredienti"))
            .navigationBarItems(
                trailing:
                    
                    Button(action: {
                       // self.tabSelection = 1
                        self.openNuovoIngrediente.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.black)
                            
                            Text("Nuovo Ingrediente").bold().foregroundColor(Color.black)
                        }
                    })
                    
            )
            .sheet(isPresented: self.$openNuovoIngrediente) {
               // NewDishView(dishVM: dishVM, backGroundColorView: .cyan)
                NuovoIngredienteMainView(propertyVM:propertyVM, backGroundColorView: backGroundColorView, dismissButton: nil)
                // Creare nuovo ingrediente
            }
            .background(backGroundColorView.opacity(0.4)) // colora la tabItemBar
        
        
        
        }
    }
}

struct ListaIngredientiView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredientiView(dishVM: DishVM(), propertyVM: PropertyVM(), tabSelection: .constant(2), backGroundColorView: Color.cyan)
    }
}
