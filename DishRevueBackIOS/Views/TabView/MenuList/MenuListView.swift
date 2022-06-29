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
                    
                ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allMenuMapCategory)
            }
            .navigationDestination(for: MenuModel.self, destination: { menu in
                NuovoMenuMainView(nuovoMenu: menu, backgroundColorView: backgroundColorView)
            })
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Menu",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                            self.viewModel.menuListPath.append(MenuModel())
                        }
                    
                    
                  /*  NavigationLink {
                        NuovoMenuMainView(backgroundColorView: backgroundColorView)
                    } label: {
                        LargeBar_Text(title: "Nuovo Menu", font: .callout, imageBack: Color("SeaTurtlePalette_2"), imageFore: Color.white)
                    } */

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
}

/*
struct DisheListView_Previews: PreviewProvider {
    static var previews: some View {
        DishListView(accounterVM: AccounterVM(), tabSelection: .constant(2), backgroundColorView: Color.cyan)
    }
}
*/
