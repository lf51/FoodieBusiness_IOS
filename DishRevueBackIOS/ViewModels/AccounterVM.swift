//
//  AccounterVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import Foundation
import SwiftUI
import MapKit // da togliere quando ripuliamo il codice dai Test
//import SwiftProtobuf


class AccounterVM: ObservableObject {
    
    // questa classe punta ad essere l'unico ViewModel dell'app. Puntiamo a spostare qui dentro tutto ciò che deve funzionare trasversalmente fra le view, e a sostituire gli altri ViewModel col sistema Struct/@State con cui abbiamo creato un NuovoPiatto, un NuovoIngrediente, e un NuovoMenu.
    
    // ATTUALMENTE NON USATA - IN FASE TEST

    // create dal sistema

    // Deprecata in futuro (COmmunityIngredientModel)
    var allTheCommunityIngredients:[CommunityIngredientModel] = [] // tutti gli ingredienti di sistema o della community. Unico elemento "Social" dell'app Business. Published perchè qualora diventasse una communityIngredients dinamica deve aggiornarsi. Nella prima versione, cioè come array di ingredienti caricati dal sistema, potrebbe non essere published, perchè verrebbe caricata in apertura e stop. // load(fileJson)
    // la lista appIngredients sarà riempita da un json che creeremo con una lista di nomi di ingredienti. Dal nome verrà creato un Modello Ingrediente nel momento in cui sarà scelto dal ristoratore
    
    var listoneFromListaBaseModelloIngrediente: [IngredientModel] = [] // questo listone sarà creato contestualmente dalla listaBaseModelloIngrediente creata da un json
    
    // end creato dal sistema
    
    @Published var allMyIngredients:[IngredientModel] = []
    @Published var allMyDish:[DishModel] = [] // tutti i piatti creati dall'accounter
    @Published var allMyMenu:[MenuModel] = [] // tutti i menu creati dall'accounter
    @Published var allMyProperties:[PropertyModel] = [] /*{ willSet {
        print("cambio Valore allMyProperties")
        objectWillChange.send() } }*/ // Deprecato per Blocco ad una singola Proprietà per Account. Manteniamo la forma dell'array per motivi tecnici, per il momento ci limitiamo a bloccare l'eventuale incremento del contenuto oltre la singola unità.
    
    @Published var showAlert: Bool = false
    @Published var alertItem: AlertModel? {didSet {showAlert = true} }
    
    var allergeni:[AllergeniIngrediente] = AllergeniIngrediente.allCases // 19.05 --> Collocazione Temporanea
    @Published var categoriaMenuAllCases: [CategoriaMenu] = CategoriaMenu.allCases // 02.06 -> Dovrà riempirsi di dati dal server

    
    // AREA TEST NAVIGATIONSTACK
    
    @Published var homeViewPath = NavigationPath()
    @Published var menuListPath = NavigationPath()
    @Published var dishListPath = NavigationPath()
    @Published var ingredientListPath = NavigationPath()

    var defaultProperty: PropertyModel? { allMyProperties[0] } // NON SO SE MI SERVE al 28.06
    
    // FINE AREA TEST
   
    init() {
        
      //  fillFromListaBaseModello()
        print("Init -> AccounterVM")
    }
    
    // Method
    
    /// Esegue un controllo nel container di riferimento utilizzando solo l'ID. Se l'item è presente ritorna true e l'item trovato. Considera infattil'item già salvato di livello superiore come informazioni contenute e dunque lo ritorna.
   /* func checkExistingIngredient(item: IngredientModel) -> (Bool,IngredientModel?) {
        
        print("AccounterVM/checkExistingIngredient - Ingrediente \(item.intestazione)")
        
        guard let index = self.allMyIngredients.firstIndex(where: {$0.id == item.id}) else {return (false, nil)}
            
            let newIngredient:IngredientModel = self.allMyIngredients[index]
            return (true,newIngredient)
            
    } */ // Deprecated 31.05
    
    
    /// azzera il path di riferimento Passato
    func refreshPath(destinationPath: DestinationPath) {
        
        switch destinationPath {
        case .homeView:
          //  self.homeViewPath = NavigationPath()
            self.homeViewPath.removeLast()
        case .menuList:
          //  self.menuListPath = NavigationPath()
            self.menuListPath.removeLast()
        case .dishList:
           // self.dishListPath = NavigationPath()
            self.dishListPath.removeLast()
        case .ingredientList:
           // self.ingredientListPath = NavigationPath()
            self.ingredientListPath.removeLast()
        }
    }
    
