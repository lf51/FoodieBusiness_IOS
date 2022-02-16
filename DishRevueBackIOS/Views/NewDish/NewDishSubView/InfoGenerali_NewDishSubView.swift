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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1(placeHolder: "Info Generali", imageName: "info.circle", backgroundColor: Color.brown)
            
            
            CSTextField_3(textFieldItem: self.$nomePiatto, placeHolder: self.newDish.name == "" ? "Nome del Piatto" : "Modifica Nome del Piatto") {
                
                self.newDish.name = self.nomePiatto
                self.nomePiatto = ""
            }
            
            if self.newDish.name != "" {DishInfoRectangle(data: self.newDish.name, baseColor: Color.green)}
            
            CSTextField_3(textFieldItem: self.$nuovoIngredientePrincipale, placeHolder: "Ingrediente Principale") {
                
                self.validateItem(array: &self.newDish.ingredientiPrincipali, item: &self.nuovoIngredientePrincipale)
   
            }
            
            if !self.newDish.ingredientiPrincipali.isEmpty {
                GridInfoDishValue_NewDishSubView(activeDelection: $activeDeletion, showArrayData: self.$newDish.ingredientiPrincipali, baseColor: Color.orange) { data in
                    
                    self.removeItem(array: &self.newDish.ingredientiPrincipali, item: data)
                    
                }
            }
            
            CSTextField_3(textFieldItem: self.$nuovoIngredienteSecondario, placeHolder: "Ingrediente Secondario (Optional)") {
                
                self.validateItem(array: &self.newDish.ingredientiSecondari, item: &self.nuovoIngredienteSecondario)
            }
            
            if !self.newDish.ingredientiSecondari.isEmpty {
                GridInfoDishValue_NewDishSubView(activeDelection: $activeDeletion, showArrayData: self.$newDish.ingredientiSecondari, baseColor: Color.mint) { data in
                    
                    self.removeItem(array: &self.newDish.ingredientiSecondari, item: data)
                }
            }
            
            
            //  CSTextField_3(newDishProperty: self.$newDish.name, placeHolder: "Quantità (Optional)", submitLabel: .done, showButton: false) */
            // Per la Quantità serve uno spazio più piccolo
            
        }
    }
    
    // function Space
    
    func removeItem(array: inout [String], item: String) {
        
        let positionIndex = array.firstIndex(of: item)
        
        array.remove(at: positionIndex!)
        
    }
    
    func validateItem(array: inout [String], item: inout String) {
        
        item = item.capitalized
        
        guard !self.newDish.ingredientiPrincipali.contains(item) else {
            print("\(item) already fra gli ingredienti Principali")
            item = ""
            return
        }
        
        guard !self.newDish.ingredientiSecondari.contains(item) else {
            print("\(item) already fra gli ingredienti Secondari")
            item = ""
            return
        }

        array.append(item)
        print("\(item) in ")
        item = ""
    }
    
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/
