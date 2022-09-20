//
//  CheckTestoTextField.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import Foundation
import SwiftUI

/// Esegue un check di convalida sulla stringa di un TextField e ritorna una Image. Non esegue alcuna azione.
func csVisualCheck(testo:String, staticImage:String, editingImage:String? = nil, imageScale:Image.Scale = .medium, conformeA:ConformitàTextField) -> some View {
    
    guard testo != "" else {
        
        return Image(systemName: staticImage).imageScale(imageScale).foregroundColor(Color.gray)
                   
    }
    
   let isConforme = csCheckConformitaTextField(testo: testo, conformeA: conformeA)
    
    if isConforme {
        
        return Image(systemName: editingImage ?? "circle")
            .imageScale(imageScale)
            .foregroundColor(Color.green)
        
    } else {
        
        return Image(systemName: "exclamationmark.circle")
            .imageScale(imageScale)
            .foregroundColor(Color.red)
    }
}


func csCheckConformitaTextField(testo:String, conformeA: ConformitàTextField ) -> Bool {
    
    switch conformeA {
        
    case .stringa(let lenght):
     return csCheckStringa(testo: testo, minLenght: lenght)
    case .intero:
      return csCheckIntero(testo: testo)
    case .decimale:
        return csCheckDouble(testo: testo)
       
    }

}

func csCheckIntero(testo:String) -> Bool { Int(testo) != nil }
func csCheckDouble(testo:String) -> Bool  {
    // dovrebbe usare una keyboard di tipo decimalPad, che usa la virgola come separatore, e sempre la virgola è l'unico caratttere extra rispetto ai numeri
    let newText = testo.replacingOccurrences(of: ",", with: ".")
    return Double(newText) != nil
    
}

/// Esegue un check sulla lunghezza della string. Teniamo lo stringCleaner fuori, perchè modifica la stringa di partenza
func csCheckStringa(testo:String, minLenght: Int) -> Bool {
    print("inside csCheckStringa")
    return testo.count >= minLenght
}

enum ConformitàTextField {
     
     case stringa(minLenght:Int = 5)
     case intero
     case decimale
     
 }
