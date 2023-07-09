//
//  MostraEOrdinaIngredienti_SelettoreSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI
import MyFoodiePackage
/*
/// Add 25.08 - Invece di un arrray M2 prende un array di String. Probabilmente dovremmo ritornarla generica per poter usare l'id di modelli diversi. Attualmente tarato per l'ingredient Model.
struct MostraEOrdinaModelIDGeneric<M2:MyProStarterPack_L1>: View /*where M2.VM == AccounterVM*/ {
 
    // M2 passa da MyModelProtocol a MyProStarterPackL1
    
    @Environment(\.editMode) var mode
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var listaId: [String]
    
    var body: some View {

            VStack(alignment:.trailing) {
                
                Text(self.mode?.wrappedValue != .active ? "Edit View" : "Indietro")
                    .foregroundColor(Color.blue)
                    .padding(.trailing)
                    .onTapGesture {
                        editActivation()
                    }
                
                List {
                    
                    ForEach(listaId, id:\.self) { idModel in

                       /* if let model = self.viewModel.modelFromId(id: idModel, modelPath: M2.basicModelInfoTypeAccess()) {
                            
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
                            
                        } */
                    }
                    .onDelete(perform: removeFromList)
                    .onMove(perform: makeOrder)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
   
            }
        }
        
        private func removeFromList(indexSet: IndexSet){
                
                self.listaId.remove(atOffsets: indexSet)
            
        }
        
        private func makeOrder(from: IndexSet, to: Int) {

                self.listaId.move(fromOffsets: from, toOffset: to)
        }
        
        private func editActivation() {
        
        self.mode?.wrappedValue = self.mode?.wrappedValue == .active ? .inactive : .active
         //   self.mode?.wrappedValue = .active
      
        }
        
    }





struct MostraEOrdinaModelGeneric<M2:MyProStarterPack_L1>: View {
    
    // M2 passa da MyModelProtocol a MyProStarterPackL1
    
    @Environment(\.editMode) var mode
    @Binding var listaAttiva: [M2]
    
    var body: some View {

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
        
    } */
/*
struct MostraEOrdinaIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        MostraEOrdinaIngredienti()
    }
}
*/
