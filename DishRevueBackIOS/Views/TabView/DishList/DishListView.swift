//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct DishListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // non Usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            CSZStackVB(title: "I Miei Prodotti", backgroundColorView: backgroundColorView) {
 

              /*  VStack {
                    
                    CSDivider()
                    ScrollView {
                        ForEach(viewModel.allMyDish) { piatto in
                            
                            GenericItemModel_RowViewMask(model: piatto) {
                                
                                piatto.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.dishListPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel:piatto,viewModel: viewModel)
 
                                vbMenuInterattivoModuloEdit(currentModel: piatto, viewModel: viewModel, navPath: \.dishListPath)
                                
                                vbMenuInterattivoModuloTrash(currentModel: piatto, viewModel: viewModel)
                            }
                            
                        }

                    }
                } */
                
                
                // fine temporaneo
                let container = self.viewModel.filtraERicerca(containerPath: \.allMyDish, filterProperty: filterProperty)
                
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container:container, navigationPath: \.dishListPath, placeHolder: "Cerca per Prodotto e/o Ingrediente..")
                    .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                          vbLocalFilterPop(containerFiltered: container)
                              .presentationDetents([.height(600)])
                          //  .presentationDetents([.medium])
                    
                      }

            }
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .dishList, readOnlyViewModel: viewModel)
            })
     
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Prodotto",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                           // viewModel.dishListPath.append(DishModel())
                            self.viewModel.dishListPath.append(DestinationPathView.piatto(DishModel()))
                        }
                
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    FilterButton(open: $openFilter, filterCount: filterProperty.countChange)
                    
                }
            }
          /*  .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(400)])
          
            } */

        
        }
    }
    
    // Method
    
    @ViewBuilder private func vbLocalFilterPop(containerFiltered:[DishModel] = []) -> some View {
     
            FilterRowContainer(backgroundColorView: backgroundColorView) {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

                FilterRow_Generic(allCases: DishModel.PercorsoProdotto.allCases, filterCollection: $filterProperty.percorsoPRP, selectionColor: Color.white.opacity(0.5), imageOrEmoji: "fork.knife",label: "Percorso Prodotto") { value in
                    
                    containerFiltered.filter({$0.percorsoProdotto == value}).count
                }
            
                let checkAvailability = checkStatoScorteAvailability()
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor: Color.teal.opacity(0.6), imageOrEmoji: "cart",label: "Livello Scorte (Solo PF)") { value in
                    
                    if checkAvailability {
                        
                      return containerFiltered.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value }).count
                    
                    }
                    else {return 0 }
                    
                }
                    .opacity(checkAvailability ? 1.0 : 0.3)
                    .disabled(!checkAvailability)
                
                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label: "Status")
                { value in
                    
                   containerFiltered.filter({$0.status.checkStatusTransition(check: value)}).count
                  
                }
                
                FilterRow_Generic(allCases: DishModel.BasePreparazione.allCase, filterProperty: $filterProperty.basePRP, selectionColor: Color.brown,imageOrEmoji: "leaf",label: "Preparazione a base di")
                { value in
                    containerFiltered.filter({ $0.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel) == value}).count
                   // return filterM.count
                }
                
                FilterRow_Generic(allCases: TipoDieta.allCases, filterCollection: $filterProperty.dietePRP, selectionColor: Color.orange.opacity(0.6), imageOrEmoji: "person.fill.checkmark",label: "Adatto alla dieta")
                { value in
                    containerFiltered.filter({$0.returnDietAvaible(viewModel: self.viewModel).inDishTipologia.contains(value)}).count
                }
                
                
                

             //   HStack {
                    
                    FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.blue, imageOrEmoji: "checkmark.shield",label: "Ingredienti di Qualità")
                    { value in
                        containerFiltered.filter({$0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality: value)}).count
                    }
                    
                    FilterRow_Generic(allCases: ProvenienzaIngrediente.allCases, filterProperty: $filterProperty.provenienzaING, selectionColor: Color.blue,imageOrEmoji: nil)
                    { value in
                        containerFiltered.filter({$0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: value)}).count
                    }

               // }
                
                FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), imageOrEmoji: "allergens",label: "Allergeni Contenuti")
                { value in
                    containerFiltered.filter({$0.calcolaAllergeniNelPiatto(viewModel: self.viewModel).contains(value)}).count
                }
                
            /*    FilterRow_GenericForString(allCases: self.viewModel.allMyIngredients, filterCollection: $filterProperty.rifIngredientiPRP, selectionColor: Color.gray, imageOrEmoji: "list.bullet.rectangle") */ // Deprecata 04.11
                
              
                
            }
                
            
        }
        
    
    private func checkStatoScorteAvailability() -> Bool {
        
        self.filterProperty.percorsoPRP.contains(.prodottoFinito) &&
        self.filterProperty.percorsoPRP.count == 1
        
    }
    
}


struct DishListView_Previews: PreviewProvider {
    
    static var previews: some View {
       
            DishListView(tabSelection: .constant(1), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}



