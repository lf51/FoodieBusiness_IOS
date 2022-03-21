//
//  AccounterVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import Foundation

class AccounterVM: ObservableObject {
    
    // questa classe punta ad essere l'unico ViewModel dell'app. Puntiamo a spostare qui dentro tutto ciò che deve funzionare trasversalmente fra le view, e a sostituire gli altri ViewModel col sistema Struct/@State con cui abbiamo creato un NuovoPiatto, un NuovoIngrediente, e un NuovoMenu.
    
    // ATTUALMENTE NON USATA - IN FASE TEST

    // create dal sistema

    var allTheCommunityIngredients:[CommunityIngredientModel] = [] // tutti gli ingredienti di sistema o della community. Unico elemento "Social" dell'app Business. Published perchè qualora diventasse una communityIngredients dinamica deve aggiornarsi. Nella prima versione, cioè come array di ingredienti caricati dal sistema, potrebbe non essere published, perchè verrebbe caricata in apertura e stop. // load(fileJson)
    // la lista appIngredients sarà riempita da un json che creeremo con una lista di nomi di ingredienti. Dal nome verrà creato un Modello Ingrediente nel momento in cui sarà scelto dal ristoratore
    
    var listoneFromListaBaseModelloIngrediente: [IngredientModel] = [] // questo listone sarà creato contestualmente dalla listaBaseModelloIngrediente creata da un json
    
    // end creato dal sistema
    
    @Published var allMyIngredients:[IngredientModel] = [] // tutti gli ingredienti creati dall'accounter
    @Published var allMyDish:[DishModel] = [] // tutti i piatti creati dall'accounter
    @Published var allMyMenu:[MenuModel] = [] // tutti i menu creati dall'accounter
    @Published var allMyProperties:[PropertyModel] = [] // tutte le proprietà registrate dall'accounter - In disuso finchè esiste un VM apposito
    
    init() {
        
        fillFromListaBaseModello()
    }
    
    
    // Method Generic
    
    func createOrEditItemModel<T:MyModelProtocol>(itemModel:T) {

        var containerT: [T] = []
        
        switch itemModel.self {
            
        case is IngredientModel:
            containerT = self.allMyIngredients as! [T]
        case is DishModel:
            containerT = self.allMyDish as! [T]
        case is MenuModel:
            containerT = self.allMyMenu as! [T]
        case is PropertyModel:
            containerT = self.allMyProperties as! [T]
            
        default: return
            
        }
  
        if let oldItemIndex = containerT.firstIndex(where: {$0 == itemModel}) {
            
            containerT.remove(at: oldItemIndex)
            containerT.insert(itemModel, at: oldItemIndex)
            print("Piato con id: \(itemModel.id) esistente. Rimosso e Reinserito")
            
        }
        
        else {
            
            print("Piatto mai Esistito Prima, creato con id: \(itemModel.id)")
            containerT.append(itemModel)
        }
        
        switch itemModel.self {
            
        case is IngredientModel:
            self.allMyIngredients = containerT as! [IngredientModel]
        case is DishModel:
            self.allMyDish = containerT as! [DishModel]
        case is MenuModel:
            self.allMyMenu = containerT as! [MenuModel]
        case is PropertyModel:
            self.allMyProperties = containerT as! [PropertyModel]
            
        default: return
            
        }
        
      //  print("Piatto con id: \(model.id) modificato con Successo")
        print("containerT as : \(containerT.count) item")
        print("self.allMyingredients as: \(self.allMyIngredients.count) item")
        print("self.allMyDish as: \(self.allMyDish.count) item")
        print("self.allMyProperties as: \(self.allMyProperties.count) item")
        print("self.allMyMenu as: \(self.allMyMenu.count) item")
        // crea e salva il piatto su firebase
        
    // Matriciana 5CE7F174-1E10-45F4-8387-4139C59E42ED
    // Carbonara 6389FF91-89A4-4458-B336-E00BD96571BF
    }

    
    func mappingModelList<T:MyModelProtocolMapConform>(modelType: T.Type) -> [T.MapCategory] {
        
        let containerT: [T] = findModelTypeArray(modelType: modelType)
        
        let firstStep = containerT.map({$0.mapCategoryAvaible})
        let secondStep = Set(firstStep)
        let lastStep = Array(secondStep)

        return lastStep
        /* Versione BETA funzionante in data 21.03 -> dopo vari tentativi abbiamo volutamente abbandonato la possibilità di selezionare la categoria per la mappatura in modo dinamico. Vediamo più avanti se questo sarà necessario e allora riproveremo. Siamo arrivati ad una sintassi del tipo func<T:MyModelProtocolMapConform,G:MyEnumProtocolMapConform> nomefunc(modelType: T.Type, categoryType: G.type) -> [G] */
    }
    
    func filteredModelList<T:MyModelProtocolMapConform>(modelType:T.Type, filtro:T.MapCategory) -> [T] {
           
        let containerT: [T] = findModelTypeArray(modelType: modelType)
         
        return containerT.filter({$0.mapCategoryAvaible == filtro})
           
       }
    
    private func findModelTypeArray<T:MyModelProtocolMapConform>(modelType:T.Type) ->[T] {
        
        var containerT: [T] = []
        
        switch modelType {
            
        case is DishModel.Type:
            containerT = self.allMyDish as! [T]
        case is IngredientModel.Type:
            containerT = [] // type ancora non conforme al MyModelProtocolMapConform
        case is MenuModel.Type:
            containerT = [] // type ancora non conforme al MyModelProtocolMapConform
        case is PropertyModel.Type:
            containerT = [] // type ancora non conforme al MyModelProtocolMapConform
            
        default: containerT = []
            
        }
        
        return containerT
    }
    

  // AREA TEST -> DA ELIMINARE
    
    let ing1 = CommunityIngredientModel(nome: "basilico")
    let ing2 = CommunityIngredientModel(nome: "aglio")
     let ing3 = CommunityIngredientModel(nome: "olio")
     let ing4 = CommunityIngredientModel(nome: "prezzemolo")
     let ing5 = CommunityIngredientModel(nome: "origano")
     let ing6 = CommunityIngredientModel(nome: "sale")
     let ing7 = CommunityIngredientModel(nome: "pepe")
     
     func fillFromListaBaseModello() { // TEST CODE DA MODIFICARE
         
         
         let ingList = [ing1,ing2,ing3,ing4,ing5,ing6,ing7]
         
         for ing in ingList {
             
             let ingMod = IngredientModel(nome: ing.nome)
             listoneFromListaBaseModelloIngrediente.append(ingMod)
             
         }

     }
    
}

