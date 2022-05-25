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
func csCheckDouble(testo:String) -> Bool  { Double(testo) != nil }
func csCheckStringa(testo:String) -> Bool {
    // da implementare
 return true
}




enum ConformitàTextField {
     
     case stringa
     case intero
     case decimale
     
 }
