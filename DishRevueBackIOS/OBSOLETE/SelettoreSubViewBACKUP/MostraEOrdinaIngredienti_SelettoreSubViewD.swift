//
//  MostraEOrdinaIngredienti_SelettoreSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

/* // BACKUP 10.05
struct MostraEOrdinaIngredientiD<M2:MyModelProtocol>: View {
        
        @Binding var listaAttiva: [M2]
        @Environment(\.editMode) var mode
        
        var body: some View {
                
            //VStack -> non lo inseriamo perchè non fa funzionare onMove e onDelete
                ForEach(listaAttiva) { model in

                    VStack {
                        HStack {
                                
                                Text(model.intestazione)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)

                                Spacer()
                        }
                        ._tightPadding()
                        Divider()
                    }
                
                }
                .onDelete(perform: removeFromList)
                .onMove(perform: makeOrder)
                .onAppear(perform: editActivation)
                .listRowSeparator(.hidden)
        }
        
        private func removeFromList(indexSet: IndexSet){
            
            self.listaAttiva.remove(atOffsets: indexSet)
            
        }
        
        private func makeOrder(from: IndexSet, to: Int) {
            
            self.listaAttiva.move(fromOffsets: from, toOffset: to)
        }
        
        private func editActivation() {
            
            self.mode?.wrappedValue = .active
            
        }
        
    } */
/*
struct MostraEOrdinaIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        MostraEOrdinaIngredienti()
    }
}
*/
