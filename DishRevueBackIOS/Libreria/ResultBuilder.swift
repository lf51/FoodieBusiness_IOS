//
//  ResultBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/11/23.
//

import Foundation
import SwiftUI

@resultBuilder
struct DialogBuilder {

    static func buildBlock(_ components: DialogButtonElement...) -> some View {

        let values = components.compactMap({
            if $0.checkCondition() { return $0 }
            else { return nil }
        })
        
       return ForEach(values,id:\.label) { element in
            
           let label:String = {
              
               if let extra = element.extraLabel {
                   
                   return "\(element.label.rawValue) \(extra)"
                   
               } else {
                   return element.label.rawValue
               }
               
           }()
           
           Button(label, role: element.role) {

                element.action()
                

            }

        }
    }
    
}

@ViewBuilder func csBuilderDialogButton(@DialogBuilder _ content: () -> some View) -> some View {
   
    content()
}


struct DialogButtonElement {
    
    let label:DialogButtonLabel
    var extraLabel:String? = nil
    var role:ButtonRole? = .none
    var checkCondition:() -> Bool = { true }
    let action:() -> Void
    
    enum DialogButtonLabel:String {
            
        case saveEsc = "Salva ed Esci"
        case saveNew = "Salva e Crea Nuovo"
        
        case saveModEsc = "Salva Modifiche ed Esci"
        case saveModNew = "Salva Modifiche e Crea Nuovo"
        
        case saveAsNew = "Salva come Nuovo"
        case validate = "Convalida Acquisti"
        
        case allAvaible = "Cambia tutti in 'disponibile'" // deprecato
        case onlyInPausa = "Cambia solo quelli 'in Pausa'" // deprecato
        
    }
}


