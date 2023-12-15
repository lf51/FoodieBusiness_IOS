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
    @State private var mapTree:MapTree<ProductModel,CategoriaMenu>?
    @State private var filterCore:CoreFilter<ProductModel> = CoreFilter()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            let container = self.viewModel.ricercaFiltra(containerPath: \.db.allMyDish, coreFilter: filterCore)
            
            let generalDisable:Bool = {
                
                let condition_1 = container.isEmpty
                let condition_2 = self.filterCore.countChange == 0
                let condition_3 = self.filterCore.stringaRicerca == ""
                
                return condition_1 && condition_2 && condition_3
                
            }()
            
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
                                
                            if dish.adress != .finito {
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: dish,viewModel: viewModel)
                            }
                                
                                vbMenuInterattivoModuloEdit(currentModel: dish, viewModel: viewModel, navPath: navigationPath)
                            
                                vbMenuInterattivoModuloTrash(currentModel: dish, viewModel: viewModel)
                           
                        }
                    
                })
            
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .dishList, readOnlyViewModel: viewModel)
            })
        
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: self.viewModel.db.allMyCategories,
                kpPropertyInObject: \ProductModel.categoriaMenu,
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
                navigationPath: .dishList,
                destination: .piatto(ProductModel()))
            
            NavigationButtonBasic(
                label: "Crea in blocco",
                systemImage: "doc.on.doc",
                navigationPath: .dishList,
                destination: .moduloCreaInBloccoPiattiEIngredienti)
   
        } label: {
            LargeBar_Text(
                title: "Nuovo Prodotto",
                font: .callout,
                imageBack: .seaTurtle_2,
                imageFore: Color.white)
        }
        
    }
    
    @ViewBuilder private func vbFilterView(container:[ProductModel]) -> some View {
        
        MyFilterRow(
            allCases: ProductAdress.allCases,
            filterCollection: $filterCore.filterProperties.percorsoPRP,
            selectionColor: Color.white.opacity(0.5),
            imageOrEmoji: "fork.knife",
            label: "Prodotto") { value in
                container.filter({$0.adress == value}).count
            }
        
        let checkAvailability = checkStatoScorteAvailability()
        
        MyFilterRow(
            allCases: StatoScorte.allCases,
            filterCollection: $filterCore.filterProperties.inventario,
            selectionColor: Color.teal.opacity(0.6),
            imageOrEmoji: "cart",
            label: "Livello Scorte") { value in
                
                if checkAvailability {
                     return container.filter({
                         
                         self.viewModel.getStatusScorteING(from: $0.id) == value
                       /* self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id) == value*/
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
                container.filter({
                    $0.getStatusTransition(viewModel:self.viewModel) == value
                }).count
            }
     
        MyFilterRow(
            allCases: self.viewModel.db.allMyCategories,
            filterCollection: $filterCore.filterProperties.categorieMenu,
            selectionColor: Color.yellow.opacity(0.7),
            imageOrEmoji: "list.bullet.indent",
            label: "Categoria") { value in
                container.filter({$0.categoriaMenu == value.id}).count
            }
        
        MyFilterRow(
            allCases: ProductModel.BasePreparazione.allCase,
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

    private func checkStatoScorteAvailability() -> Bool {
       
        guard let percorso = self.filterCore.filterProperties.percorsoPRP else { return false }
        
       return percorso.contains(.finito) &&
        percorso.count == 1
 
    }
    
}
/*
struct DishListView_Previews: PreviewProvider {
    
    static var previews: some View {
       
        DishListView(tabSelection: .dishList, backgroundColorView: Color.seaTurtle_1)
            .environmentObject(testAccount)
    }
}*/



