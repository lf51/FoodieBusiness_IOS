//
//  DishSpecific_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct DishSpecific_NewDishSubView: View {
    
    @Binding var newDish: DishModel
 
    @State private var grammi: String = ""
    @State private var pax: String = ""
    @State private var prezzo: String = ""
    
    @State private var formatoCorrente: DishFormato = .defaultValue
    @State private var wannaInsertFormatValue: Bool = false
    
    @State private var creaNuovoFormato: Bool? = false
    @State private var nuovoFormato: String = ""

    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1Button(placeHolder: "Formato", imageName: "doc.text.magnifyingglass", backgroundColor: Color.black, toggleBottone: $creaNuovoFormato).disabled(self.wannaInsertFormatValue)
            
            if !(creaNuovoFormato ?? false) {
                
                VStack {
                    
                    if !self.wannaInsertFormatValue {
                        
                        ScrollView(.horizontal,showsIndicators: false) {
                            
                            HStack {
                                
                                ForEach(DishFormato.allCases) { taglia in
        
                                    CSText_bigRectangle(testo: taglia.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: taglia.isTagliaAlreadyIn(newDish: self.newDish) ? Color.clear : Color.blue, fillColor: taglia.isTagliaAlreadyIn(newDish: self.newDish) ? Color.mint : Color.clear)
                                    
                                        .opacity(taglia.isSceltaBloccata(newDish: self.newDish) ? 0.4 : 1.0 )
                                        .onTapGesture {
                                            withAnimation(.default) {
                                                if taglia.isSceltaBloccata(newDish: self.newDish) {
                                                    
                                                    newDish.alertItem = AlertModel (
                                                        title: "Scelta Bloccata",
                                                        message: "\(taglia.qualeComboIsAvaible())\n\n - Premi a lungo un'opzione qualsiasi per Resettare - "
                                                                    )
                                                            }
                                                else {
                                                    self.wannaInsertFormatValue = true
                                                    self.formatoCorrente = taglia
                                                }
                                            }
                                        }
                                        .onLongPressGesture {
                                            withAnimation(.default) {
                                                self.newDish.formatiDelPiatto = []
                                                        }
                                                    }
                                        }
                                    }
                                }
                        
                            } else {
                        
                        VStack(alignment: .leading) {
                            
                            HStack {
                                
                                CSTextField_4(textFieldItem: $pax, placeHolder: ">=1", image: "person.fill.questionmark")
                                CSTextField_4(textFieldItem: $grammi, placeHolder: "0 gr", image: "scalemass.fill")
                                CSTextField_4(textFieldItem: $prezzo, placeHolder: "0.0", image: "eurosign.circle")
                                
                            }
                            
                            HStack {
                                
                                CSText_tightRectangle(testo: self.formatoCorrente.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: Color.clear, fillColor: Color.mint)
                                
                                Spacer()
                                
                                Button("Close") { self.wannaInsertFormatValue = false}
                                .padding(.trailing)
                                
                                Button {
     
                                    self.validateAndAddSpecificValue()
                                    self.wannaInsertFormatValue = false
                                    
                                } label: {
                                    
                                    CSText_tightRectangle(testo: self.formatoCorrente.isTagliaAlreadyIn(newDish: self.newDish) ? "Modifica" : "Aggiungi", fontWeight: .heavy, textColor: Color.white, strokeColor: Color.red, fillColor: Color.red)
      
                                }
                            }
                        }
                    }
                }
                
            } else {
                
                CSTextField_3(textFieldItem: $nuovoFormato, placeHolder: "Aggiungi un Nuovo Formato") {
                    
                    if DishFormato.isCustomCaseNameOriginal(customName: nuovoFormato) {
                        
                        DishFormato.allCases.insert(.custom(nuovoFormato, "n/d", "1", "n/d"), at: 0)
                   
                    } else { newDish.alertItem = AlertModel(
                        title: "Controlla Scroll specifiche",
                        message: "La specifica \"\(nuovoFormato)\" esiste già"
                                            )
                                    }
                    
                    print(DishFormato.allCases.description)
                    self.nuovoFormato = ""
                    self.creaNuovoFormato = false
                    
                }
            }
            
        }
    }
    
    // Method Space
    
    private func validateAndAddSpecificValue() {
        
        guard myValidateValue(value: self.grammi, convalidaAsDouble: true) else {
        
            self.newDish.alertItem = AlertModel(
                title: "Errore Inserimento Grammi",
                message: "Valore inserito non valido. Ex: 150 o 150.5" )
            
            print("Valore inserito in grammi NON VALIDO")
            self.grammi = ""
            return }
        
        guard myValidateValue(value: self.prezzo, convalidaAsDouble: true) else {
    
            self.newDish.alertItem = AlertModel(
                title: "Errore Inserimento Prezzo",
                message: "Valore inserito non valido. Ex: 180 o 180.5" )
            
            print("Valore inserito in prezzo NON VALIDO")
            self.prezzo = ""
            return}
        
        guard myValidateValue(value: self.pax, convalidaAsDouble: false) else {
        
            self.newDish.alertItem = AlertModel(
                title: "Errore Inserimento Porzioni",
                message: "Il valore si riferisce al numero di persono e deve essere un numero intero positivo. Ex: 2 - Errato 1/2" )
            
            print("Valore inserito in pax NON VALIDO")
            self.pax = ""
            return}
        
        switch self.formatoCorrente {
            
        case .unico:
            self.formatoCorrente = .unico(self.grammi, self.pax, self.prezzo)
        case .doppio:
            self.formatoCorrente = .doppio(self.grammi, self.pax, self.prezzo)
        case .piccolo:
            self.formatoCorrente = .piccolo(self.grammi, self.pax, self.prezzo)
        case .medio:
            self.formatoCorrente = .medio(self.grammi, self.pax, self.prezzo)
        case .grande:
            self.formatoCorrente = .grande(self.grammi, self.pax, self.prezzo)
            
        case .custom(let name,_,_,_):
            self.formatoCorrente = .custom(name,self.grammi,self.pax,self.prezzo)
       
        }

        print("pax: \(self.pax) - grammi: \(self.grammi) - price: \(self.prezzo)")
        print("currentDish: \(formatoCorrente.simpleDescription())")
        
        self.grammi = ""
        self.prezzo = ""
        self.pax = ""
        
        if self.formatoCorrente.isTagliaAlreadyIn(newDish: self.newDish) {
            
            let index = self.newDish.formatiDelPiatto.firstIndex(where: {$0.id == self.formatoCorrente.id})
            
            self.newDish.formatiDelPiatto.remove(at: index!)
        } // se già presente lo rimuoviamo
                
        self.newDish.formatiDelPiatto.append(self.formatoCorrente)
        print("taglieCount: \(self.newDish.formatiDelPiatto.count)")

    }
 
}

/* struct DishSpecific_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        DishSpecific_NewDishSubView()
    }
}
 */
