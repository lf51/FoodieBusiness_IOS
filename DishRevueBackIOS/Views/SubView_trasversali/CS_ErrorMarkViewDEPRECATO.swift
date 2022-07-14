//
//  CheckMark.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/05/22.
//

import SwiftUI

/// DEPRECATO in Futuro -> Sostituire con il ViewModifier .csErrorMark
struct CS_ErrorMarkViewDEPRECATO:View {
    
    let checkError:Bool
    
    var body: some View {
        
        if checkError {
            Image(systemName: "exclamationmark.triangle.fill")
                .imageScale(.medium)
                .foregroundColor(Color.yellow)
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
