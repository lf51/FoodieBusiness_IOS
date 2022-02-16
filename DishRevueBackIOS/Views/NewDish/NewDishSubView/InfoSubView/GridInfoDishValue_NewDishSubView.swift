//
//  GridInfoDishValue_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct GridInfoDishValue_NewDishSubView:View {
    
    @Binding var activeDelection: Bool
    @Binding var showArrayData: [String]
    let baseColor: Color
    let action: (_ data: String) -> Void
    
   let gridColumns: [GridItem] = [
    
    GridItem(.adaptive(minimum: 100.0, maximum: .infinity), spacing: 0, alignment: .leading) // la lunghezza minima di 90 è arbitraria. Non vogliamo cmq metterla proporzionale perchè altrimenti su schermi enormi andrebbero lo stesso numero di elementi che su scehermi piccoli e non avrebbe senso. Al senso estetico, cmq, qui preferiamo la praticità essendo questa l'iterfaccia BUSINESS
    ]
    
    var body: some View {

// Rimpiazzato lo scroll con la lazyGrid.11.02.2022
        
            LazyVGrid(columns: gridColumns) {
                
                ForEach(showArrayData,id:\.self) { data in
                   
                    if !activeDelection {
                       
                       DishInfoRectangle(data:data,baseColor:baseColor)
                            
                            .onLongPressGesture {
                                withAnimation(.easeInOut) {
                                   //  action(data)
                                     self.activeDelection = true
                                     
                                 }
                            } // il longPressure va in conflitto con lo scroll. Lo scroll non funziona se ci poggiamo sui rettangoli, funziona se ci poggiamo sullo spazio vuoto. Il problema è quando lo spazio si esaurisce. Lo Scroll funziona col Tap, anche double.
                        
                    } else {
                        
                        DishInfoDeletableRectangle(data: data, baseColor: Color.gray)
                            .onTapGesture {
                                print("TAP TO DELETE")
                                withAnimation(.easeInOut) {
                                    self.action(data)
                                    
                                    if self.showArrayData.isEmpty {self.activeDelection = false }
                                  //  self.activeDelection = false
                                    // lasciamo volutamente aperta la facoltà di cancellare finchè non si tocca su un elemento fuori da quelli cancellabili
                                }
                            }
                    }
                }
            }
    }
}

/*struct GridInfoDishValue_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        GridInfoDishValue_NewDishSubView()
    }
}
*/
