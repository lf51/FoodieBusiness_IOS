//
//  AccounterVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import Foundation
import SwiftUI
import MapKit // da togliere quando ripuliamo il codice dai Test
import MyFoodiePackage
import MyPackView_L0
import MyFilterPackage

//public final class AccounterVM: MyProViewModelPack_L1 {
public final class AccounterVM:FoodieViewModel {
    
    private let instanceDBCompiler: CloudDataCompiler // pensare ad un ricollocamento in superClasse
    
    private var loadingCount:Int { willSet { isLoading = newValue != 8 } }
    @Published var isLoading: Bool
  //  let instanceCloudData:CloudDataStore // Non sappiamo ancora cosa farne 18.11
    
   // @Published var setupAccount:AccountSetup
   // @Published var inventarioScorte:Inventario

   // @Published public var allMyIngredients:[IngredientModel]
   // @Published public var allMyDish:[DishModel]
   // @Published public var allMyMenu:[MenuModel]
   // @Published public var allMyProperties:[PropertyModel]
    
   // @Published public var allMyCategories: [CategoriaMenu]
   // @Published public var allMyReviews:[DishRatingModel]

    @Published var showAlert: Bool = false
    @Published var alertItem: AlertModel? {didSet { showAlert = true} }
    
    @Published var homeViewPath = NavigationPath()
    @Published var menuListPath = NavigationPath()
    @Published var dishListPath = NavigationPath()
    @Published var ingredientListPath = NavigationPath()
   
    var allergeni:[AllergeniIngrediente] = AllergeniIngrediente.allCases // necessario al selettore Allergeni
    
    // Innesto 01.12.22
   // @Published var dishStatusChanged:Int = 0
   // @Published var menuStatusChanged:Int = 0
    @Published var remoteStorage:RemoteChangeStorage = RemoteChangeStorage()
    
    //10.02.23 Upgrade DishFormat
    
    var allDishFormatLabel:Set<String> {
        
        let allFormat:[DishFormat] = self.allMyDish.flatMap({$0.pricingPiatto})
        let allLabel = allFormat.compactMap({$0.label})
        return Set(allLabel)
    }
    
    //10.02.23
    
   override init(userUID:String? = nil) { // L'Init ufficiale del viewModel
      
            
           // let compilerInstance = CloudDataCompiler(UID: userUID)
            self.instanceDBCompiler = CloudDataCompiler(UID: userUID)
            self.loadingCount = 0
            self.isLoading = userUID != nil
           // self.instanceCloudData = compilerInstance.cloudDataInstance()
            
            // Quello che segue si potrebbe accorpare in una instanza cloud Data. Richiede un mare di modifiche :( - Attualmente 18.11 in standBy
           // let cloudDataStore = compilerInstance.cloudDataInstance()
       super.init(userUID: userUID)
               /* self.allMyIngredients = []
                self.allMyDish = []
                self.allMyMenu = []
                self.allMyProperties = []
                
                self.setupAccount = AccountSetup()
                self.inventarioScorte = Inventario()
                
                self.allMyReviews = []
                self.allMyCategories = [] */
        

        // fine categorie accorpabili

    }
    
    func fetchDataFromFirebase() {
        
        self.allMyIngredients = fakeCloudData.allMyIngredients
        self.allMyDish = fakeCloudData.allMyDish
        self.allMyMenu = fakeCloudData.allMyMenu
        self.allMyProperties = fakeCloudData.allMyProperties
        
        self.setupAccount = fakeCloudData.setupAccount
        self.inventarioScorte = fakeCloudData.inventarioScorte
        
        self.allMyReviews = fakeCloudData.allMyReviews
        self.allMyCategories = fakeCloudData.allMyCategories
        
        self.loadingCount = 8
        
    }

    
    // Method
    
    func saveDataOnFirebase() {
        
        var cloudData = CloudDataStore()
        
        cloudData.allMyIngredients = self.allMyIngredients
        cloudData.allMyMenu = self.allMyMenu
        cloudData.allMyDish = self.allMyDish
        cloudData.allMyProperties = self.allMyProperties
        
        cloudData.allMyCategories = self.allMyCategories
        cloudData.allMyReviews = self.allMyReviews
        
        cloudData.setupAccount = self.setupAccount
        cloudData.inventarioScorte = self.inventarioScorte
        
        self.instanceDBCompiler.publishOnFirebase(dataCloud: cloudData)
        
    }
    
    // Modifiche 25.08 / 30.08 - Metodi di compilazione per trasformazione da Oggetto a riferimento degli ingredienti nei Dish
    
    // Riorganizzazione per conformità ai protocolli 15.09
    
    // MyProStarterPack_L0
    
    
    /// ritorna un modello da un riferimento.
  /*   func modelFromId<M:MyProStarterPack_L0>(id:String,modelPath:KeyPath<AccounterVM,[M]>) -> M? {
        
        let containerM = self[keyPath: modelPath]
        return containerM.first(where: {$0.id == id})
    } // 31.12.22 Spostata in superClasse
    
    /// ritorna un array di modelli  da un array di riferimenti
    func modelCollectionFromCollectionID<M:MyProStarterPack_L0>(collectionId:[String],modelPath:KeyPath<AccounterVM,[M]>) -> [M] {
         
         var modelCollection:[M] = []
        
         for id in collectionId {
             
             if let model = modelFromId(id: id, modelPath: modelPath) {modelCollection.append(model)}
         }

        return modelCollection

     }*/ // 31.12.22 Spostata in superClasse

    
    // MyProStarterPack_L1
    
    /// Controlla se un modello esiste già nel viewModel controllando la presenza del sui ID
    func isTheModelAlreadyExist<M:MyProStarterPack_L1>(modelID:String, path: KeyPath<AccounterVM,[M]>) -> Bool {
        
       // let kp = model.basicModelInfoInstanceAccess().vmPathContainer
    
        let containerM = self[keyPath: path]
        return containerM.contains(where: {$0.id == modelID})
        
    }
    
