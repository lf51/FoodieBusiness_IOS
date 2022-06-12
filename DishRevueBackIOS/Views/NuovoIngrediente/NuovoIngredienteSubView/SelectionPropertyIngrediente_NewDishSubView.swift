//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct SelectionPropertyIngrediente_NewDishSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel

    @State private var creaCaseConservazione: Bool? = false
    @State private var nuovaConservazione: String = ""

    @State private var creaNuovaProvenienza: Bool? = false
    @State private var nuovaProvenienza: String = ""
    
    @State private var creaNuovoMetodoProduzione: Bool? = false
    @State private var nuovoMetodoProduzione: String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
                        
            //Conservazione
            CSLabel_1Button(placeHolder: "Conservazione", imageNameOrEmojy: "thermometer", backgroundColor: Color.black, toggleBottone: $creaCaseConservazione)
            
            if !(creaCaseConservazione ?? false) {
                
                PropertyScrollCases(cases: ConservazioneIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.conservazione, colorSelection: Color.green)
                
            } else {
                
                CSTextField_3(textFieldItem: $nuovaConservazione, placeHolder: "Metodo di Conservazione") {
                    ConservazioneIngrediente.allCases.insert(.custom(nuovaConservazione), at: 0)
                    self.nuovaConservazione = ""
                    self.creaCaseConservazione = false
                }
                
            }
            
            
            // provenienza
            
            CSLabel_1Button(placeHolder: "Prodotto in", imageNameOrEmojy: "globe", backgroundColor: Color.black, toggleBottone: $creaNuovaProvenienza)
            
            if !(creaNuovaProvenienza ?? false) {
            
            PropertyScrollCases(cases: ProvenienzaIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.provenienza, colorSelection: Color.brown)
            
            } else {
                
                CSTextField_3(textFieldItem: $nuovaProvenienza, placeHolder: "Aggiungi Provenienza") {
                    
                    ProvenienzaIngrediente.allCases.insert(.custom(nuovaProvenienza), at: 0)
                    
                    self.nuovaProvenienza = ""
                    self.creaNuovaProvenienza = false
                    
                }
            }
            
            // metodo di Produzione
            
            CSLabel_1Button(placeHolder: "Metodo di Produzione", imageNameOrEmojy: "gearshape.2.fill", backgroundColor: Color.black, toggleBottone: $creaNuovoMetodoProduzione)
            
            if !(creaNuovoMetodoProduzione ?? false) {
            
            PropertyScrollCases(cases: ProduzioneIngrediente.allCases, dishSingleProperty: self.$nuovoIngrediente.produzione, colorSelection: Color.green)
            
            } else {
                
                CSTextField_3(textFieldItem: $nuovoMetodoProduzione, placeHolder: "Aggiungi Metodo di Produzione") {
                    
                    ProduzioneIngrediente.allCases.insert(.custom(nuovoMetodoProduzione), at: 0)
                   
                    self.nuovoMetodoProduzione = ""
                    self.creaNuovoMetodoProduzione = false
                    
                }
            }
            
   
         
        }.padding(.horizontal)
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
