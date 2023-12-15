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

struct MenuListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let tabSelection: DestinationPath 
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var openSort: Bool = false
   // @State private var mapObject: MapObject<MenuModel,TipologiaMenu>?
    @State private var mapTree: MapTree<MenuModel,TipologiaMenu>?
                                                
   // @State private var filterProperty:MenuModel.FilterProperty = MenuModel.FilterProperty()
    @State private var filterCore:CoreFilter<MenuModel> = CoreFilter()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.menuListPath) {
            
            let container = self.viewModel.ricercaFiltra(containerPath: \.db.allMyMenu, coreFilter: filterCore)
            
            let generalDisable:Bool = {
                
                let condition_1 = container.isEmpty
                let condition_2 = self.filterCore.countChange == 0
                let condition_3 = self.filterCore.stringaRicerca == ""
                
                return condition_1 && condition_2 && condition_3
                
            }()

            FiltrableContainerView(
                backgroundColorView: backgroundColorView,
                title: "I Miei Menu",
                filterCore: $filterCore,
                placeHolderBarraRicerca: "Cerca per Menu e/o Piatto",
                buttonColor: .seaTurtle_3,
                elementContainer: container,
                mapTree: mapTree,
                generalDisable: generalDisable,
                onChangeValue: self.viewModel.resetScroll,
                onChangeProxyControl: { proxy in
                    if self.tabSelection == .menuList {
                        withAnimation {
                            proxy.scrollTo(1, anchor: .top)
                        }
                    }
                },
                mapButtonAction: {
                    self.thirdButtonAction()
                }, trailingView: {
                    self.vbTrailing()
                }, filterView: {
                    self.vbFilterView(container: container)
                }, sorterView: {
                    self.vbSorterView()
                }, elementView: { menu in
                    
                    let navigationPath = \AccounterVM.menuListPath
                    
                    GenericItemModel_RowViewMask(model: menu) {
                        
                        menu.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: navigationPath)
                            
                            vbMenuInterattivoModuloCambioStatus(myModel: menu,viewModel: viewModel)
                        
                            vbMenuInterattivoModuloEdit(currentModel: menu, viewModel: viewModel, navPath: navigationPath )
                        
                            vbMenuInterattivoModuloTrash(currentModel: menu, viewModel: viewModel)
                       
                    }
                      
                })

        .navigationDestination(for: DestinationPathView.self, destination: { destination in
            destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .menuList, readOnlyViewModel: viewModel)
         })
   
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: TipologiaMenu.allCases,
                kpPropertyInObject: \MenuModel.tipologia.id,
                labelColor: .seaTurtle_3)
            
        } else {
            
            self.mapTree = nil
        }
    }

    @ViewBuilder private func vbTrailing() -> some View {
        
        LargeBar_TextPlusButton(
            buttonTitle: "Nuovo Menu",
            font: .callout,
            imageBack: .seaTurtle_2,
            imageFore: Color.white) {
                self.viewModel.menuListPath.append(DestinationPathView.menu(MenuModel()))
            }
    }
    
    @ViewBuilder private func vbFilterView(container:[MenuModel]) -> some View {
        
        MyFilterRow(
            allCases: MenuModel.OnlineStatus.allCases,
            filterProperty: $filterCore.filterProperties.onlineOfflineMenu,
            selectionColor: Color.cyan,
            imageOrEmoji: "face.dashed",
            label: "Programmazione Odierna") { value in
                container.filter({$0.isOnAirValue().today}).count
            }
        
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
            allCases: TipologiaMenu.allCases,
            filterProperty: $filterCore.filterProperties.tipologiaMenu,
            selectionColor: Color.brown,
            imageOrEmoji: "square.on.square.dashed",
            label: "Tipologia") { value in
                container.filter({$0.tipologia.returnTypeCase() == value}).count
            }
        
        MyFilterRow(
            allCases: AvailabilityMenu.allCases,
            filterProperty: $filterCore.filterProperties.rangeTemporaleMenu,
            selectionColor: Color.yellow.opacity(0.7),
            imageOrEmoji: "calendar.day.timeline.trailing",
            label: "Arco Temporale") { value in
                container.filter({$0.isAvaibleWhen == value}).count
            }
        
        MyFilterRow(
            allCases: GiorniDelServizio.allCases,
            filterProperty: $filterCore.filterProperties.giornoServizio,
            selectionColor: Color.blue,
            imageOrEmoji: "calendar",
            label: "Giorno della Settimana") { value in
                container.filter({$0.giorniDelServizio.contains(value)}).count
            }
        
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let isCloseRange:Bool = {
            self.filterCore.filterProperties.rangeTemporaleMenu == .intervalloChiuso
           // self.filterProperty.rangeTemporaleMenu == .intervalloChiuso
        }()
        
        let isMenuFisso: Bool = {
            
            self.filterCore.filterProperties.tipologiaMenu != nil &&
            self.filterCore.filterProperties.tipologiaMenu != .allaCarta()
            
          //  self.filterProperty.tipologiaMenu != nil &&
           // self.filterProperty.tipologiaMenu != .allaCarta()
        }()
        
        let color:Color = .seaTurtle_3
    

        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .alfabeticoDecrescente,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .dataInizio,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .dataFine,
            coloreScelta: color)
            .opacity(isCloseRange ? 1.0 : 0.5)
            .disabled(!isCloseRange)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .mostContaining,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .topRated,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .topPriced,
            coloreScelta: color)
            .opacity(isMenuFisso ? 1.0 : 0.5)
            .disabled(!isMenuFisso)
        
    }
    
    /*
    @ViewBuilder private func vbLocalSorterPop() -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Sort") {
             
            self.filterProperty.sortCondition = nil
                
            } content: {

                let isCloseRange:Bool = {
                    self.filterProperty.rangeTemporaleMenu == .intervalloChiuso                }()
                
                let isMenuFisso: Bool = {
                    self.filterProperty.tipologiaMenu != nil &&
                    self.filterProperty.tipologiaMenu != .allaCarta()
                }()
            
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .alfabeticoDecrescente)
                    
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .dataInizio)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .dataFine)
                    .opacity(isCloseRange ? 1.0 : 0.5)
                    .disabled(!isCloseRange)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .mostContaining)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .topRated)
                
                SortRow_Generic(sortCondition: $filterProperty.sortCondition, localSortCondition: .topPriced)
                    .opacity(isMenuFisso ? 1.0 : 0.5)
                    .disabled(!isMenuFisso)
                

            }
                
            
        }*/
    
    /*
    @ViewBuilder private func vbLocalFilterPop(container:[MenuModel]) -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {
                
               /* FilterRow_Generic(allCases: MenuModel.OnlineStatus.allCases, filterProperty: $filterProperty.onlineOfflineMenu, selectionColor: Color.cyan, imageOrEmoji: "face.dashed", label: "Programmazione Odierna") { value in
                    container.filter({$0.isOnAir(checkTimeRange: false)}).count
                }*/
                

               /* FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label:"Status"){ value in
                    container.filter({$0.status.checkStatusTransition(check: value)}).count
                } */
                
               /* FilterRow_Generic(allCases: TipologiaMenu.allCases, filterProperty: $filterProperty.tipologiaMenu, selectionColor: Color.brown, imageOrEmoji: "square.on.square.dashed", label: "Tipologia") { value in
                    container.filter({$0.tipologia.returnTypeCase() == value}).count
                } */
                
              /*  FilterRow_Generic(allCases: AvailabilityMenu.allCases, filterProperty: $filterProperty.rangeTemporaleMenu, selectionColor: Color.yellow.opacity(0.7), imageOrEmoji: "calendar.day.timeline.trailing", label: "Arco Temporale") { value in
                    container.filter({$0.isAvaibleWhen == value}).count
                } */

               /* FilterRow_Generic(allCases: GiorniDelServizio.allCases, filterProperty: $filterProperty.giornoServizio, selectionColor: Color.blue,imageOrEmoji: "calendar",label: "Giorno della Settimana"){ value in
                    container.filter({$0.giorniDelServizio.contains(value)}).count
                } */
          
                
              
                
            }
                
            
        }
*/
    
}
/*
struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView(tabSelection:.menuList, backgroundColorView: Color.seaTurtle_1)
            .environmentObject(testAccount)
    }
}*/



