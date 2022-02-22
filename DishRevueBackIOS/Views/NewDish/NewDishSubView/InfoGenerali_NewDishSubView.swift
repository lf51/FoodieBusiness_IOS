//
//  InfoGenerali_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct InfoGenerali_NewDishSubView: View {
    
    @Binding var newDish: DishModel
    
    @State private var nomePiatto: String = ""
    @State private var nuovoIngredientePrincipale: String = ""
    @State private var nuovoIngredienteSecondario: String = ""
    
    @Binding var activeDeletion: Bool
    @Binding var openEditingIngrediente: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1(placeHolder: "Info Generali", imageName: "info.circle", backgroundColor: Color.black, toggleBottone: nil)
            
            
            CSTextField_3(textFieldItem: self.$nomePiatto, placeHolder: self.newDish.name == "" ? "Nome del Piatto" : "Modifica Nome del Piatto") {
                
                self.newDish.name = self.nomePiatto
                self.nomePiatto = ""
            }
            
            if self.newDish.name != "" {
                
                CSText_tightRectangle(testo: self.newDish.name, fontWeight: .bold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.green)
                                                }
            
                CSTextField_3(textFieldItem: self.$nuovoIngredientePrincipale, placeHolder: "Ingrediente Principale") {
                
                    if self.validateItem(array: &self.newDish.ingredientiPrincipali, item: &self.nuovoIngredientePrincipale) {
                        
                        newDish.alertItem = AlertModel(title: "Error", message: "L'ingrediente \"\(nuovoIngredientePrincipale.capitalized)\" è già presente fra gli ingredienti")
                        self.nuovoIngredientePrincipale = ""
                        // anche se in un If statement il metodo validate viene eseguito e l'ingrediente originale aggiunto ritorna un false, mentre l'eventuale doppione non viene aggiunto e ritorna un true che ci permette di mandare un alert.
                    } else { self.openEditingIngrediente = true }
   
            }
            
            if !self.newDish.ingredientiPrincipali.isEmpty {
                
                GridInfoDishValue_NewDishSubView(openEditingIngrediente: $openEditingIngrediente, activeDelection: $activeDeletion, showArrayData: self.$newDish.ingredientiPrincipali, baseColor: Color.orange) { data in
                    
                    self.removeItem(array: &self.newDish.ingredientiPrincipali, item: data)
                    
                }
            }
            
            CSTextField_3(textFieldItem: self.$nuovoIngredienteSecondario, placeHolder: "Ingrediente Secondario (Optional)") {
                
                if self.validateItem(array: &self.newDish.ingredientiSecondari, item: &self.nuovoIngredienteSecondario) {
                    
                    newDish.alertItem = AlertModel(title: "Error", message: "L'ingrediente \"\(nuovoIngredienteSecondario.capitalized)\" è già presente fra gli ingredienti")
                    self.nuovoIngredienteSecondario = ""
                    // vedi commento su Ingrediente Principale
                }  else { self.openEditingIngrediente = true }
                
            }
            
            if !self.newDish.ingredientiSecondari.isEmpty {
                GridInfoDishValue_NewDishSubView(openEditingIngrediente: $openEditingIngrediente, activeDelection: $activeDeletion, showArrayData: self.$newDish.ingredientiSecondari, baseColor: Color.mint) { data in
                    
                    self.removeItem(array: &self.newDish.ingredientiSecondari, item: data)
                }
            }
            
            
            //  CSTextField_3(newDishProperty: self.$newDish.name, placeHolder: "Quantità (Optional)", submitLabel: .done, showButton: false) */
            // Per la Quantità serve uno spazio più piccolo
            
        }
        
        
    }
    
    // function Space
    
    func removeItem(array: inout [ModelloIngrediente], item: ModelloIngrediente) {
        
        let positionIndex = array.firstIndex(of: item)
        
        array.remove(at: positionIndex!)
        
    }
    
    func validateItem(array: inout [ModelloIngrediente], item: inout String) -> Bool {
        
        item = item.capitalized
        
        let newIngrediente = ModelloIngrediente(nome: item, cottura: .bollito, provenienza: nil, metodoDiProduzione: nil)
        
        guard !self.newDish.ingredientiPrincipali.contains(newIngrediente) else {
            print("\(item) already fra gli ingredienti Principali")
            // l'alert qui dentro non funziona, perchè manca un binding diretto con la newDish. Abbiamo risolto facendo ritornare un bool al metodo
           // item = ""
            return true
        }
        
        guard !self.newDish.ingredientiSecondari.contains(newIngrediente) else {
            print("\(item) already fra gli ingredienti Secondari")
          //  item = ""
            return true
        }

        array.append(newIngrediente)
        print("\(item) in ")
        item = ""
        return false
        
        // la funzione ritorna un bool per mandare un alert nel caso di un doppione
    }
    
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/
