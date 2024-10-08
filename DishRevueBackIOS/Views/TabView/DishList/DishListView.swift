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
    @State private var openSort: Bool = false
    @State private var mapObject: MapObject<DishModel,CategoriaMenu>?
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            CSZStackVB(title: "I Miei Prodotti", backgroundColorView: backgroundColorView) {

                let container = self.viewModel.filtraERicerca(containerPath: \.allMyDish, filterProperty: filterProperty) // Vedi Nota 08.11
 
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container:container,
                                  mapObject: mapObject,
                                  navigationPath: \.dishListPath, placeHolder: "Cerca per Prodotto e/o Ingrediente..")
                    .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                          vbLocalFilterPop(containerFiltered: container)
                              .presentationDetents([.height(600)])

                    
                      }
                    .popover(isPresented: $openSort, attachmentAnchor: .point(.top)) {
                          vbLocalSorterPop()
                              .presentationDetents([.height(400)])
 
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
                    
                    let sortActive = self.filterProperty.sortCondition != nil
                    
                    FilterSortMap_Bar(open: $openFilter, openSort: $openSort, filterCount: filterProperty.countChange,sortActive: sortActive) {
                        
                      thirdButtonAction()
                        
                    }
                    
                }
            }
          /*  .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(400)])
          
            } */

        
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapObject == nil {
            
            self.mapObject = MapObject(
                mapCategory: self.viewModel.allMyCategories,
                kpMapCategory: \DishModel.categoriaMenu)
            
        } else {
            
            self.mapObject = nil
        }
    }
    
    @ViewBuilder private func vbLocalSorterPop() -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Sort") {
             
            self.filterProperty.sortCondition = nil
                
            } content: {

                let isPF:Bool = {
                    
                    self.filterProperty.percorsoPRP.contains(.prodottoFinito) &&
                    self.filterProperty.percorsoPRP.count == 1
                }()
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .alfabeticoDecrescente)
                    
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .livelloScorte)
                    .opacity(isPF ? 1.0 : 0.5)
                    .disabled(!isPF)
  
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .mostUsed)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .topRated)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .mostRated)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .topPriced)
                

            }
                
            
        }

    @ViewBuilder private func vbLocalFilterPop(containerFiltered:[DishModel] = []) -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

                FilterRow_Generic(allCases: DishModel.PercorsoProdotto.allCases, filterCollection: $filterProperty.percorsoPRP, selectionColor: Color.white.opacity(0.5), imageOrEmoji: "fork.knife",label: "Prodotto") { value in
                    
                    containerFiltered.filter({$0.percorsoProdotto == value}).count
                }
            
                let checkAvailability = checkStatoScorteAvailability()
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor: Color.teal.opacity(0.6), imageOrEmoji: "cart",label: "Livello Scorte (Solo PF)") { value in
                    
                    if checkAvailability {
                        
                      return containerFiltered.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value }).count
                    
                    }
                    else { return 0 }
                    
                }
                    .opacity(checkAvailability ? 1.0 : 0.3)
                    .disabled(!checkAvailability)
                
                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label: "Status")
                { value in
                    
                   containerFiltered.filter({$0.status.checkStatusTransition(check: value)}).count
                  
                }
                
                FilterRow_Generic(allCases: self.viewModel.allMyCategories, filterCollection: $filterProperty.categorieMenu, selectionColor: Color.yellow.opacity(0.7), imageOrEmoji: "list.bullet.indent", label: "Categoria") { value in
                    containerFiltered.filter({$0.categoriaMenu == value.id }).count
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
                    
                    FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.blue, imageOrEmoji: "checkmark.shield",label: "Qualità")
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



