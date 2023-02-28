//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

struct DishListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let tabSelection: DestinationPath // non Usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var openSort: Bool = false
   // @State private var mapObject: MapObject<DishModel,CategoriaMenu>?
    @State private var mapTree:MapTree<DishModel,CategoriaMenu>?
    //@State private var filterProperty: DishModel.FilterProperty = DishModel.FilterProperty()
    @State private var filterCore:CoreFilter<DishModel> = CoreFilter()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            let container = self.viewModel.ricercaFiltra(containerPath: \.allMyDish, coreFilter: filterCore)
            let generalDisable = container.isEmpty
            
            FiltrableContainerView(
                backgroundColorView: backgroundColorView,
                title: "I Miei Prodotti",
                filterCore: $filterCore,
                placeHolderBarraRicerca: "Cerca per Prodotto e/o Ingrediente",
                buttonColor: .seaTurtle_3,
                elementContainer: container,
                mapTree: mapTree,
                generalDisable: generalDisable,
                onChangeValue: self.viewModel.resetScroll,
                onChangeProxyControl: { proxy in
                    if self.tabSelection == .dishList {
                        withAnimation {
                            proxy.scrollTo(1, anchor: .top)
                        }
                    }
                },
                mapButtonAction: {
                    self.thirdButtonAction()
                },
                trailingView: {
                    self.vbTrailing()
                },
                filterView: {
                    self.vbFilterView(container: container)
                },
                sorterView: {
                    self.vbSorterView()
                },
                elementView: { dish in
                    
                    let navigationPath = \AccounterVM.dishListPath

                        GenericItemModel_RowViewMask(model: dish) {
                    
                            dish.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath:navigationPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: dish,viewModel: viewModel)
                            
                                vbMenuInterattivoModuloEdit(currentModel: dish, viewModel: viewModel, navPath: navigationPath)
                            
                                vbMenuInterattivoModuloTrash(currentModel: dish, viewModel: viewModel)
                           
                        }
              
                    
                    
                    
                   /* BodyListe_Generic(
                        container: container,
                        mapTree: mapTree,
                        navigationPath: \.dishListPath) */
                    
                })
            
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .dishList, readOnlyViewModel: viewModel)
            })
            
     
           /* .toolbar {
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
            } */
          /*  .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(400)])
          
            } */

        
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: self.viewModel.allMyCategories,
                kpPropertyInObject: \DishModel.categoriaMenu,
                labelColor: .seaTurtle_3)
            
        } else {
            
            self.mapTree = nil
        }
    }
    
    @ViewBuilder private func vbTrailing() -> some View {
        
        LargeBar_TextPlusButton(
            buttonTitle: "Nuovo Prodotto",
            font: .callout,
            imageBack: Color("SeaTurtlePalette_2"),
            imageFore: Color.white) {
                self.viewModel.dishListPath.append(DestinationPathView.piatto(DishModel()))
            }
    }
    
    @ViewBuilder private func vbFilterView(container:[DishModel]) -> some View {
        
        MyFilterRow(
            allCases: DishModel.PercorsoProdotto.allCases,
            filterCollection: $filterCore.filterProperties.percorsoPRP,
            selectionColor: Color.white.opacity(0.5),
            imageOrEmoji: "fork.knife",
            label: "Prodotto") { value in
                container.filter({$0.percorsoProdotto == value}).count
            }
        
        let checkAvailability = checkStatoScorteAvailability()
        
        MyFilterRow(
            allCases: Inventario.TransitoScorte.allCases,
            filterCollection: $filterCore.filterProperties.inventario,
            selectionColor: Color.teal.opacity(0.6),
            imageOrEmoji: "cart",
            label: "Livello Scorte") { value in
                
                if checkAvailability {
                     return container.filter({
                        self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value
                    }).count
                } else { return 0 }
            }
            .opacity(checkAvailability ? 1.0 : 0.3)
            .disabled(!checkAvailability)
        
        MyFilterRow(
            allCases: StatusTransition.allCases,
            filterCollection: $filterCore.filterProperties.status,
            selectionColor: Color.mint.opacity(0.8),
            imageOrEmoji: "circle.dashed",
            label: "Status") { value in
                container.filter({$0.status.checkStatusTransition(check: value)}).count
            }
     
        MyFilterRow(
            allCases: self.viewModel.allMyCategories,
            filterCollection: $filterCore.filterProperties.categorieMenu,
            selectionColor: Color.yellow.opacity(0.7),
            imageOrEmoji: "list.bullet.indent",
            label: "Categoria") { value in
                container.filter({$0.categoriaMenu == value.id}).count
            }
        
        MyFilterRow(
            allCases: DishModel.BasePreparazione.allCase,
            filterProperty: $filterCore.filterProperties.basePRP,
            selectionColor: Color.brown,
            imageOrEmoji: "leaf",
            label: "Preparazione a base di") { value in
                container.filter({
                    $0.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel) == value
                }).count
            }
        
        
        MyFilterRow(
            allCases: TipoDieta.allCases,
            filterCollection: $filterCore.filterProperties.dietePRP,
            selectionColor: Color.orange.opacity(0.6),
            imageOrEmoji: "person.fill.checkmark",
            label: "Adatto alla dieta") { value in
                container.filter({
                    $0.returnDietAvaible(viewModel: self.viewModel).inDishTipologia.contains(value)
                }).count
            }
        
        MyFilterRow(
            allCases: ProduzioneIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.produzioneING,
            selectionColor: Color.blue,
            imageOrEmoji: "checkmark.shield",
            label: "Qualità") { value in
                container.filter({
                    $0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality: value)
                }).count
            }
        
        MyFilterRow(
            allCases: ProvenienzaIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.provenienzaING,
            selectionColor: Color.blue,
            imageOrEmoji: nil) { value in
                container.filter({
                    $0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: value)
                }).count
            }
        
        MyFilterRow(
            allCases: AllergeniIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.allergeniIn,
            selectionColor: Color.red.opacity(0.7),
            imageOrEmoji: "allergens",
            label: "Allergeni Contenuti") { value in
                container.filter({
                    $0.calcolaAllergeniNelPiatto(viewModel: self.viewModel).contains(value)
                }).count
            }
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let isPF = checkStatoScorteAvailability()
        let color:Color = .seaTurtle_3
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .alfabeticoDecrescente,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .livelloScorte,
            coloreScelta: color)
            .opacity(isPF ? 1.0 : 0.5)
            .disabled(!isPF)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .mostUsed,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .topRated,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .mostRated,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .topPriced,
            coloreScelta: color)
     
    }
    
    /*
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
                
            
        } */

   /* @ViewBuilder private func vbLocalFilterPop(containerFiltered:[DishModel] = []) -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

              /*  FilterRow_Generic(allCases: DishModel.PercorsoProdotto.allCases, filterCollection: $filterProperty.percorsoPRP, selectionColor: Color.white.opacity(0.5), imageOrEmoji: "fork.knife",label: "Prodotto") { value in
                    
                    containerFiltered.filter({$0.percorsoProdotto == value}).count
                } */
            
              /*  let checkAvailability = checkStatoScorteAvailability()
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor: Color.teal.opacity(0.6), imageOrEmoji: "cart",label: "Livello Scorte (Solo PF)") { value in
                    
                    if checkAvailability {
                        
                      return containerFiltered.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value }).count
                    
                    }
                    else { return 0 }
                    
                }
                    .opacity(checkAvailability ? 1.0 : 0.3)
                    .disabled(!checkAvailability) */
                
               /* FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label: "Status")
                { value in
                    
                   containerFiltered.filter({$0.status.checkStatusTransition(check: value)}).count
                  
                } */
                 
               /* FilterRow_Generic(allCases: self.viewModel.allMyCategories, filterCollection: $filterProperty.categorieMenu, selectionColor: Color.yellow.opacity(0.7), imageOrEmoji: "list.bullet.indent", label: "Categoria") { value in
                    containerFiltered.filter({$0.categoriaMenu == value.id }).count
                } */
                
                
               /* FilterRow_Generic(allCases: DishModel.BasePreparazione.allCase, filterProperty: $filterProperty.basePRP, selectionColor: Color.brown,imageOrEmoji: "leaf",label: "Preparazione a base di")
                { value in
                    containerFiltered.filter({ $0.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel) == value}).count
                   // return filterM.count
                } */
                
               /* FilterRow_Generic(allCases: TipoDieta.allCases, filterCollection: $filterProperty.dietePRP, selectionColor: Color.orange.opacity(0.6), imageOrEmoji: "person.fill.checkmark",label: "Adatto alla dieta")
                { value in
                    containerFiltered.filter({$0.returnDietAvaible(viewModel: self.viewModel).inDishTipologia.contains(value)}).count
                } */
                
                
                

             //   HStack {
                    
                   /* FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.blue, imageOrEmoji: "checkmark.shield",label: "Qualità")
                    { value in
                        containerFiltered.filter({$0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality: value)}).count
                    }*/
                    
                   /* FilterRow_Generic(allCases: ProvenienzaIngrediente.allCases, filterProperty: $filterProperty.provenienzaING, selectionColor: Color.blue,imageOrEmoji: nil)
                    { value in
                        containerFiltered.filter({$0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: value)}).count
                    }*/

               // }
                
             /*   FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), imageOrEmoji: "allergens",label: "Allergeni Contenuti")
                { value in
                    containerFiltered.filter({$0.calcolaAllergeniNelPiatto(viewModel: self.viewModel).contains(value)}).count
                } */
                
            /*    FilterRow_GenericForString(allCases: self.viewModel.allMyIngredients, filterCollection: $filterProperty.rifIngredientiPRP, selectionColor: Color.gray, imageOrEmoji: "list.bullet.rectangle") */ // Deprecata 04.11
                
              
                
            }
                
            
        } */
        
    
    private func checkStatoScorteAvailability() -> Bool {
       
        guard let percorso = self.filterCore.filterProperties.percorsoPRP else { return false }
        
       return percorso.contains(.prodottoFinito) &&
        percorso.count == 1
        
        
     //   self.filterProperty.percorsoPRP.contains(.prodottoFinito) &&
     //   self.filterProperty.percorsoPRP.count == 1
        
    }
    
}




