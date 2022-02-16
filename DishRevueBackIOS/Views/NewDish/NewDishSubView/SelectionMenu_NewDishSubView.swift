//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct SelectionMenu_NewDishSubView: View {
    
    @Binding var newDish: DishModel
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_1(placeHolder: "Tipologia", imageName: "list.dash", backgroundColor: Color.brown)
            
            EnumScrollCases(cases: DishType.allCases, dishSingleProperty: self.$newDish.type, colorSelection: Color.green)
          
            
            CSLabel_1(placeHolder: "Base", imageName: "lanyardcard", backgroundColor: Color.brown)
            
            EnumScrollCases(cases: DishBase.allCases, dishSingleProperty: self.$newDish.aBaseDi, colorSelection: Color.blue)
            
 
            CSLabel_1(placeHolder: "Cottura", imageName: "flame", backgroundColor: Color.brown)
            
            EnumScrollCases(cases: DishCookingMethod.allCases, dishSingleProperty: self.$newDish.metodoCottura, colorSelection: Color.orange)
            

            CSLabel_1(placeHolder: "Avaible for", imageName: "person.fill.checkmark", backgroundColor: Color.brown)
            
            EnumScrollCases(cases: DishCategory.allCases, dishCollectionProperty: self.$newDish.category, colorSelection: Color.yellow)
     
            
            CSLabel_1(placeHolder: "Presenza Allergeni", imageName: "exclamationmark.triangle", backgroundColor: Color.brown)
            
            EnumScrollCases(cases: Allergeni.allCases, dishCollectionProperty: self.$newDish.allergeni, colorSelection: Color.red)
            
        }.padding(.horizontal)
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
