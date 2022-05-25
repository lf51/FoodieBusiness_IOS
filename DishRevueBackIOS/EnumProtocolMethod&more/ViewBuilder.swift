//
//  ViewBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/04/22.
//

import Foundation
import SwiftUI


/// Deprecata in futuro -- usare csVbSwitchImageText(string: String?,size:Image.Scale)
/// - Parameter string: <#string description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchImageText(string: String?) -> some View { // verifica che la stringa contiene un solo carattere, in tal caso diamo per "certo" si tratti una emnojy e la trattiamo come testo. Utilizzato per CsLabel1 in data 08.04
    
        if let imageName = string {
            
            if imageName.count == 1 {Text(imageName)}
            else {Image(systemName: imageName)}
            
        } else { Image(systemName: "circle") }

}

/// ViewBuilder - Passare una emojy o il systenName di una Image. Il nil ritorna una circle Image
/// - Parameter string: <#string description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchImageText(string: String?, size: Image.Scale) -> some View { // verifica che la stringa contiene un solo carattere, in tal caso diamo per "certo" si tratti una emnojy e la trattiamo come testo. Utilizzato per CsLabel1 in data 08.04
    
        if let imageName = string {
            
            if imageName.count == 1 {
                
                switch size {
                    
                case .small:
                    Text(imageName)
                        .font(.caption2)
                 
                case .medium:
                    Text(imageName)
                        .font(.caption)
                    
                case .large:
                    Text(imageName)
                        .font(.callout)
                    
                @unknown default:
                    Text(imageName)
                        .font(.caption)
                }
   
            }
            else {
                Image(systemName: imageName)
                    .imageScale(size)
                
            }
            
        } else {
            Image(systemName: "circle")
                .imageScale(size)
            
        }

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

///ZStack con Sfondo Colorato, NavigationTitle e backgroundOpacity a livello tabBar. Standard ListModelView
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

/* // Deprecated 21.05
///ZStack con RoundedRectangle di sfondo, framed. Standard RowView. MaxWidth/Height: 400/200. Default -> 300/150
struct CSZStackVB_Framed<Content:View>:View {
        
        var frameWidth: CGFloat? = 300
        var backgroundOpacity: Double? = 0.3
        private var frameHeight: CGFloat { frameWidth! / 2 }
        @ViewBuilder var content: Content
        
        var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.opacity(backgroundOpacity!))
                    .shadow(radius: 3.0)
                
                content
                
            }
            .frame(maxWidth: 400, maxHeight: 200) // --> Mettiamo un limite alla larghezza. In questo modo possiamo variare la larghezza, sapendo che comunque, qualora nel frameWidth usassimo .infinity non andremmo a superare i maxWidth point. In questo modo ad esmpio, su iphone copriamo l'intera larghezza, mentre sul pad copriamo 500 punti. Occorre lavorare in questo modo, impostando l'altezza in proporzione della larghezza.
            .frame(width: frameWidth! < 400 ? frameWidth! : 400, height: frameHeight < 200 ? frameHeight : 200)
        }
    } */


///ZStack con RoundedRectangle di sfondo, rapporto base/altezza custom (rateWH -> default 2:1 | 300/150).MaxWidth: 400.
struct CSZStackVB_Framed<Content:View>:View {
        
        var frameWidth: CGFloat? = 300
        var rateWH: CGFloat? = 0.5
        var backgroundOpacity: Double? = 0.3
        var frameHeight: CGFloat { frameWidth! * rateWH! }
        @ViewBuilder var content: Content
        
        var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.opacity(backgroundOpacity!))
                    .shadow(radius: 3.0)
                
                content
                
            }
            .frame(maxWidth: 400)
            .frame(width: frameWidth! < 400 ? frameWidth! : 400, height: frameHeight)
        }
    }