/*
struct DishListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // non Usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var openSort: Bool = false
    @State private var mapObject: MapObject<DishModel,CategoriaMenu>?
  //  @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    @State private var coreFilter:FilterPropertyCore = FilterPropertyCore<DishModel>()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            CSZStackVB(title: "I Miei Prodotti", backgroundColorView: backgroundColorView) {

               /* let container = self.viewModel.filtraERicerca(containerPath: \.allMyDish, filterProperty: filterProperty)*/ // Vedi Nota 08.11 // deprecata 19.12.22
                let container = self.viewModel.filtraERicerca(containerPath:\.allMyDish, filterCore: coreFilter)
 
                BodyListe_Generic(
                    filterString: $coreFilter.stringaRicerca,
                    container:container,
                    mapObject: mapObject,
                    navigationPath: \.dishListPath,
                    placeHolder: "Cerca per Prodotto e/o Ingrediente..")
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
                    
                    let sortActive = self.coreFilter.conditions != nil
                    
                    FilterSortMap_Bar(open: $openFilter, openSort: $openSort, filterCount: coreFilter.countChange,sortActive: sortActive) {
                        
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
             
            self.coreFilter.conditions = nil
                
            } content: {

                let isPF:Bool = {
                    
                    if let filterProperties = self.coreFilter.properties {
                        
                       return filterProperties.percorsoPRP.contains(.prodottoFinito) &&
                        filterProperties.percorsoPRP.count == 1
                        
                    } else { return false }
                    
                   /* self.filterProperty.percorsoPRP.contains(.prodottoFinito) &&
                    self.filterProperty.percorsoPRP.count == 1 */
                }()
                
                SortRow_Generic<DishModel>(sortCondition: $coreFilter.conditions, localSortCondition: .alfabeticoDecrescente)
                    
                SortRow_Generic<DishModel>(sortCondition: $coreFilter.conditions, localSortCondition: .livelloScorte)
                    .opacity(isPF ? 1.0 : 0.5)
                    .disabled(!isPF)
  
                SortRow_Generic<DishModel>(sortCondition: $coreFilter.conditions, localSortCondition: .mostUsed)
                
                SortRow_Generic<DishModel>(sortCondition: $coreFilter.conditions, localSortCondition: .topRated)
                
                SortRow_Generic<DishModel>(sortCondition: $coreFilter.conditions, localSortCondition: .mostRated)
                
                SortRow_Generic<DishModel>(sortCondition: $coreFilter.conditions, localSortCondition: .topPriced)
                

            }
                
            
        }

    @ViewBuilder private func vbLocalFilterPop(containerFiltered:[DishModel] = []) -> some View {
     
        
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                  //  self.filterProperty = FilterPropertyModel()
            self.coreFilter.properties = nil
                
            } content: {

             
                FilterRow_Generic(allCases: DishModel.PercorsoProdotto.allCases, filterCollection: $coreFilter.properties.percorsoPRP, selectionColor: Color.white.opacity(0.5), imageOrEmoji: "fork.knife",label: "Prodotto") { value in
                    
                    containerFiltered.filter({$0.percorsoProdotto == value}).count
                }
            
                let checkAvailability = checkStatoScorteAvailability()
                
              /*  FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor: Color.teal.opacity(0.6), imageOrEmoji: "cart",label: "Livello Scorte (Solo PF)") { value in
                    
                    if checkAvailability {
                        
                      return containerFiltered.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value }).count
                    
                    }
                    else { return 0 }
                    
                }
                    .opacity(checkAvailability ? 1.0 : 0.3)
                    .disabled(!checkAvailability) */ // da Riaprire
                
             /*   FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label: "Status")
                { value in
                    
                   containerFiltered.filter({$0.status.checkStatusTransition(check: value)}).count
                  
                } */ // da Riaprire
                
                
                FilterRow_Generic(allCases: self.viewModel.allMyCategories, filterCollection: $coreFilter.properties?.categorieMenu!, selectionColor: Color.yellow.opacity(0.7), imageOrEmoji: "list.bullet.indent", label: "Categoria") { value in
                    containerFiltered.filter({$0.categoriaMenu == value.id }).count
                }
                
                
                FilterRow_Generic(allCases: DishModel.BasePreparazione.allCase, filterProperty: $coreFilter.properties.basePRP, selectionColor: Color.brown,imageOrEmoji: "leaf",label: "Preparazione a base di")
                { value in
                    containerFiltered.filter({ $0.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel) == value}).count
                   // return filterM.count
                }
                
                FilterRow_Generic(allCases: TipoDieta.allCases, filterCollection: $coreFilter.properties.dietePRP, selectionColor: Color.orange.opacity(0.6), imageOrEmoji: "person.fill.checkmark",label: "Adatto alla dieta")
                { value in
                    containerFiltered.filter({$0.returnDietAvaible(viewModel: self.viewModel).inDishTipologia.contains(value)}).count
                }
                
                
                

             //   HStack {
                    
                /*    FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.blue, imageOrEmoji: "checkmark.shield",label: "Qualità")
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
                } */ // da Riparire
                
            /*    FilterRow_GenericForString(allCases: self.viewModel.allMyIngredients, filterCollection: $filterProperty.rifIngredientiPRP, selectionColor: Color.gray, imageOrEmoji: "list.bullet.rectangle") */ // Deprecata 04.11
                
              
                
            }
                
            
        }
        
    
    private func checkStatoScorteAvailability() -> Bool {
        
        if let properties = self.coreFilter.properties {
            
            properties.percorsoPRP.contains(.prodottoFinito) &&
            properties.percorsoPRP.count == 1
            
        } else { return false }
        
       
        
      /*  self.filterProperty.percorsoPRP.contains(.prodottoFinito) &&
        self.filterProperty.percorsoPRP.count == 1 */
        
    }
    
} */ // da cancellare

/*
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
    
}*/ // Deprecata 19.12.22 per creazione Modulo Filtro - BackUp 22.12.22


struct DishListView_Previews: PreviewProvider {
    
    static var previews: some View {
       
        DishListView(tabSelection: .dishList, backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}



