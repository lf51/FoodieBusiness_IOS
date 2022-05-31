//
//  CheckTestoTextField.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import Foundation

func csCheckConformitaTextField(testo:String, conformeA: ConformitàTextField ) -> Bool {
    
    switch conformeA {
        
    case .stringa:
     return csCheckStringa(testo: testo)
    case .intero:
      return csCheckIntero(testo: testo)
    case .decimale:
        return csCheckDouble(testo: testo)
       
    }

}

func csCheckIntero(testo:String) -> Bool { Int(testo) != nil }
func csCheckDouble(testo:String) -> Bool  {
    // dovrebbe usare una keyboard di tipo decimalPad, che usa la virgola come separatore, e sempre la virgola è l'unico caratttere extra rispetto ai numeri
    let newText  = testo.replacingOccurrences(of: ",", with: ".")
    return Double(newText) != nil
    
}

func csCheckStringa(testo:String) -> Bool {
    print("csCheckStringa non implementato")
 return true
}




enum ConformitàTextField {
     
     case stringa
     case intero
     case decimale
     
 }
