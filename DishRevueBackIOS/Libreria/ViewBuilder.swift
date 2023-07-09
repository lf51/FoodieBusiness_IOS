//
//  ViewBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/04/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage


/// Ritorna l'immagine associata allo Status del Modello
@ViewBuilder func vbEstrapolaStatusImage<M:MyProStatusPack_L0>(itemModel:M,dashedColor:Color) -> some View {
    // M passa da MyModelStatusConformity a MyProStatusPackL0
   
    let image = itemModel.status.imageAssociated()
    let color = itemModel.status.transitionStateColor()

    csCircleDashed(
        internalCircle: image,
        internalColor: color,
        dashedColor: dashedColor)
    
       /* ZStack {
            
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(color)
                .zIndex(0)
            
            Image(systemName: "circle.dashed")
                .imageScale(.large)
                .foregroundColor(dashedColor)
                .zIndex(1)
            
        } */
       
}

/// Versione custom del circle.dashed.inset.filled. L'immagine internal, internalCircle, può essere customizzata. Chiaramente è preferibile che sia comunque un cerchio. Utile però perchè per le bozze passiamo un martello cerchiato.
func csCircleDashed(internalCircle:String = "circle.fill",internalColor:Color,dashedColor:Color) -> some View {
    
    ZStack {
        
        Image(systemName: internalCircle)
            .imageScale(.small)
            .foregroundColor(internalColor)
            .zIndex(0)
        
        Image(systemName: "circle.dashed")
            .bold()
            .imageScale(.large)
            .foregroundColor(dashedColor)
            .zIndex(1)
        
    }
}

@ViewBuilder func vbMenuInterattivoModuloCambioStatus<M:MyProStatusPack_L1>(myModel: M,viewModel:M.VM) -> some View {

   /* let disableCondition:Bool = {
        
        if let model = myModel as? MenuModel {
            return model.tipologia.isDiSistema()
        }
        return false
    }() */
   
    let generalDisabled = myModel.conditionToManageMenuInterattivo().disableStatus
    let currentStatus = myModel.status
   
    let disableDispoUpdate = myModel.conditionToManageMenuInterattivo_dispoStatusDisabled(viewModel: viewModel)

    Group {
        
        if currentStatus.checkStatusTransition(check: .disponibile) {
                    
            VStack {
                
                Button {
                 
                    myModel.manageCambioStatus(nuovoStatus: .inPausa, viewModel: viewModel)
                    
                } label: {
                    HStack{
                        Text("Metti in Pausa")
                        Image(systemName: "pause.circle")
                        
                    }
                }
                
                Button(role:.destructive) {
                    
                    myModel.manageCambioStatus(nuovoStatus: .archiviato, viewModel: viewModel)
                    
                } label: {
                    HStack{
                        Text("Archivia")
                        Image(systemName: "archivebox")
                      
                    }
                }

            }

        } else if currentStatus.checkStatusTransition(check: .inPausa) {
            
                VStack {
                    
                    Button {

                        myModel.manageCambioStatus(nuovoStatus: .disponibile, viewModel: viewModel)
                       // viewModel.manageCambioStatusModel(model: myModel, nuovoStatus:.disponibile)
                        
                    } label: {
                        HStack{
                            Text("Rendi Disponibile")
                            Image(systemName: "play.circle")
                           
                        }
                    }.disabled(disableDispoUpdate)
                    
                    
                    Button(role:.destructive) {

                        myModel.manageCambioStatus(nuovoStatus: .archiviato, viewModel: viewModel)
                      //  viewModel.manageCambioStatusModel(model: myModel, nuovoStatus: .archiviato)
                        
                    } label: {
                        HStack{
                            Text("Archivia")
                            Image(systemName: "archivebox")
                           
                        }
                    }

                }

        } else if currentStatus.checkStatusTransition(check: .archiviato) {
            
          /*  let disabilita:Bool = {
                if let model = myModel as? MenuModel {
                    return model.rifDishIn.isEmpty // Sviluppare --> deve controllare se ci sono piatti attivi. Senza piatti, o senza piatti attivi, il menu sarebbe vuoto e dunque non avrebbe senso renderlo disponibile
                } else { return false }
                
            }() */

                VStack {
                    
                    Button {

                        myModel.manageCambioStatus(nuovoStatus: .disponibile, viewModel: viewModel)
                     //   viewModel.manageCambioStatusModel(model: myModel, nuovoStatus:.disponibile)
                        
                    } label: {
                        HStack{
                            Text("Rendi Disponibile")
                            Image(systemName: "play.circle")
                           
                        }
                    }//.disabled(disabilita)
                    .disabled(disableDispoUpdate)


                }
        }
        
    }//.disabled(disableCondition)
    .disabled(generalDisabled)
           
}

