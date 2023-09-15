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
    
    let category:CategoriaMenu
    let importImage:String
    @Binding var focusCategory:CategoriaMenu?
    let addingAction:() -> ()
    
    var body: some View {
        
        let focusCheck:Bool = self.focusCategory?.id == category.id
        let alreadyExist = self.viewModel.isTheModelAlreadyExist(modelID: category.id, path: \.db.allMyCategories)
        
        VStack(alignment:.leading) {
            
            HStack(spacing:10) {
                
                Text(focusCheck ? focusCategory?.image ?? category.image : category.image)
                    .font(.largeTitle)
                    .opacity(alreadyExist ? 0.3 : 1.0)
                Text(category.intestazione)
                    .font(.largeTitle)
                    .foregroundStyle(Color.seaTurtle_4)
                    .opacity(alreadyExist ? 0.3 : 1.0)
                Spacer()
                
                if focusCheck {
                    
                    CSButton_image(
                        frontImage: importImage,
                        imageScale: .large,
                        frontColor: .seaTurtle_4
                        ) {
                          // addNewCategory()
                            
                                addingAction()
                            
                        }
                }
                    
            }
        }
        .padding(.vertical,10)
        .csHpadding()
        .background {
            Color.seaTurtle_3
                .cornerRadius(5.0)
                .opacity(focusCheck ? 0.6 : 0.1)
        }
        .onTapGesture {
            withAnimation{
                self.focusCategory = category
            }
        }
        .disabled(alreadyExist)
        
        
        
    }
}
/*
#Preview {
    ImportCategoryRow()
}*/
