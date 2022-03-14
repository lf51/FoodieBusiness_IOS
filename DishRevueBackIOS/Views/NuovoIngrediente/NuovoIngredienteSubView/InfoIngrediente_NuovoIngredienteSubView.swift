//
//  InfoGenerali_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct InfoIngrediente_NuovoIngredienteSubView: View {
    
    @State private var nomeNuovoIngrediente: String = ""
    @Binding var nuovoIngrediente: ModelloIngrediente
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1Button(placeHolder: nuovoIngrediente.nome == "" ? "Crea Nuovo Ingrediente" : "Editing \(nuovoIngrediente.nome)", imageName: "gearshape", backgroundColor: Color.black)
  
            CSTextField_3(textFieldItem: self.$nomeNuovoIngrediente, placeHolder: "Nome Ingrediente") {
                self.nuovoIngrediente.nome = self.nomeNuovoIngrediente
                self.nomeNuovoIngrediente = ""
            }
            
        }.padding(.horizontal)
        
        
    }
    
    // function Space
    
   /* func removeItem(array: inout [ModelloIngrediente], item: ModelloIngrediente) {
        
        let positionIndex = array.firstIndex(of: item)
        
        array.remove(at: positionIndex!)
        
    }
    
    func validateItem(array: inout [ModelloIngrediente], item: inout String) -> Bool {
        
        item = item.capitalized
        
        var newIngrediente = ModelloIngrediente()
        newIngrediente.nome = item 
        
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
    } */
    
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/
