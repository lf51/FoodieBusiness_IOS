//
//  ActionModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation
import SwiftUI

struct ActionModel {
    
    let title: TitleAction
    let action: () -> Void
    
    enum TitleAction:String {
        
        case elimina
        case conferma
        case prosegui
        case continua
        case salva
    }
}
