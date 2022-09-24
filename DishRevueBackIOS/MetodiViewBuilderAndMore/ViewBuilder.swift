//
//  ViewBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/04/22.
//

import Foundation
import SwiftUI

/*
/// Deprecata in futuro -- usare csVbSwitchImageText(string: String?,size:Image.Scale)
/// - Parameter string: <#string description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchImageText(string: String?) -> some View { // verifica che la stringa contiene un solo carattere, in tal caso diamo per "certo" si tratti una emojy e la trattiamo come testo. Utilizzato per CsLabel1 in data 08.04
    
        if let imageName = string {
            
            if imageName.count == 1 {Text(imageName)}
            else {Image(systemName: imageName)}
            
        } else { Image(systemName: "circle") }

} */ // deprecata 07.09

/// ViewBuilder - Passare una emojy o il systenName di una Image. Il nil ritorna una circle Image
/// - Parameter string: <#string description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchImageText(string: String?, size: Image.Scale = .medium,slash:Bool = false) -> some View { // verifica che la stringa contiene un solo carattere, in tal caso diamo per "certo" si tratti una emnojy e la trattiamo come testo. Utilizzato per CsLabel1 in data 08.04
    
        if let imageName = string {
            
            if imageName.count == 1 {
                
                switch size {
                    
                case .small:
                    Text(imageName)
                        .font(.caption2)
                        .overlay {
                            if slash {
                                Image(systemName: "circle.slash")
                                    .imageScale(.small)
                                    .foregroundColor(Color.white)
                            }
                        }
                case .medium:
                    Text(imageName)
                        .font(.caption)
                        .overlay {
                            if slash {
                                Image(systemName: "circle.slash")
                                    .imageScale(.medium)
                                    .foregroundColor(Color.white)
                            }
                        }
                case .large:
                    Text(imageName)
                        .font(.callout)
                        .overlay {
                            if slash {
                                Image(systemName: "circle.slash")
                                    .imageScale(.large)
                                    .foregroundColor(Color.white)
                            }
                        }
                @unknown default:
                    Text(imageName)
                        .font(.caption)
                        .overlay {
                            if slash {
                                Image(systemName: "circle.slash")
                                    .imageScale(.medium)
                                    .foregroundColor(Color.white)
                            }
                        }

                }
   
            }
            else {
                Image(systemName: imageName)
                    .imageScale(size)
                    .overlay {
                        if slash {
                            Image(systemName: "circle.slash")
                                .imageScale(size)
                                .foregroundColor(Color.white)
                        }
                    }

                
            }
            
        } else {
            Image(systemName: "circle.slash")
                .imageScale(size)
                .foregroundColor(Color.white)
            
        }

}

/// Ritorna l'immagine associata allo Status del Modello
@ViewBuilder func vbEstrapolaStatusImage<M:MyProStatusPack_L0>(itemModel:M) -> some View {
    // M passa da MyModelStatusConformity a MyProStatusPackL0
   
    let image = itemModel.status.imageAssociated()
    let color = itemModel.status.transitionStateColor()
    
        Image(systemName: image)
            .imageScale(.large)
            .foregroundColor(color)
        
 
}


/// ViewBuilder - Riconosce il modello e ritorna la rowView associata. Deprecata 19.07 Sostituita da una func nel Protocolo
/// - Parameter item: <#item description#>
/// - Returns: <#description#>
/*@ViewBuilder func csVbSwitchModelRowView<M:MyModelProtocol>(item: M) -> some View {
     
     switch item.self {
         
     case is MenuModel:
         MenuModel_RowView(menuItem: item as! MenuModel)
         
     case is DishModel:
         DishModel_RowView(item: item as! DishModel)
 
     case is IngredientModel:
         IngredientModel_RowView(item: item as! IngredientModel)
         
     case is PropertyModel:
         PropertyModel_RowView(itemModel: item as! PropertyModel)
         
     default:  Text("item is a notListed Type")
         
     }
 } */ // Deprecata 19.07


