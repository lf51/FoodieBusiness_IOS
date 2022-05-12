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
   // @Binding var listaDaMostrare: ModelList
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
        
      /*  let temporary = [String:[M2]]()
        _temporarySelectionIngredients = State(initialValue: temporary) */
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
            
        case .viewModelDishContainer(let string, let keyPath):
            let container = viewModel[keyPath: keyPath]
            MostraESelezionaIngredienti(listaAttiva: container) { model in
                
                discoverCaratteristicheModel(model: model as! M2).graficElement
            } action: { model in
                let genericCastModel = model as! M2
                self.addIngredientsTemporary(model: genericCastModel)
            }
            
        case .viewModelIngredientContainer(let string, let keyPath):
            let container = viewModel[keyPath: keyPath]
            MostraESelezionaIngredienti(listaAttiva: container) {model in
                
                discoverCaratteristicheModel(model: model as! M2).graficElement
            } action: { model in
                let genericCastModel = model as! M2
                self.addIngredientsTemporary(model: genericCastModel)
            }
            
        case .viewModelMenuContainer(let string, let keyPath):
            let container = viewModel[keyPath: keyPath]
            MostraESelezionaIngredienti(listaAttiva: container) { model in
                
                discoverCaratteristicheModel(model: model as! M2).graficElement
                
            } action: { model in
                let genericCastModel = model as! M2
                self.addIngredientsTemporary(model: genericCastModel)
            }
            
        case .viewModelPropertyContainer(let string, let keyPath):
            let container = viewModel[keyPath: keyPath]
            MostraESelezionaIngredienti(listaAttiva: container) {model in
                
                discoverCaratteristicheModel(model: model as! M2).graficElement
            } action: { model in
                let genericCastModel = model as! M2
                self.addIngredientsTemporary(model: genericCastModel)
            }
           
        case .dishModelIngredientContainer(let string, let writableKeyPath):
          
           // let keyp = writableKeyPath as! WritableKeyPath<M1,[DishModel]>
           // let item = itemModel[keyPath: keyp]
            let keypath = writableKeyPath as! WritableKeyPath<M1,[IngredientModel]>
          //  let container = itemModel[keyPath: keypath]
            MostraEOrdinaIngredienti<IngredientModel>(listaAttiva: Binding(
                get: {
                    print("dentro il Get del Binding in case .dishModelIngredientContainer")
                   return itemModel[keyPath: keypath] },
                set: {
                    print("dentro il Set del Binding in case .dishModelIngredientContainer")
                    itemModel[keyPath: keypath] = $0 }))
            
        case .dishModelMenuContainer(let string, let writableKeyPath):
            EmptyView()
        case .menuModelDishContainer(let string, let writableKeyPath):
            EmptyView()
        case .menuModelPropertyContainer(let string, let writableKeyPath):
            EmptyView()
        case .propertyModelMenuContainer(let string, let writableKeyPath):
            EmptyView()
        }
        
    }
    
    private func discoverCaratteristicheModel(model: M2) -> (graficElement:(Color,String,Bool),temporaryData:(String,[String:Bool])) {
         
        let colorContainer = [Color.mint,Color.orange]
        var destinationContainer: [String: ([M2], Color)] = [:]
        var mirrorDestinationContainer: [String:Bool] = [:] // mirroring per la funzione addModelTemporary
                
        for list in self.itemModelList {
            
            let index = self.itemModelList.firstIndex(of: list)
            let isPrincipal = index == 0
            let(title,keypath,_) = list.returnAssociatedValue()
            destinationContainer[title] = (self.itemModel[keyPath: keypath] as! [M2], colorContainer[index!])
            
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

        if temporaryKey == "" /* && isNotUsed */ {
            
            print("temporaryKey.count-Pre: \(temporaryDestinationModelContainer.keys.count)")
            
            if self.temporaryDestinationModelContainer[principalKey] != nil {
                
                self.temporaryDestinationModelContainer[principalKey]!.append(model)
                
            } else {
                
                var temporaryArray:[M2] = []
                self.temporaryDestinationModelContainer[principalKey] = temporaryArray
                self.temporaryDestinationModelContainer[principalKey]!.append(model)
                
            }
    
            print("temporaryKey.count-Post: \(temporaryDestinationModelContainer.keys.count)")
                    
            }
            
        else if temporaryKey == principalKey {
                
        let index = self.temporaryDestinationModelContainer[principalKey]!.firstIndex(of: model)
                    self.temporaryDestinationModelContainer[principalKey]!.remove(at: index!)
            
            if secondaryKey != "" {
                
                if self.temporaryDestinationModelContainer[secondaryKey] != nil {
                    
                    self.temporaryDestinationModelContainer[secondaryKey]?.append(model)
                
                } else {
                    
                    var temporaryArray:[M2] = []
                    self.temporaryDestinationModelContainer[secondaryKey] = temporaryArray
                    self.temporaryDestinationModelContainer[secondaryKey]!.append(model)
                    
                }
                
                
                }
           
            }
        
        else if secondaryKey != "" && temporaryKey == secondaryKey {
            
            let index = self.temporaryDestinationModelContainer[secondaryKey]!.firstIndex(of: model)
            self.temporaryDestinationModelContainer[secondaryKey]!.remove(at: index!)
            
        }
    }
    
    

} // Chiusa Struct



