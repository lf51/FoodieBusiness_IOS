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
    
    //let tabSelection: DestinationPath // Ancora non Usate
    let backgroundColorView: Color
    
    @State private var openFilter:Bool = false
    @State private var openSort: Bool = false
   // @State private var mapObject: MapObject<IngredientModel,OrigineIngrediente>?
    @State private var mapTree:MapTree<IngredientModel,OrigineIngrediente>?
    
  //  @State private var filterProperty:IngredientModel.FilterProperty = IngredientModel.FilterProperty()
    
    @State private var filterCore:CoreFilter<IngredientModel> = CoreFilter()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.ingredientListPath) {
            
            /*let container:[IngredientModel] = self.viewModel.ricercaFiltra(containerPath: \.db.allMyIngredients, coreFilter: filterCore)*/
            
            let container:[IngredientModel] = {
                
                if let specificOne = self.viewModel.showSpecificModel,
                   let model = self.viewModel.modelFromId(id: specificOne, modelPath: \.db.allMyIngredients){
                    
                    return [model] // Nota 08.02.24
                    
                } else {
                    
                   return self.viewModel.ricercaFiltra(containerPath: \.db.allMyIngredients, coreFilter: filterCore)
                }
                
            }()
           
            let generalDisable:Bool = {
                
                let condition_1 = container.isEmpty
                let condition_2 = self.filterCore.countChange == 0
                let condition_3 = self.filterCore.stringaRicerca == ""
                
                return condition_1 && condition_2 && condition_3
                
            }()
            
            FiltrableContainerView(
                backgroundColorView: backgroundColorView,
                title: "I Miei Ingredienti (\(container.count))",
                filterCore: $filterCore,
                placeHolderBarraRicerca: "Cerca per nome e/o allergene",
                altezzaPopOverSorter: 300,
                buttonColor: .seaTurtle_3,
                elementContainer: container,
                mapTree: mapTree,
                generalDisable: generalDisable,
                onChangeValue: self.viewModel.resetScroll,
                onChangeProxyControl: { proxy in
                    if self.viewModel.pathSelection == .ingredientList {
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
                    
                   // let navigationPath = \AccounterVM.ingredientListPath
                    let navigationPath = self.viewModel.pathSelection.vmPathAssociato()
                    let isReady = ingredient.ingredientType == .asProduct
        
                    GenericItemModel_RowViewMask(model: ingredient) {
                        
                            ingredient.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: navigationPath)
 
                        Group {
                            
                            vbMenuInterattivoModuloEdit(currentModel: ingredient, viewModel: viewModel, navPath: navigationPath)
                     //  }
                            vbMenuInterattivoModuloTrash(currentModel: ingredient, viewModel: viewModel)
                        }
                        .csModifier(isReady) { $0.hidden() }
                            
                            vbReadyProdutcOption(ingredient: ingredient)
        
                    }
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
                kpPropertyInObject: \IngredientModel.values.origine.id,
                labelColor: .seaTurtle_3)
            
        } else {
            
            self.mapTree = nil
        }
    }
    
    private func removeTask(for ingredientId:String,and productId:String) {
        
        Task {
            
            do {
                
                DispatchQueue.main.async {
                    self.viewModel.isLoading = true
                }
                
              try validateProductRemotion(productId: productId)
                
                let key = IngredientModel.CodingKeys.asProduct.rawValue
                let value:String? = nil
                let path = [key:value as Any]
                
               try await self.viewModel.updateSingleField(
                    docId: ingredientId,
                    sub: .allMyIngredients,
                    path: path)
                
            } catch let error {
                
                DispatchQueue.main.async {
                    self.viewModel.isLoading = nil
                    self.viewModel.alertItem = AlertModel(
                        title: "Azione Bloccata",
                        message: error.localizedDescription)
                    
                }
            }
 
        }
        
    }
    
    private func validateProductRemotion(productId:String) throws {
        
        let menuIn:Int = self.viewModel.allMenuContaining(idPiatto: productId).countWhereDishIsIn
        
        guard menuIn == 0 else {
   
            throw CS_ErroreGenericoCustom.erroreGenerico(
                modelName: "Prodotto Pronto",
                problem: "L'ingrediente come prodotto pronto non può essere rimosso.",
                reason: "Attualmente in uso in \(menuIn) menu.")
        }

    }
    
    // ViewBuilder
    
    @ViewBuilder private func vbReadyProdutcOption(ingredient:IngredientModel) -> some View {
        
        let disable = ingredient.getStatusTransition() == .archiviato
        let isAReadyProduct:ProductModel? = {
            
            if let asProduct = ingredient.asProduct {
                
                let product = viewModel.modelFromId(id: asProduct.id, modelPath: \.db.allMyDish)
                return product
                
            } else { return nil }

         }()
        
        if let isAReadyProduct {
            
            Button {
                self.viewModel.addToThePath(destinationPath: .ingredientList, destinationView: .piatto(isAReadyProduct))
            } label: {
                HStack {
                    Text("Modifica")
                    Image(systemName: "square.and.pencil")
                }
            }.disabled(disable)
            
            Menu {
            
                Button(role:.destructive) {
                    
                    removeTask(for: ingredient.id, and: isAReadyProduct.id)
                    
                } label: {
                    HStack {
                        Text("Rimuovi Prodotto")
                        Image(systemName: "trash")
                    }
                }
                
                vbMenuInterattivoModuloTrash(currentModel: ingredient, viewModel: viewModel)
                
            } label: {
                
                HStack {
                    Text(" Trash Options")
                    Image(systemName: "trash.slash")
                }
            }

        } else {
            
            Button {
                
                let product = ProductModel(from: ingredient)
                self.viewModel.addToThePath(destinationPath: .ingredientList, destinationView: .piatto(product))
            } label: {
                HStack {
                    Text("Crea Prodotto")
                    Image(systemName: "fork.knife.circle")
                }
            }.disabled(disable)
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
        
       /* MyFilterRow(
            allCases: StatusTransition.allCases,
            filterCollection: $filterCore.filterProperties.status,
            selectionColor: Color.mint.opacity(0.8),
            imageOrEmoji: "circle.dashed",
            label: "Status") { value in
                container.filter({$0.statusTransition == value}).count
            }*/
        MyFilterRow(
            allCases: IngredientModel.IngredientType.allCases,
             filterProperty: $filterCore.filterProperties.tipologia,
             selectionColor: Color.mint.opacity(0.8),
             imageOrEmoji: "leaf",
             label: "Tipologia") { value in
                 container.filter({$0.ingredientType == value}).count
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
                container.filter({$0.values.provenienza == value}).count
            }
        
        MyFilterRow(
            allCases: ProduzioneIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.produzioneING,
            selectionColor: Color.green,
            imageOrEmoji: "sun.min.fill",
            label: "Metodo di Produzione") { value in
                container.filter({$0.values.produzione == value}).count
            }
        
        MyFilterRow(
            allCases: ConservazioneIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.conservazioneING,
            selectionColor: Color.cyan,
            imageOrEmoji: "thermometer.snowflake",
            label: "Metodo di Conservazione") { value in
                container.filter({$0.values.conservazione == value}).count
            }
        
        MyFilterRow(
            allCases: OrigineIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.origineING,
            selectionColor: Color.brown,
            imageOrEmoji: "leaf",
            label: "Origine") { value in
                container.filter({$0.values.origine == value}).count
            }
        
        MyFilterRow(
            allCases: AllergeniIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.allergeniIn,
            selectionColor: Color.red.opacity(0.7),
            imageOrEmoji: "allergens",
            label: "Allergeni Contenuti") { value in
               // container.filter({$0.allergeni.contains(value)}).count
                container.filter({
                    
                    if let allergens = $0.values.allergeni {
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
