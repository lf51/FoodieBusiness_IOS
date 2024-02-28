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

@ViewBuilder func vbMenuInterattivoModuloCambioStatus<M:MyProTransitionGetPack_L01&MyProTransitionSetPack_L02>(myModel: M,viewModel:M.VM) -> some View {

    let statusTransition = myModel.getStatusTransition(viewModel: viewModel)
    let generalDisable = myModel.generalDisableSetStatusTransition(viewModel: viewModel)

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
                    }//.disabled(disabilita.upToDisponibile)
                    
                    
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
                    }//.disabled(disabilita.upToDisponibile)

                }
        }
       
    }.disabled(generalDisable)
}

@ViewBuilder func vbMenuInterattivoModuloEdit<M:MyProEditingPack_L0&MyProNavigationPack_L0&MyProVMPack_L0>(currentModel:M,viewModel:M.VM, navPath:ReferenceWritableKeyPath<M.VM,NavigationPath>) -> some View {
    
    let generalDisabled = currentModel.disabilitaEditing(viewModel: viewModel)

    Button {

        let currentDestination:M.DPV = currentModel.pathDestination()
        viewModel[keyPath: navPath].append(currentDestination)
        
            
          } label: {
              HStack{
                  Text("Modifica")
                  Image(systemName:"square.and.pencil")
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
