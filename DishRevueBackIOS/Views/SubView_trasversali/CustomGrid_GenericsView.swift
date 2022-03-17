//
//  GridInfoDishValue_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct CustomGrid_GenericsView<R:CustomGridAvaible>:View {
    
  //  @Binding var openEditingIngrediente: Bool
    @Binding var wannaDeleteItem: Bool?
    @Binding var genericDataToShow: [R]
    let baseColor: Color
  //  let action: (_ data: R) -> Void
    
   let gridColumns: [GridItem] = [
    
    GridItem(.adaptive(minimum: 100.0, maximum: .infinity), spacing: 0, alignment: .leading) // la lunghezza minima di 90 è arbitraria. Non vogliamo cmq metterla proporzionale perchè altrimenti su schermi enormi andrebbero lo stesso numero di elementi che su scehermi piccoli e non avrebbe senso. Al senso estetico, cmq, qui preferiamo la praticità essendo questa l'iterfaccia BUSINESS
    ]
    
    var body: some View {

// Rimpiazzato lo scroll con la lazyGrid.11.02.2022
        
            LazyVGrid(columns: gridColumns) { // la lazyGrid non visualizza elementi duplicati, ma nel debug mi informa che ci sono id duplicati. Blocchiamo l'inserimento di duplicati a monte dove modifichiamo l'array
                
                ForEach(genericDataToShow) { data in
                   
                    if !wannaDeleteItem! {
           
                       CSText_RotatingRectangleStaticFace(testo: data.intestazione, fontWeight: .bold, textColor: Color.white, scaleFactor: 0.6, strokeColor: Color.blue, fillColor: baseColor, topTrailingImage: "flame.fill")
                           /* .onTapGesture(count: 2, perform: {
                                self.openEditingIngrediente = true 
                            }).disabled(self.wannaDeleteIngredient)*/
                            .onLongPressGesture {
                                withAnimation(.easeInOut) {
                                   //  action(data)
                                     self.wannaDeleteItem = true
                                     
                                 }
                            }//.disabled(self.openEditingIngrediente)
                        // il longPressure va in conflitto con lo scroll. Lo scroll non funziona se ci poggiamo sui rettangoli, funziona se ci poggiamo sullo spazio vuoto. Il problema è quando lo spazio si esaurisce. Lo Scroll funziona col Tap, anche double.
                        
                        
                        
                    } else {
                        
                        CSText_RotatingRectangleDynamicDeletingFace(testo: data.intestazione, fontWeight: .bold, textColor: Color.white, scaleFactor: 0.6, strokeColor: Color.blue, fillColor: Color.gray, showDeleteImage: true)
                            .onTapGesture {
                                print("TAP TO DELETE Item")
                                withAnimation(.easeInOut) {
                                    
                                    self.removeGenericItem(item: data)
                                    
                                    if self.genericDataToShow.isEmpty {self.wannaDeleteItem = false }
                                  //  self.wannaDeleteIngredient = false
                                    // lasciamo volutamente aperta la facoltà di cancellare finchè non si tocca su un elemento fuori da quelli cancellabili
                                }
                            }
                    }
                }
            }
    }
    
    private func removeGenericItem(item: R) {
         
        let positionIndex = self.genericDataToShow.firstIndex(of: item)
         
        self.genericDataToShow.remove(at: positionIndex!)
         
     }
    
}

/*struct GridInfoDishValue_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        GridInfoDishValue_NewDishSubView()
    }
}
*/
