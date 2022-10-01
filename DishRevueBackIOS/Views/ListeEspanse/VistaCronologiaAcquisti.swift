//
//  VistaCronologiaAcquisti.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/10/22.
//

import SwiftUI

struct VistaCronologiaAcquisti: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let ingrediente:IngredientModel
    let backgroundColorView: Color
    
    var body: some View {
        
        CSZStackVB(title: "Log Acquisti", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                let logDate = self.viewModel.inventarioScorte.logAcquisti(idIngrediente: ingrediente.id)
                let logDateEnumerated = logDate.enumerated()
                
                HStack {
                    
                    Text(ingrediente.intestazione)
                        .italic()
                        .fontWeight(.light)
                        .font(.title2)
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                  
                    Spacer()
                }

                ScrollView(showsIndicators:false) {
                    
                    ForEach(Array(logDateEnumerated),id:\.element) { position,stamp in
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack(alignment:.bottom) {
                                Text("\(position + 1).")
                                    .font(.system(.headline, design: .monospaced, weight: .bold))
                                    .foregroundColor(Color.gray)
                                
                                Text("\(stamp)")
                                    .italic()
                                    .font(.system(.headline, design: .monospaced, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                                
                                if position == (logDate.endIndex - 1) {
                                    
                                    Text("ultimo acquisto")
                                        .italic()
                                        .font(.callout)
                                        .foregroundColor(Color("SeaTurtlePalette_3"))
                                    
                                }
                            }
                            Divider()
                        }
                       
                        
                    }
                    
                    
                }
                
              //  Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}

struct VistaCronologiaAcquisti_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VistaCronologiaAcquisti(ingrediente: ingredientSample_Test, backgroundColorView: Color("SeaTurtlePalette_1"))
        }
            .environmentObject(testAccount)
    }
}
