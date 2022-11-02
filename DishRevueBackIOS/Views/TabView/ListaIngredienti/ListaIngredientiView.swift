//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct ListaIngredientiView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // Ancora non Usate
    let backgroundColorView: Color
    
    @State private var openFilter:Bool = false
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.ingredientListPath) {
            
            CSZStackVB(title: "I Miei Ingredienti", backgroundColorView: backgroundColorView) {

                BodyListe_Generic(filterProperty: $filterProperty, containerKP: \.allMyIngredients, navigationPath: \.ingredientListPath)
                            
            }
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .ingredientList, readOnlyViewModel: viewModel)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Ingrediente",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                            self.viewModel.ingredientListPath.append(DestinationPathView.ingrediente(IngredientModel()))
                        }

                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    CSButton_image(frontImage: "slider.horizontal.3", imageScale: .large, frontColor: Color("SeaTurtlePalette_3")) {
                        self.openFilter.toggle()
                    }

                }
               
            }
            .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(350)])
          
            }
        }
    }
    
    // Method
    
    @ViewBuilder private func vbLocalFilterPop() -> some View {
     
            FilterRowContainer(backgroundColorView: backgroundColorView) {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), image: "circle.dashed")
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor:Color.teal.opacity(0.6), image: "cart")
                    
                FilterRow_Generic(allCases: ProvenienzaIngrediente.allCases, filterProperty: $filterProperty.provenienzaING, selectionColor: Color.gray,image:"globe.americas")
                
                FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.green,image: "sun.min.fill")

                FilterRow_Generic(allCases: ConservazioneIngrediente.allCases, filterCollection: $filterProperty.conservazioneING, selectionColor: Color.cyan,image:"thermometer.snowflake")
                
                FilterRow_Generic(allCases: OrigineIngrediente.allCases, filterProperty: $filterProperty.origineING, selectionColor: Color.brown,image:"leaf")
                
                FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), image: "allergens")
            }
                
            
        }
    
}

struct ListaIngredientiView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredientiView(tabSelection: .constant(2), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}
