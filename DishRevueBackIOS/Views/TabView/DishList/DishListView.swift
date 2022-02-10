//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct DishListView: View {
    
    @ObservedObject var dishVM: DishVM
    @ObservedObject var propertyVM: PropertyVM
    @Binding var tabSelection: Int
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
                            
                            ForEach(dishVM.dishList.indices,id:\.self) { i in
                                
                              //  Text("\(i)")
                                
                                
                            NavigationLink {
                                    
                                    VStack {
                                        EditDishView(dishVM: dishVM, propertyVM: propertyVM, currentDishIndexPosition: i)
                                        
                                                                            }
                                    
                                    
                                } label: {
                                    HStack {
                                        
                                        Text(dishVM.dishList[i].name)
                                        
                                        ForEach(dishVM.dishList[i].allergeni) { allergene in
                                            
                                            Text(allergene.rawValue)
                                            
                                        
                                            
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
                NewDishSheetView(dishVM: dishVM, backGroundColorView: .cyan, openNewDish: $openNewDish)
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
