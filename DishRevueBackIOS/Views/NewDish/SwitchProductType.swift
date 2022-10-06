//
//  SwitchNewDishType.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 03/10/22.
//

import SwiftUI

/*
enum ProductType:String  {
    
    case preparato = "Preparato"
    case daPreparare = "Elaborato"
    
    func simpleDescription() -> String {
        
        switch self {
        case .preparato:
            return "Trattasi di un prodotto pronto che non richiede altri ingredienti per essere servito"
        case .daPreparare:
            return "E' il frutto della combinazione e/o lavorazione di uno o più ingredienti"
        }
    }
} */ // 06.10 deprecata - sostituita con una nestedType nel DishModel


struct SwitchProductType: View {
    
   // @State private var type:ProductType = .daPreparare
  //  @Binding var newDish:DishModel
   // @Binding var type:ProductType
    @Binding var type:DishModel.PercorsoProdotto
    let nascondiTesto:Bool
    
    var body: some View {
        
        VStack(alignment:.leading) {
            Picker(selection: $type) {
                Text("Prodotto Finito")
                    .tag(DishModel.PercorsoProdotto.prodottoFinito)
                Text("Food")
                    .tag(DishModel.PercorsoProdotto.preparazioneFood)
                Text("Beverage")
                    .tag(DishModel.PercorsoProdotto.preparazioneBeverage)
                
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)
          /*  .onChange(of: type) { newValue in
                
                if newValue == .preparato {
                    self.newDish.ingredientiPrincipali = [self.newDish.id]
                } else {
                    self.newDish.ingredientiPrincipali = []
                }
               
            } */
            
            if !nascondiTesto {
                Text(type.simpleDescription())
                    .italic()
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
        

    }
}

/*
struct SwitchNewDishType_Previews: PreviewProvider {
    static var previews: some View {
        SwitchProductType(newDish: )
    }
}
*/
