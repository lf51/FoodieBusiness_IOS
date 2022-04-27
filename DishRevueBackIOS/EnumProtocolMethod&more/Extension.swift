//
//  Extension.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation
import SwiftUI

extension View {
    
    func csAlertModifier(isPresented: Binding<Bool>, item: AlertModel?) -> some View {
        
        self.modifier(CS_AlertModifier(isPresented: isPresented, item: item))
        
    }
    
    
}
