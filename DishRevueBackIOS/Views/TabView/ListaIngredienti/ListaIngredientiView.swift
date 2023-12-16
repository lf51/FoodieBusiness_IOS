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
    
    let tabSelection: DestinationPath // Ancora non Usate
    let backgroundColorView: Color
    
    @State private var openFilter:Bool = false
    @State private var openSort: Bool = false
   // @State private var mapObject: MapObject<IngredientModel,OrigineIngrediente>?
    @State private var mapTree:MapTree<IngredientModel,OrigineIngrediente>?
    
  //  @State private var filterProperty:IngredientModel.FilterProperty = IngredientModel.FilterProperty()
    
    @State private var filterCore:CoreFilter<IngredientModel> = CoreFilter()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.ingredientListPath) {
            
            let allModelCount = self.viewModel.db.allMyIngredients.count
           // let container_0 = self.viewModel.ricercaFiltra(containerPath: \.cloudData.allMyIngredients, coreFilter: filterCore)
            let container = self.viewModel.ricercaFiltra(containerPath: \.db.allMyIngredients, coreFilter: filterCore)
            // update 10.07.23
           /* let container = container_0.filter({$0.status != .bozza()})*/ // obsoleto
            // update per escludere gli ing di sistema. Prima questo avveniva nella propertyCompare degli Ing, ma abbiamo dovuto modificare perchè ci impediva di filtrare i prodotti finiti nella vista espansa PF del monitor.
            let generalDisable:Bool = {
                
                let condition_1 = container.isEmpty
                let condition_2 = self.filterCore.countChange == 0
                let condition_3 = self.filterCore.stringaRicerca == ""
                
                return condition_1 && condition_2 && condition_3
                
            }()
            
            FiltrableContainerView(
                backgroundColorView: backgroundColorView,
                title: "I Miei Ingredienti (\(allModelCount))",
                filterCore: $filterCore,
                placeHolderBarraRicerca: "Cerca per nome e/o allergene",
                altezzaPopOverSorter: 300,
                buttonColor: .seaTurtle_3,
                elementContainer: container,
                mapTree: mapTree,
                generalDisable: generalDisable,
                onChangeValue: self.viewModel.resetScroll,
                onChangeProxyControl: { proxy in
                    if self.tabSelection == .ingredientList {
                        withAnimation {
                            proxy.scrollTo(1, anchor: .top)
                        }
                    }
                },
                mapButtonAction: {
                    self.thirdButtonAction()
                }, trailingView: {
                    vbTrailing()
                }, filterView: {
                    vbFilterView(container: container)
                }, sorterView: {
                    vbSorterView()
                }, elementView: { ingredient in
                    
                    let navigationPath = \AccounterVM.ingredientListPath
                    
                    let isAReadyProduct:ProductModel? = {
                        if let id = viewModel.isASubOfReadyProduct(id: ingredient.id) {
                           return viewModel.modelFromId(id:id, modelPath: \.db.allMyDish)
                        } else {
                            return nil
                        }
                        
                    }()
                    
                    GenericItemModel_RowViewMask(model: ingredient) {
                        
                        Group {
                            
                            ingredient.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: navigationPath)

                            vbMenuInterattivoModuloEdit(currentModel: ingredient, viewModel: viewModel, navPath: navigationPath)
                        
                            vbMenuInterattivoModuloTrash(currentModel: ingredient, viewModel: viewModel)
                            
                        }//.disabled(isAReadyProduct != nil)
                        
                        // Da ViewBuildizzare
                        if let isAReadyProduct {
                            Button {
                                self.viewModel.addToThePath(destinationPath: .ingredientList, destinationView: .piatto(isAReadyProduct))
                            } label: {
                                Text("Vedi Prodotto")
                            }

                        } else {
                            Button {
                                self.viewModel.addToThePath(destinationPath: .ingredientList, destinationView: .piatto(ProductModel(from: ingredient)))
                            } label: {
                                Text("Crea Prodotto")
                            }
                        }
                        
                       
                    }
                   // .opacity(isAReadyProduct != nil ? 0.6 : 1.0)
                    
                                        
                })
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .ingredientList, readOnlyViewModel: viewModel)
            })
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: OrigineIngrediente.allCases,
                kpPropertyInObject: \IngredientModel.origine.id,
                labelColor: .seaTurtle_3)
            
        } else {
            
            self.mapTree = nil
        }
    }
    
    @ViewBuilder private func vbTrailing() -> some View {
        
        Menu {
            
            NavigationButtonBasic(
                label: "Crea Nuovo",
                systemImage: "square.and.pencil",
                navigationPath: .ingredientList,
                destination: .ingrediente(IngredientModel()))
            
            NavigationButtonBasic(
                label: "Importa dal Cloud",
                systemImage: "cloud",
                navigationPath: .ingredientList,
                destination: .moduloImportazioneDaLibreriaIngredienti)
   
        } label: {
            LargeBar_Text(
                title: "Nuovo Ingrediente",
                font: .callout,
                imageBack: .seaTurtle_2,
                imageFore: Color.white)
        }

        
    }
    
    @ViewBuilder private func vbFilterView(container:[IngredientModel]) -> some View {
        
        MyFilterRow(
            allCases: StatusTransition.allCases,
            filterCollection: $filterCore.filterProperties.status,
            selectionColor: Color.mint.opacity(0.8),
            imageOrEmoji: "circle.dashed",
            label: "Status") { value in
                container.filter({$0.statusTransition == value}).count
            }
        
        MyFilterRow(
            allCases: StatoScorte.allCases,
            filterCollection: $filterCore.filterProperties.inventario,
            selectionColor: Color.teal.opacity(0.6),
            imageOrEmoji: "cart",
            label: "Livello Scorte") { value in
                container.filter({
                    $0.statusScorte() == value 
                    /*self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id) == value*/
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
               // container.filter({$0.allergeni.contains(value)}).count
                container.filter({
                    
                    if let allergens = $0.allergeni {
                        return allergens.contains(value)
                    } else { return false }
                }).count
            }
        
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let color:Color = .seaTurtle_3
        
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
    

}
/*
struct ListaIngredientiView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredientiView(tabSelection: .ingredientList, backgroundColorView: .seaTurtle_1)
            .environmentObject(testAccount)
    }
}*/