    /// Controlla che non ci sia un modello con lo stesso nome, qualora ci fosse ritorna il modello esistente. Questo ci serve per dare superiorità al dato salvato nel caso ad esempio del fastSave
    func checkExistingUniqueModelName<M:MyProStarterPack_L1>(model:M) -> (Bool,M?) where M.VM == AccounterVM {
        
        print("NEW AccounterVM/checkModelExist - Item: \(model.intestazione)")
        
        let containerM = assegnaContainer(itemModel: model)
        let newItemUniqueName = creaNomeUnivocoModello(fromIntestazione: model.intestazione)
        
        guard let index = containerM.firstIndex(where: {creaNomeUnivocoModello(fromIntestazione: $0.intestazione) == newItemUniqueName}) else {return (false, nil)}
        
        let oldItem:M = containerM[index]
        return (true,oldItem)
        
    }
    
    /// Controlla se il nome del modello Passato esiste già, se si lo aggiorna, altrimenti lo crea.
    func switchFraCreaEUpdateModel<T:MyProStarterPack_L1>(itemModel:T) where T.VM == AccounterVM {
        // Nota 20.10 -> Risolvere rimuovendo e ricreando, senza update
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
    func createItemModel<T:MyProStarterPack_L1>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil) where T.VM == AccounterVM {
        
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
        
    private func createItemModelExecutive<T:MyProStarterPack_L1>(itemModel:T, destinationPath:DestinationPath? = nil) where T.VM == AccounterVM {
        
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
        // Innesto 02.12.22
        self.remoteStorage.modelRif_newOne.append(itemModel.id)
        //
        if let path = destinationPath {
            
            self.refreshPath(destinationPath: path)
            
        }
      /*  self.alertItem = AlertModel(
            title: "\(itemModel.intestazione)",
            message: "Oggetto Creato con Successo!") */
    
        print("Nuovo Oggeto \(itemModel.intestazione) creato con id: \(itemModel.id)")
        
    }
    
    /// Manda un alert per Confermare le Modifiche all'oggetto MyModelProtocol
    func updateItemModel<T:MyProStarterPack_L1>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil) where T.VM == AccounterVM  {
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
    
    private func updateItemModelExecutive<T:MyProStarterPack_L1>(itemModel: T, destinationPath: DestinationPath? = nil) where T.VM == AccounterVM {
        
        var containerT = assegnaContainer(itemModel: itemModel)
  
        guard let oldItemIndex = containerT.firstIndex(where: {$0.id == itemModel.id}) else {
            self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
            return}

        print("elementi nel Container Pre-Update: \(containerT.count)")
        
            containerT[oldItemIndex] = itemModel
            aggiornaContainer(containerT: containerT, modelT: itemModel)
        // Innesto 02.12.22
        self.remoteStorage.modelRif_modified.insert(itemModel.id)
        
        if let path = destinationPath {
            
            self.refreshPath(destinationPath: path)
            
        }
        
        print("elementi nel Container POST-Update: \(containerT.count)")
        print("updateItemModelExecutive executed")
    }
 
    ///  Permette di aggiornare un array di model. Modifica il viewModel solo dopo aver modificato localmente ogni elemento e manda il refresh del path a processo concluso. Non distingue fra item che hanno ricevuto modifiche e item modificati. Li riscrive tutti.
    func updateItemModelCollection<T:MyProStarterPack_L1>(items:[T],destinationPath:DestinationPath? = nil) where T.VM == AccounterVM {
        
        let itemsVmPath = T.basicModelInfoTypeAccess()
        var container = self[keyPath: itemsVmPath]
        
        for itemModel in items {
            
            if let index = container.firstIndex(where: {$0.id == itemModel.id}) {
                container[index] = itemModel
                // innesto 02.12.22
                self.remoteStorage.modelRif_modified.insert(itemModel.id)
            }
        }
        
       aggiornaContainer(containerT: container, path: itemsVmPath)
        
        if let destPath = destinationPath {
            
            self.refreshPath(destinationPath: destPath)
            
        }
        
    }
    
    /// Manda un alert di conferma prima di eliminare l' Oggetto MyModelProtocol
    func deleteItemModel<T:MyProStarterPack_L1>(itemModel: T) where T.VM == AccounterVM {
        
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
    
    private func deleteItemModelExecution<T:MyProStarterPack_L1>(itemModel: T) where T.VM == AccounterVM {
        
        var containerT = assegnaContainer(itemModel: itemModel)
        
        guard let index = containerT.firstIndex(of: itemModel) else {
            self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
            return }
        
        containerT.remove(at: index)
        self.aggiornaContainer(containerT: containerT, modelT: itemModel)
        // Innesto 02.12.22
        self.remoteStorage.modelRif_deleted[itemModel.id] = itemModel.intestazione
        //
        self.alertItem = AlertModel(title: "Eliminazione Eseguita", message: "\(itemModel.intestazione) rimosso con Successo!")
        
    }
    
    /// Riconosce e Assegna il container dal tipo di item Passato.Ritorna un container
    private func assegnaContainer<T:MyProStarterPack_L1>(itemModel:T) -> [T] where T.VM == AccounterVM {
       
        let pathContainer = itemModel.basicModelInfoInstanceAccess().vmPathContainer

        return self[keyPath: pathContainer]

    }
    
    /// Come AssegnaContainer ma richiede come parametro direttamente il path
    private func assegnaContainerFromPath<M:MyProStarterPack_L1>(path:KeyPath<AccounterVM,[M]>) -> [M] {
        
        self[keyPath: path]
        
    }
    
    /// Aggiorna il container nel viewModel corrispondente al tipo T passato.
   private func aggiornaContainer<T:MyProStarterPack_L1>(containerT: [T], modelT:T) where T.VM == AccounterVM {
      
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
    
  
    
    // MyProModelPack_L2 aka MyModelStatusConformity
    
    /*func infoFromId<M:MyProToolPack_L0>(id:String,modelPath:KeyPath<AccounterVM,[M]>) -> (isActive:Bool,nome:String,hasAllergeni:Bool) {
        
        guard let model = modelFromId(id: id, modelPath: modelPath) else { return (false,"",false) }

        let isActive = model.status.checkStatusTransition(check: .disponibile)
        let name = model.intestazione
        var allergeniIn:Bool = false
        
        if let ingredient = model as? IngredientModel {
            allergeniIn = !ingredient.allergeni.isEmpty
        }
        
        return (isActive,name,allergeniIn)
        
    }*/ // 31.12.22 Spostasta in SuperClass FoodieViewModel
    
    //
    
    // 23.10 Gestione del Cambio Status dei Modelli (Al fine di eliminare il binding dalle liste per il funzionamento del cambio status nei menu interattivi )
   
    func manageCambioStatusModel<M:MyProStatusPack_L1>(model:M,nuovoStatus:StatusTransition) where M.VM == AccounterVM {
        // Modificata 25.11
        
        var newModel = model
        newModel.status = model.status.changeStatusTransition(changeIn: nuovoStatus)
       // self.remoteStorage.modelRif_modified.insert(model.id)
        self.updateItemModel(itemModel: newModel)
        
       /* let newModel:M =  {
            
            var new = model
            new.status = model.status.changeStatusTransition(changeIn: nuovoStatus)
            return new
            
        }()
    
        self.updateItemModel(itemModel: newModel) */
    }
    
    /// ritorna un array con i piatti contenenti l'ingrediente passato. La presenza dell'ing è controllata fra i principali, i secondari, e i sosituti.
    func allDishContainingIngredient(idIng:String) -> [DishModel] {
        
        let allDishFiltered = self.allMyDish.filter({$0.checkIngredientsIn(idIngrediente: idIng)})
        return allDishFiltered
        
    }
    
    // ALTRO
    
    /// Ritorna una tupla contenente le seguenti Info: Un array con tutti i menuModel ad accezzione di quelli di Sistema, il count dell'array, e il count dei menu (meno quelli di Sistema) contenenti l'id del piatto
    func allMenuMinusDiSistemaPlusContain(idPiatto:String) -> (allModelMinusDS:[MenuModel], allModelMinusDScount:Int,countWhereDishIsIn:Int) {
        
        let allMinusSistema = self.allMyMenu.filter({
            $0.tipologia != .allaCarta(.delGiorno) &&
            $0.tipologia != .allaCarta(.delloChef)
        })
        
        let witchContain = allMinusSistema.filter({
            $0.rifDishIn.contains(idPiatto)
        })
        
        let allMinusCount = allMinusSistema.count
        let witchContainCount = witchContain.count
        
        return (allMinusSistema,allMinusCount,witchContainCount)
    }
    
    /// Ritorna una Tupla gemella dell'AllMenuMinusDiSistemaPlusContain ma senza escludere i menu di sistema
    func allMenuContaining(idPiatto:String) -> (allModelWithDish:[MenuModel], allMyMenuCount:Int,countWhereDishIsIn:Int) {
                
        let witchContain = self.allMyMenu.filter({
            $0.rifDishIn.contains(idPiatto)
        })
        
        let allMenuCount = self.allMyMenu.count
        let witchContainCount = witchContain.count
        
        return (witchContain,allMenuCount,witchContainCount)
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
            
            self.alertItem = AlertModel(title: "Errore", message: "Abilita nella Home il \(menuDiSistema.extendedDescription())")
        }
    }
    
    
    /// Controlla se un menuDiSistema contiene un dato piatto
  /*  func checkMenuDiSistemaContainDish(idPiatto:String,menuDiSistema:TipologiaMenu.DiSistema) -> Bool {
        
        if let menuDS = trovaMenuDiSistema(menuDiSistema: menuDiSistema) {
            return menuDS.rifDishIn.contains(idPiatto)
        } else {
            return false
        }

    }*/ // 02.01.23 Ricollocato in MyFoodiePackage
    
    /// Ritorna un menuDiSistema Attivo. Se non lo trova ritorna nil
   /*func trovaMenuDiSistema(menuDiSistema:TipologiaMenu.DiSistema) -> MenuModel? {
        
        let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
        
        return self.allMyMenu.first(where:{
               //  $0.tipologia.returnTypeCase() == tipologia &&
                 $0.tipologia == tipologia && // Vedi Nota 09.11
                 $0.isOnAir()
            })
    }*/ // 02.01.23 Ricollocato in MyFoodiePackage
    
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
    func dishAndIngredientsFastSave(item: TemporaryModel) /*throws*/ {

      /*  guard !checkExistingUniqueModelName(model: item.dish).0 else { // da spostare a monte, nell'estrapolazione delle Stringhe
            
            throw CancellationError()
            
        } *///06.10 Spostata nel forEach che crea le tab con il piatto.
        
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
            
            if !isTheModelAlreadyExist(modelID: ingredient.id,path: \.allMyIngredients) {
             
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
            if rifIngredientiPrincipali.contains(item.dish.id) {
                new.percorsoProdotto = .prodottoFinito
            }
            return new
            
        }()
 
        self.allMyDish.append(dish)
        self.allMyIngredients.append(contentsOf: modelIngredients)

    }

    /// La usiamo per creare un nome univoco dei Model per un confronto sull'unicità del nome
    private func creaNomeUnivocoModello(fromIntestazione:String) -> String {
        fromIntestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }

    /// Crea Inventario Ingredienti per Lista della Spesa ordinato per aree tematiche (vegetali,latticini,carne,pesce)
    func inventarioIngredienti() -> [IngredientModel] {
         
         let allIDing = self.inventarioScorte.allInventario()
         let allING = self.modelCollectionFromCollectionID(collectionId: allIDing, modelPath: \.allMyIngredients)
           
         let allVegetable = allING.filter({
             $0.origine.returnTypeCase() == .vegetale
         }).sorted(by: {$0.intestazione < $1.intestazione})
        
        /* let allMeat = allING.filter({
               $0.origine.returnTypeCase() == .animale &&
               !$0.allergeni.contains(.latte_e_derivati) &&
               !$0.allergeni.contains(.molluschi) &&
               !$0.allergeni.contains(.pesce) &&
               !$0.allergeni.contains(.crostacei)
           }).sorted(by: {$0.intestazione < $1.intestazione})
        
         let allFish = allING.filter({
               $0.allergeni.contains(.molluschi) ||
               $0.allergeni.contains(.pesce) ||
               $0.allergeni.contains(.crostacei)
           }).sorted(by: {$0.intestazione < $1.intestazione})
           
         let allMilk = allING.filter({
               $0.origine.returnTypeCase() == .animale &&
               $0.allergeni.contains(.latte_e_derivati)
           }).sorted(by: {$0.intestazione < $1.intestazione})
         
         // 09.02
         */
         
        let allMeat = allING.filter({
            
            let conditionOne = $0.origine.returnTypeCase() == .animale
            var conditionTwo = true
            
            if let allergens = $0.allergeni {
                
                conditionTwo =
                !allergens.contains(.latte_e_derivati) &&
                !allergens.contains(.molluschi) &&
                !allergens.contains(.pesce) &&
                !allergens.contains(.crostacei)
                
            }
               return conditionOne && conditionTwo
              
          }).sorted(by: {$0.intestazione < $1.intestazione})
       
        let allFish = allING.filter({
            
            if let allergens = $0.allergeni {
                
               return allergens.contains(.molluschi) ||
                allergens.contains(.pesce) ||
                allergens.contains(.crostacei)
                
            } else { return false }
             
            
          }).sorted(by: {$0.intestazione < $1.intestazione})
          
        let allMilk = allING.filter({
            
            let conditionOne = $0.origine.returnTypeCase() == .animale
            var conditionTwo = false
            if let allergens = $0.allergeni {
                conditionTwo = allergens.contains(.latte_e_derivati)
            }
              return conditionOne && conditionTwo
          }).sorted(by: {$0.intestazione < $1.intestazione})
        
         print("Dentro Inventario Filtrato")

         return (allVegetable + allMilk + allMeat + allFish)
       
     }

    /// Ritorna un quadro corrente del servizio, ossia il servizo del giorno. Le preparazione tornate sono quelle marcate come .disponibili, i menu sono quelli onAir, e gli ingredienti quelli attivi delle preparazioni disponibili.
    func monitorServizio() -> (rifMenuOnAir:[String],rifFoodBeverage:[String],rifProdottiFiniti:[String], rifIngredients:[String],rifPreparazioniEseguibili:[String]) {
        
        // Menu
        
        let allMenuOnAir = self.allMyMenu.filter({$0.isOnAir(checkTimeRange: false)})
        
        // Dish
        var allDishId:[String] = []
      // var allDish:[DishModel] = []
        
        for cart in allMenuOnAir {
            
            allDishId.append(contentsOf: cart.rifDishIn)
            
        }
        
        let cleanDish = Set(allDishId)
        let allDishIdCleaned = Array(cleanDish)
        
        let allDishModel:[DishModel] = self.modelCollectionFromCollectionID(collectionId: allDishIdCleaned, modelPath: \.allMyDish)
        
        let allDishAvaible = allDishModel.filter({$0.status.checkStatusTransition(check: .disponibile)})
       
        let foodB = allDishAvaible.filter({
            $0.percorsoProdotto == .preparazioneBeverage ||
            $0.percorsoProdotto == .preparazioneFood
        })
        let prodottiFiniti = allDishAvaible.filter({
            $0.percorsoProdotto == .prodottoFinito
        })
        // Ingredient && eseguibilità Piatto
        var allIngredients:[IngredientModel] = []
        var dishEseguibili:[DishModel] = []
        
        for dish in foodB {
            
            let activeIngredient = dish.allIngredientsAttivi(viewModel: self)
            allIngredients.append(contentsOf: activeIngredient)
            
            let isEseguibile = dish.controllaSeEseguibile(viewModel: self)
            if isEseguibile { dishEseguibili.append(dish) }
            
        }
        
        let cleanAllIngredient = Set(allIngredients)
        let cleanAllIngreArray = Array(cleanAllIngredient)
    
        let menuOn = allMenuOnAir.map({$0.id})
        let foodAndB = foodB.map({$0.id})
        let readyProduct = prodottiFiniti.map({$0.id})
        let ingredientsNeeded = cleanAllIngreArray.map({$0.id})
        let preparazioniOk = dishEseguibili.map({$0.id})
        
        return (menuOn,foodAndB,readyProduct,ingredientsNeeded,preparazioniOk)
        
    }
    
    /// ritorna il numero di recensioni totali, quelle delle ultime 24h, la media totale, la media delle ulteme 10
  /*  func monitorRecensioni(rifReview:[String]? = nil) -> (totali:Int,l24:Int,mediaGen:Double,ml10:Double) {
        
        let starter:[DishRatingModel]
        
        if rifReview == nil {
            
            starter = self.allMyReviews
            
        } else {
            starter = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.allMyReviews)
        }
        
        
        let currentDate = Date()
        let totalCount = starter.count //.0
        
        let last24Count = starter.filter({
            $0.dataRilascio < currentDate &&
            $0.dataRilascio > currentDate.addingTimeInterval(-86400)
        }).count // .1
        
        let reviewByDate = starter.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        let onlyLastTen = reviewByDate.prefix(10)
        let onlyL10 = Array(onlyLastTen)
        
        let mediaGeneralePonderata = csCalcoloMediaRecensioni(elementi: starter) //.2
        let mediaL10 = csCalcoloMediaRecensioni(elementi: onlyL10) //.3
        
        return (totalCount,last24Count,mediaGeneralePonderata,mediaL10)
    }*/ // 07.02.23 Ricollocata in MyFoodiePackage
    
    /// Analizza un array di recensioni, di default è nil e analizza l'intero comparto recensioni nel viewModel. Ritorna il numero di recensioni negative, positive, topRange, complete, il trend di voto (positivo, negativo, topRange), e il trend di completamento delle recensioni.
    func monitorRecensioniPlus(rifReview:[String]? = nil) -> (negative:Int,positive:Int,top:Int,complete:Int,trendVoto:Int,trendComplete:Int) {
        
        let allRev:[DishRatingModel]
        
        if rifReview == nil {
            
            allRev = self.allMyReviews
            
        } else {
            
            allRev = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.allMyReviews)
        }
    
        let allVote = allRev.compactMap({$0.voto.generale})
        
        let negative = allVote.filter({$0 < 6.0}).count//.0
        let positive = allVote.filter({
            $0 >= 6.0 &&
            $0 < 9.0
        }).count//.1
        let topRange = allVote.filter({$0 >= 9.0}).count //.2
        
        let complete = allRev.filter({
            $0.rifImage != "" &&
            $0.titolo != "" &&
            $0.commento != ""
        }).count //.3
        
        // Analisi ultime 10
        
        let allByDate = allRev.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        let lastTen = allByDate.prefix(10)
        let lastTenArray = Array(lastTen)
        
        let l10AllVote = lastTenArray.compactMap({$0.voto.generale})
        
        let l10negative = l10AllVote.filter({$0 < 6.0}).count//.0
        let l10positive = l10AllVote.filter({
            $0 >= 6.0 &&
            $0 < 9.0
        }).count//.1
        let l10topRange = l10AllVote.filter({$0 >= 9.0}).count //.2
        
        var trendValue:Int = 0 // 1 is Negativo / 5 is Positivo / 10 is Top Range
        if l10negative > l10positive { trendValue = 1 }
        else if l10positive > l10negative {
            
            let value = Double(l10topRange) / Double(l10positive)
            
            if value >= 0.5 { trendValue = 10 }
            else { trendValue = 5}
        }
        
        let l10Complete = lastTenArray.filter({
            $0.rifImage != "" &&
            $0.titolo != "" &&
            $0.commento != ""
        }).count
        
        let completeFraLast10 = Double(l10Complete) / Double(lastTenArray.count)
        
        var trendComplete = 1
        if completeFraLast10 >= 0.5 { trendComplete = 2 }
        // trend completezza 1 negativo 2 positivo
        return (negative,positive,topRange,complete,trendValue,trendComplete)
    }
  
    /// Ritorna il numero di preparazioni (esclude i prodotti finit) con recensioni, il totale delle preparazioni, il numero di preparazioni con media sotto il 6, sopra il 6, sopra il 9.
    func monitorRecensioniMoreInfo() -> (preparazioniConRev:Int,totPrep:Int,negCount:Int,posCount:Int,topCount:Int) {
        
        let dishReviewed = self.allMyDish.filter({
            !$0.rifReviews.isEmpty
        })
        let soloLePreparazioni = self.allMyDish.filter({
            $0.percorsoProdotto != .prodottoFinito
        })
        
        let dishReviewedCount = dishReviewed.count // .1
        let totalePreparazioni = soloLePreparazioni.count  // .2
        
        
        let rateMap = dishReviewed.compactMap({$0.ratingInfo(readOnlyViewModel:self).media})
        
        let negative = rateMap.filter({$0 < 6.0}).count
        let positive = rateMap.filter({
            $0 >= 6.0 &&
            $0 < 9.0
        }).count
        let topRange = rateMap.filter({$0 >= 9.0}).count
        
        
        
        return (dishReviewedCount,totalePreparazioni,negative,positive,topRange)
    }
    
    // MyProSearchPack_L0 // Metodi per filtro e Ricarca
    
   /* func filtraERicerca<M:MyProToolPack_L1>(containerPath:WritableKeyPath<AccounterVM,[M]>,filterProperty:FilterPropertyModel) -> [M] where M.VM == AccounterVM, M.FPM == FilterPropertyModel {
        
        let container = self[keyPath: containerPath]
        
        let filterZero = container.filter({$0.status != .bozza()})
 
        let filterInTheModel = filterZero.filter({
            $0.modelPropertyCompare(filterProperty: filterProperty, readOnlyVM: self)
        })
        
        let sortedInTheModel = filterInTheModel.sorted{
            M.sortModelInstance(lhs: $0, rhs: $1, condition: filterProperty.sortCondition,readOnlyVM: self)
        }
        
        return sortedInTheModel
    }*/ // deprecata 19.12 // da cancellare
    
  /*  func filtraERicerca<M:MyProFilter_L0>(containerPath:WritableKeyPath<AccounterVM,[M]>,filterCore:FilterPropertyCore<M>) -> [M] where M.VM == AccounterVM {
        
        let container = self[keyPath: containerPath]
        
        guard let filterProp = filterCore.properties else {
            return container }
 
        let filterInTheModel = container.filter({
            $0.propertyCompare(filterProperty: filterProp, readOnlyVM: self)
        })
        
        guard let sortCond = filterCore.conditions else {
            return filterInTheModel }
        
        let sortedInTheModel = filterInTheModel.sorted{
            M.sortModelInstance(lhs: $0, rhs: $1, condition: sortCond,readOnlyVM: self)
        }
        
        return sortedInTheModel
    } */ // da cancellare
    
    
} // chiusa Class

extension AccounterVM:VM_FPC {
    
