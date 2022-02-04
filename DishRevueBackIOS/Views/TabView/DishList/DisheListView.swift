//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct DisheListView: View {
    
    @ObservedObject var dishVM: DishVM
    @Binding var tabSelection: Int
    var backGroundColorView: Color
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                backGroundColorView.edgesIgnoringSafeArea(.top)
                
                VStack {
                    
                    Text("Lista")
                    
                    ScrollView {
                        
                        VStack{
                            
                            ForEach(dishVM.dishList) { dish in
                                
                                NavigationLink {
                                    
                                    VStack {
                                        EditDishView(currentDish: dish)
                                                                            }
                                    
                                    
                                } label: {
                                    HStack {
                                        Text(dish.name)
                                        Text(dish.ingredientiPrincipali[0])
                                           
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
                        self.tabSelection = 1
                    }, label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.black)
                    })
                    
            )
            .background(backGroundColorView.opacity(0.4)) // colora la tabItemBar
        }
    }
}

struct DisheListView_Previews: PreviewProvider {
    static var previews: some View {
        DisheListView(dishVM: DishVM(), tabSelection: .constant(2), backGroundColorView: Color.cyan)
    }
}
