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
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var tabSelection: Int
    let backgroundColorView: Color
    
   // @State private var openNuovoIngrediente: Bool = false
    
    var body: some View {
        
        NavigationStack(path:$viewModel.ingredientListPath) {
            
            CSZStackVB(title: "I Miei Ingredienti", backgroundColorView: backgroundColorView) {

               /* ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allIngredientMapCategory) */ // STAND-BY 16.09
                
                // Temporaneo
                
                VStack {
                    
                    CSDivider()
                    ScrollView(showsIndicators:false) {
                        
                        ForEach($viewModel.allMyIngredients) { $ingredient in
                            
                            GenericItemModel_RowViewMask(model: ingredient) {
                                
                                ingredient.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.ingredientListPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: $ingredient)
                                
                                vbMenuInterattivoModuloEdit(currentModel: ingredient, viewModel: viewModel, navPath: \.ingredientListPath)
                                
                                vbMenuInterattivoModuloTrash(currentModel: ingredient, viewModel: viewModel)
                            }
                            
                        }
                    }
                    CSDivider()
                }
                
                
                
                // fine temporaneo
                
                

            }
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .ingredientList, readOnlyViewModel: viewModel)
            })
          /*  .navigationDestination(for: IngredientModel.self, destination: { ingredient in
                NuovoIngredienteMainView(nuovoIngrediente: ingredient, backgroundColorView: backgroundColorView)
            }) */
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Ingrediente",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                           // viewModel.ingredientListPath.append(IngredientModel())
                            viewModel.ingredientListPath.append(DestinationPathView.ingrediente(IngredientModel()))
                        }
                    
                 /*   NavigationLink {
                        NuovoIngredienteMainView(backgroundColorView: backgroundColorView)
                    } label: {
                        LargeBar_Text(title: "Nuovo Ingrediente", font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white)
                    } */

                }
            }
            
         
           /* .navigationBarItems(
                trailing:
                    
                    
                NavigationLink(destination: {
                    NuovoIngredienteMainView(backgroundColorView: backgroundColorView)
                }, label: {
                    LargeBar_Text(title: "Nuovo Ingrediente", font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white)
                })
                    
                    
                  /*  LargeBar_TextPlusButton(buttonTitle: "Nuovo Ingrediente", font: .callout, imageBack: Color.mint, imageFore: Color.white) {
                        self.openNuovoIngrediente.toggle()
                    } */
                ) */
           // .navigationBarTitleDisplayMode(.large)
            //.navigationViewStyle(StackNavigationViewStyle())
          /*  .fullScreenCover(isPresented: self.$openNuovoIngrediente, content: {
                NuovoIngredienteMainView(backgroundColorView: backgroundColorView)
            }) */
         //   .background(backgroundColorView.opacity(0.4)) // colora la tabItemBar
    
        }//.navigationViewStyle(StackNavigationViewStyle())
    }
}
/*
struct ListaIngredientiView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredientiView(tabSelection: .constant(2), backgroundColorView: Color.cyan)
    }
}
*/
