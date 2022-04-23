//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct BottonBar_NewDishSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var newDish: DishModel
    @Binding var wannaProgramAndPublishNewDish: Bool
    
    var body: some View {
        
        HStack {
            
            CSButton_large(title: "Salva Bozza", accentColor: Color.white, backgroundColor: Color.red.opacity(0.8), cornerRadius: 5.0) {
                
                print("SVILUPPARE FUNZIONI BOTTONE")
              //  accounterVM.createNewOrEditOldDish(dish: self.newDish)
                viewModel.createOrEditItemModel(itemModel: self.newDish)
                self.newDish.categoria.mantieniUltimaScelta() // mette l'ultima type utilizzata come default per il prox piatto
                self.newDish = DishModel() // inizializza un piatto nuovo
                
            }
            
            Spacer()
            
            CSButton_large(title: "Pubblica", accentColor: Color.white, backgroundColor: Color.green.opacity(0.8), cornerRadius: 5.0) {
                
                self.wannaProgramAndPublishNewDish = true
                print("Pubblica Piatto")
            }
            
        }
        
    }
}