/*
/// ViewBuilder - Riconosce il modello e ritorna la rowView associata.
/// - Parameter item: <#item description#>
/// - Returns: <#description#>
@ViewBuilder func csVbSwitchModelRowView<M:MyModelProtocol>(itemModel: Binding<M>) -> some View {
     
     switch itemModel.self {
         
     case is Binding<MenuModel>:
         MenuModel_RowView(menuItem: itemModel as! Binding<MenuModel>)
         
     case is Binding<DishModel>:
         DishModel_RowView(item: itemModel as! Binding<DishModel>)
 
     case is Binding<IngredientModel>:
         IngredientModel_RowView(item: itemModel as! Binding<IngredientModel>)
         
     case is Binding<PropertyModel>:
         PropertyModel_RowView(itemModel: itemModel as! Binding<PropertyModel>)
         
     default:
         Text("ItemModel type not lysted")
         
     }
 } */ // Deprecata il 28.06 per ritorno a delle Row senza Binding



///ZStack con Sfondo Colorato, NavigationTitle e backgroundOpacity a livello tabBar. Standard ListModelView
struct CSZStackVB<Content:View>:View {
    
    let title: String
    let backgroundColorView:Color
    @ViewBuilder var content: Content
    
    var body: some View {
        
        ZStack {

           // backgroundColorView.edgesIgnoringSafeArea(.top).zIndex(0)
            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.top)
                .zIndex(0)
            content.zIndex(1)
            
        }
        .background(backgroundColorView.opacity(0.6))
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

/*
///ZStack con RoundedRectangle di sfondo, rapporto base/altezza custom (rateWH -> default 2:1 | 400/200).MaxWidth: larghezza Schermo - 20 punti
struct CSZStackVB_Framed<Content:View>:View {
        
        var frameWidth: CGFloat = 400//300
        var rateWH: CGFloat = 0.5
        var backgroundOpacity: Double = 0.3
     //   var frameHeight: CGFloat { frameWidth * rateWH }
        var frameHeight: CGFloat = 80
      
        @ViewBuilder var content: Content
        
        let screenWidth:CGFloat = UIScreen.main.bounds.width
    
        var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.gradient.opacity(backgroundOpacity))
                    .shadow(color:Color.black,radius: 5.0)
                    .zIndex(0)
                
                content
                  //  .padding(.horizontal)
                    .zIndex(1)
                
              /*  VStack {
                    
                    Text("screenWidth:\(screenWidth)")
                    
                    Text("frameWidth:\(frameWidth)")
                    Text("frameHeight:\(frameHeight)")
                    
                    Text("maxWidth: \(screenWidth - 20)")
                    Text("maxHeight: \((screenWidth - 20) * rateWH)")
                    
                }
                .padding(.vertical)
                .zIndex(1) */
            
                
                
              /*  Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("SeaTurtlePalette_1"))
                  // .offset(x: 10, y: 10)
                    .zIndex(2) */
                
            }
            
          //  .padding(.horizontal)
            .frame(maxHeight: (screenWidth - 20) * rateWH )
            .frame(maxWidth: screenWidth - 20) // fisso un limite max che permetterà di scalare sugli schermi più stretti
            
            .frame(width: frameWidth, height: frameHeight)
           // .padding(.vertical)
            
           // .frame(width: frameWidth < 400 ? frameWidth : 400)
           // .frame(height: frameHeight < 200 ? frameHeight : 200)
        }
    }*/ // BackUp 23.08

/*
///ZStack con RoundedRectangle di sfondo, rapporto base/altezza custom (rateWH -> default 2:1 | 300/150).MaxWidth: 400.
struct CSZStackVB_Framed<Content:View>:View {
        
        var frameWidth: CGFloat = 300
        var rateWH: CGFloat = 0.5
        var backgroundOpacity: Double = 0.3
        var frameHeight: CGFloat { frameWidth * rateWH }
        @ViewBuilder var content: Content
        
        var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.gradient.opacity(backgroundOpacity))
                    .shadow(color:Color.black,radius: 5.0)
                    .zIndex(0)
                
                content
                    .zIndex(1)
                
            }
            .frame(maxWidth: 400)
            .frame(width: frameWidth < 400 ? frameWidth : 400, height: frameHeight)
        }
    } */ // BAckUp 21.08 - Prova modifica larghezza

