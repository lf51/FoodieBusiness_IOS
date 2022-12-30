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

struct ListaIngredientiView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // Ancora non Usate
    let backgroundColorView: Color
    
    @State private var openFilter:Bool = false
    @State private var openSort: Bool = false
   // @State private var mapObject: MapObject<IngredientModel,OrigineIngrediente>?
    @State private var mapTree:MapTree<IngredientModel,OrigineIngrediente>?
    
  //  @State private var filterProperty:IngredientModel.FilterProperty = IngredientModel.FilterProperty()
    
    @State private var filterCore:CoreFilter<IngredientModel> = CoreFilter()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.ingredientListPath) {
            
            let container = self.viewModel.ricercaFiltra(containerPath: \.allMyIngredients, coreFilter: filterCore)
           
            FiltrableContainerView(
                backgroundColorView: backgroundColorView,
                title: "I Miei Ingredienti",
                filterCore: $filterCore,
                placeHolderBarraRicerca: "Cerca per nome e/o allergene",
                altezzaPopOverSorter: 300,
                buttonColor: CatalogoColori.seaTurtle_3.color(),
                elementContainer: container,
                mapTree: mapTree) {
                    self.thirdButtonAction()
                } trailingView: {
                    vbTrailing()
                } filterView: {
                    vbFilterView(container: container)
                } sorterView: {
                    vbSorterView()
                } elementView: { ingredient in
                    
                    let navigationPath = \AccounterVM.ingredientListPath
                    
                    GenericItemModel_RowViewMask(model: ingredient) {
                        
                        ingredient.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: navigationPath)
                            
                            vbMenuInterattivoModuloCambioStatus(myModel: ingredient,viewModel: viewModel)
                        
                            vbMenuInterattivoModuloEdit(currentModel: ingredient, viewModel: viewModel, navPath: navigationPath)
                        
                            vbMenuInterattivoModuloTrash(currentModel: ingredient, viewModel: viewModel)
                       
                    }
                    
                    
                    
                   /* BodyListe_Generic(
                        container: container,
                        mapTree: mapTree,
                        navigationPath: \.ingredientListPath) */
                    
                }

            
            
            
            
           /* CSZStackVB(title: "I Miei Ingredienti", backgroundColorView: backgroundColorView) {

                let container = self.viewModel.filtraERicerca(containerPath: \.allMyIngredients, filterProperty: filterProperty)
            
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container:container,mapObject: mapObject, navigationPath: \.ingredientListPath)
                    .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                        vbLocalFilterPop(container: container)
                            .presentationDetents([.height(600)])
                  
                    }
                    .popover(isPresented: $openSort, attachmentAnchor: .point(.top)) {
                        vbLocalSorterPop()
                            .presentationDetents([.height(300)])
                  
                    }
                            
            }*/
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .ingredientList, readOnlyViewModel: viewModel)
            })
           /* .toolbar {
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
                    
                    let sortActive = self.filterProperty.sortCondition != nil
                    
                    FilterSortMap_Bar(open: $openFilter,openSort: $openSort, filterCount: filterProperty.countChange,sortActive: sortActive) {
                        thirdButtonAction()
                    }
                    
                  /*  CSButton_image(frontImage: "slider.horizontal.3", imageScale: .large, frontColor: Color("SeaTurtlePalette_3")) {
                        self.openFilter.toggle()
                    } */

                }
               
            } */
            /*.popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(350)])
          
            }*/
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: OrigineIngrediente.allCases,
                kpPropertyInObject: \IngredientModel.origine.id,
                labelColor: CatalogoColori.seaTurtle_3.color())
            
        } else {
            
            self.mapTree = nil
        }
    }
        
    @ViewBuilder private func vbTrailing() -> some View {
        
        LargeBar_TextPlusButton(
            buttonTitle: "Nuovo Ingrediente",
            font: .callout,
            imageBack: CatalogoColori.seaTurtle_2.color(),
            imageFore: Color.white) {
                self.viewModel.ingredientListPath.append(DestinationPathView.ingrediente(IngredientModel()))
            }
    }
    
    @ViewBuilder private func vbFilterView(container:[IngredientModel]) -> some View {
        
        MyFilterRow(
            allCases: StatusTransition.allCases,
            filterCollection: $filterCore.filterProperties.status,
            selectionColor: Color.mint.opacity(0.8),
            imageOrEmoji: "circle.dashed",
            label: "Status") { value in
                container.filter({$0.status.checkStatusTransition(check: value)}).count
            }
        
        MyFilterRow(
            allCases: Inventario.TransitoScorte.allCases,
            filterCollection: $filterCore.filterProperties.inventario,
            selectionColor: Color.teal.opacity(0.6),
            imageOrEmoji: "cart",
            label: "Livello Scorte") { value in
                container.filter({
                    self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value
                }).count
            }
        
        MyFilterRow(
            allCases: ProvenienzaIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.provenienzaING,
            selectionColor: Color.gray,
            imageOrEmoji: "globe.americas",
            label: "Provenienza") { value in
                container.filter({$0.provenienza == value}).count
            }
        
        MyFilterRow(
            allCases: ProduzioneIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.produzioneING,
            selectionColor: Color.green,
            imageOrEmoji: "sun.min.fill",
            label: "Metodo di Produzione") { value in
                container.filter({$0.produzione == value}).count
            }
        
        MyFilterRow(
            allCases: ConservazioneIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.conservazioneING,
            selectionColor: Color.cyan,
            imageOrEmoji: "thermometer.snowflake",
            label: "Metodo di Conservazione") { value in
                container.filter({$0.conservazione == value}).count
            }
        
        MyFilterRow(
            allCases: OrigineIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.origineING,
            selectionColor: Color.brown,
            imageOrEmoji: "leaf",
            label: "Origine") { value in
                container.filter({$0.origine == value}).count
            }
        
        MyFilterRow(
            allCases: AllergeniIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.allergeniIn,
            selectionColor: Color.red.opacity(0.7),
            imageOrEmoji: "allergens",
            label: "Allergeni Contenuti") { value in
                container.filter({$0.allergeni.contains(value)}).count
            }
        
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let color = CatalogoColori.seaTurtle_3.color()
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .alfabeticoDecrescente,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .livelloScorte,
            coloreScelta: color)
       
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .mostUsed,
            coloreScelta: color)
    }
    
  /*  @ViewBuilder private func vbLocalSorterPop() -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Sort") {
             
            self.filterProperty.sortCondition = nil
                
            } content: {

                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .alfabeticoDecrescente)
                    
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .livelloScorte)
  
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .mostUsed)
                

            }
                
            
        } */
    
   /* @ViewBuilder private func vbLocalFilterPop(container:[IngredientModel]) -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

              /*  FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label: "Status"){ value in
                    container.filter({$0.status.checkStatusTransition(check: value)}).count
                } */
                
              /*  FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor:Color.teal.opacity(0.6), imageOrEmoji: "cart",label: "Livello Scorte"){ value in
                    container.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value}).count
                } */
                    
              /*  FilterRow_Generic(allCases: ProvenienzaIngrediente.allCases, filterProperty: $filterProperty.provenienzaING, selectionColor: Color.gray,imageOrEmoji:"globe.americas",label: "Provenienza"){ value in
                    container.filter({$0.provenienza == value}).count
                }*/
                
              /*  FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.green,imageOrEmoji: "sun.min.fill",label: "Metodo di Produzione"){ value in
                    container.filter({$0.produzione == value}).count
                }*/

               /* FilterRow_Generic(allCases: ConservazioneIngrediente.allCases, filterCollection: $filterProperty.conservazioneING, selectionColor: Color.cyan,imageOrEmoji:"thermometer.snowflake",label: "Metodo di Conservazione"){ value in
                    container.filter({$0.conservazione == value}).count
                } */
                
              /*  FilterRow_Generic(allCases: OrigineIngrediente.allCases, filterProperty: $filterProperty.origineING, selectionColor: Color.brown,imageOrEmoji:"leaf",label: "Origine"){ value in
                    container.filter({$0.origine == value}).count
                } */
                
                FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), imageOrEmoji: "allergens",label: "Allergeni Contenuti"){ value in
                    container.filter({$0.allergeni.contains(value)}).count
                }
            }
                
            
        } */
    
}
/*
struct ListaIngredientiView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // Ancora non Usate
    let backgroundColorView: Color
    
    @State private var openFilter:Bool = false
    @State private var openSort: Bool = false
    @State private var mapObject: MapObject<IngredientModel,OrigineIngrediente>?
    
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.ingredientListPath) {
            
            
            
            
            
            
            
            CSZStackVB(title: "I Miei Ingredienti", backgroundColorView: backgroundColorView) {

                let container = self.viewModel.filtraERicerca(containerPath: \.allMyIngredients, filterProperty: filterProperty)
            
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container:container,mapObject: mapObject, navigationPath: \.ingredientListPath)
                    .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                        vbLocalFilterPop(container: container)
                            .presentationDetents([.height(600)])
                  
                    }
                    .popover(isPresented: $openSort, attachmentAnchor: .point(.top)) {
                        vbLocalSorterPop()
                            .presentationDetents([.height(300)])
                  
                    }
                            
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
                    
                    let sortActive = self.filterProperty.sortCondition != nil
                    
                    FilterSortMap_Bar(open: $openFilter,openSort: $openSort, filterCount: filterProperty.countChange,sortActive: sortActive) {
                        thirdButtonAction()
                    }
                    
                  /*  CSButton_image(frontImage: "slider.horizontal.3", imageScale: .large, frontColor: Color("SeaTurtlePalette_3")) {
                        self.openFilter.toggle()
                    } */

                }
               
            }
            /*.popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(350)])
          
            }*/
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapObject == nil {
            
            self.mapObject = MapObject(
                mapCategory: OrigineIngrediente.allCases,
                kpMapCategory: \IngredientModel.origine.id)
            
        } else {
            
            self.mapObject = nil
        }
    }
        
    
    @ViewBuilder private func vbLocalSorterPop() -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Sort") {
             
            self.filterProperty.sortCondition = nil
                
            } content: {

                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .alfabeticoDecrescente)
                    
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .livelloScorte)
  
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .mostUsed)
                

            }
                
            
        }
    
    @ViewBuilder private func vbLocalFilterPop(container:[IngredientModel]) -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label: "Status"){ value in
                    container.filter({$0.status.checkStatusTransition(check: value)}).count
                }
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor:Color.teal.opacity(0.6), imageOrEmoji: "cart",label: "Livello Scorte"){ value in
                    container.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value}).count
                }
                    
                FilterRow_Generic(allCases: ProvenienzaIngrediente.allCases, filterProperty: $filterProperty.provenienzaING, selectionColor: Color.gray,imageOrEmoji:"globe.americas",label: "Provenienza"){ value in
                    container.filter({$0.provenienza == value}).count
                }
                
                FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.green,imageOrEmoji: "sun.min.fill",label: "Metodo di Produzione"){ value in
                    container.filter({$0.produzione == value}).count
                }

                FilterRow_Generic(allCases: ConservazioneIngrediente.allCases, filterCollection: $filterProperty.conservazioneING, selectionColor: Color.cyan,imageOrEmoji:"thermometer.snowflake",label: "Metodo di Conservazione"){ value in
                    container.filter({$0.conservazione == value}).count
                }
                
                FilterRow_Generic(allCases: OrigineIngrediente.allCases, filterProperty: $filterProperty.origineING, selectionColor: Color.brown,imageOrEmoji:"leaf",label: "Origine"){ value in
                    container.filter({$0.origine == value}).count
                }
                
                FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), imageOrEmoji: "allergens",label: "Allergeni Contenuti"){ value in
                    container.filter({$0.allergeni.contains(value)}).count
                }
            }
                
            
        }
    
}*/ // backup 22.12

struct ListaIngredientiView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredientiView(tabSelection: .constant(2), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}