@ViewBuilder func vbMenuInterattivoModuloEdit<M:MyProStatusPack_L1>(currentModel:M,viewModel:M.VM, navPath:ReferenceWritableKeyPath<M.VM,NavigationPath>) -> some View {
    
    // M passa da MyModelStatusConformity a MyProStatusPackL1
    let generalDisabled = currentModel.conditionToManageMenuInterattivo().disableEdit
    let isBozza = currentModel.status.checkStatusBozza()
    let title = isBozza ? "Completa" : "Modifica"
    
   /* let disableCondition:Bool = {
       
        if let model = currentModel as? MenuModel {
            
            return model.tipologia.isDiSistema()
        }
        
        return false
    }() */
    
 //   VStack {
        
    Button {
          //  viewModel[keyPath: navPath].append(currentModel)
          /*  let currentDestination:DestinationPathView = currentModel.pathDestination()
            viewModel[keyPath: navPath].append(currentDestination) */
        
        let currentDestination:M.DPV = currentModel.pathDestination()
        viewModel[keyPath: navPath].append(currentDestination)
        
            
          } label: {
              HStack{
                  Text(title)
                  Image(systemName: isBozza ? "hammer" : "square.and.pencil")
              }
          }//.disabled(disableCondition)
          .disabled(generalDisabled)
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

@ViewBuilder func vbMenuInterattivoModuloTrash<M:MyProManagingPack_L0>(currentModel:M,viewModel:M.VM) -> some View {
    
    // Nota 27.11
    let generalDisabled = currentModel.conditionToManageMenuInterattivo().disableTrash
    // M passa da MyModelStatusConformity a MyProStatusPackL1
        Button(role:.destructive) {
             currentModel.manageModelDelete(viewModel: viewModel)
            //  viewModel.deleteItemModel(itemModel: currentModel)
            // currentModel.manageModelDelete
              
          } label: {
              HStack{
                  Text("Elimina")
                  Image(systemName: "trash")
              }
          }
          .disabled(generalDisabled)
}

/// Ritorna uno scroll orizzontale degli Allergeni utile per le rowView del Dish e dell'ingredient
@ViewBuilder func vbAllergeneScrollRowView(listaAllergeni:[AllergeniIngrediente]?) -> some View {
    
    let allergens = listaAllergeni ?? []
    
    HStack(spacing: 4.0) {
        
        Image(systemName: "allergens")
            .imageScale(.small)
            .foregroundColor(Color.black)
    
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack(spacing: 2.0) {
                
                if !allergens.isEmpty {
                    
                    let listaA:[String] = estrapolaListaAllergeni(listaAllergeni: allergens)
                    
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

// 21.10 Comparto Recensioni

@ViewBuilder func vbIndicatoreTrendVotoRecensioni(valoreAssociato:Int,trend:Int,coloreAssociato:Color) -> some View {

    // 1 is Negativo / 5 is Positivo / 10 is Top Range / 0 is Neutro - Trend
    
    if valoreAssociato == trend {
        Image(systemName: "arrowtriangle.up.fill")
            .foregroundColor(coloreAssociato)
        
    }
    else if trend == 0 {
        Image(systemName: "minus")
            .foregroundColor(Color.gray)
    }
    
    // Special case
    
    else if trend == 10 && valoreAssociato == 5 {
        Image(systemName: "arrowtriangle.up")
            .foregroundColor(coloreAssociato)
    }
            
}

@ViewBuilder func vbTrendCompletezzaRecensioni(trendValue:Int) -> some View {

    if trendValue == 1 {
        Image(systemName: "arrowtriangle.down")
            .foregroundColor(Color.red)
    }
    else {
        Image(systemName: "arrowtriangle.up.fill")
            .foregroundColor(Color.green)
    }

}

/*
@ViewBuilder func vbMediaL10(mediaGen:Double,mediaL10:Double) -> some View {

    if mediaL10 == mediaGen {
        Image(systemName: "minus")
            .foregroundColor(Color.gray)
    }
    else if mediaL10 > mediaGen {
        Image(systemName: "arrowtriangle.up.fill")
            .foregroundColor(Color.green)
    }
    else {
        Image(systemName: "arrowtriangle.down")
            .foregroundColor(Color.red)
    }
    
}*/ // 07.02.23 Ricollocato in MyFoodiePackage
// end comparto Recensioni
