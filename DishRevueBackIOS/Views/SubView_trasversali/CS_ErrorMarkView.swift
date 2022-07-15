//
//  CheckMark.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/05/22.
//

import SwiftUI

/// lf51 - Error Mark View alla base del modifier, da utilizzare come View in linea.
struct CS_ErrorMarkView:View {
    
    let generalErrorCheck: Bool
    let localErrorCondition:Bool
    
    var body: some View {
        
        if generalErrorCheck {
            
            if localErrorCondition {
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .imageScale(.medium)
                    .foregroundColor(Color.red)
                }
        }
   
    }
    
}

/*
struct CS_ErrorMark_Previews: PreviewProvider {
    static var previews: some View {
        CS_ErrorMark(checkError: )
    }
}
*/
