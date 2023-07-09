//
//  ListaIngredienti_ConditionalView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI
import MyFoodiePackage

/*
/// M1 è il modello da Modificare. M2 è il modello da listare. Ex: M1 è la proprietà, M2 è il Model associato alla proprietà
struct CurrentModelListView<M1:MyProStarterPack_L1,M2:MyProStarterPack_L1>: View where M2.VM == AccounterVM {
    
    // M1 passa da MyModelProtocol a MyProStarterPackL1
    // M2 passa da MyModelProtocol a MyProStarterPackL1
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var itemModel: M1
    @Binding var modelListCorrente: String
    
    let allModelList: [ModelList]
    let itemModelList: [ModelList]

    @Binding var temporaryDestinationModelContainer: [String:[M2]]
    
    init(itemModel:Binding<M1>, modelListCorrente: Binding<String>,allModelList:[ModelList], itemModelList: [ModelList], temporaryDestinationModelList:Binding<[String:[M2]]>) {
        
        _itemModel = itemModel
        _modelListCorrente = modelListCorrente
        _temporaryDestinationModelContainer = temporaryDestinationModelList
        
        self.allModelList = allModelList
        self.itemModelList = itemModelList
    }

    var body: some View {

       // List {
            
            vbShowCurrentModelList()
      //  }
      //  .listStyle(.plain)
        
    }
    
 //Method
    
   @ViewBuilder private func vbShowCurrentModelList() -> some View {
        
       let currentList: ModelList = allModelList.first { $0.returnAssociatedValue().0 == modelListCorrente }!
        
       switch currentList {
           
       case .viewModelContainer(_, let partialKeyPath, _):
           
         if let container:[M2] = viewModel[keyPath: partialKeyPath] as? [M2] {
               
               MostraESelezionaModel(listaAttiva: container) { model in
               
                   self.discoverCaratteristicheModel(model: model).graficElement
                   
               } action: { model in
                   
                   self.addModelTemporary(model: model)
               }
               
           } else {Text("Keypath errato")}
           
       
       case .itemModelContainer(_, let anyKeyPath, _):

           if let destinationKeypath = anyKeyPath as? WritableKeyPath<M1,[M2]> {
  
             /* MostraEOrdinaModelGeneric(listaAttiva: $itemModel[dynamicMember: destinationKeypath]) */
               MostraEOrdinaModelGeneric(listaAttiva: self.$itemModel[dynamicMember: destinationKeypath])
              
           }
           // add 25.08
           else if let destinationKeyPath = anyKeyPath as? WritableKeyPath<M1,[String]> {
               
               MostraEOrdinaModelIDGeneric<M2>(listaId: self.$itemModel[dynamicMember:destinationKeyPath])
             /*  MostraEOrdinaModelString(listaIdModel: $itemModel[dynamicMember: destinationKeyPath]) */
               
           }
           // end 25.08
           else {Text("Keypath errato")}
       
       }
        
    }
    
    private func discoverCaratteristicheModel(model: M2) -> (graficElement:(Color,String,Bool),temporaryData:(String,[String:Bool])) {
         
        print("discoverCaratteristicheModel is Active")
        
        var destinationContainer: [String: ([M2], Color)] = [:]
        var mirrorDestinationContainer: [String: Bool] = [:] // mirroring per la funzione addModelTemporary
                
        for list in self.itemModelList {

            let(title,keypath,containerType) = list.returnAssociatedValue()
            let(containerColor,grado) = containerType.returnAssociatedValue()
            let isPrincipal = grado == .principale
            
            // modifica 26.08
            
            if let destinationCollection = self.itemModel[keyPath:keypath] as? [M2] {
                
                destinationContainer[title] = (destinationCollection,containerColor)
            }
            
            else if let destinationCollection = self.itemModel[keyPath:keypath] as? [String] {
                
              /*  let modelCollection = self.viewModel.modelCollectionFromCollectionID(
                    collectionId: destinationCollection,
                    modelPath: model.basicModelInfoInstanceAccess().vmPathContainer)
                
             
                
                destinationContainer[title] = (modelCollection,containerColor) */
              // 08.02.23 Chiuso per silenziare un errore nel keypath: (il medtodo vuole un percorso nella superClasse, e il percorso gli è dato da una generica che usa un typealias conforme alla superClasse. Il problema nasce perchè ad esempio gli allergeni non sono in superClasse (e non avrebbero motivo di starci, e se tutto ciò è un problema per il selettore e basta apporteremo delle modifiche a questo in quanto lo usiamo ormai soltanto per gli allergeni)) 
            }
            
            
           /* destinationContainer[title] = ((self.itemModel[keyPath: keypath] as? [M2]) ?? [], containerColor) */
            
            // end 26.08
            
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
    
    private func addModelTemporary(model:M2) {

        let (temporaryKey, mirrorContainer) = discoverCaratteristicheModel(model: model).temporaryData

        var principalKey:String = ""
        var secondaryKey:String = ""
        
        for (title,isPrincipal) in mirrorContainer {
            
            if isPrincipal {
                print("principalKey: \(title)")
                principalKey = title }
            else {
                print("secondaryKey: \(title)")
                secondaryKey = title }
            
        }
        
        func checkAndAttribution(key: String) { // internalFunc
            
            if self.temporaryDestinationModelContainer[key] != nil {
                
                self.temporaryDestinationModelContainer[key]!.append(model)
                
            } else {

                self.temporaryDestinationModelContainer[key] = []
                self.temporaryDestinationModelContainer[key]!.append(model)
                
            }            
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

*/

/*

struct ListaIngredienti_ConditionalView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredienti_ConditionalView()
    }
}

*/
