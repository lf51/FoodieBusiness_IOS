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
                
                BodyListe_Generic(filterProperty: $filterProperty, containerKP: \.allMyMenu, navigationPath: \.menuListPath)
                
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
                    
                    FilterButton(open: $openFilter, filterCount: filterProperty.countChange)
                    
                }
                
            }
            .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(400)])
          
            }

        }
    }
    
    // Method
    @ViewBuilder private func vbLocalFilterPop() -> some View {
     
            FilterRowContainer(backgroundColorView: backgroundColorView) {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {


                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed")
    
                FilterRow_Generic(allCases: GiorniDelServizio.allCases, filterProperty: $filterProperty.giornoServizio, selectionColor: Color.blue,imageOrEmoji: "calendar")
          
                
              
                
            }
                
            
        }

    
}


struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView(tabSelection: .constant(3), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}



