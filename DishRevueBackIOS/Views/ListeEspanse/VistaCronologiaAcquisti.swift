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
        
        CSZStackVB(title: ingrediente.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                let logDate = self.viewModel.inventarioScorte.logAcquisti(idIngrediente: ingrediente.id)
                let logDateEnumerated = logDate.enumerated()
                
                HStack {
                    
                    Text("Cronologia degli Acquisti")
                        .italic()
                        .fontWeight(.light)
                        .font(.title2)
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                  
                    Spacer()
                }

                ScrollView(showsIndicators:false) {
                    
                    ForEach(Array(logDateEnumerated),id:\.element) { position,stamp in
                        
                        let(time,note) = self.viewModel.inventarioScorte.splitDateFromNote(stringa: stamp)
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack(alignment:.bottom) {
                                Text("\(position + 1).")
                                    .font(.system(.headline, design: .monospaced, weight: .bold))
                                    .foregroundColor(Color.gray)
                                   // .foregroundColor(Color("SeaTurtlePalette_4"))
                                
                                Text("\(time)")
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
                            
                            Text(note)
                                .italic()
                                .font(.system(.subheadline, design: .default, weight: .light))
                                .foregroundColor(Color.black.opacity(0.8))
                            
                            
                            Divider()
                        }
                       
                        
                    }
                    
                    
                }
                
              //  Spacer()
                
            }
            .padding(.horizontal)
        }
    }
    
   /* private func splitDateFromNote(stringa: String) -> (data:String,nota:String) {
        
        guard stringa.contains("|") else { return (stringa,"Nessuna Nota")}
        
        let split = stringa.split(separator: "|")
        let data = String(split[0])
        let nota = String(split[1])
        return (data,nota)
        
    } */
}

struct VistaCronologiaAcquisti_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VistaCronologiaAcquisti(ingrediente: ingredientSample_Test, backgroundColorView: Color("SeaTurtlePalette_1"))
        }
            .environmentObject(testAccount)
    }
}
