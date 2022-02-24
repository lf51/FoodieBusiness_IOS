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

struct NuovoIngredienteView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var dishVM: DishVM // ATTUALMENTE NON UTILIZZATO
    var backGroundColorView: Color
    
    @State var nuovoIngrediente: ModelloIngrediente = ModelloIngrediente() // ogni volta che parte la view viene creato un ingrediente vuoto, lo modifichiamo e lo aggiungiamo alla listaIngredienti.
  //  @Binding var openNewDish: Bool // dismiss button
    @State var activeDeletion: Bool = false // attiva l'eliminazione degli ingredienti
    @State var openEditingIngrediente: Bool = false // attiva l'editing dell'ingrediente
    
    var body: some View {
        
        ZStack {

            backGroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack { // VStack Madre
                
                HStack { // una Sorta di NavigationBar
                    
                    Text(nuovoIngrediente.nome != "" ? nuovoIngrediente.nome : "Nuovo Ingrediente")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                    
                    Spacer()
  
                    // Done Button
                    
                    if openEditingIngrediente {
                        
                        CSButton_1(title: "Done", fontWeight: .heavy, titleColor: Color.white, fillColor: Color.blue) {
                            self.openEditingIngrediente = false
                        }
                        
                    }
        
                    // Delete Button
                    
                    else if activeDeletion {
                        
                        CSButton_1(title: "Annulla", fontWeight: .heavy, titleColor: Color.white, fillColor: Color.red) {
                            self.activeDeletion = false
                        }
                        
                    }
      
                    // Default Button
                    else {Button(action: {dismiss()}, label: {Text("Dismiss").foregroundColor(Color.black)})}

                }
                .padding()
                .background(Color.cyan) // questo background riguarda la parte alta della View occupata dall'HStack
                
                Spacer()
                
                ScrollView { // La View Mobile

                        VStack(alignment:.leading) { // info Dish
                         //   Text(dishVM.newDish.images) // ICONA STANDARD PIATTO
                            
                            InfoIngrediente_NuovoIngredienteSubView(nuovoIngrediente:$nuovoIngrediente, activeDeletion: $activeDeletion, openEditingIngrediente: $openEditingIngrediente)
                   
                               SelectionPropertyIngrediente_NewDishSubView(nuovoIngrediente: $nuovoIngrediente)                           
                            
                        }

                }.onTapGesture {
                    print("TAP ON Entire SCROLL VIEW") // funziona su tutto tranne che sui menu orizzontali che abbiamo disabilitato ad hoc.
                    self.activeDeletion = false
                    self.openEditingIngrediente = false
                }
                
                Spacer()
                
                VStack {
                    CSButton_2(title: "Crea Ingrediente", accentColor: .white, backgroundColor: .cyan, cornerRadius: 5.0) {
                        
                        print("CREARE Ingrediente SU FIREBASE")
                        print(nuovoIngrediente.nome)
                        
                        print(nuovoIngrediente.conservazione.simpleDescription())
                        print(nuovoIngrediente.provenienza.simpleDescription())
                        print(nuovoIngrediente.produzione.simpleDescription())
                        
                       // dishVM.createNewOrEditOldDish(dish: self.newDish)
                      //  self.newDish.type.mantieniUltimaScelta()
                      //  self.newDish = DishModel()
                        
                    }
                }.background(Color.cyan) // questo back permette di amalgamare il bottone con il suo Vstack, altrimenti il bottone si vede come una striscia
                
            } // End VSTACK MADRE

            
        } // end ZStack
       /* .alert(item:$newDish.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         } */
    }
    
}

struct NuovoIngredienteView_Previews: PreviewProvider {
    static var previews: some View {
        
        NuovoIngredienteView(dishVM: DishVM(), backGroundColorView: Color.cyan)
     
    }
}


















