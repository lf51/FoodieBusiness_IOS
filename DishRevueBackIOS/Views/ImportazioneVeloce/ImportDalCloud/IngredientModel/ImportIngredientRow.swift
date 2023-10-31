//
//  ImportIngredientRow.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/10/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct ImportIngredientRow: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var importVM:CloudImportGenericViewModel<IngredientModel>
    
    let ingredient:IngredientModel
   // let selectingAction:(_ isSelected:Bool) -> ()
    
    var body: some View {
        
        let isAlreadySelected:Bool = {
            self.importVM.selectedContainer?.contains(ingredient) ?? false
        }()
        
        let alreadyImported = self.viewModel.isTheModelAlreadyExist(modelID: ingredient.id, path: \.db.allMyIngredients)
        
        let image:(name:String,color:Color) = {
           
            if alreadyImported {
                return ("checkmark.circle.fill",Color.seaTurtle_1)
            }
            
            if isAlreadySelected {
                return ("checkmark.circle.fill",Color.green)
            }
             else {
                return ("icloud.and.arrow.down",Color.seaTurtle_4)
            }
            
        }()

        IngredientModel_RowView(
           item: ingredient,
           rowSize: .fromSharedLibrary)
         .opacity(isAlreadySelected ? 1.0 : 0.6)
         .overlay(alignment: .topTrailing, content: {
             
             Image(systemName: image.name)
                 .imageScale(.large)
                 .foregroundStyle(image.color)
                 .opacity(alreadyImported ? 0.5 : 1.0)
                 .padding([.trailing,.top],5)
         })
            
            .onTapGesture {
                //selectingAction(isAlreadySelected)
                withAnimation {
                    self.importVM.selectingLogic(isAlreadySelect: isAlreadySelected, selected: ingredient)
                }
            }
            .disabled(alreadyImported)

    }
}