///ZStack con RoundedRectangle di sfondo, rapporto base/altezza custom (rateWH -> default 2:1 | 400/200).MaxWidth: larghezza Schermo - 20 punti
struct CSZStackVB_Framed<Content:View>:View {
        
        var frameWidth: CGFloat
        var backgroundOpacity: Double
    
        @ViewBuilder var content: Content

    // Modificato 01.09
    init(frameWidth: CGFloat = 650, backgroundOpacity: Double = 0.3, content: () -> Content) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 30
       // self.frameWidth = frameWidth > screenWidth ? screenWidth : frameWidth
        self.frameWidth = .minimum(frameWidth, screenWidth)
        self.backgroundOpacity = backgroundOpacity
        self.content = content()
    }
    // Vedi Nota Vocale 01.09
        var body: some View {
            
            ZStack(alignment:.leading) {
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.gradient.opacity(backgroundOpacity))
                    .shadow(color:Color.black,radius: 5.0)
                    .zIndex(0)
                
                content
                    .zIndex(1)
       
            }
           // .background(Color.red.opacity(0.4))
          //  .frame(maxHeight: (screenWidth - 20) * rateWH )
           // .frame(maxWidth: screenWidth - 20) // fisso un limite max che permetterà di scalare sugli schermi più stretti
            .frame(width:frameWidth)
          //  .frame(width: frameWidth, height: frameHeight)
          
        }
    }

/*
/// Gestisce il Menu della RowModel in base al cambio di Status. Generic conforme al MyModelStatusConformity
@ViewBuilder func vbCambioStatusModelList<M:MyModelStatusConformity>(myModel: Binding<M>,viewModel:AccounterVM, navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
    
    let currentModel = myModel.wrappedValue
    
    if currentModel.status == .completo(.disponibile) {
                
        VStack {
            
            Button {
                myModel.wrappedValue.status = .completo(.inPausa)
                
            } label: {
                HStack{
                    Text("Metti in Pausa")
                    Image(systemName: "pause.circle")
                }
            }
            
            Button {
                myModel.wrappedValue.status = .completo(.archiviato)
                
            } label: {
                HStack{
                    Text("Archivia")
                    Image(systemName: "archivebox")
                }
            }
            
            vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath)
        }

        
    } else if currentModel.status == .completo(.inPausa) {
        
            VStack {
                
                Button {
                    myModel.wrappedValue.status = .completo(.disponibile)
                    
                } label: {
                    HStack{
                        Text("Pubblica")
                        Image(systemName: "play.circle")
                    }
                }
                
                Button {
                    myModel.wrappedValue.status = .completo(.archiviato)
                    
                } label: {
                    HStack{
                        Text("Archivia")
                        Image(systemName: "archivebox")
                    }
                }
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath)
            }
        
    } else if currentModel.status == .completo(.archiviato) {
        
            VStack {
                
                Button {
                    myModel.wrappedValue.status = .completo(.disponibile)
                    
                } label: {
                    HStack{
                        Text("Pubblica")
                        Image(systemName: "play.circle")
                    }
                }
                
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath)

            }
    } else if currentModel.status == .bozza() {
        
        VStack {
                
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath, titleOne: "Completa Bozza")
                
            }
        
    }
           
} */ // deprecata 07.09


