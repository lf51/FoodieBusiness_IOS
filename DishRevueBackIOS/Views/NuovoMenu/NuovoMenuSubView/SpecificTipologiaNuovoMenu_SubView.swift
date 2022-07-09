//
//  SpecificTipologiaNuovoMenu_SubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import SwiftUI

struct SpecificTipologiaNuovoMenu_SubView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @Binding var newMenu: MenuModel

   // @State private var pax: String = ""
    @State private var pax: PaxMenuFisso = .uno
    @State private var prezzo: String = ""

    @State private var wannaInsertValues: Bool = false
    
    var body: some View {
        
        VStack {
                
        if !self.wannaInsertValues {
                        
            HStack {
                            
                ForEach(TipologiaMenu.allCases) { tipologia in
                    
                  /*  CSText_bigRectangle(testo: tipologia.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: self.newMenu.tipologia?.id == tipologia.id ? Color.clear : Color.blue, fillColor: self.newMenu.tipologia?.id == tipologia.id ? Color.orange : Color.clear) */
                    CSText_tightRectangle(testo: tipologia.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: self.newMenu.tipologia?.id == tipologia.id ? Color.clear : Color.blue, fillColor: self.newMenu.tipologia?.id == tipologia.id ? Color.orange : Color.clear)
                        .onTapGesture {
                            withAnimation(.default) {
                              
                                if tipologia.editingAvaible() {
                                    
                                    self.wannaInsertValues = true
      
                                }
                                
                                else {
                                    
                                    self.newMenu.tipologia = self.newMenu.tipologia?.id == tipologia.id ? nil : tipologia
                                    
                                            }
                                        }
                                    }
                        .onLongPressGesture {
                            withAnimation(.default) {
                                self.newMenu.tipologia = nil
                                                    }
                                                }
                                    }
                                }
            
                        } else {
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                          /*  CSTextField_4(textFieldItem: $pax, placeHolder: ">=1", image: "person.fill.questionmark", keyboardType: .numberPad) */
                            CS_Picker(
                                selection: $pax,
                                customLabel: "Pax",
                                dataContainer: PaxMenuFisso.allCases)
                            
                            CSTextField_4(textFieldItem: $prezzo, placeHolder: "0.0", image: "eurosign.circle", keyboardType: .decimalPad)
                            
                        }
                        
                        HStack {
                            
                            CSText_tightRectangle(testo: "Menu Fisso", fontWeight: .bold, textColor: Color.white, strokeColor: Color.clear, fillColor: Color.mint)
                            
                            Spacer()
                            
                            Button("Chiudi") {
                               // self.tipologiaCorrente = .defaultValue
                                self.wannaInsertValues = false }
                            .foregroundColor(Color.blue)
                            .padding(.trailing)
                            
                            Button {
 
                                self.validateAndAddSpecificValue()
                                self.wannaInsertValues = false
                                
                            } label: {
                                
                                CSText_tightRectangle(testo: self.newMenu.tipologia?.id != "fisso" ? "Aggiungi" : "Modifica", fontWeight: .heavy, textColor: Color.white, strokeColor: Color.red, fillColor: Color.red)
  
                            }
                        }
                    }
                }
            }
            
        }
        
    // Method
    
    private func validateAndAddSpecificValue() {
                
        guard csValidateValue(value: self.prezzo, convalidaAsDouble: true) else {
    
           /* self.newMenu.alertItem = AlertModel(
                title: "Errore Inserimento Prezzo",
                message: "Valore inserito non valido. Ex: 180 o 180.5" ) */
            
            self.viewModel.alertItem = AlertModel(
                title: "Errore Inserimento Prezzo",
                message: "Valore inserito non valido. Ex: 180 o 180.5" )
            
            print("Valore inserito in prezzo NON VALIDO - DEVE ESSERE APPARSO UN ALERT")
            self.prezzo = ""
            //self.tipologiaCorrente = .defaultValue
            return}
        
      /*  guard csValidateValue(value: self.pax, convalidaAsDouble: false) else {
        
          /*  self.newMenu.alertItem = AlertModel(
                title: "Errore Inserimento Porzioni",
                message: "Il valore si riferisce al numero di persono e deve essere un numero intero positivo. Ex: 2 - Errato 1/2" ) */
            
            viewModel.alertItem = AlertModel(
                title: "Errore Inserimento Porzioni",
                message: "Il valore si riferisce al numero di persono e deve essere un numero intero positivo. Ex: 2 - Errato 1/2" )
            
            print("Valore inserito in pax NON VALIDO - DEVE ESSERE APPARSO UN ALERT")
            self.pax = ""
           // self.tipologiaCorrente = .defaultValue
            return} */
        
    //    self.newMenu.tipologia = .fisso(persone: self.pax, costo: self.prezzo)
        self.newMenu.tipologia = .fisso(persone: self.pax, costo: self.prezzo)
        
        print("pax: \(self.pax.simpleDescription()) - price: \(self.prezzo)")
        print("nuovoMenuTipologia: \(self.newMenu.tipologia?.simpleDescription() ?? "Tipologia Menu is Nil")")

        self.prezzo = ""
        self.pax = .uno

    }
        
    }


/*struct SpecificTipologiaNuovoMenu_SubView_Previews: PreviewProvider {
    static var previews: some View {
        SpecificTipologiaNuovoMenu_SubView()
    }
} */



