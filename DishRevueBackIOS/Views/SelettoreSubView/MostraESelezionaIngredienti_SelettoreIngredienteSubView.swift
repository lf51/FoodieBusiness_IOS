//
//  MostraESelezionaIngredienti_SelettoreIngredienteSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct MostraESelezionaIngredienti<M2:MyModelProtocol>: View {
        
        var listaAttiva: [M2]
        let caratteristicheModel: (_ ingredient: M2) -> (colore: Color, image: String, isUsed: Bool)
        let action: (_ ingredient: M2) -> Void
     
        var body: some View {
                
                ForEach(listaAttiva) { model in

                    VStack {
                        
                        HStack {
                            
                            Text(model.intestazione)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                  //  .minimumScaleFactor(0.7) -> Tolto perchè lo scala sempre

                           Spacer()
                            
                            Image(systemName: self.caratteristicheModel(model).image)
                                .imageScale(.large)
                                .foregroundColor(self.caratteristicheModel(model).colore)
                            
                                .onTapGesture {
                                    
                                    withAnimation {
                                        action(model)
                                    }
                                }
                        }
                        .opacity(self.caratteristicheModel(model).isUsed ? 0.5 : 1.0)
                        .disabled(self.caratteristicheModel(model).isUsed)
                        ._tightPadding()
                        
                        Divider()
                           
                    }

                }.listRowSeparator(.hidden)
        }
    }



/* struct MostraESelezionaIngredienti: View {
        
        var listaAttiva: [IngredientModel]
        let attributeIngredient: (_ ingredient: IngredientModel) -> (colore: Color,image: String, isUsed: Bool)
        let action: (_ ingredient: IngredientModel) -> Void
     
        var body: some View {
                
                ForEach(listaAttiva) { ingrediente in

                    VStack {
                        
                        HStack {
                            
                            Text(ingrediente.intestazione)
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
    }*/ // 07.05 BACKUP per Trasformazione in Generica
/*
struct MostraESelezionaIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        MostraESelezionaIngredienti()
    }
}
*/
