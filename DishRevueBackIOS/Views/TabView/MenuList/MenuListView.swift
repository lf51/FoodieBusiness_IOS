//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct MenuListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // non usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var openSort: Bool = false
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.menuListPath) {
            
            CSZStackVB(title: "I Miei Menu", backgroundColorView: backgroundColorView) {
                    
              /*  ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allMenuMapCategory)*/ // STAND-BY 16.09
                
                // Temporaneo
                
               /* VStack {
                    
                    CSDivider()
                    
                    ScrollView(showsIndicators:false) {
                        ForEach(viewModel.allMyMenu) { menu in
                            
                            
                            GenericItemModel_RowViewMask(model: menu) {
                                
                                menu.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.menuListPath)
                                
                              //  if !menu.tipologia.isDiSistema() {
                                    vbMenuInterattivoModuloCambioStatus(myModel: menu,viewModel: viewModel)
                                    
                                    vbMenuInterattivoModuloEdit(currentModel: menu, viewModel: viewModel, navPath: \.menuListPath)
                              //  }
    
                                vbMenuInterattivoModuloTrash(currentModel: menu, viewModel: viewModel)
                            }
                            
                        }
                    }
                    CSDivider()
                } */
                
                // fine temporaneo
                let container = self.viewModel.filtraERicerca(containerPath: \.allMyMenu, filterProperty: filterProperty)
                
                BodyListe_Generic(filterString: $filterProperty.stringaRicerca, container: container, navigationPath: \.menuListPath)
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
                        //    self.viewModel.menuListPath.append(MenuModel())
                            self.viewModel.menuListPath.append(DestinationPathView.menu(MenuModel()))
                        }

                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    let sortActive = self.filterProperty.sortCondition != nil
                    
                    FilterButton(open: $openFilter, openSort: $openSort, filterCount: filterProperty.countChange,sortActive: sortActive)
                        
                }
                
            }
          /*  .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(400)])
          
            } */

        }
    }
    
    // Method
    
    @ViewBuilder private func vbLocalSorterPop() -> some View {
     
        FilterAndSort_RowContainer(backgroundColorView: backgroundColorView, label: "Sort") {
             
            self.filterProperty.sortCondition = nil
                
            } content: {

                let isCloseRange:Bool = {
                    self.filterProperty.rangeTemporaleMenu == .intervalloChiuso                }()
                
                let isMenuFisso: Bool = {
                    self.filterProperty.tipologiaMenu != nil &&
                    self.filterProperty.tipologiaMenu != .allaCarta
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


                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed",label:"Status"){ value in
                    container.filter({$0.status.checkStatusTransition(check: value)}).count
                }
                
                FilterRow_Generic(allCases: TipologiaMenu.allCases, filterProperty: $filterProperty.tipologiaMenu, selectionColor: Color.brown, imageOrEmoji: "circle", label: "Tipologia") { value in
                    container.filter({$0.tipologia.returnTypeCase() == value}).count
                }
                
                FilterRow_Generic(allCases: AvailabilityMenu.allCases, filterProperty: $filterProperty.rangeTemporaleMenu, selectionColor: Color.yellow.opacity(0.7), imageOrEmoji: "circle", label: "Arco Temporale") { value in
                    container.filter({$0.isAvaibleWhen == value}).count
                }

                FilterRow_Generic(allCases: GiorniDelServizio.allCases, filterProperty: $filterProperty.giornoServizio, selectionColor: Color.blue,imageOrEmoji: "calendar",label: "Giorno della Settimana"){ value in
                    container.filter({$0.giorniDelServizio.contains(value)}).count
                }
          
                
              
                
            }
                
            
        }

    
}


struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView(tabSelection: .constant(3), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}



