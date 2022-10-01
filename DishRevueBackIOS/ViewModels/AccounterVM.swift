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
    @Published var categoriaMenuAllCases: [CategoriaMenu] = [
        CategoriaMenu(
            intestazione: "Antipasti",
            image: "🫒"),
        CategoriaMenu(
            intestazione: "Primi",
            image: "🍝"),
        CategoriaMenu(
            intestazione: "Secondi",
            image: "🍴"),
        CategoriaMenu(
            intestazione: "Contorni",
            image: "🥗"),
        CategoriaMenu(
            intestazione: "Frutta",
            image: "🍉"),
        CategoriaMenu(
            intestazione: "Dessert",
            image: "🍰"),
        CategoriaMenu(
            intestazione: "Bevande",
            image: "🍷")]
    
    @Published var allMyReviews:[DishRatingModel] = []
    @Published var inventarioScorte:Inventario = Inventario()
    // AREA TEST NAVIGATIONSTACK
    
    @Published var homeViewPath = NavigationPath()
    @Published var menuListPath = NavigationPath()
    @Published var dishListPath = NavigationPath()
    @Published var ingredientListPath = NavigationPath()

   // var defaultProperty: PropertyModel? { allMyProperties[0] } // NON SO SE MI SERVE al 28.06
    
    // FINE AREA TEST
   
    init() {
        
      //  fillFromListaBaseModello()
        print("Init -> AccounterVM")
    }
    
    // Method
    
    // Modifiche 25.08 / 30.08 - Metodi di compilazione per trasformazione da Oggetto a riferimento degli ingredienti nei Dish
    
    // Riorganizzazione per conformità ai protocolli 15.09
    
    // MyProStarterPack_L0
    
    /// ritorna un modello da un riferimento.
    func modelFromId<M:MyProStarterPack_L0>(id:String,modelPath:KeyPath<AccounterVM,[M]>) -> M? {
        
        let containerM = self[keyPath: modelPath]
        return containerM.first(where: {$0.id == id})
    }
    
    /// ritorna un array di modelli  da un array di riferimenti
    func modelCollectionFromCollectionID<M:MyProStarterPack_L0>(collectionId:[String],modelPath:KeyPath<AccounterVM,[M]>) -> [M] {
         
         var modelCollection:[M] = []
        
         for id in collectionId {
             
             if let model = modelFromId(id: id, modelPath: modelPath) {modelCollection.append(model)}
         }

        return modelCollection

     }

    
    // MyProStarterPack_L1
    
    /// Controlla se un modello esiste già nel viewModel controllando la presenza del sui ID
    func isTheModelAlreadyExist<M:MyProStarterPack_L1>(model:M) -> Bool {
        
        let kp = model.basicModelInfoInstanceAccess().vmPathContainer
        
        let containerM = self[keyPath: kp]
        
        return containerM.contains(where: {$0.id == model.id})
        
    }
    
    /// Controlla che non ci sia un modello con lo stesso nome, qualora ci fosse ritorna il modello esistente. Questo ci serve per dare superiorità al dato salvato nel caso ad esempio del fastSave
    func checkExistingUniqueModelName<M:MyProStarterPack_L1>(model:M) -> (Bool,M?) {
        
        print("NEW AccounterVM/checkModelExist - Item: \(model.intestazione)")
        
        let containerM = assegnaContainer(itemModel: model)
        let newItemUniqueName = creaNomeUnivocoModello(fromIntestazione: model.intestazione)
        
        guard let index = containerM.firstIndex(where: {creaNomeUnivocoModello(fromIntestazione: $0.intestazione) == newItemUniqueName}) else {return (false, nil)}
        
        let oldItem:M = containerM[index]
        return (true,oldItem)
        
    }
    
    /// Controlla se il nome del modello Passato esiste già, se si lo aggiorna, altrimenti lo crea.
    func switchFraCreaEUpdateModel<T:MyProStarterPack_L1>(itemModel:T) {
        
        if let oldModel = checkExistingUniqueModelName(model: itemModel).1 {
            
            let newOldModel:T = {
                var new = itemModel
                new.id = oldModel.id
                return new
            }()
            self.updateItemModel(itemModel: newOldModel)
            
        } else {
            self.createItemModel(itemModel: itemModel)
        }
        
    }
    
    
    /// Manda un alert (opzionale, ) per confermare la creazione del nuovo Oggetto.
    func createItemModel<T:MyProStarterPack_L1>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil) {
        
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
        
    private func createItemModelExecutive<T:MyProStarterPack_L1>(itemModel:T, destinationPath:DestinationPath? = nil) {
        
        // Mod 15.09
       // var containerT = assegnaContainer(itemModel: itemModel)
        
        let(kpContainerT,_,nomeModelloT,_) = itemModel.basicModelInfoInstanceAccess()
        var containerT = assegnaContainerFromPath(path: kpContainerT)
        //
        
        guard !containerT.contains(where: {$0.id == itemModel.id}) else {
            
        return self.alertItem = AlertModel(
                title: "Errore",
                message: "Id Oggetto Esistente")
        
            
        } // 18.08 Una volta cambiato l'id in UUIDString, questo problema è obsoleto, serviva per controllare l'unicità del nome. Lo manteniamo ma lo potremmo in futuro deprecare
        
        // Add 18.08
        
        guard !containerT.contains(where: {creaNomeUnivocoModello(fromIntestazione: $0.intestazione) == creaNomeUnivocoModello(fromIntestazione: itemModel.intestazione)}) else {
            
            return self.alertItem = AlertModel(
                    title: "Errore",
                    message: "Nome \(nomeModelloT) Esistente")
        }
        
        // End Adding 18.08
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
    func updateItemModel<T:MyProStarterPack_L1>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil)  {
        print("UpdateItemModel()")
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
    
    private func updateItemModelExecutive<T:MyProStarterPack_L1>(itemModel: T, destinationPath: DestinationPath? = nil) {
        
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
 
    ///  Permette di aggiornare un array di model. Modifica il viewModel solo dopo aver modificato localmente ogni elemento e manda il refresh del path a processo concluso. Non distingue fra item che hanno ricevuto modifiche e item modificati. Li riscrive tutti.
    func updateItemModelCollection<T:MyProStarterPack_L1>(items:[T],destinationPath:DestinationPath? = nil) {
        
        let itemsVmPath = T.basicModelInfoTypeAccess()
        var container = self[keyPath: itemsVmPath]
        
        for itemModel in items {
            
            if let index = container.firstIndex(where: {$0.id == itemModel.id}) {
                container[index] = itemModel
            }
        }
        
       aggiornaContainer(containerT: container, path: itemsVmPath)
        
        if let destPath = destinationPath {
            
            self.refreshPath(destinationPath: destPath)
            
        }
        
    }
    
    /// Manda un alert di conferma prima di eliminare l' Oggetto MyModelProtocol
    func deleteItemModel<T:MyProStarterPack_L1>(itemModel: T) {
        
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
    
    private func deleteItemModelExecution<T:MyProStarterPack_L1>(itemModel: T) {
        
        var containerT = assegnaContainer(itemModel: itemModel)
        
        guard let index = containerT.firstIndex(of: itemModel) else {
            self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
            return }
        
        containerT.remove(at: index)
        self.aggiornaContainer(containerT: containerT, modelT: itemModel)
        self.alertItem = AlertModel(title: "Eliminazione Eseguita", message: "\(itemModel.intestazione) rimosso con Successo!")
        
    }
    
    /// Riconosce e Assegna il container dal tipo di item Passato.Ritorna un container
    private func assegnaContainer<T:MyProStarterPack_L1>(itemModel:T) -> [T] {
       
        let pathContainer = itemModel.basicModelInfoInstanceAccess().vmPathContainer
        print("ViewModel/assegnaContainer() per itemModel: \(itemModel.intestazione)")
        return self[keyPath: pathContainer]

    }
    
    /// Come AssegnaContainer ma richiede come parametro direttamente il path
    private func assegnaContainerFromPath<M:MyProStarterPack_L1>(path:KeyPath<AccounterVM,[M]>) -> [M] {
        
        self[keyPath: path]
        
    }
    
    /// Aggiorna il container nel viewModel corrispondente al tipo T passato.
   private func aggiornaContainer<T:MyProStarterPack_L1>(containerT: [T], modelT:T) {

       let (pathContainer,nomeContainer,_,_) = modelT.basicModelInfoInstanceAccess()
       self[keyPath: pathContainer] = containerT
       
       self.alertItem = AlertModel(
            title: modelT.intestazione,
            message: "\(nomeContainer) aggiornata con Successo!")

    }
    
    private func aggiornaContainer<T:MyProStarterPack_L1>(containerT:[T],path:ReferenceWritableKeyPath<AccounterVM,[T]>) {
        
        self[keyPath: path] = containerT
        
        self.alertItem = AlertModel(
             title: "Update Process",
             message: "Aggiornamento completato con Successo!")
    }
    
    // MyProSearchPack_L0
    
    func stringResearch<T:MyProSearchPack_L0>(item: T, stringaRicerca: String) -> Bool {
        
        guard stringaRicerca != "" else { return true }
        
        let ricerca = stringaRicerca.replacingOccurrences(of: " ", with: "").lowercased()
        print("Dentro Stringa Ricerca")
        
        let result = item.modelStringResearch(string: ricerca)
        return result

    }
    
    // MyProModelPack_L2 aka MyModelStatusConformity
    
    func infoFromId<M:MyProToolPack_L0>(id:String,modelPath:KeyPath<AccounterVM,[M]>) -> (isActive:Bool,nome:String,hasAllergeni:Bool) {
        
        guard let model = modelFromId(id: id, modelPath: modelPath) else { return (false,"",false) }

        let isActive = model.status.checkStatusTransition(check: .disponibile)
        let name = model.intestazione
        var allergeniIn:Bool = false
        
        if let ingredient = model as? IngredientModel {
            allergeniIn = !ingredient.allergeni.isEmpty
        }
        
        return (isActive,name,allergeniIn)
        
    }
    
    //
    
   
    
    
    // ALTRO
    
    /// Ritorna una tupla contenente le seguenti Info: Un array con tutti i menuModel ad accezzione di quelli di Sistema, il count dell'array, e il count dei menu (meno quelli di Sistema) contenenti l'id del piatto
    func allMenuMinusDiSistemaPlusContain(idPiatto:String) -> (allModelMinusDS:[MenuModel], allModelMinusDScount:Int,countWhereDishIsIn:Int) {
        
        let allMinusSistema = self.allMyMenu.filter({
            $0.tipologia != .delGiorno &&
            $0.tipologia != .delloChef
        })
        
        let witchContain = allMinusSistema.filter({
            $0.rifDishIn.contains(idPiatto)
        })
        
        let allMinusCount = allMinusSistema.count
        let witchContainCount = witchContain.count
        
        return (allMinusSistema,allMinusCount,witchContainCount)
    }
    
    
    /// Permette di inserire o rimuovere un piatto da un MenuModel ed esegue l'update.
    func manageInOutPiattoDaMenuModel(idPiatto:String,menuDaEditare:MenuModel) {
        
        var currentMenu = menuDaEditare
        
        if menuDaEditare.rifDishIn.contains(idPiatto) {
            currentMenu.rifDishIn.removeAll(where: {$0 == idPiatto})
        } else {
            currentMenu.rifDishIn.append(idPiatto)
        }
        
        self.updateItemModel(itemModel: currentMenu)
        
    }

    /// Permette di inserire o rimuovere un piatto da un MenuDiSistema
    func manageInOutPiattoDaMenuDiSistema(idPiatto:String,menuDiSistema:TipologiaMenu.DiSistema) {
        
        if let menuDS = trovaMenuDiSistema(menuDiSistema: menuDiSistema) {
            
            manageInOutPiattoDaMenuModel(idPiatto: idPiatto, menuDaEditare: menuDS)
            
        } else {
            
            self.alertItem = AlertModel(title: "Errore", message: "Abilita nella Home il \(menuDiSistema.simpleDescription())")
        }
    }
    
    
    /// Controlla se un menuDiSistema contiene un dato piatto
    func checkMenuDiSistemaContainDish(idPiatto:String,menuDiSistema:TipologiaMenu.DiSistema) -> Bool {
        
        if let menuDS = trovaMenuDiSistema(menuDiSistema: menuDiSistema) {
            return menuDS.rifDishIn.contains(idPiatto)
        } else {
            return false
        }

    }
    
    /// Ritorna un menuDiSistema Attivo. Se non lo trova ritorna nil
    func trovaMenuDiSistema(menuDiSistema:TipologiaMenu.DiSistema) -> MenuModel? {
        
        let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
        
        return  self.allMyMenu.first(where:{
                 $0.tipologia.returnTypeCase() == tipologia &&
                 $0.isOnAir()
            })
    }
    
    func dishFilteredByIngrediet(idIngredient:String) -> [DishModel] {
        // Da modificare per considerare anche gli ingredienti Sostituti
        
        let filteredDish = self.allMyDish.filter { dish in
            dish.ingredientiPrincipali.contains(where: { $0 == idIngredient }) ||
            dish.ingredientiSecondari.contains(where: { $0 == idIngredient })
        }
        
        return filteredDish

    }

    /// filtra tutti gli ingredient Model presenti nel viewModel per status, escludendo quello con l'idIngredient passato.
    func ingredientListFilteredBy(idIngredient:String,ingredientStatus:StatusTransition) ->[IngredientModel] {

        let filterArray = self.allMyIngredients.filter({
            $0.id != idIngredient &&
            $0.status.checkStatusTransition(check: ingredientStatus)
            
        })

        return filterArray
    }
    
    
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

    ///Richiede un TemporaryModel, e oltre a salvare il piatto, salva anche gli ingredienti nel viewModel. Ideata per Modulo Importazione Veloce
    func dishAndIngredientsFastSave(item: TemporaryModel) throws {

        guard !checkExistingUniqueModelName(model: item.dish).0 else { // da spostare a monte, nell'estrapolazione delle Stringhe
            
            throw CancellationError()
            
        }
        
        let ingredients = item.ingredients
        let rifSecondari = item.rifIngredientiSecondari
        
        var modelIngredients:[IngredientModel] = []
        var rifIngredientiPrincipali:[String] = []
        var rifIngredientiSecondari:[String] = []
        
        for ingredient in ingredients {
            
           /* if !checkExistingUniqueModelID(model: ingredient).0 {
            
                modelIngredients.append(ingredient)
                // copia il modello solo se già non esiste
            } */
            
            if !isTheModelAlreadyExist(model: ingredient) {
             
                 modelIngredients.append(ingredient)
                 // copia il modello solo se già non esiste
             }
            
            if rifSecondari.contains(where: {$0 == ingredient.id})  {
                rifIngredientiSecondari.append(ingredient.id)
            } else {
                rifIngredientiPrincipali.append(ingredient.id)
            }
            // mentre salva il riferimento sempre per il piatto
            
        }
        
        let dish = {
            var new = item.dish
            new.categoriaMenu = item.categoriaMenu.id
            new.ingredientiPrincipali = rifIngredientiPrincipali
            new.ingredientiSecondari = rifIngredientiSecondari
            return new
            
        }()
 
        self.allMyDish.append(dish)
        self.allMyIngredients.append(contentsOf: modelIngredients)

    }

    /// La usiamo per creare un nome univoco dei Model per un confronto sull'unicità del nome
    private func creaNomeUnivocoModello(fromIntestazione:String) -> String {
        fromIntestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }

    /*
    ///Deprecata in futuro. Da Ottimizzare attraverso l'uso del keypath.
    func deepFiltering<M:MyProStarterPack_L0>(model:M, filterCategory:MapCategoryContainer) -> Bool {
       
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
           return dishModel.categoriaMenuDEPRECATA == filter
           
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
     
   } */ // in STAND-BY 16.09
    
  
    
 
    
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
