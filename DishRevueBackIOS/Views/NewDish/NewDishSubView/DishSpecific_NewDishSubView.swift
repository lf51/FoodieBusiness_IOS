//
//  DishSpecific_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct DishSpecific_NewDishSubView: View {
    
    @Binding var newDish: DishModel
 
    @State private var grammi: String = ""
    @State private var pax: String = ""
    @State private var prezzo: String = ""
    @State private var currentDish: DishSpecificValue = .unico("0", "1", "0.0")
    
    @State private var openSpecificValue: Bool = false

    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1(placeHolder: "Specifiche", imageName: "doc.text.magnifyingglass", backgroundColor: Color.black, toggleBottone: nil)
            
            VStack {
                if !self.openSpecificValue {
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(DishSpecificValue.allCases) { taglia in
                                
                              /* Text(taglia.simpleDescription())
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .background (
                                        
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .strokeBorder(taglia.isTagliaAlreadyIn(newDish: self.newDish) ? Color.clear : Color.blue)
                                            .background(RoundedRectangle(cornerRadius: 5.0)
                                                            .fill(taglia.isTagliaAlreadyIn(newDish: self.newDish) ? Color.mint.opacity(0.8) : Color.clear))
                                            .shadow(radius: 3.0)
                                    ) */
                                CSText_bigRectangle(testo: taglia.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: taglia.isTagliaAlreadyIn(newDish: self.newDish) ? Color.clear : Color.blue, fillColor: taglia.isTagliaAlreadyIn(newDish: self.newDish) ? Color.mint : Color.clear)
                                
                                    .opacity(taglia.isSceltaBloccata(newDish: self.newDish) ? 0.4 : 1.0 )
                                    .onTapGesture {
                                        self.openSpecificValue = true
                                        self.currentDish = taglia
                                        
                                    }.disabled(taglia.isSceltaBloccata(newDish: self.newDish)) // validiamo la scelta
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
                            
                            CSText_tightRectangle(testo: self.currentDish.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: Color.clear, fillColor: Color.mint)
                            
                          /*  Text(self.currentDish.simpleDescription())
                                .bold()
                                .foregroundColor(.white)
                                ._tightPadding()
                                .background (
                                    
                                    RoundedRectangle(cornerRadius: 5.0)
                                        .strokeBorder(Color.clear)
                                        .background(RoundedRectangle(cornerRadius: 5.0)
                                                        .fill(Color.mint.opacity(0.8))
                                        .shadow(radius: 3.0)
                                                   )
                                    ) */
                            
                            Spacer()
                            
                            Button("Close") { self.openSpecificValue = false}
                            .padding(.trailing)
                            
                            Button {
 
                                self.validateAndAddSpecificValue()
                                self.openSpecificValue = false
                                
                            } label: {
                                
                                CSText_tightRectangle(testo: self.currentDish.isTagliaAlreadyIn(newDish: self.newDish) ? "Modifica" : "Aggiungi", fontWeight: .heavy, textColor: Color.white, strokeColor: Color.red, fillColor: Color.red)
                                
                              /*  Text(self.currentDish.isTagliaAlreadyIn(newDish: self.newDish) ? "Modifica" : "Aggiungi")
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    ._tightPadding()
                                    .background (
                                        
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .strokeBorder(Color.red)
                                            .background(RoundedRectangle(cornerRadius: 5.0)
                                                            .fill(Color.red.opacity(0.8))
                                            .shadow(radius: 3.0)
                                                       )
                                        ) */
                            }
                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
    
    // Method Space
    func validateAndAddSpecificValue() {
        
        guard Int(self.grammi) != nil else {
            // inserire alert
            print("Valore inserito in grammi NON VALIDO")
            self.grammi = "0 gr"
            return}
        guard Double(self.prezzo) != nil else {
            // alert
            print("Valore inserito in prezzo NON VALIDO")
            self.prezzo = "0.0"
            return}
        guard Int(self.pax) != nil else {
            //alert
            print("Valore inserito in pax NON VALIDO")
            self.pax = ">= 1"
            return}
        
        switch self.currentDish {
            
        case .unico:
            self.currentDish = .unico(self.grammi, self.pax, self.prezzo)
        case .doppio:
            self.currentDish = .doppio(self.grammi, self.pax, self.prezzo)
        case .piccolo:
            self.currentDish = .piccolo(self.grammi, self.pax, self.prezzo)
        case .medio:
            self.currentDish = .medio(self.grammi, self.pax, self.prezzo)
        case .grande:
            self.currentDish = .grande(self.grammi, self.pax, self.prezzo)
        case.custom:
            self.currentDish = .custom("DA IMPLEMENTARE-HAVE A CHECK",self.grammi,self.pax,self.prezzo)
       
        }

        print("pax: \(self.pax) - grammi: \(self.grammi) - price: \(self.prezzo)")
        
        self.grammi = "0 gr"
        self.prezzo = "0.0"
        self.pax = ">= 1"
        
        if self.currentDish.isTagliaAlreadyIn(newDish: self.newDish) {
            
            let index = self.newDish.tagliaPiatto.firstIndex(where: {$0.id == self.currentDish.id})
            
            self.newDish.tagliaPiatto.remove(at: index!)
        } // se già presente lo rimuoviamo
        
        
        self.newDish.tagliaPiatto.append(self.currentDish)
        print("taglieCount: \(self.newDish.tagliaPiatto.count)")

    }
    
  
    
    
}

/* struct DishSpecific_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        DishSpecific_NewDishSubView()
    }
}
 */
