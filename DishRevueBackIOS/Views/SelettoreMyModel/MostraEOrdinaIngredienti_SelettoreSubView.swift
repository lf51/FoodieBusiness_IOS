//
//  MostraEOrdinaIngredienti_SelettoreSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct MostraEOrdinaModel<M2:MyModelProtocol>: View {
    
    @Environment(\.editMode) var mode
    
    @Binding var listaAttiva: [M2]
   
  /*  init(listaAttiva: Binding<[M2]>) {
        
        _listaAttiva = listaAttiva
        
      //  editActivation()
        print("Init MostraEOrdina")
        
    } */
    
        var body: some View {
                
            //VStack -> non lo inseriamo perchè non fa funzionare onMove e onDelete

            VStack(alignment:.trailing) {
                
                Text(self.mode?.wrappedValue != .active ? "Edit View" : "Indietro")
                    .foregroundColor(Color.blue)
                    .padding(.trailing)
                    .onTapGesture {
                        editActivation()
                    }
                
                List {
                    
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
                 //   .onAppear{editActivation()} //18.05.2022 -> non performante. Ha bisogno di tempo per darmi quello che voglio. Da Ottimizzare.
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                
                
                
            }
            
                
                
                
        }
        
        private func removeFromList(indexSet: IndexSet){
                
                self.listaAttiva.remove(atOffsets: indexSet)
            
        }
        
        private func makeOrder(from: IndexSet, to: Int) {

                self.listaAttiva.move(fromOffsets: from, toOffset: to)
        }
        
        private func editActivation() {
        
        self.mode?.wrappedValue = self.mode?.wrappedValue == .active ? .inactive : .active
         //   self.mode?.wrappedValue = .active
      
        }
        
    }
/*
struct MostraEOrdinaIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        MostraEOrdinaIngredienti()
    }
}
*/
