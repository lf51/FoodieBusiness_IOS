//
//  MostraESelezionaIngredienti_SelettoreIngredienteSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct MostraESelezionaIngredienti: View {
        
        var listaAttiva: [ModelloIngrediente]
        let attributeIngredient: (_ ingredient: ModelloIngrediente) -> (colore: Color,image: String, isUsed: Bool)
        let action: (_ ingredient: ModelloIngrediente) -> Void
     
        var body: some View {
                
                ForEach(listaAttiva) { ingrediente in

                    VStack {
                        
                        HStack {
                            
                            Text(ingrediente.nome)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                  //  .minimumScaleFactor(0.7) -> Tolto perchè lo scala sempre

                           Spacer()
                            
                            Image(systemName: self.attributeIngredient(ingrediente).image)
                                .imageScale(.large)
                                .foregroundColor(self.attributeIngredient(ingrediente).colore)
                                .onTapGesture {
                                    
                                    withAnimation {
                                        action(ingrediente)
                                    }
                                }
                        }
                        .opacity(self.attributeIngredient(ingrediente).isUsed ? 0.5 : 1.0)
                        .disabled(self.attributeIngredient(ingrediente).isUsed)
                        ._tightPadding()
                        
                        Divider()
                           
                    }

                }.listRowSeparator(.hidden)
        }
    }
/*
struct MostraESelezionaIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        MostraESelezionaIngredienti()
    }
}
*/
