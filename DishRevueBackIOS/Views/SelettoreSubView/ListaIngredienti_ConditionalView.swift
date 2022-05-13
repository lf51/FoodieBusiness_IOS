//
//  ListaIngredienti_ConditionalView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

/// M1 è il modello da Modificare. M2 è il modello da listare. Ex: M1 è la proprietà, M2 è il MenuModel associato alla proprietà
struct ListaIngredienti_ConditionalView<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M1
    @Binding var listaDaMostrare: String
    
    let elencoModelList: [ModelList]
    let itemModelList: [ModelList]

    @Binding var temporaryDestinationModelContainer: [String:[M2]]
    
    init(itemModel:Binding<M1>, listaDaMostrare: Binding<String>, elencoModelList:[ModelList], itemModelList: [ModelList], temporaryDestinationModelList:Binding<[String:[M2]]>) {
        
        _itemModel = itemModel
        _listaDaMostrare = listaDaMostrare
        _temporaryDestinationModelContainer = temporaryDestinationModelList
        self.elencoModelList = elencoModelList
        self.itemModelList = itemModelList

    }

    var body: some View {

        List {

            vbShowModelList()
          
        }
        .listStyle(.plain)
        
    }
    
 //Method
    
   @ViewBuilder private func vbShowModelList() -> some View {
        
        let currentList: ModelList = elencoModelList.first { $0.returnAssociatedValue().0 == listaDaMostrare }!
        
       switch currentList {
           
       case .viewModelContainer(_, let partialKeyPath, _):
           
         if let container:[M2] = viewModel[keyPath: partialKeyPath] as? [M2] {
               
               MostraESelezionaIngredienti(listaAttiva: container) { model in
               
                   discoverCaratteristicheModel(model: model).graficElement
                   
               } action: { model in
                   
                   self.addIngredientsTemporary(model: model)
               }
               
           } else {Text("Keypath errato")}
           
       
       case .itemModelContainer(_, let anyKeyPath, _):
           
           if let destinationKeypath = anyKeyPath as? WritableKeyPath<M1,[M2]> {
               
               MostraEOrdinaIngredienti<M2>(listaAttiva: Binding(
                get: {
                    print("dentro il Get del Binding in case .destinazioneModelContainer")
                    return itemModel[keyPath: destinationKeypath]
                },
                set: {
                    
                    print("dentro il Set del Binding in case .destinazioneModelContainer")
                    itemModel[keyPath: destinationKeypath] = $0
                    
                }) )
               
           } else {Text("Keypath errato")}
       
       }
        
    }
    
    private func discoverCaratteristicheModel(model: M2) -> (graficElement:(Color,String,Bool),temporaryData:(String,[String:Bool])) {
         
     //   let colorContainer = [Color.mint,Color.orange]
        var destinationContainer: [String: ([M2], Color)] = [:]
        var mirrorDestinationContainer: [String:Bool] = [:] // mirroring per la funzione addModelTemporary
                
        for list in self.itemModelList {

            let(title,keypath,containerType) = list.returnAssociatedValue()
            let(containerColor,grado) = containerType.returnAssociatedValue()
            let isPrincipal = grado == .principale
            
            destinationContainer[title] = ((self.itemModel[keyPath: keypath] as? [M2]) ?? [], containerColor)
            
            mirrorDestinationContainer[title] = isPrincipal
            
        }
        
        for container in destinationContainer {
            
            if container.value.0.contains(model) {
                
                return ((container.value.1, "circle.slash", true),("",mirrorDestinationContainer))
            }
            
        }
        
        for (title,container) in self.temporaryDestinationModelContainer {
            
            if container.contains(model) {
                
                let color = destinationContainer[title]!.1  // accediamo al ContainerStored per prendere il color associato alla stessa chiave.
                return ((color, "circle.fill", false),(title,mirrorDestinationContainer))
                
            }
            
        }
            
     
        return ((Color.black, "circle", false),("",mirrorDestinationContainer))
     
    }
    
    private func addIngredientsTemporary(model:M2) {

        let (_,(temporaryKey, mirrorContainer)) = discoverCaratteristicheModel(model: model)

        var principalKey:String = ""
        var secondaryKey:String = ""
        
        for (title,isPrincipal) in mirrorContainer {
            
            if isPrincipal {
                print("principalKey:\(title)")
                principalKey = title }
            else {
                print("secondaryKey:\(title)")
                secondaryKey = title }
            
        }
        
        func checkAndAttribution(key: String) { // internalFunc
            
            if self.temporaryDestinationModelContainer[key] != nil {
                
                self.temporaryDestinationModelContainer[key]!.append(model)
                print("temporaryDestination - \(key) - is not nil")
                
            } else {
                
                print("temporaryDestination - \(key) - is nil")
             
                self.temporaryDestinationModelContainer[key] = []
                self.temporaryDestinationModelContainer[key]!.append(model)
                
            }
            print("temporaryKey.count-Post: \(temporaryDestinationModelContainer.keys.count) - \(temporaryDestinationModelContainer.keys.description)")
            
        }
        func findAndRemove(key:String) {
            
            let index = self.temporaryDestinationModelContainer[key]!.firstIndex(of: model)
            self.temporaryDestinationModelContainer[key]!.remove(at: index!)
        }

        if temporaryKey == "" /* && isNotUsed */ { checkAndAttribution(key: principalKey) }
            
        else if temporaryKey == principalKey { findAndRemove(key: principalKey)
            
            if secondaryKey != "" { checkAndAttribution(key: secondaryKey) }
           
            }
        
        else if secondaryKey != "" && temporaryKey == secondaryKey { findAndRemove(key: secondaryKey) }
        
}
    
    

} // Chiusa Struct



/*

struct ListaIngredienti_ConditionalView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredienti_ConditionalView()
    }
}

*/