/*private func discoverCaratteristicheModel<M1:MyModelProtocol,M2:MyModelProtocol>(itemModel:M1, model: M2) -> (imageColorUsed:(Color,String,Bool), keys: (temporary:String,principal:String,secondary:String)) {
     
    var storedContainer_1:[M2] = []
    var storedContainer_2:[M2] = []
    var principalKey: String = ""
    var secondaryKey: String = ""
    
    switch itemModel {
        
    case is DishModel:
        let currentModel = itemModel as! DishModel
        
        if model is IngredientModel {
            
            storedContainer_1 = currentModel.ingredientiPrincipali as! [M2]
            storedContainer_2 = currentModel.ingredientiSecondari as! [M2]
            principalKey = "IngredientiPrincipali"
            secondaryKey = "IngredientiSecondari"
        }
        else if model is MenuModel {
            
            storedContainer_1 = currentModel.menuWhereIsIn as! [M2]
            principalKey = "MenuIN"
            
        }
  
    default:
        storedContainer_1 = []
        storedContainer_2 = []
        
    }

    guard !storedContainer_1.contains(model) else {
        
        return ((Color.mint, "circle.slash", true),("",principalKey,secondaryKey))
    }

    
    guard !storedContainer_2.contains(model) else {
            
            return ((Color.orange, "circle.slash", true),("",principalKey,secondaryKey))
            
        }
        
    let temporarySelectionKey:[String] = [String](temporarySelectionIngredients.keys)
    
    for key in temporarySelectionKey {
        
        if temporarySelectionIngredients[key]!.contains(model) {
            
            let color = principalKey == key ? Color.mint : Color.orange
            
            return ((color,"circle.fill",false),(key,principalKey,secondaryKey))
            
        }
    }
    
    return ((Color.black, "circle",false),("",principalKey,secondaryKey))
    
} */








/*


  /*  @ViewBuilder func vbShowModelList<M2:MyModelProtocol>() -> some View {
    
        switch listaDaMostrare {
            
        case .viewModelContainer(let partialKeyPath):
            let container:[M2] = viewModel[keyPath: partialKeyPath] as! [M2]
            MostraESelezionaIngredienti(listaAttiva: container) { model in
                return (Color.red,"circle",true)
              //  self.discoverCaratteristicheModel(itemModel: itemModel, model: model).imageColorUsed
            } action: { model in
               // self.addIngredientsTemporary(model: model as! M2)
            }
        case .itemModelContainer(let string, let anyKeyPath):
            EmptyView()
            // MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiPrincipali)
        }
        
        
    } */
    
  /*  @ViewBuilder func vbShowModelList2() -> some View {
          
          switch listaDaMostrare {
              
          case .allMyIngredients:
              
              MostraESelezionaIngredienti(listaAttiva: viewModel.allMyIngredients) { model in
                  self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
              } action: { model in
                  self.addIngredientsTemporary(model: model as! M2)
              }
          case .allFromCommunity:
              MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { model in
                  self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
                
              } action: { model in
                  self.addIngredientsTemporary(model: model as! M2)
              }
          case .ingredientiPrincipali:
             
           //   print("Dentro Case:IngredientiPrincipali")
              EmptyView()
              // MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiPrincipali)
          case .ingredientiSecondari:
                     
             // print("Dentro Case:IngredientiSecondari")
              EmptyView()
              //  MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiSecondari)
        
          default:
              
              MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { model in
                  self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
                
              } action: { model in
                  self.addIngredientsTemporary(model: model as! M2)
              }
              
          }
              
      } */
    
    
    
  /*  @ViewBuilder func vbShowModelList() -> some View {
        
        switch listaDaMostrare {
            
        case .allMyIngredients:
            
            MostraESelezionaIngredienti(listaAttiva: viewModel.allMyIngredients) { model in
                self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
            } action: { model in
                self.addIngredientsTemporary(model: model as! M2)
            }
        case .allFromCommunity:
            MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { model in
                self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
              
            } action: { model in
                self.addIngredientsTemporary(model: model as! M2)
            }
        case .ingredientiPrincipali:
           
         //   print("Dentro Case:IngredientiPrincipali")
            EmptyView()
            // MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiPrincipali)
        case .ingredientiSecondari:
                   
           // print("Dentro Case:IngredientiSecondari")
            EmptyView()
            //  MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiSecondari)
      
        default:
            
            MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { model in
                self.discoverCaratteristicheModel(itemModel: itemModel, model: model as! M2).imageColorUsed
              
            } action: { model in
                self.addIngredientsTemporary(model: model as! M2)
            }
            
        }
            
    } */
    
