//
//  MostraESelezionaIngredienti_SelettoreIngredienteSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct MostraESelezionaModel<M2:MyModelProtocol>: View {
        
        let listaAttiva: [M2]
        let caratteristicheModel: (_ model: M2) -> (colore: Color, image: String, isUsed: Bool)
        let action: (_ model: M2) -> Void

        var body: some View {
                
                ForEach(listaAttiva) { model in

                    vbManageGraficElement(model: model)
                    
                }.listRowSeparator(.hidden)
        }
    // Method
    
    @ViewBuilder func vbManageGraficElement(model:M2) -> some View {
        
        let (color,image,isAlreadyStored) = self.caratteristicheModel(model)
        
        VStack {
            
            HStack {
                
                Text(model.intestazione)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                
               Spacer()
                
                Image(systemName: image)
                    .imageScale(.large)
                    .foregroundColor(color)
                    .onTapGesture {
                        withAnimation {
                            self.action(model)
                        }
                    }
                }
                .opacity(isAlreadyStored ? 0.5 : 1.0)
                .disabled(isAlreadyStored)
                ._tightPadding()
            
            Divider()
               
            }
        }

    }


/*
struct MostraESelezionaIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        MostraESelezionaIngredienti()
    }
}
*/
