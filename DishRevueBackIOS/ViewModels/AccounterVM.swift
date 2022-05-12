//
//  AccounterVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import Foundation
import SwiftUI
import MapKit // da togliere quando ripuliamo il codice dai Test


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
    @Published var allMyProperties:[PropertyModel] = [] /*{ willSet {
        print("cambio Valore allMyProperties")
        objectWillChange.send() } }*/
    @Published var showAlert: Bool = false
    @Published var alertItem: AlertModel? {didSet {showAlert = true} }
    
    init() {
        
        fillFromListaBaseModello()
        print("Init -> AccounterVM")
    }
    
    // Method Generic

    func createOrUpdateItemModel<T:MyModelProtocol>(itemModel:T) { // 03.05 Deprecated
    
        var (containerT, editAvaible) = assegnaContainer(itemModel: itemModel)
  
        if let oldItemIndex = containerT.firstIndex(where: {$0 == itemModel}) {
            
            if editAvaible {
                
                containerT.remove(at: oldItemIndex)
                containerT.insert(itemModel, at: oldItemIndex)
                
                self.alertItem = AlertModel(title: "\(itemModel.intestazione)", message: "Item modificato con succcesso.")
                
                print("Item con id: \(itemModel.id) esistente. Rimosso e Reinserito. Modificato con successo")
                
            } else {
                
                self.alertItem = AlertModel(title: "Error", message: "Item already Listed")
                print("ITEM ALREADY IN")
                
            }
        }
        
        else {
            
            self.alertItem = AlertModel(
                title: "\(itemModel.intestazione)",
                message: "New Item Added Successfully")
            
            containerT.append(itemModel)
            print("Item mai Esistita Prima, creato con id: \(itemModel.id)")
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

    func updateItemModel<T:MyModelProtocol>(itemModel: T) { // Deprecated 06.05
        
        self.alertItem = AlertModel(
            title: "Confermare Modifiche",
            message: itemModel.descrizione,
            actionPlus: ActionModel(
                title: .conferma,
                action: {
                    self.updateItemModelExecutive(itemModel: itemModel)
                }))
        
    }
    
    /// Manda un alert peri Confermare le Modifiche
    func updateItemModel<T:MyModelProtocol>(messaggio:String, action: @escaping () -> T )  {
        
        self.alertItem = AlertModel(
            title: "Confermare Modifiche",
            message: messaggio,
            actionPlus: ActionModel(
                title: .conferma,
                action: {
                 
                    let itemModel = action()
                    self.updateItemModelExecutive(itemModel: itemModel)
                
                                    }))
        
    }
    
    
    private func updateItemModelExecutive<T:MyModelProtocol>(itemModel: T) {
        
        var (containerT, _) = assegnaContainer(itemModel: itemModel)
  
        guard let oldItemIndex = containerT.firstIndex(of: itemModel) else {return}
            
           // containerT.remove(at: oldItemIndex)
          //  containerT.insert(itemModel, at: oldItemIndex)
        print("elementi nel Container Pre-Update: \(containerT.count)")
            containerT[oldItemIndex] = itemModel
            aggiornaContainer(containerT: containerT)
        print("elementi nel Container POST-Update: \(containerT.count)")
        print("updateItemModelExecutive executed")
    }
    
    /// Manda un alert di conferma prima di eliminare l' Oggetto
    func deleteItemModel<T:MyModelProtocol>(itemModel: T) {
        
        self.alertItem = AlertModel(
            title: "Conferma Eliminazione",
            message: "Confermi di volere eliminare \(itemModel.intestazione)?",
            actionPlus: ActionModel(
                title: .elimina,
                action: {
                    withAnimation {
                        self.deleteItemModelExecution(itemModel: itemModel)
                    }
                   
                }))

    }
    
    private func deleteItemModelExecution<T:MyModelProtocol>(itemModel: T) {
        
        var (containerT, _) = assegnaContainer(itemModel: itemModel)
        
        guard let index = containerT.firstIndex(of: itemModel) else {
            self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
            return }
        
        containerT.remove(at: index)
        self.alertItem = AlertModel(title: "Eliminazione Eseguita", message: "\(itemModel.intestazione) rimosso con Successo!")
        
        self.aggiornaContainer(containerT: containerT)
       /* switch itemModel.self {
            
        case is IngredientModel:
            self.allMyIngredients = containerT as! [IngredientModel]
        case is DishModel:
            self.allMyDish = containerT as! [DishModel]
        case is MenuModel:
            self.allMyMenu = containerT as! [MenuModel]
        case is PropertyModel:
            self.allMyProperties = containerT as! [PropertyModel]
            
        default: return
            
        } */
    }
    
   
    
    
    func deepFiltering<M:MyModelProtocol>(model:M, filterCategory:MapCategoryContainer) -> Bool {
       
       switch filterCategory {
           
       case .tipologiaMenu(let internalFilter):
           
           guard internalFilter != nil else { return true}
           let menuModel = model as! MenuModel
           return menuModel.tipologia.returnTypeCase() == internalFilter
           
       case .giorniDelServizio(let filter):
           
           guard filter != nil else { return true}
           let menuModel = model as! MenuModel
           return menuModel.giorniDelServizio.contains(filter!)
           
       case .statusMenu:
           print("Dentro statusMenu/deepFiltering - Da Settare")
           return true
           
       case .conservazione(let filter):
           
           guard filter != nil else { return true}
           let ingredientModel = model as! IngredientModel
           return ingredientModel.conservazione == filter
           
       case .produzione(let filter):
           
           guard filter != nil else { return true}
           let ingredientModel = model as! IngredientModel
           return ingredientModel.produzione == filter
           
       case .provenienza(let filter):
           
           guard filter != nil else { return true}
           let ingredientModel = model as! IngredientModel
           return ingredientModel.provenienza == filter
           
       case .categoria(let filter):
           
           guard filter != nil else { return true}
           let dishModel = model as! DishModel
           return dishModel.categoria == filter
           
       case .base(let filter):
           
           guard filter != nil else { return true}
           let dishModel = model as! DishModel
           return dishModel.aBaseDi == filter
           
       case .tipologiaPiatto(let filter):
           
           guard filter != nil else { return true}
           let dishModel = model as! DishModel
           return dishModel.tipologia == filter
           
       case .statusPiatto:
           print("Dentro statusPiatto/deepFiltering - Da Settare")
           return true
           
       case .menuAz, .ingredientAz,.dishAz, .reset:
           return true

       }
     
   }
    
    func stringResearch<T:MyModelProtocol>(item: T, stringaRicerca: String) -> Bool {
        
        guard stringaRicerca != "" else { return true }
        
        let ricerca = stringaRicerca.replacingOccurrences(of: " ", with: "").lowercased()
        print("Dentro Stringa Ricerca")
        switch item.self {
            
        case is IngredientModel:
            let itemModel = item as! IngredientModel
            let condition_One = itemModel.intestazione.lowercased().contains(ricerca)
  
            return condition_One

        case is DishModel:
            
            let itemModel = item as! DishModel
            let condition_One = itemModel.intestazione.lowercased().contains(ricerca)
          
            return condition_One
            
        case is MenuModel:
            
            let itemModel = item as! MenuModel
            let condition_One = itemModel.intestazione.lowercased().contains(ricerca)
            
            return condition_One
            
        default: return false
            
            
        }
        
       
        
    }
    
    private func assegnaContainer<T:MyModelProtocol>(itemModel:T) -> (container:[T],editAvaible:Bool) {
        
        switch itemModel.self {
            
        case is IngredientModel:
            return(self.allMyIngredients as! [T], true)
        case is DishModel:
            return(self.allMyDish as! [T], true)
        case is MenuModel:
            return (self.allMyMenu as! [T], true)
        case is PropertyModel:
            return(self.allMyProperties as! [T], false)
            
        default: return([],false)
            
        }
    }
    
    private func aggiornaContainer<T:MyModelProtocol>(containerT: [T]) {
        
        guard !containerT.isEmpty else {
            print("ContainerT vuoto. updateContainer non eseguito")
            return
        }
        
        let exampleItem = containerT[0]
        
        switch exampleItem.self {
            
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
   
    }
    
    
  // AREA TEST -> DA ELIMINARE
    
     let ing1 = CommunityIngredientModel(nome: "basilico")
     let ing2 = CommunityIngredientModel(nome: "aglio")
     let ing3 = CommunityIngredientModel(nome: "olio")
     let ing4 = CommunityIngredientModel(nome: "prezzemolo")
     let ing5 = CommunityIngredientModel(nome: "origano")
     let ing6 = CommunityIngredientModel(nome: "sale")
     let ing7 = CommunityIngredientModel(nome: "pepe")
     
    let menu1 = MenuModel(nome: "Pranzo WeekEnd", tipologia: .allaCarta, giorniDelServizio: [.venerdi,.sabato])
    let menu2 = MenuModel(nome: "Pranzo Feriale", tipologia: .fisso(persone: "1", costo: "15"), giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi])
    let menu3 = MenuModel(nome: "ColazioneExpress", tipologia: .fisso(persone: "1", costo: "2.5"), giorniDelServizio: [.giovedi])
    let menu4 = MenuModel(nome: "CenaAllDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato])
    let prop1 = PropertyModel(nome: "Mia", coordinates:  CLLocationCoordinate2D(latitude: 37.510987, longitude: 13.041434))
    let prop2 = PropertyModel(nome: "Tua", coordinates:  CLLocationCoordinate2D(latitude: 37.510997, longitude: 13.041434))
    let prop3 = PropertyModel(nome: "Sua", coordinates:  CLLocationCoordinate2D(latitude: 37.510927, longitude: 13.041434))
    let prop4 = PropertyModel(nome: "Essa", coordinates: CLLocationCoordinate2D(latitude: 37.510937, longitude: 13.041434))
    let dish1 = DishModel(intestazione: "Spaghetti alla Carbonara", aBaseDi: .carne, categoria: .primo, tipologia: .standard, status: .pubblico)
    let dish2 = DishModel(intestazione: "Bucatini alla Matriciana", aBaseDi: .carne, categoria: .primo, tipologia: .standard,status: .archiviato)
    let dish4 = DishModel(intestazione: "Tiramisu", aBaseDi: .carne, categoria: .dessert, tipologia: .standard,status: .bozza)
    let dish3 = DishModel(intestazione: "Fritto Misto", aBaseDi: .pesce, categoria: .secondo, tipologia: .vegariano, status: .inPausa)

    let ingre1 = IngredientModel(nome: "Aglio", provenienza: .italia, metodoDiProduzione: .biologico, conservazione: .conserva)
    let ingre2 = IngredientModel(nome: "Aglio Rosso", provenienza: .homeMade, metodoDiProduzione: .naturale, conservazione: .surgelato)
    let ingre3 = IngredientModel(nome: "Cipolla", provenienza: .europa, metodoDiProduzione: .convenzionale, conservazione: .congelato)
    let ingre4 = IngredientModel(nome: "Prezzemolo", provenienza: .restoDelMondo, metodoDiProduzione: .selvatico, conservazione: .fresco)
    let ingre5 = IngredientModel(nome: "TestIngr", provenienza: .italia, metodoDiProduzione: .biologico, conservazione: .fresco)
    
  //  let menu5 = MenuModel.Filter.tipologia(.allaCarta)
 //   let menu6 = MenuModel.Filter.tipologia(.fisso(costo: "25"))
    
     func fillFromListaBaseModello() { // TEST CODE DA MODIFICARE
                  
         let ingList = [ing1,ing2,ing3,ing4,ing5,ing6,ing7]
         
         for ing in ingList {
             
             let ingMod = IngredientModel(nome: ing.nome)
             listoneFromListaBaseModelloIngrediente.append(ingMod)
           //  allMyIngredients.append(ingMod)
         }
         
         let menuList = [menu1,menu2,menu3,menu4]
         let dishList = [dish1,dish2,dish3,dish4]
       //  let propList = [prop1,prop2,prop3,prop4]
         let ingrList = [ingre1,ingre2,ingre3,ingre4, ingre5]
         
         allMyMenu.append(contentsOf: menuList)
         allMyDish.append(contentsOf: dishList)
       //  allMyProperties.append(contentsOf: propList)
         allMyIngredients.append(contentsOf: ingrList)
         
     }
}


// OBSOLETE

/* func mappingModelList<T:MyModelProtocolMapConform, E: MyEnumProtocolMapConform>(modelList:[T], filtro: KeyPath<T,E>) -> [E] {
    
    let containerT: [T] = modelList
    let filter = filtro
    
    let firstStep = containerT.map { model -> [E] in
        let mod = model as! IngredientModel
       return [mod.conservazione]
    }
} */

/* func mappingModelList<T:MyModelProtocolMapConform>(modelType: T.Type) -> [T.MapProperty] {
    
    let containerT: [T] = assignToContainerT(modelType: modelType)
    
    let firstStep = containerT.map({$0.staticMapCategory})
   
    print("firstStep containerT.map -> \(firstStep)")
    let lastStep = centrifugaMapCategory(array: firstStep)
    return lastStep
    /* 12.04 -> dopo vari tentativi abbiamo volutamente abbandonato la possibilità di selezionare la categoria per la mappatura in modo dinamico, dopo esserci riusciti con un viewbuilder. Preferiamo una mappatura statica con filtro dinamico. */
} */

/* func filteredModelList<T:MyModelProtocolMapConform>(modelType:T.Type, filtro:T.MapCategory) -> [T] {
       
    let containerT: [T] = assignToContainerT(modelType: modelType)
     
    return containerT.filter({$0.mapCategoryAvaible.returnTypeCase() == filtro})
       
   } */

/*  private func centrifugaMapCategory<E:MyEnumProtocolMapConform>(array:[E]) -> [E] {
    
    var secondStep: [E] = []
    
    for eachCase in array {
        
        let element:E = eachCase.returnTypeCase()
        secondStep.append(element)
        
    }
    print("secondStep Centriguga(firstStep) -> \(secondStep)")
    let thirdStep = Set(secondStep)
    print("thirdStep Set(secondStep) -> \(thirdStep)")
    let lastStep = Array(thirdStep)
    print("lastStep Array(thirdStep) -> \(lastStep)")
    return lastStep
   
} */


/* private func assignToContainerT<T:MyModelProtocolMapConform> (modelType:T.Type) -> [T] {
    
    var containerT: [T] = []
    
    switch modelType {
        
    case is DishModel.Type:
        containerT = self.allMyDish as! [T]
    case is IngredientModel.Type:
        containerT = self.allMyIngredients as! [T]
    case is MenuModel.Type:
        containerT = self.allMyMenu as! [T]
    case is PropertyModel.Type:
        containerT = [] // type ancora non conforme al MyModelProtocolMapConform
        
    default: containerT = []
        
    }
    
    return containerT
} */


let menu1 = MenuModel(nome: "Pranzo WeekEnd", tipologia: .allaCarta, giorniDelServizio: [.venerdi,.sabato])
let menu2 = MenuModel(nome: "Pranzo Feriale", tipologia: .fisso(persone: "1", costo: "15"), giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi])
let menu3 = MenuModel(nome: "ColazioneExpress", tipologia: .fisso(persone: "1", costo: "2.5"), giorniDelServizio: [.giovedi])
let menu4 = MenuModel(nome: "CenaAllDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato])