/*
    
    private func addIngredientsTemporary(model:M2) {

       let((_,_,_),(temporaryKey,principalKey,secondaryKey)) = discoverCaratteristicheModel(itemModel: itemModel, model: model)
    
            if temporaryKey == "" {
                
                temporarySelectionIngredients[principalKey]!.append(model)
                
            }
            
           else if temporaryKey == principalKey {
                
            let index = temporarySelectionIngredients[principalKey]!.firstIndex(of: model)
               temporarySelectionIngredients[principalKey]!.remove(at: index!)
               temporarySelectionIngredients[secondaryKey]!.append(model)
                
                
            }
        
            else if temporaryKey == secondaryKey {
            
            let index = temporarySelectionIngredients[temporaryKey]!.firstIndex(of: model)
            temporarySelectionIngredients[temporaryKey]!.remove(at: index!)
            
        }

    
    }
    
    /// Il secondo contenitore è optional.
    private func discoverCaratteristicheModel(itemModel:M1, model: M2) -> (imageColorUsed:(Color,String,Bool), keys: (temporary:String,principal:String,secondary:String)) {
         
        var storedContainer_1:[M2] = []
        var storedContainer_2:[M2] = []
        var principalKey: String = ""
        var secondaryKey: String = ""
        
        switch itemModel {
            
        case is DishModel:
            let currentModel = itemModel as! DishModel
            
            if model is IngredientModel {
                
                storedContainer_1 = currentModel.ingredientiPrincipali as! [M2]
                storedContainer_2 = currentModel.ingredientiSecondari as! [M2]
                principalKey = "IngredientiPrincipali"
                secondaryKey = "IngredientiSecondari"
            }
            else if model is MenuModel {
                
                storedContainer_1 = currentModel.menuWhereIsIn as! [M2]
                principalKey = "MenuIN"
                
            }
      
        default:
            storedContainer_1 = []
            storedContainer_2 = []
            
        }
  
        guard !storedContainer_1.contains(model) else {
            
            return ((Color.mint, "circle.slash", true),("",principalKey,secondaryKey))
        }
 
        
        guard !storedContainer_2.contains(model) else {
                
                return ((Color.orange, "circle.slash", true),("",principalKey,secondaryKey))
                
            }
            
        let temporarySelectionKey:[String] = [String](temporarySelectionIngredients.keys)
        
        for key in temporarySelectionKey {
            
            if temporarySelectionIngredients[key]!.contains(model) {
                
                let color = principalKey == key ? Color.mint : Color.orange
                
                return ((color,"circle.fill",false),(key,principalKey,secondaryKey))
                
            }
        }
        
        return ((Color.black, "circle",false),("",principalKey,secondaryKey))
        
    }
    
    
   
    /* // ULTIMA VERSIONE 10.05
    
}
    
   /*
    private func addIngredientsTemporary(ingredient: IngredientModel) {

        let((_,_,_),ingredientKey) = discoverIngredientAttribute(ingredient: ingredient)
    
            if ingredientKey == "" {
                
                temporarySelectionIngredients["IngredientiPrincipali"]!.append(ingredient)
                
            }
            
           else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionIngredients["IngredientiPrincipali"]!.firstIndex(of: ingredient)
                
                temporarySelectionIngredients["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionIngredients["IngredientiSecondari"]!.append(ingredient)
                
            }
            
            else if ingredientKey == "IngredientiSecondari"{
                
                let index = temporarySelectionIngredients["IngredientiSecondari"]!.firstIndex(of: ingredient)
                temporarySelectionIngredients["IngredientiSecondari"]!.remove(at: index!)
                
            }
        

    }
    
    
    private func discoverIngredientAttribute(ingredient: IngredientModel) -> (imageColorUsed:(Color,String,Bool), key: String) {
         
        // Guard per controllo di unicità
        guard !self.newDish.ingredientiPrincipali.contains(ingredient) else {
            
            return ((Color.mint, "circle.slash", true),"")
            
        }
        
        guard !self.newDish.ingredientiSecondari.contains(ingredient) else {
            
            return ((Color.orange, "circle.slash", true),"")
        }
  
            if temporarySelectionIngredients["IngredientiPrincipali"]!.contains(ingredient) {return ((Color.mint, "circle.fill",false),"IngredientiPrincipali")}
            
            else if temporarySelectionIngredients["IngredientiSecondari"]!.contains(ingredient) {return ((Color.orange, "circle.fill",false),"IngredientiSecondari")}
            
            else {return ((Color.black, "circle",false),"")}
  
    
    }
*/ // BACKUP 07.05 per trasformazione in Generics
    
    
    




