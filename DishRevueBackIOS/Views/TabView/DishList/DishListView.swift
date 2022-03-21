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

struct DishListView: View {
    
    @ObservedObject var accounterVM: AccounterVM
    
    @ObservedObject var propertyVM: PropertyVM // forse evitabile
    @Binding var tabSelection: Int // serve a muoversi fra le tabItem, utile se vogliamo rimettere la NewDishView nella tabBar
    var backGroundColorView: Color
    
    @State private var openCreateNewDish: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                backGroundColorView.edgesIgnoringSafeArea(.top)
                
                VStack(alignment:.leading) {
                    
                    Text("Lista")
                    
                    ScrollView {
                        
                        ForEach(accounterVM.mappingModelList(modelType: DishModel.self)) { tipologia in
                            
                            CSText_tightRectangle(testo: tipologia.simpleDescription(), fontWeight: .heavy, textColor: Color.black, strokeColor: Color.yellow, fillColor: Color.yellow.opacity(0.6))
                           // Text(tipologia.simpleDescription())
                          
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack {
                      
                                    ForEach(accounterVM.filteredModelList(modelType: DishModel.self, filtro: tipologia)) { dish in
                    
                                    NavigationLink {
                                       
                                // Destinazione View per Creare/Modificare il piatto
                                        NewDishMainView(propertyVM:propertyVM, accounterVM: accounterVM, backGroundColorView: Color.cyan, newDish: dish)
                                            .navigationBarHidden(true)
                                        
                                            
                                        } label: {
                                            
                                            InfoDishRow(borderColor: Color.clear, fillColor: Color.black, currentDish: dish)
                                                                            }
                                    }
                                    
                                }
                            }
                        
                        }
                    }
                
                }

            }
            .navigationTitle(Text("All Dishes"))
            .navigationBarItems(
                trailing:
                    
                    Button(action: {
                       // self.tabSelection = 1
                        self.openCreateNewDish.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.black)
                            
                            Text("New Dish").bold().foregroundColor(Color.black)
                        }
                    })
                    
            )
            .fullScreenCover(isPresented: self.$openCreateNewDish, content: {
                NewDishMainView(propertyVM: propertyVM, accounterVM: accounterVM,  backGroundColorView: .cyan)
            })

            .background(backGroundColorView.opacity(0.4)) // colora la tabItemBar
        
        
        
        }
    }
}

struct DisheListView_Previews: PreviewProvider {
    static var previews: some View {
        DishListView(accounterVM: AccounterVM(), propertyVM: PropertyVM(), tabSelection: .constant(2), backGroundColorView: Color.cyan)
    }
}
