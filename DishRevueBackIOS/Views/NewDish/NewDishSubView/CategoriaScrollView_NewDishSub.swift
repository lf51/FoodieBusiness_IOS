//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct CategoriaScrollView_NewDishSub: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var newDish: DishModel
    let generalErrorCheck: Bool
    
    var body: some View {
                
        VStack(alignment: .leading) {
            
            CSLabel_conVB(placeHolder: "Categoria Menu", imageNameOrEmojy: "list.bullet.below.rectangle", backgroundColor: Color.black) {
                
                HStack {
                    
                    NavigationLink(value: DestinationPathView.categoriaMenu) {
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.large)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                    }
                    
                   /* CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.categoriaMenuDEPRECATA == .defaultValue) */
                    CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.categoriaMenu.isEmpty)
                }
                
            }

            // Mod 13.09
            
            PropertyScrollCases_Rif(cases:viewModel.allMyCategories, dishSingleProperty: self.$newDish.categoriaMenu, colorSelection: Color.green.opacity(0.8))
                .padding(.top,5)
            
               /* PropertyScrollCases(cases:viewModel.categoriaMenuAllCases, dishSingleProperty: self.$newDish.categoriaMenuDEPRECATA, colorSelection: Color.green.opacity(0.8))
                    .padding(.top,5) */

            // end 13.09
        }
        
    }
    
    
}

