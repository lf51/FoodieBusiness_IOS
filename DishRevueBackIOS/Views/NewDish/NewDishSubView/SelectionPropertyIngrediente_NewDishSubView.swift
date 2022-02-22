//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct SelectionPropertyIngrediente_NewDishSubView: View {
    
    @Binding var newDish: DishModel
    
    @State private var creaNuovaCottura: Bool? = false
    @State private var nuovaCottura: String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
        
                CSLabel_1(placeHolder: "Metodo di cottura", imageName: "flame", backgroundColor: Color.black, toggleBottone: $creaNuovaCottura)
                
                    if !(creaNuovaCottura ?? false) {
                        
                        EnumScrollCases(cases: DishCookingMethod.allCases, dishSingleProperty: self.$newDish.metodoCottura, colorSelection: Color.orange)
                    
                    } else {
                        
                        CSTextField_3(textFieldItem: $nuovaCottura, placeHolder: "Aggiungi Metodo di Cottura") {
                            
                            DishCookingMethod.allCases.insert(.metodoCustom(nuovaCottura), at: 1) // 1 per tenere sempre il Crudo come Prima Scelta
                            self.nuovaCottura = ""
                            self.creaNuovaCottura = false
                            
                        }
                    }
         
        }.padding(.horizontal)
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