    public func ricercaFiltra<M:Object_FPC>(
        containerPath: WritableKeyPath<AccounterVM, [M]>,
        coreFilter: CoreFilter<M>) -> [M] where AccounterVM == M.VM {
        
        let container = self[keyPath: containerPath]
       // print("isContainerEmpty:\(container.isEmpty)")
      // let filterZero = container.filter({$0.status != .bozza()}) ???
        let containerFiltrato = container.filter({
            $0.propertyCompare(coreFilter: coreFilter, readOnlyVM: self)
        })
       // print("isContainerFilteredEmpty:\(containerFiltrato.isEmpty)")
        let containerOrdinato = containerFiltrato.sorted {
            M.sortModelInstance(lhs: $0, rhs: $1, condition: coreFilter.sortConditions, readOnlyVM: self)
        }
      //  print("isContainerSortedEmpty:\(containerOrdinato.isEmpty)")
        return containerOrdinato
    }
}




/*public class AccounterVM: ObservableObject {
    
    private let instanceDBCompiler: CloudDataCompiler
    private var loadingCount:Int { willSet { isLoading = newValue != 8 } }
    @Published var isLoading: Bool
  //  let instanceCloudData:CloudDataStore // Non sappiamo ancora cosa farne 18.11
    
    @Published var setupAccount:AccountSetup
    @Published var inventarioScorte:Inventario

    @Published var allMyIngredients:[IngredientModel]
    @Published var allMyDish:[DishModel]
    @Published var allMyMenu:[MenuModel]
    @Published var allMyProperties:[PropertyModel]
    
    @Published var allMyCategories: [CategoriaMenu]
    @Published var allMyReviews:[DishRatingModel]

    @Published var showAlert: Bool = false
    @Published var alertItem: AlertModel? {didSet { showAlert = true} }
    
    @Published var homeViewPath = NavigationPath()
    @Published var menuListPath = NavigationPath()
    @Published var dishListPath = NavigationPath()
    @Published var ingredientListPath = NavigationPath()
   
    var allergeni:[AllergeniIngrediente] = AllergeniIngrediente.allCases // necessario al selettore Allergeni
    
    // Innesto 01.12.22
   // @Published var dishStatusChanged:Int = 0
   // @Published var menuStatusChanged:Int = 0
    @Published var remoteStorage:RemoteChangeStorage = RemoteChangeStorage()
    
    
    init(userUID:String? = nil) { // L'Init ufficiale del viewModel
      
            
           // let compilerInstance = CloudDataCompiler(UID: userUID)
            self.instanceDBCompiler = CloudDataCompiler(UID: userUID)
            self.loadingCount = 0
            self.isLoading = userUID != nil 
           // self.instanceCloudData = compilerInstance.cloudDataInstance()
            
            // Quello che segue si potrebbe accorpare in una instanza cloud Data. Richiede un mare di modifiche :( - Attualmente 18.11 in standBy
           // let cloudDataStore = compilerInstance.cloudDataInstance()
         
                self.allMyIngredients = []
                self.allMyDish = []
                self.allMyMenu = []
                self.allMyProperties = []
                
                self.setupAccount = AccountSetup()
                self.inventarioScorte = Inventario()
                
                self.allMyReviews = []
                self.allMyCategories = []
        

        // fine categorie accorpabili

    }
    
    func fetchDataFromFirebase() {
        
      //  self.isLoading = true
        
     /* self.instanceDBCompiler.downloadFromFirebase { cloudData in
            self.setupAccount = cloudData.setupAccount
            print("2. Fetch SetupAccpunt")
            
        }*/
       /* self.instanceDBCompiler.downloadIngredientFirebase { cloudData in
            self.allMyIngredients = cloudData.allMyIngredients
            print("3.end Fetch ingredients")
        } */
        
        
      /*  self.instanceDBCompiler.downloadFromFirebase_allMyElement { cloudData in
            print("isCloudData allMyDishEmpty: \(cloudData.allMyDish.isEmpty.description)")
            
            self.allMyIngredients = cloudData.allMyIngredients
            self.allMyDish = cloudData.allMyDish
            self.allMyMenu = cloudData.allMyMenu
            self.allMyProperties = cloudData.allMyProperties
            self.allMyCategories = cloudData.allMyCategories
            self.allMyReviews = cloudData.allMyReviews
            
            print("isCloudData at end allMyDishEmpty: \(cloudData.allMyDish.isEmpty.description)")
        } */
        print("1.fetchData.Start")
        self.instanceDBCompiler.downloadFromFirebase_allMyElement(collectionKP: \.allMyIngredients,cloudCollectionKey: .ingredient) { allMyElements,isDone in
            
            self.allMyIngredients = allMyElements
            self.loadingCount += isDone
            print("1.Closure.ING")
        }
        print("2.fetchData.InG")
        self.instanceDBCompiler.downloadFromFirebase_allMyElement(collectionKP: \.allMyDish,cloudCollectionKey: .dish) { allMyElements,isDone in
            
            self.allMyDish = allMyElements
            self.loadingCount += isDone
            print("2.Closure.Dish")
        }
        print("3.fetchData.Dish")
        self.instanceDBCompiler.downloadFromFirebase_allMyElement(collectionKP: \.allMyMenu,cloudCollectionKey: .menu) { allMyElements,isDone in
            
            self.allMyMenu = allMyElements
            self.loadingCount += isDone
            print("3.Closure.Menu")
        }
        print("4.fetchData.Menu")
        self.instanceDBCompiler.downloadFromFirebase_allMyElement(collectionKP: \.allMyProperties,cloudCollectionKey: .properties) { allMyElements,isDone in
            
            self.allMyProperties = allMyElements
            self.loadingCount += isDone
            print("4.Closure.Pro")
        }
        print("5.fetchData.Prop")
        self.instanceDBCompiler.downloadFromFirebase_allMyElement(collectionKP: \.allMyCategories,cloudCollectionKey: .categories) { allMyElements,isDone in
            
            self.allMyCategories = allMyElements.sorted(by: {$0.listIndex ?? 0 < $1.listIndex ?? 1}) // Nota 24.11
            self.loadingCount += isDone
            print("5.Closure.Cat")
        }
        print("6.fetchData.Cat")
        self.instanceDBCompiler.downloadFromFirebase_allMyElement(collectionKP: \.allMyReviews,cloudCollectionKey: .reviews) { allMyElements,isDone in
            
            self.allMyReviews = allMyElements
            self.loadingCount += isDone
            print("6.Closure.Rev")
        }
        print("7.fetchData.Rev")
        
