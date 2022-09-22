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
    // In base alle impostazioni di sistema la tastiera decimale da un seperatore diverso, o il punto o la virgola. Il problema è che se si usa la virgola non mi riconosce il numero come double per cui la convertiamo in punto.
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
