//
//  SpecificTipologiaNuovoMenu_SubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct SpecificTipologiaNuovoMenu_SubView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @Binding var newMenu: MenuModel

    @State private var pax: PaxMenuFisso = .uno
    @State private var prezzo: String = ""

    @State private var wannaInsertValues: Bool = false
    
    var body: some View {
        
        VStack(alignment:.leading) {
                
        if !self.wannaInsertValues {
                        
            HStack {
                            
                ForEach(TipologiaMenu.allCases) { tipologia in
 
                    CSText_tightRectangle(testo: tipologia.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: self.newMenu.tipologia.id == tipologia.id ? Color.clear : Color.blue, fillColor: self.newMenu.tipologia.id == tipologia.id ? Color.seaTurtle_3 : Color.clear)
                        .onTapGesture {
                            withAnimation(.default) {
                              
                                if tipologia.editingAvaible() {
                                    
                                    self.wannaInsertValues = true
      
                                }
                                
                                else {
                                    
                                    self.newMenu.tipologia = self.newMenu.tipologia.id == tipologia.id ? .defaultValue : tipologia
                                    
                                            }
                                        }
                                    }
                        .onLongPressGesture {
                            withAnimation(.default) {
                                
                                if tipologia.editingAvaible() { self.newMenu.tipologia = .defaultValue }
                               
                                                    }
                                                }
                                    }
                                }
                Text(self.newMenu.tipologia.extendedDescription())
                    .font(.caption)
                    .fontWeight(.light)
                    .italic()
                    .foregroundColor(Color.black)
            
                        } else {
                    
                    VStack(alignment: .leading) {
 
                        HStack {

                            CS_Picker(
                                selection: $pax,
                                customLabel: "Pax",
                                dataContainer: PaxMenuFisso.allCases,
                                cleanAndOrderContainer: false)
                            
                            CSTextField_4(textFieldItem: $prezzo, placeHolder: "0.00", image: "dollarsign.circle", keyboardType: .decimalPad)
                            
                        }
                        
                        HStack {
                            
                            CSText_tightRectangle(testo: "Menu Fisso", fontWeight: .bold, textColor: Color.white, strokeColor: Color.clear, fillColor: Color.mint)
                            
                            Spacer()
                            
                            Button("Chiudi") {
                                self.wannaInsertValues = false }
                            .foregroundColor(Color.blue)
                            .padding(.trailing)
                            
                            Button {
 
                                self.validateAndAddSpecificValue()
                                self.wannaInsertValues = false
                                
                            } label: {
                                
                                CSText_tightRectangle(testo: self.newMenu.tipologia.id != "fisso" ? "Aggiungi" : "Modifica", fontWeight: .heavy, textColor: Color.white, strokeColor: Color.red, fillColor: Color.red)
  
                            }
                        }
                    }
                }
            }
        }
        
    // Method
    
    private func validateAndAddSpecificValue() {
                
       // guard csValidateValue(value: self.prezzo, convalidaAsDouble: true) else { // 22.09
        
        guard csCheckDouble(testo: self.prezzo) else {
            
            self.viewModel.alertItem = AlertModel(
                title: "Errore Inserimento Prezzo",
                message: "Valore inserito non valido. Ex: 180 o 180,5 o 180.5" )
            
            self.prezzo = ""
            return}
    
        let newPrice = self.prezzo.replacingOccurrences(of: ",", with: ".")
        self.newMenu.tipologia = .fisso(persone: self.pax, costo: newPrice)

        self.prezzo = ""
        self.pax = .uno

    }
        
    }

/*struct SpecificTipologiaNuovoMenu_SubView_Previews: PreviewProvider {
    static var previews: some View {
        SpecificTipologiaNuovoMenu_SubView()
    }
} */



