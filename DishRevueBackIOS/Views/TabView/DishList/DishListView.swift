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
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var tabSelection: Int // serve a muoversi fra le tabItem, utile se vogliamo rimettere la NewDishView nella tabBar
    let backgroundColorView: Color
    
    @State private var openCreateNewDish: Bool = false
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            CSZStackVB(title: "I Miei Piatti", backgroundColorView: backgroundColorView) {
 
                       /* ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allDishMapCategory)*/ // STAND-BY 16.09
                
                // Temporaneo
                
                VStack {
                    
                    CSDivider()
                    ScrollView {
                        ForEach($viewModel.allMyDish) { $piatto in
                            
                            GenericItemModel_RowViewMask(model: piatto) {
                                
                                piatto.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.dishListPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: $piatto)
 
                                vbMenuInterattivoModuloTrashEdit(currentModel: piatto, viewModel: viewModel, navPath: \.dishListPath)
                            }
                            
                        }

                    }
                }
                
                
                // fine temporaneo
                
                

            }
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .dishList, readOnlyViewModel: viewModel)
            })
          /*  .navigationDestination(for: DishModel.self, destination: { dish in
                NewDishMainView(newDish: dish, backgroundColorView: backgroundColorView,destinationPath: .dishList)
            }) */
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Piatto",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                           // viewModel.dishListPath.append(DishModel())
                            viewModel.dishListPath.append(DestinationPathView.piatto(DishModel()))
                        }
                    
                  /*  NavigationLink {
                        NewDishMainView(backgroundColorView: backgroundColorView)
                    } label: {
                        LargeBar_Text(title: "Nuovo Piatto", font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white)
                    } */

                }
            }
          /*  .navigationBarItems(
                 trailing:
              
                    NavigationLink(destination: {
                        NewDishMainView(backgroundColorView: backgroundColorView)
                    }, label: {

                        LargeBar_Text(title: "Nuovo Piatto", font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white)
                        
                        })
  
                ) */
            
            
            
           /* .navigationBarItems(
                trailing:
             
                    LargeBar_TextPlusButton(buttonTitle: "Nuovo Piatto", font: .callout, imageBack: Color.mint, imageFore: Color.white) {
                        self.openCreateNewDish.toggle()
                    }
                )

            .fullScreenCover(isPresented: self.$openCreateNewDish, content: {
                NewDishMainView(backgroundColorView: backgroundColorView)
            }) */ // Deprecated 02.06
    
        
        }//.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct DishListView_Previews: PreviewProvider {
    
    static var dishItem: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Spaghetti alla Carbonara"
        newDish.categoriaMenuDEPRECATA = CategoriaMenu(
            intestazione: "Primi",
            image: "🍝")
        newDish.status = .completo(.inPausa)
       /* newDish.rating = [
            DishRatingModel(voto: "9.0", titolo: "Strepitoso", commento: "Materie Prime eccezzionali perfettamente combinate fra loro per un gusto autentico e genuino."),
            DishRatingModel(voto: "5.0", titolo: "Il mare non c'è", commento: "Pesce congelato senza sapore"),
            DishRatingModel(voto: "9.0", titolo: "Il mare..forse", commento: "Pescato locale sicuramente di primissima qualità, cucinato forse un po' male."),
            DishRatingModel(voto: "10.0", titolo: "Amazing", commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!"),
            DishRatingModel(voto: "4.0", titolo: "Sapore di Niente", commento: "NoComment")
            
            ] */
        return newDish
    }()

    
    @StateObject static var viewModel:AccounterVM = {
   
      var viewM = AccounterVM()
        viewM.allMyDish = [dishItem]
        return viewM
    }()
    
    static var previews: some View {
       
       // NavigationStack {
            
            DishListView(tabSelection: .constant(2), backgroundColorView: Color("SeaTurtlePalette_1")).environmentObject(viewModel)
      //  }

    }
}

