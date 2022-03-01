//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct BottonBar_NewDishSubView: View {
    
    @ObservedObject var dishVM: DishVM
    @Binding var newDish: DishModel
    @Binding var openProgrammaEPubblica: Bool
    
    var body: some View {
        
        HStack {
            
            CSButton_2(title: "Salva Bozza", accentColor: Color.white, backgroundColor: Color.red.opacity(0.8), cornerRadius: 5.0) {
                
                print("SVILUPPARE FUNZIONI BOTTONE")
                dishVM.createNewOrEditOldDish(dish: self.newDish)
                self.newDish.type.mantieniUltimaScelta()
                self.newDish = DishModel()
                
            }
            
            Spacer()
            
            CSButton_2(title: "Pubblica", accentColor: Color.white, backgroundColor: Color.green.opacity(0.8), cornerRadius: 5.0) {
                
                self.openProgrammaEPubblica = true
                print("Pubblica Piatto")
            }
            
        }
        
    }
}
