//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

// Bozza COMPLETATA 10.02.2022
// Fare Ordine
// 60DA0BBB-0D44-4CF9-B609-05CB517DF35A

struct NewDishView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var dishVM: DishVM // ATTUALMENTE NON UTILIZZATO
    var backGroundColorView: Color
    
    @State var newDish: DishModel = DishModel() // ogni volta che parte la view viene creato un piatto vuoto, lo modifichiamo e lo aggiungiamo alla dishlist.
  //  @Binding var openNewDish: Bool // dismiss button
    @State var activeDeletion: Bool = false // attiva l'eliminazione degli ingredienti
    
    var body: some View {
        
        ZStack {

            backGroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack { // VStack Madre
                
                HStack { // una Sorta di NavigationBar
                    
                    Text(newDish.name != "" ? newDish.name : "New Dish")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    if !activeDeletion {
                        
                        Button {
                           // self.openNewDish.toggle()
                            dismiss()
                        } label: {
                            Text("Dismiss")
                                .foregroundColor(Color.black)
                            //.padding()
                        }
                    } else {
                        
                        Button {
                            self.activeDeletion = false
                        } label: {
                            Text("ANNULLA")
                                .fontWeight(.heavy)
                                ._tightPadding()
                                .foregroundColor(Color.white)
                                .background(RoundedRectangle(cornerRadius: 5.0).fill(Color.red))
                        }
                    }
                }
                .padding()
                .background(Color.cyan) // questo background riguarda la parte alta della View occupata dall'HStack
                
                Spacer()
                
                ScrollView { // La View Mobile

                        VStack(alignment:.leading) { // info Dish
                         //   Text(dishVM.newDish.images) // ICONA STANDARD PIATTO
                            
                            InfoGenerali_NewDishSubView(newDish: $newDish, activeDeletion: $activeDeletion)
                                .padding()
                          /*
                           INFO COTTURA DI OGNI SINGOLO INGREDIENTE
                           
                           */
                         //   Spacer()

                  
                            SelectionMenu_NewDishSubView(newDish: $newDish)
                                .disabled(self.activeDeletion)

                            DishSpecific_NewDishSubView(newDish: $newDish)
                                .disabled(self.activeDeletion)
                            
                        }
                  
                      //  Spacer()
                
                   // }
                }.onTapGesture {
                    print("TAP ON Entire SCROLL VIEW") // funziona su tutto tranne che sui menu orizzontali che abbiamo disabilitato ad hoc.
                    self.activeDeletion = false
                }
                
                Spacer()
                
                VStack {
                    CSButton_2(title: "Create Dish", accentColor: .white, backgroundColor: .cyan, cornerRadius: 5.0) {
                        
                        print("CREARE PIATTO SU FIREBASE")
                        dishVM.createNewOrEditOldDish(dish: self.newDish)
                        self.newDish = DishModel()
                        
                    }
                }.background(Color.cyan) // questo back permette di amalgamare il bottone con il suo Vstack, altrimenti il bottone si vede come una striscia
                
            } // End VSTACK MADRE

            
        } // end ZStack
    
    }
    
}

struct NewDishView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewDishView(dishVM: DishVM(), backGroundColorView: Color.cyan)
     
    }
}


