        self.instanceDBCompiler.downloadFromFirebase_singleElement(singleKP: \.setupAccount, cloudCollectionKey: .anyDocument) { singleElement,isDone in
            self.setupAccount = singleElement
            self.loadingCount += isDone
            print("7.Closure.Setup")
        }
        
        self.instanceDBCompiler.downloadFromFirebase_singleElement(singleKP: \.inventarioScorte, cloudCollectionKey: .anyDocument) { singleElement,isDone in
            self.inventarioScorte = singleElement
            self.loadingCount += isDone
            print("8.Closure.INV")
        }
        
    }
    
    // Method
    
    func saveDataOnFirebase() {
        
        var cloudData = CloudDataStore()
        
        cloudData.allMyIngredients = self.allMyIngredients
        cloudData.allMyMenu = self.allMyMenu
        cloudData.allMyDish = self.allMyDish
        cloudData.allMyProperties = self.allMyProperties
        
        cloudData.allMyCategories = self.allMyCategories
        cloudData.allMyReviews = self.allMyReviews
        
        cloudData.setupAccount = self.setupAccount
        cloudData.inventarioScorte = self.inventarioScorte
        
        self.instanceDBCompiler.publishOnFirebase(dataCloud: cloudData)
        
    }
    
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
        // Nota 20.10 -> Risolvere rimuovendo e ricreando, senza update
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
        // Innesto 02.12.22
        self.remoteStorage.modelRif_newOne.append(itemModel.id)
        //
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
        // Innesto 02.12.22
        self.remoteStorage.modelRif_modified.insert(itemModel.id)
        
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
                // innesto 02.12.22
                self.remoteStorage.modelRif_modified.insert(itemModel.id)
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
        // Innesto 02.12.22
        self.remoteStorage.modelRif_deleted[itemModel.id] = itemModel.intestazione
        //
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
    
    // 23.10 Gestione del Cambio Status dei Modelli (Al fine di eliminare il binding dalle liste per il funzionamento del cambio status nei menu interattivi )
   
    func manageCambioStatusModel<M:MyProStatusPack_L1>(model:M,nuovoStatus:StatusTransition) {
        // Modificata 25.11
        
        var newModel = model
        newModel.status = model.status.changeStatusTransition(changeIn: nuovoStatus)
       // self.remoteStorage.modelRif_modified.insert(model.id)
        self.updateItemModel(itemModel: newModel)
        
       /* let newModel:M =  {
            
            var new = model
            new.status = model.status.changeStatusTransition(changeIn: nuovoStatus)
            return new
            
        }()
    
        self.updateItemModel(itemModel: newModel) */
    }
    
    /// ritorna un array con i piatti contenenti l'ingrediente passato. La presenza dell'ing è controllata fra i principali, i secondari, e i sosituti.
    func allDishContainingIngredient(idIng:String) -> [DishModel] {
        
        let allDishFiltered = self.allMyDish.filter({$0.checkIngredientsIn(idIngrediente: idIng)})
        return allDishFiltered
        
    }
    
    // ALTRO
    
    /// Ritorna una tupla contenente le seguenti Info: Un array con tutti i menuModel ad accezzione di quelli di Sistema, il count dell'array, e il count dei menu (meno quelli di Sistema) contenenti l'id del piatto
    func allMenuMinusDiSistemaPlusContain(idPiatto:String) -> (allModelMinusDS:[MenuModel], allModelMinusDScount:Int,countWhereDishIsIn:Int) {
        
        let allMinusSistema = self.allMyMenu.filter({
            $0.tipologia != .allaCarta(.delGiorno) &&
            $0.tipologia != .allaCarta(.delloChef)
        })
        
        let witchContain = allMinusSistema.filter({
            $0.rifDishIn.contains(idPiatto)
        })
        
        let allMinusCount = allMinusSistema.count
        let witchContainCount = witchContain.count
        
        return (allMinusSistema,allMinusCount,witchContainCount)
    }
    
    /// Ritorna una Tupla gemella dell'AllMenuMinusDiSistemaPlusContain ma senza escludere i menu di sistema
    func allMenuContaining(idPiatto:String) -> (allModelWithDish:[MenuModel], allMyMenuCount:Int,countWhereDishIsIn:Int) {
                
        let witchContain = self.allMyMenu.filter({
            $0.rifDishIn.contains(idPiatto)
        })
        
        let allMenuCount = self.allMyMenu.count
        let witchContainCount = witchContain.count
        
        return (witchContain,allMenuCount,witchContainCount)
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
            
            self.alertItem = AlertModel(title: "Errore", message: "Abilita nella Home il \(menuDiSistema.extendedDescription())")
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
        
        return self.allMyMenu.first(where:{
               //  $0.tipologia.returnTypeCase() == tipologia &&
                 $0.tipologia == tipologia && // Vedi Nota 09.11
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
    func dishAndIngredientsFastSave(item: TemporaryModel) /*throws*/ {

      /*  guard !checkExistingUniqueModelName(model: item.dish).0 else { // da spostare a monte, nell'estrapolazione delle Stringhe
            
            throw CancellationError()
            
        } *///06.10 Spostata nel forEach che crea le tab con il piatto.
        
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
            if rifIngredientiPrincipali.contains(item.dish.id) {
                new.percorsoProdotto = .prodottoFinito
            }
            return new
            
        }()
 
        self.allMyDish.append(dish)
        self.allMyIngredients.append(contentsOf: modelIngredients)

    }

    /// La usiamo per creare un nome univoco dei Model per un confronto sull'unicità del nome
    private func creaNomeUnivocoModello(fromIntestazione:String) -> String {
        fromIntestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }

    /// Crea Inventario Ingredienti per Lista della Spesa ordinato per aree tematiche (vegetali,latticini,carne,pesce)
    func inventarioIngredienti() -> [IngredientModel] {
         
         let allIDing = self.inventarioScorte.allInventario()
         let allING = self.modelCollectionFromCollectionID(collectionId: allIDing, modelPath: \.allMyIngredients)
           
         let allVegetable = allING.filter({
             $0.origine.returnTypeCase() == .vegetale
         }).sorted(by: {$0.intestazione < $1.intestazione})
        
         let allMeat = allING.filter({
               $0.origine.returnTypeCase() == .animale &&
               !$0.allergeni.contains(.latte_e_derivati) &&
               !$0.allergeni.contains(.molluschi) &&
               !$0.allergeni.contains(.pesce) &&
               !$0.allergeni.contains(.crostacei)
           }).sorted(by: {$0.intestazione < $1.intestazione})
        
         let allFish = allING.filter({
               $0.allergeni.contains(.molluschi) ||
               $0.allergeni.contains(.pesce) ||
               $0.allergeni.contains(.crostacei)
           }).sorted(by: {$0.intestazione < $1.intestazione})
           
         let allMilk = allING.filter({
               $0.origine.returnTypeCase() == .animale &&
               $0.allergeni.contains(.latte_e_derivati)
           }).sorted(by: {$0.intestazione < $1.intestazione})
         
         print("Dentro Inventario Filtrato")

         return (allVegetable + allMilk + allMeat + allFish)
       
     }

    /// Ritorna un quadro corrente del servizio, ossia il servizo del giorno. Le preparazione tornate sono quelle marcate come .disponibili, i menu sono quelli onAir, e gli ingredienti quelli attivi delle preparazioni disponibili.
    func monitorServizio() -> (rifMenuOnAir:[String],rifFoodBeverage:[String],rifProdottiFiniti:[String], rifIngredients:[String],rifPreparazioniEseguibili:[String]) {
        
        // Menu
        
        let allMenuOnAir = self.allMyMenu.filter({$0.isOnAir(checkTimeRange: false)})
        
        // Dish
        var allDishId:[String] = []
      // var allDish:[DishModel] = []
        
        for cart in allMenuOnAir {
            
            allDishId.append(contentsOf: cart.rifDishIn)
            
        }
        
        let cleanDish = Set(allDishId)
        let allDishIdCleaned = Array(cleanDish)
        
        let allDishModel:[DishModel] = self.modelCollectionFromCollectionID(collectionId: allDishIdCleaned, modelPath: \.allMyDish)
        
        let allDishAvaible = allDishModel.filter({$0.status.checkStatusTransition(check: .disponibile)})
       
        let foodB = allDishAvaible.filter({
            $0.percorsoProdotto == .preparazioneBeverage ||
            $0.percorsoProdotto == .preparazioneFood
        })
        let prodottiFiniti = allDishAvaible.filter({
            $0.percorsoProdotto == .prodottoFinito
        })
        // Ingredient && eseguibilità Piatto
        var allIngredients:[IngredientModel] = []
        var dishEseguibili:[DishModel] = []
        
        for dish in foodB {
            
            let activeIngredient = dish.allIngredientsAttivi(viewModel: self)
            allIngredients.append(contentsOf: activeIngredient)
            
            let isEseguibile = dish.controllaSeEseguibile(viewModel: self)
            if isEseguibile { dishEseguibili.append(dish) }
            
        }
        
        let cleanAllIngredient = Set(allIngredients)
        let cleanAllIngreArray = Array(cleanAllIngredient)
    
        let menuOn = allMenuOnAir.map({$0.id})
        let foodAndB = foodB.map({$0.id})
        let readyProduct = prodottiFiniti.map({$0.id})
        let ingredientsNeeded = cleanAllIngreArray.map({$0.id})
        let preparazioniOk = dishEseguibili.map({$0.id})
        
        return (menuOn,foodAndB,readyProduct,ingredientsNeeded,preparazioniOk)
        
    }
    
    /// ritorna il numero di recensioni totali, quelle delle ultime 24h, la media totale, la media delle ulteme 10
    func monitorRecensioni(rifReview:[String]? = nil) -> (totali:Int,l24:Int,mediaGen:Double,ml10:Double) {
        
        let starter:[DishRatingModel]
        
        if rifReview == nil {
            
            starter = self.allMyReviews
            
        } else {
            starter = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.allMyReviews)
        }
        
        
        let currentDate = Date()
        let totalCount = starter.count //.0
        
        let last24Count = starter.filter({
            $0.dataRilascio < currentDate &&
            $0.dataRilascio > currentDate.addingTimeInterval(-86400)
        }).count // .1
        
        let reviewByDate = starter.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        let onlyLastTen = reviewByDate.prefix(10)
        let onlyL10 = Array(onlyLastTen)
        
        let mediaGeneralePonderata = csCalcoloMediaRecensioni(elementi: starter) //.2
        let mediaL10 = csCalcoloMediaRecensioni(elementi: onlyL10) //.3
        
        return (totalCount,last24Count,mediaGeneralePonderata,mediaL10)
    }
    
    /// Analizza un array di recensioni, di default è nil e analizza l'intero comparto recensioni nel viewModel. Ritorna il numero di recensioni negative, positive, topRange, complete, il trend di voto (positivo, negativo, topRange), e il trend di completamento delle recensioni.
    func monitorRecensioniPlus(rifReview:[String]? = nil) -> (negative:Int,positive:Int,top:Int,complete:Int,trendVoto:Int,trendComplete:Int) {
        
        let allRev:[DishRatingModel]
        
        if rifReview == nil {
            
            allRev = self.allMyReviews
            
        } else {
            
            allRev = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.allMyReviews)
        }
    
        let allVote = allRev.compactMap({Double($0.voto)})
        
        let negative = allVote.filter({$0 < 6.0}).count//.0
        let positive = allVote.filter({
            $0 >= 6.0 &&
            $0 < 9.0
        }).count//.1
        let topRange = allVote.filter({$0 >= 9.0}).count //.2
        
        let complete = allRev.filter({
            $0.image != "" &&
            $0.titolo != "" &&
            $0.commento != ""
        }).count //.3
        
        // Analisi ultime 10
        
        let allByDate = allRev.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        let lastTen = allByDate.prefix(10)
        let lastTenArray = Array(lastTen)
        
        let l10AllVote = lastTenArray.compactMap({Double($0.voto)})
        
        let l10negative = l10AllVote.filter({$0 < 6.0}).count//.0
        let l10positive = l10AllVote.filter({
            $0 >= 6.0 &&
            $0 < 9.0
        }).count//.1
        let l10topRange = l10AllVote.filter({$0 >= 9.0}).count //.2
        
        var trendValue:Int = 0 // 1 is Negativo / 5 is Positivo / 10 is Top Range
        if l10negative > l10positive { trendValue = 1 }
        else if l10positive > l10negative {
            
            let value = Double(l10topRange) / Double(l10positive)
            
            if value >= 0.5 { trendValue = 10 }
            else { trendValue = 5}
        }
        
        let l10Complete = lastTenArray.filter({
            $0.image != "" &&
            $0.titolo != "" &&
            $0.commento != ""
        }).count
        
        let completeFraLast10 = Double(l10Complete) / Double(lastTenArray.count)
        
        var trendComplete = 1
        if completeFraLast10 >= 0.5 { trendComplete = 2 }
        // trend completezza 1 negativo 2 positivo
        return (negative,positive,topRange,complete,trendValue,trendComplete)
    }
  
    /// Ritorna il numero di preparazioni (esclude i prodotti finit) con recensioni, il totale delle preparazioni, il numero di preparazioni con media sotto il 6, sopra il 6, sopra il 9.
    func monitorRecensioniMoreInfo() -> (preparazioniConRev:Int,totPrep:Int,negCount:Int,posCount:Int,topCount:Int) {
        
        let dishReviewed = self.allMyDish.filter({
            !$0.rifReviews.isEmpty
        })
        let soloLePreparazioni = self.allMyDish.filter({
            $0.percorsoProdotto != .prodottoFinito
        })
        
        let dishReviewedCount = dishReviewed.count // .1
        let totalePreparazioni = soloLePreparazioni.count  // .2
        
        
        let rateMap = dishReviewed.compactMap({$0.ratingInfo(readOnlyViewModel:self).media})
        
        let negative = rateMap.filter({$0 < 6.0}).count
        let positive = rateMap.filter({
            $0 >= 6.0 &&
            $0 < 9.0
        }).count
        let topRange = rateMap.filter({$0 >= 9.0}).count
        
        
        
        return (dishReviewedCount,totalePreparazioni,negative,positive,topRange)
    }
    
    // MyProSearchPack_L0 // Metodi per filtro e Ricarca
    
    func filtraERicerca<M:MyProToolPack_L1>(containerPath:WritableKeyPath<AccounterVM,[M]>,filterProperty:FilterPropertyModel) -> [M] {
        
        let container = self[keyPath: containerPath]
        
        let filterZero = container.filter({$0.status != .bozza()})
 
        let filterInTheModel = filterZero.filter({
            $0.modelPropertyCompare(filterProperty: filterProperty, readOnlyVM: self) 
        })
        
        let sortedInTheModel = filterInTheModel.sorted{
            M.sortModelInstance(lhs: $0, rhs: $1, condition: filterProperty.sortCondition,readOnlyVM: self)
        }
        
        return sortedInTheModel
    }
    
}*/ // Backup 10.12.22



