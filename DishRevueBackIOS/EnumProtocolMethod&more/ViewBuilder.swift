//
//  ViewBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/04/22.
//

import Foundation
import SwiftUI

/// ViewBuilder - Passare una emojy o il systenName di una Image. Il nil ritorna una circle Image
/// - Parameter string: <#string description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchImageText(string: String?) -> some View { // verifica che la stringa contiene un solo carattere, in tal caso diamo per "certo" si tratti una emnojy e la trattiamo come testo. Utilizzato per CsLabel1 in data 08.04
    
        if let imageName = string {
            
            if imageName.count == 1 {Text(imageName)}
            else {Image(systemName: imageName)}
            
        } else { Image(systemName: "circle") }

}

/// ViewBuilder - Riconosce il modello e ritorna la rowView associata
/// - Parameter item: <#item description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchModelRowView<M:MyModelProtocol>(item: M) -> some View {
     
     switch item.self {
         
     case is MenuModel:
         MenuModel_RowView(item: item as! MenuModel)
         
     case is DishModel:
         DishModel_RowView(item: item as! DishModel)
 
     case is IngredientModel:
         IngredientModel_RowView(item: item as! IngredientModel)
         
     default:  Text("item is a notListed Type")
         
     }
 }

///ZStack con Sfondo Colorato, NavigationTitle e backgroundOpacity a livello tabBar
struct CSZStackVB<Content:View>:View {
    
    let title: String
    let backgroundColorView:Color
    @ViewBuilder var content: Content
    
    var body: some View {
        
        ZStack {
            
            backgroundColorView.edgesIgnoringSafeArea(.top)
            
            content
            
        }
        .background(backgroundColorView.opacity(0.4))
        .navigationTitle(Text(title))
    }
}



///ZStack con RoundedRectangle di sfondo, framed
struct CSZStackVB_Framed<Content:View>:View {
        
        @ViewBuilder var content: Content
        
        var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.opacity(0.3))
                    .shadow(radius: 3.0)
                
                content
                
            }
            .frame(width: 300, height: 150)
           
        }
    }
