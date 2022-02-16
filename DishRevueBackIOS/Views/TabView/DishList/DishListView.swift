//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

/* Passiamo nelle SubView l'indice del dish da editare/visuallizare in modo da poter effettuare modifiche direttamente sull'oggetto senza passarlo. In questa maniera le modifiche sono visualizzate in realTime. Passando l'oggetto (essendo il DishModel una struttura) abbiamo invece gli stessi problemi di sincronia avuti con FantaBid (dove non abbiamo risolto in modo efficace), perchè le modifiche vengono effettuate su un "Nuovo" oggetto*/


struct DishListView: View {
    
    @ObservedObject var dishVM: DishVM
    
    @ObservedObject var propertyVM: PropertyVM // forse evitabile
    @Binding var tabSelection: Int // serve a muoversi fra le tabItem, utile se vogliamo rimettere la NewDishView nella tabBar
    var backGroundColorView: Color
    
    @State private var openNewDish: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                backGroundColorView.edgesIgnoringSafeArea(.top)
                
                VStack {
                    
                    Text("Lista")
                    
                    ScrollView {
                        
                        VStack{
                            
                          /*  ForEach(dishVM.dishList) { dish in
                  
                            NavigationLink {
                                    
                                    VStack {
                                        EditDishView(dishVM: dishVM, propertyVM: propertyVM, currentDishIndexPosition: 0, currentDish: dish)
                                        
                                                                            }
                                    
                                    
                                } label: {
                                    HStack {
                                        
                                        Text(dish.name)
                                        
                                      /*  ForEach(dishVM.dishList[i].allergeni) { allergene in
                                            
                                            Text(allergene.simpleDescription())
                                            
                                        
                                            
                                        }*/
                                       // Text(dish.name)
                                        //Text(dish.ingredientiPrincipali[0])
                                           
                                    } .foregroundColor(.black)
                                }
                            } */
                            
                            
                            ForEach(dishVM.dishList.indices,id:\.self) { i in
                                
                            
                                
                                
                            NavigationLink {
                                    
                                    VStack {
                                        EditDishView(dishVM: dishVM, propertyVM: propertyVM, currentDishIndexPosition: i)
                                        
                                                                            }
                                    
                                    
                                } label: {
                                    HStack {
                                        
                                        Text(dishVM.dishList[i].name)
                                        
                                        ForEach(dishVM.dishList[i].allergeni) { allergene in
                                            
                                            Text(allergene.simpleDescription())
                                            
                                        
                                            
                                        }
                                       // Text(dish.name)
                                        //Text(dish.ingredientiPrincipali[0])
                                           
                                    } .foregroundColor(.black)
                                } 
                            }
                            
                        }
                    }
                }
                
                
                
                Text("Elenco Piatti Creati + ModificaPiattiEsistenti + Visualizza/rispondi recensioni")
            }
            .navigationTitle(Text("All Dishes"))
            .navigationBarItems(
                trailing:
                    
                    Button(action: {
                       // self.tabSelection = 1
                        self.openNewDish.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.black)
                            
                            Text("New Dish").bold()
                        }
                    })
                    
            )
            .sheet(isPresented: self.$openNewDish) {
                NewDishView(dishVM: dishVM, backGroundColorView: .cyan, openNewDish: $openNewDish)
            }
            .background(backGroundColorView.opacity(0.4)) // colora la tabItemBar
        
        
        
        }
    }
}

struct DisheListView_Previews: PreviewProvider {
    static var previews: some View {
        DishListView(dishVM: DishVM(), propertyVM: PropertyVM(), tabSelection: .constant(2), backGroundColorView: Color.cyan)
    }
}
