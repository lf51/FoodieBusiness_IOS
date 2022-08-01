//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//

import SwiftUI

struct IngredientModel_RowView: View {

    let item: IngredientModel
    
    var body: some View {
                
        CSZStackVB_Framed {
        
            VStack(alignment:.leading) {
    
                HStack(alignment: .top) {
   
                    Text(item.intestazione)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                }
                
                Spacer()
 
               /* AllergeniBottomScroll_GenericSubView(allergeniItem: item.allergeni) */
                
              /*  HStack(spacing: 4.0) {
                    
                    Image(systemName: "allergens")
                        .imageScale(.medium)
                
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack(spacing: 2.0) {
                            
                            ForEach(item.allergeni) { allergene in
                                
                                Text(allergene.simpleDescription().replacingOccurrences(of: " ", with: ""))
                                    .font(.caption)
                                    .foregroundColor(Color.black)
                                    .italic()
                                
                                Text("•")
                                
                            }
                            
                        }
                    }
                }*/

                
                
                
            } // chiuda VStack madre
            ._tightPadding()
        } // chiusa Zstack Madre
       // .frame(width: 300, height: 150)
        
        
    }
}


struct IngredientModel_RowView_Previews: PreviewProvider {
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.glutine,.anidride_solforosa_e_solfiti],
        origine: .carneAnimale,
        status: .vuoto)
    
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            IngredientModel_RowView(item: ingredientSample)
        }
    }
}
