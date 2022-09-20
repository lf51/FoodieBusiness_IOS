//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct MenuListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var tabSelection: Int
    let backgroundColorView: Color
    
  //  @State private var openCreateNewMenu: Bool = false
    
    var body: some View {
        
        NavigationStack(path:$viewModel.menuListPath) {
            
            CSZStackVB(title: "I Miei Menu", backgroundColorView: backgroundColorView) {
                    
              /*  ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allMenuMapCategory)*/ // STAND-BY 16.09
                
                // Temporaneo
                
                VStack {
                    
                    CSDivider()
                    
                    ScrollView {
                        ForEach($viewModel.allMyMenu) { $menu in
                            
                            
                            GenericItemModel_RowViewMask(model: menu) {
                              /*  vbMenuInterattivoModuloCambioStatus(myModel: $menu, viewModel: viewModel, navPath: \.menuListPath)
                                
                                vbMenuInterattivoModuloTrashEdit(currentModel: menu, viewModel: viewModel, navPath: \.menuListPath)
                                
                                menu.customInteractiveMenu(viewModel: viewModel, navigationPath: \.menuListPath) */
                            }
                            
                        }
                    }
                    
                }
                
                // fine temporaneo
                
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
                
                
            }
           /* .navigationBarItems(
                trailing:
             
                    NavigationLink(destination: {
                        NuovoMenuMainView(backgroundColorView: backgroundColorView)
                    }, label: {
                        LargeBar_Text(title: "Nuovo Menu", font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white)
                    })
                    
                    
                   /* LargeBar_TextPlusButton(buttonTitle: "Nuovo Menu", font: .callout, imageBack: Color.mint, imageFore: Color.white) {
                        self.openCreateNewMenu.toggle()
                    } */
                ) */
          /*  .fullScreenCover(isPresented: self.$openCreateNewMenu, content: {
                NuovoMenuMainView(backgroundColorView: backgroundColorView)
            }) */
        }//.navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Method


    
}

/*
struct DisheListView_Previews: PreviewProvider {
    static var previews: some View {
        DishListView(accounterVM: AccounterVM(), tabSelection: .constant(2), backgroundColorView: Color.cyan)
    }
}
*/


