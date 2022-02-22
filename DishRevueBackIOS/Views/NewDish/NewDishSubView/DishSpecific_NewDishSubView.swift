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
    
    @State private var creaNuovaTaglia: Bool? = false
    @State private var nuovaTaglia: String = ""

    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1(placeHolder: "Specifiche", imageName: "doc.text.magnifyingglass", backgroundColor: Color.black, toggleBottone: $creaNuovaTaglia).disabled(self.openSpecificValue)
            
            if !(creaNuovaTaglia ?? false) {
                
                VStack {
                    
                    if !self.openSpecificValue {
                        
                        ScrollView(.horizontal,showsIndicators: false) {
                            
                            HStack {
                                
                                ForEach(DishSpecificValue.allCases) { taglia in
                                    
                                    
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
                                                    self.openSpecificValue = true
                                                    self.currentDish = taglia
                                                }
                                            }
                                        }
                                        .onLongPressGesture {
                                            withAnimation(.default) {
                                                self.newDish.tagliaPiatto = []
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
                                
                                CSText_tightRectangle(testo: self.currentDish.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: Color.clear, fillColor: Color.mint)
                                
                                Spacer()
                                
                                Button("Close") { self.openSpecificValue = false}
                                .padding(.trailing)
                                
                                Button {
     
                                    self.validateAndAddSpecificValue()
                                    self.openSpecificValue = false
                                    
                                } label: {
                                    
                                    CSText_tightRectangle(testo: self.currentDish.isTagliaAlreadyIn(newDish: self.newDish) ? "Modifica" : "Aggiungi", fontWeight: .heavy, textColor: Color.white, strokeColor: Color.red, fillColor: Color.red)
      
                                }
                            }
                        }
                    }
                }
                
            } else {
                
                CSTextField_3(textFieldItem: $nuovaTaglia, placeHolder: "Aggiungi un Nuovo taglio") {
                    
                    if DishSpecificValue.isCustomCaseNameOriginal(customName: nuovaTaglia) {
                        
                        DishSpecificValue.allCases.insert(.custom(nuovaTaglia, "n/d", "1", "n/d"), at: 0)
                   
                    } else { newDish.alertItem = AlertModel(
                        title: "Controlla Scroll specifiche",
                        message: "La specifica \"\(nuovaTaglia)\" esiste già"
                                            )
                                    }
                    
                    print(DishSpecificValue.allCases.description)
                    self.nuovaTaglia = ""
                    self.creaNuovaTaglia = false
                    
                }
            }
            
        }.padding(.horizontal)
    }
    
    // Method Space
    func validateAndAddSpecificValue() {
        
        guard Int(self.grammi) != nil else {
            // inserire alert
            print("Valore inserito in grammi NON VALIDO")
            self.grammi = ""
            return}
        guard Double(self.prezzo) != nil else {
            // alert
            print("Valore inserito in prezzo NON VALIDO")
            self.prezzo = ""
            return}
        guard Int(self.pax) != nil else {
            //alert
            print("Valore inserito in pax NON VALIDO")
            self.pax = ""
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
            
        case .custom(let name,_,_,_):
            self.currentDish = .custom(name,self.grammi,self.pax,self.prezzo)
       
        }

        print("pax: \(self.pax) - grammi: \(self.grammi) - price: \(self.prezzo)")
        print("currentDish: \(currentDish.simpleDescription())")
        
        self.grammi = ""
        self.prezzo = ""
        self.pax = ""
        
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