    /// Aggiunge una destinaziona al Path. Utile per aggiungere View tramite Bottone
    func addToThePath(destinationPath:DestinationPath, destinationView:DestinationPathView) {
        
        switch destinationPath {
            
        case .homeView:
            self.homeViewPath.append(destinationView)
        case .menuList:
            self.menuListPath.append(destinationView)
        case .dishList:
            self.dishListPath.append(destinationView)
        case .ingredientList:
            self.ingredientListPath.append(destinationView)
        }
        
    }

    /// Esegue un controllo nel container di riferimento utilizzando solo l'ID. Se l'item è presente ritorna true e l'item trovato. Considera infattil'item già salvato di livello superiore come informazioni contenute e dunque lo ritorna.
    func checkExistingModel<M:MyModelProtocol>(model: M) -> (Bool,M?) {
        
        print("AccounterVM/checkExistingItem - Item: \(model.intestazione)")
        
        let containerM = assegnaContainer(itemModel: model)
        
        guard let index = containerM.firstIndex(where: {$0.id == model.id}) else {return (false, nil)}

            let newItem:M = containerM[index]
        
            return (true,newItem)
            
    }

    ///Richiede un DishModel, e oltre a salvare il piatto, salva anche gli ingredienti Principali nel viewModel. Ideata per Modulo Importazione Veloce
    func dishAndIngredientsFastSave(item: DishModel) throws {
        
        guard !checkExistingModel(model: item).0 else {
            
            throw CancellationError()
            
        }
            
         /*   self.alertItem = AlertModel(
                title: "Errore - Piatto Esistente",
                message: "Modifica il nome del piatto nell'Editor ed estrai nuovamente il testo.") */
     
        self.allMyDish.append(item)
        
        var newIngredient:[IngredientModel] = []
        
        for ingredient in item.ingredientiPrincipali {
            
            if !checkExistingModel(model: ingredient).0 {
                
                newIngredient.append(ingredient)
            }
            
        }
        
        self.allMyIngredients.append(contentsOf: newIngredient)

    }
    
    
   /* func createOrUpdateItemModel<T:MyModelProtocol>(itemModel:T) { // 03.05 Deprecated ma non ancora sostituita (02.07)
    
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
    } */ // Deprecta 11.07