/* struct ListaIngredienti_ConditionalView: View {
    
  //  @ObservedObject var propertyVM: PropertyVM
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var newDish: DishModel
    @Binding var listaDaMostrare: ElencoListeIngredienti
    
    @Binding var temporarySelectionIngredients: [String:[IngredientModel]]
    
    var body: some View {

        List {
            
         //   VStack(alignment:.leading) { // -> non lo inseriamo in un Vstack perchè non fa funzionare l'onMove e l'onDelete

            if listaDaMostrare == .allFromCommunity {
                    
                    MostraESelezionaIngredienti(listaAttiva:viewModel.listoneFromListaBaseModelloIngrediente) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColorUsed
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
                    
                }
                
                else if listaDaMostrare == .allMyIngredients {
                    
                    MostraESelezionaIngredienti(listaAttiva: viewModel.allMyIngredients) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColorUsed
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
 
                }
                
                else if listaDaMostrare == .ingredientiPrincipali {
                    
                   MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiPrincipali)
                    
          
                }
                
                else if listaDaMostrare == .ingredientiSecondari {
                    
                    MostraEOrdinaIngredienti(listaAttiva: $newDish.ingredientiSecondari)
                    
                }
        }
        .listStyle(.plain)
        
    }
    
 //Method

    
    private func addIngredientsTemporary(ingredient: IngredientModel) {

        let((_,_,_),ingredientKey) = discoverIngredientAttribute(ingredient: ingredient)
    
            if ingredientKey == "" {
                
                temporarySelectionIngredients["IngredientiPrincipali"]!.append(ingredient)
                
            }
            
           else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionIngredients["IngredientiPrincipali"]!.firstIndex(of: ingredient)
                
                temporarySelectionIngredients["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionIngredients["IngredientiSecondari"]!.append(ingredient)
                
            }
            
            else if ingredientKey == "IngredientiSecondari"{
                
                let index = temporarySelectionIngredients["IngredientiSecondari"]!.firstIndex(of: ingredient)
                temporarySelectionIngredients["IngredientiSecondari"]!.remove(at: index!)
                
            }
        

    }
    
    
    private func discoverIngredientAttribute(ingredient: IngredientModel) -> (imageColorUsed:(Color,String,Bool), key: String) {
         
        // Guard per controllo di unicità
        guard !self.newDish.ingredientiPrincipali.contains(ingredient) else {
            
            return ((Color.mint, "circle.slash", true),"")
            
        }
        
        guard !self.newDish.ingredientiSecondari.contains(ingredient) else {
            
            return ((Color.orange, "circle.slash", true),"")
        }
  
            if temporarySelectionIngredients["IngredientiPrincipali"]!.contains(ingredient) {return ((Color.mint, "circle.fill",false),"IngredientiPrincipali")}
            
            else if temporarySelectionIngredients["IngredientiSecondari"]!.contains(ingredient) {return ((Color.orange, "circle.fill",false),"IngredientiSecondari")}
            
            else {return ((Color.black, "circle",false),"")}
  
    
    }

    
 } */// BaCKUP 07.05 tentivo di trasformazione in Genrica

struct ListaIngredienti_ConditionalView_Previews: PreviewProvider {
    static var previews: some View {
        ListaIngredienti_ConditionalView()
    }
}


     */*/*/