/// Add 07.09 - Gestisce il Modulo di cambio Status del Menu interattivo delle RowView dei model conformi al protocollo MyProStatusPackL1
@ViewBuilder func vbMenuInterattivoModuloCambioStatus<M:MyProStatusPack_L1>(myModel: Binding<M>) -> some View {
    
    // M passa da MyModelProtocol a MyProStatusPackL1
    
    let currentModel = myModel.wrappedValue
    
   // if currentModel.status == .completo(.disponibile) {
    if currentModel.status.checkStatusTransition(check: .disponibile) {
                
        VStack {
            
            Button {
               // myModel.wrappedValue.status = .completo(.inPausa)
                myModel.wrappedValue.status = currentModel.status.changeStatusTransition(changeIn: .inPausa)
                
            } label: {
                HStack{
                    Text("Metti in Pausa")
                    Image(systemName: "pause.circle")
                    
                }
            }
            
            Button {
              //  myModel.wrappedValue.status = .completo(.archiviato)
                myModel.wrappedValue.status = currentModel.status.changeStatusTransition(changeIn: .archiviato)
                
            } label: {
                HStack{
                    Text("Archivia")
                    Image(systemName: "archivebox")
                  
                }
            }
            
          //  vbMenuInterattivoModuloTrashEdit(currentModel: currentModel, viewModel: viewModel, navPath: navPath)
        }

        
  //  } else if currentModel.status == .completo(.inPausa) {
    } else if currentModel.status.checkStatusTransition(check: .inPausa) {
        
            VStack {
                
                Button {
                   // myModel.wrappedValue.status = .completo(.disponibile)
                    myModel.wrappedValue.status = currentModel.status.changeStatusTransition(changeIn: .disponibile)
                    
                } label: {
                    HStack{
                        Text("Rendi Disponibile")
                        Image(systemName: "play.circle")
                       
                    }
                }
                
                Button {
                  //  myModel.wrappedValue.status = .completo(.archiviato)
                    myModel.wrappedValue.status = currentModel.status.changeStatusTransition(changeIn: .archiviato)
                    
                } label: {
                    HStack{
                        Text("Archivia")
                        Image(systemName: "archivebox")
                       
                    }
                }
             //   vbMenuInterattivoModuloTrashEdit(currentModel: currentModel, viewModel: viewModel, navPath: navPath)
            }
        
   // } else if currentModel.status == .completo(.archiviato) {
    } else if currentModel.status.checkStatusTransition(check: .archiviato) {
        
        let disabilita:Bool = {
            if let model = currentModel as? MenuModel {
                return model.rifDishIn.isEmpty // Sviluppare --> deve controllare se ci sono piatti attivi. Senza piatti, o senza piatti attivi, il menu sarebbe vuoto e dunque non avrebbe senso renderlo disponibile
            } else { return false }
            
        }()

            VStack {
                
                Button {
                  //  myModel.wrappedValue.status = .completo(.disponibile)
                    myModel.wrappedValue.status = currentModel.status.changeStatusTransition(changeIn: .disponibile)
                    
                } label: {
                    HStack{
                        Text("Rendi Disponibile")
                        Image(systemName: "play.circle")
                       
                    }
                }.disabled(disabilita)
                
            //    vbMenuInterattivoModuloTrashEdit(currentModel: currentModel, viewModel: viewModel, navPath: navPath)

            }
    } /*else if currentModel.status == .bozza(nil) {
        
        VStack {
                
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath, titleOne: "Completa Bozza")
                
            }
        
    } */
           
}


/// Gestisce il Menu della RowModel in base al cambio di Status. Generic conforme al MyModelStatusConformity
/*@ViewBuilder func vbCambioStatusModelList<M:MyModelStatusConformity>(myModel: Binding<M>,viewModel:AccounterVM, navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
    
    let currentModel = myModel.wrappedValue
    
    if currentModel.status == .completo(.pubblico) {
        
        GenericItemModel_RowViewMask(
            model: currentModel) {
                
                Button {
                    myModel.wrappedValue.status = .completo(.inPausa)
                    
                } label: {
                    HStack{
                        Text("Metti in Pausa")
                        Image(systemName: "pause.circle")
                    }
                }
                
                Button {
                    myModel.wrappedValue.status = .completo(.archiviato)
                    
                } label: {
                    HStack{
                        Text("Archivia")
                        Image(systemName: "archivebox")
                    }
                }
                
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath)
                
            }
        
    } else if currentModel.status == .completo(.inPausa) {
        
        GenericItemModel_RowViewMask(
            model: currentModel) {
                
                Button {
                    myModel.wrappedValue.status = .completo(.pubblico)
                    
                } label: {
                    HStack{
                        Text("Pubblica")
                        Image(systemName: "play.circle")
                    }
                }
                
                Button {
                    myModel.wrappedValue.status = .completo(.archiviato)
                    
                } label: {
                    HStack{
                        Text("Archivia")
                        Image(systemName: "archivebox")
                    }
                }
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath)
            }
    } else if currentModel.status == .completo(.archiviato) {
        
        GenericItemModel_RowViewMask(
            model: currentModel) {
                
                Button {
                    myModel.wrappedValue.status = .completo(.pubblico)
                    
                } label: {
                    HStack{
                        Text("Pubblica")
                        Image(systemName: "play.circle")
                    }
                }
                
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath)

            }
    } else if currentModel.status == .bozza {
        
        GenericItemModel_RowViewMask(
            model: currentModel) {
                
                vbScopoDestinazionePathButton(currentModel: currentModel, viewModel: viewModel, navPath: navPath, titleOne: "Completa Bozza")
                
            }
        
    }
           
} */ // Deprecato. Portato fuori la View Generic e creato un viewBulder che ritorna una lista di bottoni che valgono per tutti i myModel

