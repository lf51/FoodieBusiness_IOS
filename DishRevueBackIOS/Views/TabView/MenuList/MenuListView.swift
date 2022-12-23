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
    
    @Binding var tabSelection: Int // non usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var openSort: Bool = false
   // @State private var mapObject: MapObject<MenuModel,TipologiaMenu>?
    @State private var mapTree: MapTree<MenuModel,TipologiaMenu>?
                                                
    @State private var filterProperty:MenuModel.FilterProperty = MenuModel.FilterProperty()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.menuListPath) {
            
            let container = self.viewModel.ricercaFiltra(containerPath: \.allMyMenu, filterProperties: filterProperty)
            
            FiltrableContainerView(
                backgroundColorView: backgroundColorView,
                title: "I Miei Menu",
                filterProperties: $filterProperty,
                placeHolderBarraRicerca: "Cerca per Nome e/o Piatto",
                buttonColor: CatalogoColori.seaTurtle_3.color()) {
                    self.thirdButtonAction()
                } content: {
                   
                    BodyListe_Generic(
                        container: container,
                        mapTree: mapTree,
                        navigationPath: \.menuListPath)
                    
                } trailingView: {
                    self.vbTrailing()
                } filterView: {
                    self.vbFilterView(container: container)
                } sorterView: {
                    self.vbSorterView()
                }

            
            
            
            
            
            
          /*  CSZStackVB(title: "I Miei Menu", backgroundColorView: backgroundColorView) {
                    
                let container = self.viewModel.filtraERicerca(containerPath: \.allMyMenu, filterProperty: filterProperty)
                
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container: container,mapObject: mapObject, navigationPath: \.menuListPath)
                    .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                        vbLocalFilterPop(container: container)
                            .presentationDetents([.height(600)])
                  
                    }
                    .popover(isPresented: $openSort, attachmentAnchor: .point(.top)) {
                        vbLocalSorterPop()
                            .presentationDetents([.height(400)])
                    }
                
            } */
        .navigationDestination(for: DestinationPathView.self, destination: { destination in
            destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .menuList, readOnlyViewModel: viewModel)
         })
          /*  .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Menu",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                   
                            self.viewModel.menuListPath.append(DestinationPathView.menu(MenuModel()))
                        }

                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    let sortActive = self.filterProperty.sortCondition != nil
            
                    FilterSortMap_Bar(open: $openFilter, openSort: $openSort, filterCount: filterProperty.countChange,sortActive: sortActive) {
                        thirdButtonAction()
                    }
                        
                        
                }
                
            }*/
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: TipologiaMenu.allCases,
                kpPropertyInObject: \MenuModel.tipologia.id)
            
        } else {
            
            self.mapTree = nil
        }
    }

    @ViewBuilder private func vbTrailing() -> some View {
        
        LargeBar_TextPlusButton(
            buttonTitle: "Nuovo Menu",
            font: .callout,
            imageBack: CatalogoColori.seaTurtle_2.color(),
            imageFore: Color.white) {
                self.viewModel.menuListPath.append(DestinationPathView.menu(MenuModel()))
            }
    }
    
    @ViewBuilder private func vbFilterView(container:[MenuModel]) -> some View {
        
        MyFilterRow(
            allCases: MenuModel.OnlineStatus.allCases,
            filterProperty: $filterProperty.onlineOfflineMenu,
            selectionColor: Color.cyan,
            imageOrEmoji: "face.dashed",
            label: "Programmazione Odierna") { value in
                container.filter({$0.isOnAir(checkTimeRange: false)}).count
            }
        
        MyFilterRow(
            allCases: StatusTransition.allCases,
            filterCollection: $filterProperty.status,
            selectionColor: Color.mint.opacity(0.8),
            imageOrEmoji: "circle.dashed",
            label: "Status") { value in
                container.filter({$0.status.checkStatusTransition(check: value)}).count
            }
        
        MyFilterRow(
            allCases: TipologiaMenu.allCases,
            filterProperty: $filterProperty.tipologiaMenu,
            selectionColor: Color.brown,
            imageOrEmoji: "square.on.square.dashed",
            label: "Tipologia") { value in
                container.filter({$0.tipologia.returnTypeCase() == value}).count
            }
        
        MyFilterRow(
            allCases: AvailabilityMenu.allCases,
            filterProperty: $filterProperty.rangeTemporaleMenu,
            selectionColor: Color.yellow.opacity(0.7),
            imageOrEmoji: "calendar.day.timeline.trailing",
            label: "Arco Temporale") { value in
                container.filter({$0.isAvaibleWhen == value}).count
            }
        
        MyFilterRow(
            allCases: GiorniDelServizio.allCases,
            filterProperty: $filterProperty.giornoServizio,
            selectionColor: Color.blue,
            imageOrEmoji: "calendar",
            label: "Giorno della Settimana") { value in
                container.filter({$0.giorniDelServizio.contains(value)}).count
            }
        
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let isCloseRange:Bool = {
            self.filterProperty.rangeTemporaleMenu == .intervalloChiuso
        }()
        
        let isMenuFisso: Bool = {
            self.filterProperty.tipologiaMenu != nil &&
            self.filterProperty.tipologiaMenu != .allaCarta()
        }()
        
        let color = CatalogoColori.seaTurtle_3.color()
    
        MySortRow(
            sortCondition: $filterProperty.sortCondition,
            localSortCondition: .alfabeticoDecrescente,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterProperty.sortCondition,
            localSortCondition: .dataInizio,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterProperty.sortCondition,
            localSortCondition: .dataFine,
            coloreScelta: color)
            .opacity(isCloseRange ? 1.0 : 0.5)
            .disabled(!isCloseRange)
        
        MySortRow(
            sortCondition: $filterProperty.sortCondition,
            localSortCondition: .mostContaining,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterProperty.sortCondition,
            localSortCondition: .topRated,
            coloreScelta: color)
        
        MySortRow(
            sortCondition: $filterProperty.sortCondition,
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
struct MenuListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // non usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var openSort: Bool = false
    @State private var mapObject: MapObject<MenuModel,TipologiaMenu>?
                                                
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.menuListPath) {
            
            CSZStackVB(title: "I Miei Menu", backgroundColorView: backgroundColorView) {
                    
                let container = self.viewModel.filtraERicerca(containerPath: \.allMyMenu, filterProperty: filterProperty)
                
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container: container,mapObject: mapObject, navigationPath: \.menuListPath)
                    .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                        vbLocalFilterPop(container: container)
                            .presentationDetents([.height(600)])
                  
                    }
                    .popover(isPresented: $openSort, attachmentAnchor: .point(.top)) {
                        vbLocalSorterPop()
                            .presentationDetents([.height(400)])
                    }
                
            }
        .navigationDestination(for: DestinationPathView.self, destination: { destination in
            destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .menuList, readOnlyViewModel: viewModel)
         })
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Menu",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                   
                            self.viewModel.menuListPath.append(DestinationPathView.menu(MenuModel()))
                        }

                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    let sortActive = self.filterProperty.sortCondition != nil
            
                    FilterSortMap_Bar(open: $openFilter, openSort: $openSort, filterCount: filterProperty.countChange,sortActive: sortActive) {
                        thirdButtonAction()
                    }
                        
                        
                }
                
            }
        }
    }
    
    // Method
    
    private func thirdButtonAction() {
        
        if mapObject == nil {
            
            self.mapObject = MapObject(
                mapCategory: TipologiaMenu.allCases,
                kpMapCategory: \MenuModel.tipologia.id)
            
        } else {
            
            self.mapObject = nil
        }
    }
    
    
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
                
            
        }
    
    @ViewBuilder private func vbLocalFilterPop(container:[MenuModel]) -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Filtri") {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {
                
                FilterRow_Generic(allCases: MenuModel.OnlineStatus.allCases, filterProperty: $filterProperty.onlineOfflineMenu, selectionColor: Color.cyan, imageOrEmoji: "face.dashed", label: "Programmazione Odierna") { value in
                    container.filter({$0.isOnAir(checkTimeRange: false)}).count
                }
                

                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label:"Status"){ value in
                    container.filter({$0.status.checkStatusTransition(check: value)}).count
                }
                
                FilterRow_Generic(allCases: TipologiaMenu.allCases, filterProperty: $filterProperty.tipologiaMenu, selectionColor: Color.brown, imageOrEmoji: "square.on.square.dashed", label: "Tipologia") { value in
                    container.filter({$0.tipologia.returnTypeCase() == value}).count
                }
                
                FilterRow_Generic(allCases: AvailabilityMenu.allCases, filterProperty: $filterProperty.rangeTemporaleMenu, selectionColor: Color.yellow.opacity(0.7), imageOrEmoji: "calendar.day.timeline.trailing", label: "Arco Temporale") { value in
                    container.filter({$0.isAvaibleWhen == value}).count
                }

                FilterRow_Generic(allCases: GiorniDelServizio.allCases, filterProperty: $filterProperty.giornoServizio, selectionColor: Color.blue,imageOrEmoji: "calendar",label: "Giorno della Settimana"){ value in
                    container.filter({$0.giorniDelServizio.contains(value)}).count
                }
          
                
              
                
            }
                
            
        }

    
} */ //BackUp 22.12


struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView(tabSelection: .constant(3), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}



