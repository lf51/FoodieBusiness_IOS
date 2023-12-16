//
//  ViewBuilder.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/04/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyPackView_L0


/// Ritorna l'immagine associata allo Status del Modello
/*@ViewBuilder func vbEstrapolaStatusImage<M:MyProStatusPack_L01>(itemModel:M,dashedColor:Color) -> some View {
   
    let image = itemModel.status.imageAssociated()
    let color = itemModel.statusTransition.colorAssociated()
  //  let dashedColor = itemModel.statusScorte().coloreAssociato()

    csCircleDashed(
        internalCircle: image,
        internalColor: color,
        dashedColor: dashedColor)
 
}*/ // deprecato

@ViewBuilder func vbEstrapolaStatusImage<M:MyProStatusPack_L02&MyProStarterPack_L01>(itemModel:M,viewModel:AccounterVM) -> some View where M.VM == AccounterVM {
   
    let visualData = itemModel.visualStatusDescription(viewModel: viewModel)
    
    let image = visualData.internalImage 
    let color = visualData.internalColor
    let dashedColor = visualData.externalColor
    let description = visualData.description

    csCircleDashed(
        internalCircle: image,
        internalColor: color,
        dashedColor: dashedColor)
    .onTapGesture {
        
        viewModel.alertItem = AlertModel(
            title: "\(itemModel.intestazione)",
            message: description)
    }
 
}

/// Versione custom del circle.dashed.inset.filled. L'immagine internal, internalCircle, può essere customizzata. Chiaramente è preferibile che sia comunque un cerchio. Utile però perchè per le bozze passiamo un martello cerchiato.
func csCircleDashed(internalCircle:String = "circle.fill",internalColor:Color,dashedColor:Color) -> some View {
    
    ZStack {
        
        Image(systemName: internalCircle)
            .imageScale(.small)
            .foregroundStyle(internalColor)
            .zIndex(0)
        
        Image(systemName: "circle.dashed")
            .bold()
            .imageScale(.large)
            .foregroundStyle(dashedColor)
            .zIndex(1)
        
    }
}

/*@ViewBuilder func vbMenuInterattivoModuloCambioStatus<M:MyProStatusPack_L1>(myModel: M,viewModel:M.VM) -> some View {

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
           
}*/ // deprecato 06_12_23

@ViewBuilder func vbMenuInterattivoModuloCambioStatus<M:MyProStatusPack_L1>(myModel: M,viewModel:M.VM) -> some View {

    let statusTransition = myModel.getStatusTransition(viewModel: viewModel)
    let disabilita = myModel.disabilitaSetStatusTransition(viewModel: viewModel)

    Group {
        if statusTransition == .disponibile {
                    
            VStack {
                
                Button {
                    
                    myModel.setStatusTransition(to: .inPausa, viewModel: viewModel)
                    
                } label: {
                    HStack{
                        Text("Metti in Pausa")
                        Image(systemName: "pause.circle")
                        
                    }
                }
                
                Button(role:.destructive) {

                    myModel.setStatusTransition(to: .archiviato, viewModel: viewModel)
                    
                } label: {
                    HStack{
                        Text("Archivia")
                        Image(systemName: "archivebox")
                      
                    }
                }

            }

        } else if statusTransition == .inPausa {
            
                VStack {
                    
                    Button {

                        myModel.setStatusTransition(to: .disponibile, viewModel: viewModel)
       
                        
                    } label: {
                        HStack{
                            Text("Rendi Disponibile")
                            Image(systemName: "play.circle")
                           
                        }
                    }.disabled(disabilita.upToDisponibile)
                    
                    
                    Button(role:.destructive) {

                        myModel.setStatusTransition(to: .archiviato, viewModel: viewModel)

                        
                    } label: {
                        HStack{
                            Text("Archivia")
                            Image(systemName: "archivebox")
                           
                        }
                    }

                }

        } else if statusTransition == .archiviato {
 
                VStack {
                    
                    Button {

                        myModel.setStatusTransition(to: .disponibile, viewModel: viewModel)
       
                        
                    } label: {
                        HStack{
                            Text("Rendi Disponibile")
                            Image(systemName: "play.circle")
                           
                        }
                    }.disabled(disabilita.upToDisponibile)
                    


                }
        }
       
    }.disabled(disabilita.general)           
}

@ViewBuilder func vbMenuInterattivoModuloEdit<M:MyProStatusPack_L0&MyProEditingPack_L0&MyProNavigationPack_L0&MyProVMPack_L0>(currentModel:M,viewModel:M.VM, navPath:ReferenceWritableKeyPath<M.VM,NavigationPath>) -> some View {
    
    let generalDisabled = currentModel.disabilitaEditing(viewModel: viewModel)
    let isBozza = currentModel.status == .bozza
    let title = isBozza ? "Completa" : "Modifica"

    Button {

        let currentDestination:M.DPV = currentModel.pathDestination()
        viewModel[keyPath: navPath].append(currentDestination)
        
            
          } label: {
              HStack{
                  Text(title)
                  Image(systemName: isBozza ? "hammer" : "square.and.pencil")
              }
          }
          .disabled(generalDisabled)
   
}

@ViewBuilder func vbMenuInterattivoModuloTrash<M:MyProTrashPack_L0>(currentModel:M,viewModel:M.VM) -> some View {

    let generalDisabled = currentModel.disabilitaTrash(viewModel: viewModel)
    
        Button(role:.destructive) {
             currentModel.manageModelDelete(viewModel: viewModel)
              
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
            .foregroundStyle(Color.black)
    
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack(spacing: 2.0) {
                
                if !allergens.isEmpty {
                    
                    let listaA:[String] = estrapolaListaAllergeni(listaAllergeni: allergens)
                    
                    Text(listaA,format: .list(type: .and))
                        .italic()
                        .fontWeight(.semibold)
                        .font(.caption)
                        .foregroundStyle(Color.black)
 
                    
                } else {
                    Text("Nessun Allergene indicato")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black)
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
            .foregroundStyle(coloreAssociato)
        
    }
    else if trend == 0 {
        Image(systemName: "minus")
            .foregroundStyle(Color.gray)
    }
    
    // Special case
    
    else if trend == 10 && valoreAssociato == 5 {
        Image(systemName: "arrowtriangle.up")
            .foregroundStyle(coloreAssociato)
    }
            
}

@ViewBuilder func vbTrendCompletezzaRecensioni(trendValue:Int) -> some View {

    if trendValue == 1 {
        Image(systemName: "arrowtriangle.down")
            .foregroundStyle(Color.red)
    }
    else {
        Image(systemName: "arrowtriangle.up.fill")
            .foregroundStyle(Color.green)
    }

}

/*
@ViewBuilder func vbMediaL10(mediaGen:Double,mediaL10:Double) -> some View {

    if mediaL10 == mediaGen {
        Image(systemName: "minus")
            .foregroundStyle(Color.gray)
    }
    else if mediaL10 > mediaGen {
        Image(systemName: "arrowtriangle.up.fill")
            .foregroundStyle(Color.green)
    }
    else {
        Image(systemName: "arrowtriangle.down")
            .foregroundStyle(Color.red)
    }
    
}*/ // 07.02.23 Ricollocato in MyFoodiePackage
// end comparto Recensioni
