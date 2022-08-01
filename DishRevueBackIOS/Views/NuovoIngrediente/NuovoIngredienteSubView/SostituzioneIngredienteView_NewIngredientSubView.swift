//
//  SostituzioneIngredienteView_NewIngredientSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/07/22.
//

import SwiftUI

struct SostituzioneIngredienteView_NewIngredientSubView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var nuovoIngrediente: IngredientModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            CSLabel_conVB(
                placeHolder: "Sostituisci con..",
                imageNameOrEmojy: "arrow.left.arrow.right.circle",
                backgroundColor: Color.black) {
                    
                    Picker(selection: $nuovoIngrediente.idIngredienteDiRiserva) {
                        
                        let mapArray:[String] = {
                            
                            let filterArray = viewModel.allMyIngredients.filter({$0.id != nuovoIngrediente.id})
                            
                            return filterArray.map({$0.intestazione})
                        }()
                        
                        if nuovoIngrediente.idIngredienteDiRiserva == "" {
                            Text("Scegli")
                                .tag("")
                               // .tag("SCEGLI") // seza il tag non è selezionabile, ovvero il valore non viene passato e quindi lo possiamo usare come "segnaposto"
                        }
                        
                        ForEach(mapArray,id:\.self) { ingredient in
                                
                                Text(ingredient)
                                .tag(ingredient)

                            }
                        
                    } label: {
                        Text("Pick")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(Color("SeaTurtlePalette_3"))
                    .padding(.horizontal)
                    .background(
                  
                  RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color("SeaTurtlePalette_2").opacity(0.4))
                      .shadow(radius: 1.0)
              )

                }
            
            sostituisciConInfo()
                .multilineTextAlignment(.leading)
                .fontWeight(.light)
                .font(.caption)
                .foregroundColor(Color.black)
    
        }
    }
    
    private func sostituisciConInfo() -> Text {
        
        guard self.nuovoIngrediente.intestazione != "" else { return Text("") }
        
        if self.nuovoIngrediente.idIngredienteDiRiserva == "" {
            
            return Text("Quando in-Pausa l'ingrediente \(self.nuovoIngrediente.intestazione) viene omesso dal piatto e NON viene indicato un sostituito.")
              
            
        } else {
            
            return Text("Quando in-Pausa l'ingrediente \(self.nuovoIngrediente.intestazione) viene omesso dal piatto ma E' INDICATA la sostituzione con: \(self.nuovoIngrediente.idIngredienteDiRiserva)")
               
        }
    }
    
}

/*
struct SostituzioneIngredienteView_NewIngredientSubView_Previews: PreviewProvider {
    static var previews: some View {
        SostituzioneIngredienteView_NewIngredientSubView()
    }
}
*/
