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
        
        ZStack(alignment:.leading){
            
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.white.opacity(0.3))
                .shadow(radius: 3.0)
                
            VStack(alignment:.leading) {
    
                HStack(alignment: .top) {
   
                    Text(item.intestazione)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                }
              //  ._tightPadding()
                
                Spacer()
     
             //   Divider().padding(.horizontal)
                
             //   Spacer()
                
                VStack(alignment:.leading) {
                    
                    HStack {
                        
                        CSText_tightRectangle(
                            testo: item.provenienza.simpleDescription(),
                            fontWeight: .semibold,
                            textColor: Color.black,
                            strokeColor: Color.white,
                            fillColor: Color.cyan)
                        
                        CSText_tightRectangle(
                            testo: item.conservazione.simpleDescription(),
                            fontWeight: .semibold,
                            textColor: Color.black,
                            strokeColor: Color.white,
                            fillColor: Color.yellow)
        
                    }
                    
                    CSText_tightRectangle(
                        testo: item.produzione.simpleDescription(),
                        fontWeight: .semibold,
                        textColor: Color.black,
                        strokeColor: Color.white,
                        fillColor: Color.green.opacity(0.5))
                    
                    
                }
         
            } // chiuda VStack madre
            ._tightPadding()
        } // chiusa Zstack Madre
        .frame(width: 300, height: 150)
        
        
    }
}

struct IngredientModel_RowView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            IngredientModel_RowView(item: IngredientModel(
                nome: "Guanciale",
                provenienza: .custom("Argentina"),
                metodoDiProduzione: .custom("All'Aperto"),
                conservazione: .custom("Stagionato 12Mesi")))
        }
    }
}
