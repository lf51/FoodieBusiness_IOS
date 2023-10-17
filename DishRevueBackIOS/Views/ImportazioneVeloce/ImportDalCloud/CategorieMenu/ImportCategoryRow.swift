//
//  ImportCategoryRow.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/09/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/// Row comune ai moduli di importazione, manuale e dal web delle categorieMenu
struct ImportCategoryRow: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var importVM:CloudImportGenericViewModel<CategoriaMenu>
    
    let category:CategoriaMenu
   // let selectingAction:(_ isSelected:Bool) -> ()
    
    var body: some View {
        
        let isAlreadySelected:Bool = {
            self.importVM.selectedContainer?.contains(category) ?? false
        }()
        
        let alreadyImported = self.viewModel.isTheModelAlreadyExist(modelID: category.id, path: \.db.allMyCategories)
        
        let image:(name:String,color:Color) = {
           
            if isAlreadySelected || alreadyImported {
                return ("checkmark.circle.fill",Color.seaTurtle_1)
            } else {
                return ("icloud.and.arrow.down",Color.seaTurtle_4)
            }
            
        }()

            HStack(spacing:10) {
                
                Text(category.image)
                    .font(.largeTitle)
                    .opacity(alreadyImported ? 0.3 : 1.0)
                Text(category.intestazione)
                    .font(.largeTitle)
                    .foregroundStyle(Color.seaTurtle_4)
                    .opacity(alreadyImported ? 0.3 : 1.0)
                
                Spacer()
                
                Image(systemName: image.name)
                    .imageScale(.large)
                    .foregroundStyle(image.color)
                    .opacity(alreadyImported ? 0.3 : 1.0)

            }
            .padding(.vertical,10)
            .csHpadding()
            .background {
            Color.seaTurtle_3
                .cornerRadius(5.0)
                .opacity(isAlreadySelected ? 0.6 : 0.1)
            }
            .onTapGesture {
               // selectingAction(isAlreadySelected)
                withAnimation {
                    self.importVM.selectingLogic(isAlreadySelect: isAlreadySelected, selected: category)
                }
            }
            .disabled(alreadyImported)
    
        
        
        
    }
}
/*
#Preview {
    ImportCategoryRow()
}*/
