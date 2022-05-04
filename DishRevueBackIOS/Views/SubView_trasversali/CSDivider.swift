//
//  CSDivider.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/05/22.
//

import SwiftUI

struct CSDivider: View {
    
    var isVisible:Bool? = false
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10.0) // da lo stacco per evitare l'inline.
            .frame(height: 2.0)
            .foregroundColor(isVisible! ? Color.white : Color.cyan) // Color.cyan lo rende invisibile
        
    }
 
}