    /// Manda un alert (opzionale, ) per confermare la creazione del nuovo Oggetto. 
    func createItemModel<T:MyModelProtocol>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil) {
        
        if !showAlert {
            
            self.createItemModelExecutive(itemModel: itemModel,destinationPath: destinationPath)
            
        } else {
            
            self.alertItem = AlertModel(
                title: "Crea \(itemModel.intestazione)",
                message: messaggio,
                actionPlus: ActionModel(
                    title: .conferma,
                    action: {
        
                        self.createItemModelExecutive(itemModel: itemModel, destinationPath: destinationPath)
                    
                                        }))
        }
    }
        
    private func createItemModelExecutive<T:MyModelProtocol>(itemModel:T, destinationPath:DestinationPath? = nil) {
        
        var containerT = assegnaContainer(itemModel: itemModel)
        
        guard !containerT.contains(where: {$0.id == itemModel.id}) else {
            
        return self.alertItem = AlertModel(
                title: "Errore",
                message: "Id Oggetto Esistente")
        
            
        }
        
        containerT.append(itemModel)
        aggiornaContainer(containerT: containerT, modelT: itemModel)
        if let path = destinationPath {
            
            self.refreshPath(destinationPath: path)
            
        }
      /*  self.alertItem = AlertModel(
            title: "\(itemModel.intestazione)",
            message: "Oggetto Creato con Successo!") */
    
        print("Nuovo Oggeto \(itemModel.intestazione) creato con id: \(itemModel.id)")
        
    }
    
    /// Manda un alert per Confermare le Modifiche all'oggetto MyModelProtocol
    func updateItemModel<T:MyModelProtocol>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil)  {
        
        if !showAlert {
            
            self.updateItemModelExecutive(itemModel: itemModel,destinationPath: destinationPath)
       
        } else {
            
            self.alertItem = AlertModel(
                title: "Confermare Modifiche",
                message: messaggio,
                actionPlus: ActionModel(
                    title: .conferma,
                    action: {
        
                        self.updateItemModelExecutive(itemModel: itemModel,destinationPath: destinationPath)
                    
                                        }))
        }
       
        
    }
    
    private func updateItemModelExecutive<T:MyModelProtocol>(itemModel: T, destinationPath: DestinationPath? = nil) {
        
        var containerT = assegnaContainer(itemModel: itemModel)
  
        guard let oldItemIndex = containerT.firstIndex(where: {$0.id == itemModel.id}) else {
            self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
            return}

        print("elementi nel Container Pre-Update: \(containerT.count)")
            containerT[oldItemIndex] = itemModel
            aggiornaContainer(containerT: containerT, modelT: itemModel)
        if let path = destinationPath {
            
            self.refreshPath(destinationPath: path)
            
        }
        
        
        print("elementi nel Container POST-Update: \(containerT.count)")
        print("updateItemModelExecutive executed")
    }
    
    /// Manda un alert di conferma prima di eliminare l' Oggetto MyModelProtocol
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
        
        var containerT = assegnaContainer(itemModel: itemModel)
        
        guard let index = containerT.firstIndex(of: itemModel) else {
            self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
            return }
        
        containerT.remove(at: index)
        self.aggiornaContainer(containerT: containerT, modelT: itemModel)
        self.alertItem = AlertModel(title: "Eliminazione Eseguita", message: "\(itemModel.intestazione) rimosso con Successo!")
        
    }
    
    ///Deprecata in futuro. Da Ottimizzare attraverso l'uso del keypath.
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
           return dishModel.categoriaMenu == filter
           
       case .base(let filter):
           
           guard filter != nil else { return true}
           let dishModel = model as! DishModel
           return dishModel.aBaseDi == filter
           
       case .tipologiaPiatto(let filter):
           
           guard filter != nil else { return true}
           let dishModel = model as! DishModel
           return dishModel.dieteCompatibili.contains(filter!)
           
       case .statusPiatto:
           print("Dentro statusPiatto/deepFiltering - Da Settare")
           return true
           
       case .menuAz, .ingredientAz,.dishAz, .reset:
           return true

       }
     
   }
    
    func stringResearch<T:MyModelStatusConformity>(item: T, stringaRicerca: String) -> Bool {
        
        guard stringaRicerca != "" else { return true }
        
        let ricerca = stringaRicerca.replacingOccurrences(of: " ", with: "").lowercased()
        print("Dentro Stringa Ricerca")
        
        let result = item.modelStringResearch(string: ricerca)
        return result
      /*  switch item.self {
            
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
            
        } */// Deprecata 19.07
    }
    
    /// Riconosce e Assegna il container dal tipo di item Passato.Ritorna un container e un bool (indicante se il container è o non è editabile)
    private func assegnaContainer<T:MyModelProtocol>(itemModel:T) -> [T] {
       
        let pathContainer = itemModel.viewModelContainer().pathContainer
        print("ViewModel/assegnaContainer() per itemModel: \(itemModel.intestazione)")
        return self[keyPath: pathContainer]

    }
    
    /// Aggiorna il container nel viewModel corrispondente al tipo T passato.
   private func aggiornaContainer<T:MyModelProtocol>(containerT: [T], modelT:T) {

       let (pathContainer,nomeContainer,_) = modelT.viewModelContainer()
       self[keyPath: pathContainer] = containerT
       
       self.alertItem = AlertModel(
            title: modelT.intestazione,
            message: "\(nomeContainer) aggiornata con Successo!")

    }
    
    /// Riconosce e Assegna il container dal tipo di item Passato.Ritorna un container e un bool (indicante se il container è o non è editabile)
  /*  private func assegnaContainer<T:MyModelProtocol>(itemModel:T) -> (container:[T],editAvaible:Bool) {
        
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
    } */ // Deprecata 11.07
    
    /// Aggiorna il container nel viewModel corrispondente al tipo T passato.
  /*  private func aggiornaContainer<T:MyModelProtocol>(containerT: [T], modelT:T) {
            
        let nomeContainer:String
        
        switch modelT.self {
            
        case is IngredientModel:
            self.allMyIngredients = containerT as! [IngredientModel]
            nomeContainer = "Lista Ingredienti"
        case is DishModel:
            self.allMyDish = containerT as! [DishModel]
            nomeContainer = "Lista Piatti"
        case is MenuModel:
            self.allMyMenu = containerT as! [MenuModel]
            nomeContainer = "Lista Menu"
        case is PropertyModel:
            self.allMyProperties = containerT as! [PropertyModel]
            nomeContainer = "Lista Proprietà"
            
        default: return
            
        }
        
        self.alertItem = AlertModel(
            title: modelT.intestazione,
            message: "\(nomeContainer) aggiornata con Successo!")
    
        
   // Il parametro modelT è in apparenza superfluo. Potremmo difatti farne a meno nel 99% dei casi, ma quando il containerT è vuoto, se lo usassimo per comprendere il tipo T avremmo dei bug.
    }*/ // Deprecata 11.07
    
    
  // AREA TEST -> DA ELIMINARE
    
     let ing1 = CommunityIngredientModel(nome: "basilico")
     let ing2 = CommunityIngredientModel(nome: "aglio")
     let ing3 = CommunityIngredientModel(nome: "olio")
     let ing4 = CommunityIngredientModel(nome: "prezzemolo")
     let ing5 = CommunityIngredientModel(nome: "origano")
     let ing6 = CommunityIngredientModel(nome: "sale")
     let ing7 = CommunityIngredientModel(nome: "pepe")
     
  //  let menu1 = MenuModel(nome: "Pranzo WeekEnd", tipologia: .allaCarta, giorniDelServizio: [.venerdi,.sabato])
  //  let menu2 = MenuModel(nome: "Pranzo Feriale", tipologia: .fisso(persone: "1", costo: "15"), giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi])
  //  let menu3 = MenuModel(nome: "ColazioneExpress", tipologia: .fisso(persone: "1", costo: "2.5"), giorniDelServizio: [.giovedi])
  //  let menu4 = MenuModel(nome: "CenaAllDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato])
    let prop1 = PropertyModel(nome: "Mia", coordinates:  CLLocationCoordinate2D(latitude: 37.510987, longitude: 13.041434))
    let prop2 = PropertyModel(nome: "Tua", coordinates:  CLLocationCoordinate2D(latitude: 37.510997, longitude: 13.041434))
    let prop3 = PropertyModel(nome: "Sua", coordinates:  CLLocationCoordinate2D(latitude: 37.510927, longitude: 13.041434))
    let prop4 = PropertyModel(nome: "Essa", coordinates: CLLocationCoordinate2D(latitude: 37.510937, longitude: 13.041434))
 

    
  //  let menu5 = MenuModel.Filter.tipologia(.allaCarta)
 //   let menu6 = MenuModel.Filter.tipologia(.fisso(costo: "25"))
    
 
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


//let menu1 = MenuModel(nome: "Pranzo WeekEnd", tipologia: .allaCarta, giorniDelServizio: [.venerdi,.sabato])
//let menu2 = MenuModel(nome: "Pranzo Feriale", tipologia: .fisso(persone: "1", costo: "15"), giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi])
//let menu3 = MenuModel(nome: "ColazioneExpress", tipologia: .fisso(persone: "1", costo: "2.5"), giorniDelServizio: [.giovedi])
//let menu4 = MenuModel(nome: "CenaAllDay", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato])