@ViewBuilder func vbMenuInterattivoModuloEdit<M:MyProStatusPack_L1>(currentModel:M,viewModel:AccounterVM, navPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
    
    // M passa da MyModelStatusConformity a MyProStatusPackL1
    
    let isBozza = currentModel.status.checkStatusBozza()
    let title = isBozza ? "Completa" : "Modifica"
    
 //   VStack {
        
        Button {
          //  viewModel[keyPath: navPath].append(currentModel)
            let currentDestination:DestinationPathView = currentModel.pathDestination()
            viewModel[keyPath: navPath].append(currentDestination)
            
          } label: {
              HStack{
                  Text(title)
                  Image(systemName: isBozza ? "hammer" : "square.and.pencil")
              }
          }

     /*   Button(role:.destructive) {
            
              viewModel.deleteItemModel(itemModel: currentModel)
              
          } label: {
              HStack{
                  Text("Elimina")
                  Image(systemName: "trash")
              }
          } */
        
   // }
   
}

@ViewBuilder func vbMenuInterattivoModuloTrash<M:MyProStatusPack_L1>(currentModel:M,viewModel:AccounterVM) -> some View {
    
    // M passa da MyModelStatusConformity a MyProStatusPackL1
        Button(role:.destructive) {
            
              viewModel.deleteItemModel(itemModel: currentModel)
              
          } label: {
              HStack{
                  Text("Elimina")
                  Image(systemName: "trash")
              }
          }
}

/*
/// Ritorna uno scroll orizzontale degli Allergeni utile per le rowView del Dish e dell'ingredient
@ViewBuilder func vbAllergeneScrollRowView(listaAllergeni:[AllergeniIngrediente]) -> some View {
    
    HStack(spacing: 4.0) {
        
        Image(systemName: "allergens")
            .imageScale(.small)
            .foregroundColor(Color.black)
    
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack(spacing: 2.0) {
                
                if !listaAllergeni.isEmpty {
                    
                    ForEach(listaAllergeni) { allergene in
                        
                        if listaAllergeni[0] != allergene {
                            Text("•")
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                        }
                        
                        Text(allergene.simpleDescription().replacingOccurrences(of: " ", with: ""))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .italic()
      
                    }
                    
                } else {
                    Text("Nessun Allergene indicato")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                }
                
             
                
            }
        }
    }
} */ // Deprecata 24.08
/// Ritorna uno scroll orizzontale degli Allergeni utile per le rowView del Dish e dell'ingredient
@ViewBuilder func vbAllergeneScrollRowView(listaAllergeni:[AllergeniIngrediente]) -> some View {
    
    HStack(spacing: 4.0) {
        
        Image(systemName: "allergens")
            .imageScale(.small)
            .foregroundColor(Color.black)
    
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack(spacing: 2.0) {
                
                if !listaAllergeni.isEmpty {
                    
                    let listaA:[String] = estrapolaListaAllergeni(listaAllergeni: listaAllergeni)
                    
                    Text(listaA,format: .list(type: .and))
                        .italic()
                        .fontWeight(.semibold)
                        .font(.caption)
                        .foregroundColor(Color.black)
 
                    
                } else {
                    Text("Nessun Allergene indicato")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                }   
            }
        }
    }
}

/// Crea un Array di stringhe con i nomi degli allergeni
private func estrapolaListaAllergeni(listaAllergeni:[AllergeniIngrediente]) -> [String] {
    
    var lista:[String] = []
    
    for allergene in listaAllergeni {
        
        let allergeneName = allergene.simpleDescription()
        lista.append(allergeneName)
        
    }
    
    return lista
}
