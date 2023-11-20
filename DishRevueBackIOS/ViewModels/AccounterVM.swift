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
import Combine


/*public struct InitServiceObjet { // deprecato
    
    public let allPropertiesImage:[PropertyLocalImage]
    public let currentProperty:PropertyCurrentData
    
}*/

public enum SubViewStep {
    
    case mainView
    case openLandingPage
    case backToAuthentication
   // case openWaitingView
    
}
// final means that no other class can be inherit from this
//@MainActor
public final class AccounterVM:FoodieViewModel/*,MyProDataCompiler*/ {

    // manager
    let userManager:UserManager
    private(set) var propertiesManager:PropertyManager
    private(set) var categoriesManager:CategoriesManager
    private(set) var ingredientsManager:IngredientManager
    private(set) var subCollectionManager:SubCollectionManager
    
    @Published public var stepView:SubViewStep?
    @Published var isLoading: Bool?
     var cancellables = Set<AnyCancellable>()
    
   // @Published public var currentUser:UserCloudData?
    /// Andrebbe in superClasse, ma contiene una proprietà che è tipica del firestore, e non riusciamo ad importare il firestore nel framework e dunque l'abbiamo spostata in sottoClasse
    @Published public var allMyPropertiesImage:[PropertyLocalImage]
  
    @Published var showAlert: Bool = false
    @Published var alertItem: AlertModel? {didSet { showAlert = true} }
    @Published var logMessage:String?
    
    @Published var homeViewPath = NavigationPath()
    @Published var menuListPath = NavigationPath()
    @Published var dishListPath = NavigationPath()
    @Published var ingredientListPath = NavigationPath()
    
    @Published var resetScroll:Bool = false
    
    var allergeni:[AllergeniIngrediente] = AllergeniIngrediente.allCases // necessario al selettore Allergeni
    
    @Published var remoteStorage:RemoteChangeStorage = RemoteChangeStorage()
    
    var allDishFormatLabel:Set<String> {
        
        let allFormat:[DishFormat] = self.db.allMyDish.flatMap({$0.pricingPiatto})
        let allLabel = allFormat.compactMap({$0.label})
        return Set(allLabel)
    }
    
    
     deinit {
         print("ACCOUNTERVM_DEINIT")
       // GlobalDataManager.user.userListener?.remove()
       //  GlobalDataManager.property.propertyImagesListener?.remove()
         
        /* print("""
         
 Are Listener active when call ACCOUNTERVM_DEINIT :

 UserListener is active: \(GlobalDataManager.shared.userManager.userListener != nil),

 PropertyImagesListener is active: \(GlobalDataManager.shared.propertiesManager.propertyImagesListener != nil)

 """)*/
     
    }
    
    public init(userManager:UserManager) {
        
        print("""
[START] ACCOUNTERVM_INIT(id:\(userManager.currentUserUID)
UserManager refCount:\(CFGetRetainCount(userManager))
""")
        self.userManager = userManager
        self.propertiesManager = PropertyManager(userAuthUID: userManager.currentUserUID)
        self.subCollectionManager = SubCollectionManager()
        self.categoriesManager = CategoriesManager()
        self.ingredientsManager = IngredientManager()
        
        self.allMyPropertiesImage = [] // Da valutare optiona
        super.init(currentProperty: PropertyCurrentData()) // da valutare optional
            // let's start subscriber
        addUserManagerSubscriber()
        addPropertyManagerImagesSubscriber()
        addPropertyManagerCurrentPropSubscriber()
     
        addAllMyIngredientsSubscriber()
        
        addGenericSubscriber(to: self.subCollectionManager.allMyProductsPublisher.main)
        addGenericSubscriber(to: self.subCollectionManager.allMyMenuPublisher.main)
        addGenericSubscriber(to: self.subCollectionManager.allMyReviewsPublisher.main)
      //  addAllMyProductsSubscriber()
      //  addAllMyMenusSubscriber()
        addAllMyCategoriesSubscriber()
      //  addAllMyReviewsSubscriber()
 
        // start data train fetch
        fetchAndListenCurrentUserData()
        // vedi Nota 28.08.23
        
        print("""
[END_INIT]_AccounterVM

UserManager refCount:\(CFGetRetainCount(userManager))
""")
        
    }

   
    
   /* public init(from serviceObject:InitServiceObjet) {
        self.isLoading = true
        self.stepView = .mainView
       // self.dbCompiler = CloudDataCompiler(userAuthUID: "Deprecato")
      //  self.currentUser = nil
        self.allMyPropertiesImage = serviceObject.allPropertiesImage
            
        super.init(currentProperty: serviceObject.currentProperty)
        print("Init ACCOUNTERVM_propIMagesCount:\(self.allMyPropertiesImage.count)")
        
        
    }*/// deprecato
    
    public init(fromUser userCloudData:UserCloudData) {
        self.isLoading = true
        self.stepView = .mainView
       // self.currentUser = nil
        self.userManager = UserManager(userAuthUID: "")
        self.propertiesManager = PropertyManager(userAuthUID: "")
        self.subCollectionManager = SubCollectionManager()
        self.categoriesManager = CategoriesManager()
        self.ingredientsManager = IngredientManager()
        
        self.allMyPropertiesImage = []
        super.init(currentProperty: PropertyCurrentData())
        print("Init ACCOUNTERVM")
        
    } // deprecato

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
    
    /// Controlla se esiste già un meni di quel tipo, se si lo rigenera, altrimenti lo crea
    func creaORigeneraMenuDiSistema(tipo menu:TipologiaMenu.DiSistema) {
        
        var newMenu = MenuModel(tipologiaDiSistema: menu)
        
        if let oldModel = checkExistingUniqueModelName(model: newMenu).1 {
            
            newMenu.id = oldModel.id
            newMenu.rifDishIn = oldModel.rifDishIn
            
            self.updateModelOnSub(itemModel: newMenu)
            
        } else {
            
            self.createModelOnSub(itemModel: newMenu)
        }

    }
    /// rigenera un menu di sistema. Se si passa un altra tipologia ritorna un errore
    func rigeneraMenuDiSistema(from oldModel:MenuModel) {
        
        let subType = oldModel.tipologia.returnSubTypeCase()
        
        guard let subType else {
            
            self.logMessage = "BUG -> \(oldModel.intestazione) non è un menu di sistema"
            
            return }
        
        var new = MenuModel(tipologiaDiSistema: subType)
        new.id = oldModel.id
        new.rifDishIn = oldModel.rifDishIn
        
        self.updateModelOnSub(itemModel: new)
        
    }
    
    func creaPropertyRef(propertyRef:String,role:RoleModel) {
        
       // self.currentProperty.db.allMyPropertiesRef = [role:propertyRef]
        print("[ERRORE]Property ref:\(propertyRef) - Metodo Vuoto richiede UPDATE:\(role.rawValue)")
        
    }
        
    /// Manda un alert (opzionale, ) per confermare la creazione del nuovo Oggetto.
   /* func createItemModel<T:MyProStarterPack_L1>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil) where T.VM == AccounterVM {
        
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
    }*/// deprecato in futuro
    
   /* private func createItemModelExecutive<T:MyProStarterPack_L1>(itemModel:T, destinationPath:DestinationPath? = nil) where T.VM == AccounterVM {
        
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
        
    }*/// deprecato in Futuro
    
    /// Manda un alert per Confermare le Modifiche all'oggetto MyModelProtocol
    /*func updateItemModel<T:MyProStarterPack_L1>(itemModel:T,showAlert:Bool = false, messaggio: String = "", destinationPath:DestinationPath? = nil) where T.VM == AccounterVM  {
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
       
        
    }// deprecata in futuro
    
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
    }*/// deprecata in futuro
 
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
        
    } // deprecata
    
    // PropertyManager
    
    /// Metodo specifico delle proprietà per l'eliminazione che interagisce direttamente anche col server
    func deletePropertyAlert() {
        // Configurata per eliminare la proprietà corrente. Quindi per eliminare una property dobbiamo prima caricarla
        guard let property = currentProperty.info else { return }
        
        self.alertItem = AlertModel(
            title: "Azione non Reversibile",
            message: "Confermi di volere de-Registrare \(property.intestazione)?\nTutti i dati saranno eliminati",
            actionPlus: ActionModel(
                title: .elimina,
                action: {
                    withAnimation {
                        self.deletePropertyExecutive(property.id)
                      
                    }
                   
                }))
    }
    
    private func deletePropertyExecutive(_ propUID:String) {
        print("[EMPTY METHOD] - deletePropertyExecutive ")
    }
   /* private func deletePropertyExecutive(_ propUID:String) { // 15.08.23 da aggiornare
     
        self.dbCompiler.deRegistraProprietà(propertyUID: propUID) { deleteSuccess in
            
            if deleteSuccess {
               // il documento relativo alla Prop è stato eliminato dal firebase
                // aggiorniamo i ref dello user
                self.allMyPropertiesImage.removeAll(where: {$0.propertyID == propUID})
                let allRef = self.allMyPropertiesImage.compactMap({$0.propertyID})
                let userCloud = UserCloudData(propertiesRef: allRef)
                
                self.dbCompiler.publishGenericOnFirebase(collection: .businessUser, refKey: Self.userAuthData.id, element: userCloud)
               
                // update currentProperty
                
                if let next = self.allMyPropertiesImage.first {
                    // esistono altre immagini di proprietà / carichiamo la prima
                    print("CODICE ASSENTE in func deletePropertyExecutive ")
                  //  self.compilaFromPropertyImage(propertyImage: next)
                    
                } else {

                    // non ci sono altre immagini
                    // resettiamo lo user ai valori di autentica
                    let resetUser = UserRoleModel(uid: Self.userAuthData.id, userName: Self.userAuthData.userName, mail: Self.userAuthData.mail)
                    // creiamo un propertyData con property nil e cloudData vuoto
                   // self.currentProperty = PropertyDataModel(userAuth: resetUser)
  
                }

                self.alertItem = AlertModel(title: "Server Message", message: "Aggiornamento Proprietà success")
                
            } else {
                self.alertItem = AlertModel(title: "Server Error", message: "deRegistrazione non Avvenuta. Controllare la connessione e riprovare.\nSe il problema persiste contattare info@foodies.com")
            }
        }
        // rimuovi dal viewModel
       // self.deleteItemModelExecution(itemModel: property)
        
    }*/
    
    /// Manda un alert di conferma prima di eliminare l' Oggetto MyModelProtocol
   /* func deleteItemModel<T:MyProStarterPack_L1>(itemModel: T) where T.VM == AccounterVM {
        
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

    } // deprecato
    
    private func deleteItemModelExecution<T:MyProStarterPack_L1>(itemModel: T) where T.VM == AccounterVM {
        
        var containerT = assegnaContainer(itemModel: itemModel)
        
        guard let index = containerT.firstIndex(of: itemModel) else {
            self.alertItem = AlertModel(title: "Errore Locale", message: "Oggetto non presente nel database")
            return }
        
        containerT.remove(at: index)
        self.aggiornaContainer(containerT: containerT, modelT: itemModel)
        // Innesto 02.12.22
        self.remoteStorage.modelRif_deleted[itemModel.id] = itemModel.intestazione
        //
        self.alertItem = AlertModel(title: "Eliminazione Eseguita", message: "\(itemModel.intestazione) rimosso con Successo!")
        
    }*/ // deprecato
    
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
   
    func manageCambioStatusModel<M:MyProStatusPack_L1&Codable>(model:M,nuovoStatus:StatusTransition) where M.VM == AccounterVM {
        // Modificata 25.11
        
        var newModel = model
        newModel.status = model.status.changeStatusTransition(changeIn: nuovoStatus)
     
       // self.updateItemModel(itemModel: newModel)
        self.updateModelOnSub(itemModel: newModel)

    }
    
    /// ritorna un array con i piatti contenenti l'ingrediente passato. La presenza dell'ing è controllata fra i principali, i secondari, e i sosituti.
    func allDishContainingIngredient(idIng:String) -> [ProductModel] {
        
        let allDishFiltered = self.db.allMyDish.filter({$0.checkIngredientsIn(idIngrediente: idIng)})
        return allDishFiltered
        
    }
    
    // ALTRO
    
    /// Ritorna una tupla contenente le seguenti Info: Un array con tutti i menuModel ad accezzione di quelli di Sistema, il count dell'array, e il count dei menu (meno quelli di Sistema) contenenti l'id del piatto
    func allMenuMinusDiSistemaPlusContain(idPiatto:String) -> (allModelMinusDS:[MenuModel], allModelMinusDScount:Int,countWhereDishIsIn:Int) {
        
        let allMinusSistema = self.db.allMyMenu.filter({
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
                
        let witchContain = self.db.allMyMenu.filter({
            $0.rifDishIn.contains(idPiatto)
        })
        
        let allMenuCount = self.db.allMyMenu.count
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
        
      //  self.updateItemModel(itemModel: currentMenu)
        self.updateModelOnSub(itemModel: currentMenu)
        
    }

    /// Permette di inserire o rimuovere un piatto da un MenuDiSistema
    func manageInOutPiattoDaMenuDiSistema(idPiatto:String,menuDiSistema:TipologiaMenu.DiSistema) {
        
        if let menuDS = trovaMenuDiSistema(tipo: menuDiSistema) {
            
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
    
    func dishFilteredByIngrediet(idIngredient:String) -> [ProductModel] {
        // Da modificare per considerare anche gli ingredienti Sostituti
        
        let filteredDish = self.db.allMyDish.filter { dish in
            
            let ingredientiPrincipali = dish.ingredientiPrincipali ?? []
            let ingredientiSecondari = dish.ingredientiSecondari ?? []
            
            return ingredientiPrincipali.contains(where: { $0 == idIngredient }) ||
            ingredientiSecondari.contains(where: { $0 == idIngredient })
        }
        
        return filteredDish

    }

    /// filtra tutti gli ingredient Model presenti nel viewModel per status, escludendo quello con l'idIngredient passato.
    func ingredientListFilteredBy(idIngredient:String,ingredientStatus:StatusTransition) ->[IngredientModel] {

        let filterArray = self.db.allMyIngredients.filter({
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
    
    /// Azzera il path di riferimento e chiama il reset dello Scroll
    func refreshPathAndScroll(tab:DestinationPath) -> Void {

        let path = tab.vmPathAssociato()
        
        if self[keyPath: path].isEmpty { self.resetScroll.toggle() }
        else { self[keyPath: path] = NavigationPath() }

    }
    

    ///Richiede un TemporaryModel, e oltre a salvare il piatto, salva anche gli ingredienti nel viewModel. Ideata per Modulo Importazione Veloce
   /* func dishAndIngredientsFastSave(item: TemporaryModel) /*throws*/ {

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
            
            if !isTheModelAlreadyExist(modelID: ingredient.id,path: \.db.allMyIngredients) {
             
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
 
        self.db.allMyDish.append(dish)
        self.db.allMyIngredients.append(contentsOf: modelIngredients)

    }*/// 30_10_23 spostato in una extension

    /// La usiamo per creare un nome univoco dei Model per un confronto sull'unicità del nome
    private func creaNomeUnivocoModello(fromIntestazione:String) -> String {
        fromIntestazione.replacingOccurrences(of: " ", with: "").lowercased()
    }

    /// Crea Inventario Ingredienti per Lista della Spesa ordinato per aree tematiche (vegetali,latticini,carne,pesce)
    func inventarioIngredienti() -> [IngredientModel] {
         
         let allIDing = self.currentProperty.inventario.allInventario()
         let allING = self.modelCollectionFromCollectionID(collectionId: allIDing, modelPath: \.db.allMyIngredients)
           
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
    func monitorServizio(menuModelToAnalize allMenuOnAir:[MenuModel]) -> (rifMenuOnAir:[String],rifFoodBeverage:[String],rifProdottiFiniti:[String], rifIngredients:[String],rifPreparazioniEseguibili:[String]) {
        
        // Menu
       
        // menuModelToAnalize è il punto di partenza
       
        // Dish
        var allDishId:[String] = []

        for cart in allMenuOnAir {
            
            allDishId.append(contentsOf: cart.rifDishIn)
            
        }
        
        let cleanDish = Set(allDishId)
        let allDishIdCleaned = Array(cleanDish)
        
        let allProductModel:[ProductModel] = self.modelCollectionFromCollectionID(collectionId: allDishIdCleaned, modelPath: \.db.allMyDish)
        
        let allDishAvaible = allProductModel.filter({
            $0.status.checkStatusTransition(check: .disponibile) ||
            $0.status.checkStatusTransition(check: .inPausa)
        })
       
        let foodB = allDishAvaible.filter({
           /* $0.percorsoProdotto == .preparazioneBeverage ||
            $0.percorsoProdotto == .preparazioneFood*/
            $0.percorsoProdotto == .preparazione
        })
        
        let prodottiFiniti = allDishAvaible.filter({
            $0.percorsoProdotto == .finito()
        })
        //Update 09.07.23
        let composizioni = allDishAvaible.filter({$0.percorsoProdotto == .composizione()})
        // end update
        // Ingredient && eseguibilità Piatto
        var allIngredientsRif:[String] = []
        var dishEseguibili:[ProductModel] = [] // deprecata 16.03.23
        
        for dish in foodB {
            
           // let activeIngredient = dish.allIngredientsAttivi(viewModel: self)
            let activeIngRif = dish.allIngredientsRif()
            allIngredientsRif.append(contentsOf: activeIngRif)
            
            let isEseguibile = dish.controllaSeEseguibile(viewModel: self)
            if isEseguibile { dishEseguibili.append(dish) }
            
        }
        
        let cleanAllIngredient = Set(allIngredientsRif)
        let cleanAllIngreArray = Array(cleanAllIngredient)
        //
        
        let allIngModelFiltered = self.modelCollectionFromCollectionID(collectionId: cleanAllIngreArray, modelPath: \.db.allMyIngredients).filter({!$0.status.checkStatusTransition(check: .archiviato)})
        
        //
        
        let menuOn = allMenuOnAir.map({$0.id})
        let foodAndB = foodB.map({$0.id})
        //update 00.07.23
        let compo = composizioni.map({$0.id})
        let foodBevCompo = foodAndB + compo
        // end Update
        let readyProduct = prodottiFiniti.map({$0.id})
        let ingredientsNeeded = allIngModelFiltered.map({$0.id})
        let preparazioniOk = dishEseguibili.map({$0.id})
        
        return (menuOn,foodBevCompo,readyProduct,ingredientsNeeded,preparazioniOk)
        
    }
    
    /// Filtra una collezione di piatti per un executionStatus. Se passiamo nil, verrà filtrata l'intera collezione di piatti del viewModel.
    public func checkDishStatusExecution(of dishes:[String]? = nil,check:ProductModel.ExecutionState) -> [String] {
        
        let allModel:[ProductModel] = {
            
            guard let allDishes = dishes else {
                return self.db.allMyDish
            }
            
          let allModelDishes = self.modelCollectionFromCollectionID(
            collectionId: allDishes,
            modelPath: \.db.allMyDish)
        
            return allModelDishes
        }()
        
        let allModelChecked = allModel.filter({$0.checkStatusExecution(viewModel: self) == check})
        let allRif = allModelChecked.map({$0.id})
        
        return allRif
    }
    
    
    /*
    /// Ritorna un quadro corrente del servizio, ossia il servizo del giorno. Le preparazione tornate sono quelle marcate come .disponibili, i menu sono quelli onAir, e gli ingredienti quelli attivi delle preparazioni disponibili.
    func monitorServizio() -> (rifMenuOnAir:[String],rifFoodBeverage:[String],rifProdottiFiniti:[String], rifIngredients:[String],rifPreparazioniEseguibili:[String]) {
        
        // Menu
        
        let allMenuOnAir = self.allMyMenu.filter({$0.isOnAir(checkTimeRange: false)})
        
        // Dish
        var allDishId:[String] = []
      // var allDish:[ProductModel] = []
        
        for cart in allMenuOnAir {
            
            allDishId.append(contentsOf: cart.rifDishIn)
            
        }
        
        let cleanDish = Set(allDishId)
        let allDishIdCleaned = Array(cleanDish)
        
        let allProductModel:[ProductModel] = self.modelCollectionFromCollectionID(collectionId: allDishIdCleaned, modelPath: \.allMyDish)
        
        let allDishAvaible = allProductModel.filter({$0.status.checkStatusTransition(check: .disponibile)})
       
        let foodB = allDishAvaible.filter({
            $0.percorsoProdotto == .preparazioneBeverage ||
            $0.percorsoProdotto == .preparazioneFood
        })
        let prodottiFiniti = allDishAvaible.filter({
            $0.percorsoProdotto == .prodottoFinito
        })
        // Ingredient && eseguibilità Piatto
        var allIngredients:[IngredientModel] = []
        var dishEseguibili:[ProductModel] = []
        
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
        
    } */ // 09.03.23 Backup per upgrade a multiversion today/general
    
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
            
            allRev = self.db.allMyReviews
            
        } else {
            
            allRev = self.modelCollectionFromCollectionID(collectionId: rifReview!, modelPath: \.db.allMyReviews)
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
            $0.intestazione != "" &&
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
            $0.intestazione != "" &&
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
        
      /*  let dishReviewed = self.db.allMyDish.filter({
            !$0.rifReviews.isEmpty
        })
        let soloLePreparazioni = self.db.allMyDish.filter({
            $0.percorsoProdotto != .finito()
        })*/
        
         let soloLePreparazioni = self.db.allMyDish.filter({
             // preparazione + composizione
             $0.percorsoProdotto != .finito()
         })
        let dishReviewed = soloLePreparazioni.filter({
            // !$0.rifReviews.isEmpty
            $0.ratingInfo(readOnlyViewModel: self).count != 0
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
    
    /// Ritorna un array di recensioni ordinate per data di rilascio
    func reviewValue(rifReviews:[String]) -> [DishRatingModel] {
        
      //  let allRif = dish.rifReviews
        let allRev = self.modelCollectionFromCollectionID(collectionId: rifReviews, modelPath: \.db.allMyReviews)
        let sortElement = allRev.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        return sortElement
        
    } // Da Spostare altrove
    
   // 28.02.23
    func filtroRecensioni(rifReviews:[String],filter:TimeSchedule,lastCount:Int) -> [DishRatingModel] {
        
        let all = reviewValue(rifReviews: rifReviews)

        switch filter {
            
        case .all:
           return all
        case .last:
           return Array(all.prefix(lastCount))
        case .new:
            let currentDate = Date()
            let last24Count = all.filter({
                $0.dataRilascio < currentDate &&
                $0.dataRilascio > currentDate.addingTimeInterval(-86400)
            })
            return last24Count
            
        }
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
    
    public func filtraSpecificCollection<M:Object_FPC>(
        ofModel collection:[M],
        coreFilter: CoreFilter<M>) -> [M] where AccounterVM == M.VM {
            
            let container = collection.filter({$0.propertyCompare(coreFilter: coreFilter, readOnlyVM: self)})
            
            let containerOrdinato = container.sorted {
                M.sortModelInstance(lhs: $0, rhs: $1, condition: coreFilter.sortConditions, readOnlyVM: self)
            } // Lo abbiamo inserito per usare l'ordine alfabeico di default. in quanto non abbiamo predisposto la customizzazione del valore nella view che la utilizza
            
           return containerOrdinato
            
        }
}

extension AccounterVM {
    // fetch & save on Firebase
    private func fetchAndListenCurrentUserData()  {
        
        print("[START TRAIN FETCH DATA]_fetchAndListenCurrentUserData")
        // fa partire il treno dei dati grazie ai subscriber

        self.userManager
            .fetchAndListenUserDataPublisher()
        
    }
    
    func updateCategoriesListFromLocalCache(news:[CategoriaMenu],edited:[CategoriaMenu],removedId:[String]) async throws {
        
        var newsForMain:[CategoriaMenu] = []
        var newsForSub:[CategoriaMenu] = []
        
        for item in news {
            
            if let id = try await self.categoriesManager.checkCategoryAlreadyExistInLibrary(categoria: item) {
                // già esiste/salviamo solo nella sub con id dalla library
                let new = item.rigeneraCategoria(newId: id)
                newsForSub.append(new)
                
            } else {
                // non esiste/salviamo nella sub e nella library
                
                newsForMain.append(item)
                newsForSub.append(item)
                
            }
            
        }
        
        // salviamo nella main le nuove
        
        if !newsForMain.isEmpty {
            // questa la creiamo in batch ma non è comunque un problema perchè le main non hanno listener
            try await self.categoriesManager
               .publishInMainCollection(items: newsForMain)
        }
        
        // newsForSub + edited possono essere salvate insieme
        
        let allEdited = newsForSub + edited
        
        try await self.subCollectionManager.publishBatchSubCollection(sub: .allMyCategories, newOrEdited: allEdited, removed: removedId)

    }
    

}

extension AccounterVM {
    // subscriber

    private func addUserManagerSubscriber()  {
       // 1° Publisher
        print("[CALL]_addCurrentUserSubscriber")
        // alla prima chiama nell'init i subscriber non ricevono alcun valore per cui non viene eseguito alcun sink. Se dopo il fetch dei dati il valore ricevuto non è valido partiraà la landing
       // GlobalDataManager
         //   .shared
            self.userManager
            .userPublisher
            .sink { error in
                //
                print("ERRROR IN SINK_")
            } receiveValue: { [weak self] userData in
               
                guard let self else {
                    print("[SELF_is_WEAK]_addCurrentUserSubscriber")
                    return
                }
                guard let userData else {
                    // qui fallisce non tanto quando il documento non esiste, li va oltre, fallisce nel decodificare. In teoria se lo user è stato registrato non dovrebbe fallire. Proviamo a rimandarlo indietro e fargli reimpostare lo username e dunque tutto lo user nel firestore
                    print("""

                          [EPIC FAIL]_addCurrentUserSubscriber_USERDATA is NIL
                   
                           ViewModel reference Count: \(CFGetRetainCount(self))

                   """)

                    self.isLoading = nil
                    self.stepView = .backToAuthentication
                    
                    return
                }
                
                self.currentUser = userData
                
                guard let ref = userData.propertiesRef,
                      !ref.isEmpty else {
                    
                    print("[STOP]_addCurrentUserSubscriber_Properties ref is NIL or empty")
                    self.stepView = .openLandingPage
                    self.isLoading = nil
                    return
                }
                
                withAnimation {
                    self.stepView = .mainView
                    self.isLoading = true // in attesa di caricare i dati della proprietà
                }

                self.propertiesManager
                    .fetchAndListenPropertyImagesPublisher(from: ref)
                
                  /*  GlobalDataManager
                    .shared
                    .propertiesManager
                    .fetchAndListenPropertyImagesPublisher(
                        from: ref,
                        for: userData.id) */
                
            }.store(in: &cancellables)

    }

    private func addPropertyManagerImagesSubscriber()  {
        
        // 2°Publisher
        
        print("[CALL]_addPropertyImagesSubscriber")

        // GlobalDataManager
          //  .shared
        self.propertiesManager
            .propertyImagesPublisher
            .sink { error in
                //
            } receiveValue: { [weak self] allPropImages in
                
                guard let self,
                      let allPropImages else {
                    
                    print("[ERROR SINK]_PropIMAGES not VALID")
                    self?.isLoading = false
                    self?.stepView = .openLandingPage
                    
                    return
                }
                
                self.allMyPropertiesImage = allPropImages
                
                if self.isLoading != true {
                    
                    withAnimation {
                        self.isLoading = true
                    }
                }
               
                // fetch currenProperty

                   // GlobalDataManager
                   // .shared
                self.propertiesManager
                    .fetchCurrentPropertyPublisher(from: allPropImages)

            }.store(in: &cancellables)

    }
    
    private func addPropertyManagerCurrentPropSubscriber()  {
        // 3° Publisher
        print("[CALL]_addCurrentPropertySubscriber")
       
       // GlobalDataManager
         //   .shared
        self.propertiesManager
            .currentPropertyPublisher
            .sink { error in
                //
            } receiveValue: { [weak self] currentPropData, currentUserRole, propertyDocRef in
                //
                guard let self,
                      let currentPropData,
                      let currentUserRole,
                      let propertyDocRef else {
                    
                    print("[ERROR_SINK] Property Current Data not VALID")
                   
                    withAnimation {
                        self?.stepView = .openLandingPage
                        self?.isLoading = false
                    }
                    
                    return
                }

                if self.isLoading != true {
                    
                    withAnimation {
                        self.isLoading = true
                    }
                }
                print("[RECEIVE]_currentPropertyData_thread:\(Thread.current)")
              //  DispatchQueue.main.async {
                   // self.allMyPropertiesImage = propertiesImages
                    self.currentUser?.propertyRole = currentUserRole
                    self.currentProperty = currentPropData
       
             //  }
                // setta la prop corrente per le subCollection
                self.subCollectionManager.currentPropertySnap = propertyDocRef
                self.subCollectionManager
                    .retrieveCloudData()
               // fetch cloudDataStore
               /* GlobalDataManager
                    .shared
                    .cloudDataManager
                    .retrieveCloudData(from: propertyDocRef)*/
                
            }.store(in: &cancellables)

    }
    
    private func addAllMyCategoriesSubscriber() {
        
        self.subCollectionManager
            .allMyCategoriesPublisher
            .main
            .sink { completion in
                //
            } receiveValue: { [weak self] allCategories in
                
                guard let self,
                let allCategories else { 
                    print("[RECEIVE_VALUE]_addAllMyCategoriesSubscriber_NOVALUEorWEAKSELF")
                    self?.db.allMyCategories = []
                    self?.isLoading = nil
                    return }
                
                Task {
                    
                let joinedCategories = try await self.categoriesManager.joinCategories(from: allCategories)
                    
                    DispatchQueue.main.async {
                        
                        self.db.allMyCategories = joinedCategories
                        self.isLoading = nil
                        
                    }
                    
                }

            }.store(in: &cancellables)

    }
    
    private func addAllMyIngredientsSubscriber() {
        
        self.subCollectionManager
            .allMyIngredientsPublisher
            .main
            .sink { completion in
                //
            } receiveValue: { [weak self] allIngredients in
                
                guard let self,
                let allIngredients else {
                    print("[RECEIVE_VALUE]_addAllMyIngredientsSubscriber_NOVALUEorWEAKSELF")
                    self?.db.allMyIngredients = []
                    self?.isLoading = nil
                    return }
                
                Task {
                    
                    let joinedIngredients = try await self.ingredientsManager.joinIngredients(from: allIngredients)
                    print("joinedIngredients.count:\(joinedIngredients.count)")
                    DispatchQueue.main.async {
                        
                        self.db.allMyIngredients = joinedIngredients
                        self.isLoading = nil
                        
                        print("db.allMyIngredients.count:\(self.db.allMyIngredients.count)")
                    }
                    
                }

            }.store(in: &cancellables)

    }
    
    private func addGenericSubscriber<Item:MyProStarterPack_L1&Codable>(to publisher:PassthroughSubject<[Item]?,Error>) where Item.VM == AccounterVM {
        
        let kp = Item.basicModelInfoTypeAccess()
        
        publisher
            .sink { completion in
                //
            } receiveValue: { [weak self] items in
                
                guard let self,
                let items else {
                    print("[RECEIVE_VALUE]_addGenericSubscriber_to\(kp.debugDescription)")
                   // self?.db.allMyDish = []
                    self?[keyPath: kp] = []
                    self?.isLoading = nil
                    return }
                
                    DispatchQueue.main.async {
                        
                        self[keyPath: kp] = items
                        self.isLoading = nil
                        
                        print("\(kp.debugDescription) count:\(self[keyPath: kp].count)")
                    }
                    
            }.store(in: &cancellables)

    }
    
    
    
   /* private func addAllMyProductsSubscriber() {
        
        self.subCollectionManager
            .allMyProductsPublisher
            .main
            .sink { completion in
                //
            } receiveValue: { [weak self] allMyProducts in
                
                guard let self,
                let allMyProducts else {
                    print("[RECEIVE_VALUE]_addAllMyIngredientsSubscriber_NOVALUEorWEAKSELF")
                    self?.db.allMyDish = []
                    self?.isLoading = nil
                    return }
                
                    DispatchQueue.main.async {
                        
                        self.db.allMyDish = allMyProducts
                        self.isLoading = nil
                        
                        print("db.allMyProducts.count:\(self.db.allMyDish.count)")
                    }
                    
            }.store(in: &cancellables)

    }
    
    private func addAllMyMenusSubscriber() {
        
        self.subCollectionManager
            .allMyMenuPublisher
            .main
            .sink { completion in
                //
            } receiveValue: { [weak self] allMyMenus in
                
                guard let self,
                let allMyMenus else {
                    print("[RECEIVE_VALUE]_addAllMyIngredientsSubscriber_NOVALUEorWEAKSELF")
                    self?.db.allMyMenu = []
                    self?.isLoading = nil
                    return }
                
                    DispatchQueue.main.async {
                        
                        self.db.allMyMenu = allMyMenus
                        self.isLoading = nil
                        
                        print("db.allMyMenus.count:\(self.db.allMyMenu.count)")
                    }
                    
            }.store(in: &cancellables)

    }
    
    private func addAllMyReviewsSubscriber() {
        
        self.subCollectionManager
            .allMyReviewsPublisher
            .main
            .sink { completion in
                //
            } receiveValue: { [weak self] allMyReviews in
                
                guard let self,
                let allMyReviews else {
                    print("[RECEIVE_VALUE]_addAllMyIngredientsSubscriber_NOVALUEorWEAKSELF")
                    self?.db.allMyReviews = []
                    self?.isLoading = nil
                    return }
                
                    DispatchQueue.main.async {
                        
                        self.db.allMyReviews = allMyReviews
                        self.isLoading = nil
                        
                        print("db.allMyReviews.count:\(self.db.allMyReviews.count)")
                    }
                    
            }.store(in: &cancellables)

    }*/
}

import Firebase
/// save, update and delete Model
extension AccounterVM {
    
    func checkModelNotInVM<T:MyProStarterPack_L1 & Codable>(itemModel:T) -> Bool where T.VM == AccounterVM {
        
        // verifica unicità nel viewModel
        let kpContainerT = itemModel.basicModelInfoInstanceAccess().vmPathContainer
            
        let containerT = assegnaContainerFromPath(path: kpContainerT)
            
        return !containerT.contains(where: {$0.isEqual(to: itemModel)})
      
    }
    
    
    /// Crea un oggetto nella SubCollection. Manda un alert (opzionale)
    func createModelOnSub<T:MyProStarterPack_L1 & Codable>(
        itemModel:T,
        showAlert:Bool = false,
        alertMessagge: String = "",
        refreshPath:DestinationPath? = nil,
        encoder:Firestore.Encoder = Firestore.Encoder()) where T.VM == AccounterVM {
        
        if !showAlert {
            
            self.createModelExecutive(
                itemModel: itemModel,
                destinationPath: refreshPath,
                encoder: encoder)
            
        } else {
            
            self.alertItem = AlertModel(
                title: "Crea \(itemModel.intestazione)",
                message: alertMessagge,
                actionPlus: ActionModel(
                    title: .conferma,
                    action: {
        
                        self.createModelExecutive(
                            itemModel: itemModel,
                            destinationPath: refreshPath,
                            encoder: encoder)
                    
                                        }))
        }
    }
    
    private func createModelExecutive<T:MyProStarterPack_L1 & Codable>(
        itemModel:T,
        destinationPath:DestinationPath? = nil,
        encoder:Firestore.Encoder = Firestore.Encoder()) where T.VM == AccounterVM {

        // verifica unicità nel viewModel
      
     /*   let(kpContainerT,_,nomeModelloT,_) = itemModel.basicModelInfoInstanceAccess()
            
        let containerT = assegnaContainerFromPath(path: kpContainerT)
            
        guard !containerT.contains(where: {$0.isEqual(to: itemModel)}) else {
                return self.alertItem = AlertModel(
                    title: "Controllare",
                    message: "Hai già un \(nomeModelloT) con queste caratteristiche")
            } */
            
          /* guard self.checkModelNotInVM(itemModel: itemModel) else {
                
                return self.alertItem = AlertModel(
                    title: "Controllare",
                    message: "Hai già creato un oggetto con questo nome e caratteristiche")
                
            }*/ // obsoleto
            
            let sub = itemModel.subCollection() as! CloudDataStore.SubCollectionKey
            
            Task {
                
            // let item = itemModel
                
            /* if item is IngredientModel {
                // salva in main
                 let ingredient = item as! IngredientModel
                 
               /*  if let id = try await self.ingredientsManager.checkAndPublish(ingredient: ingredient) { item.id = id } */
                 try await manageIngredientCreation(item: ingredient){ id in
                     print("Nuovo Oggeto \(ingredient.intestazione) creato con id: \(id ?? "Nuovo")")
                 }
                     
             }*/// else {
                 
                 // salvare in subCollection
               try await self.subCollectionManager
                     .setDataSubCollectionSingleDocument(
                        to: sub,
                        item: itemModel,
                        throw: encoder)
           //  }

                // refresh del path
                if let path = destinationPath {
                    
                    self.refreshPath(destinationPath: path)
                    
                }

            }
    }
    
    /// Aggiorna un Modello nelle subCollection. Manda un alert di conferma optional
    func updateModelOnSub<T:MyProStarterPack_L1 & Codable>(
        itemModel:T,
        showAlert:Bool = false,
        alertMessage: String = "",
        refreshPath:DestinationPath? = nil,
        encoder:Firestore.Encoder = Firestore.Encoder()) where T.VM == AccounterVM  {

        if !showAlert {
            
            self.updateModelExecutive(
                itemModel: itemModel,
                destinationPath: refreshPath,
                encoder: encoder)
       
        } else {
            
            self.alertItem = AlertModel(
                title: "Confermare Modifiche",
                message: alertMessage,
                actionPlus: ActionModel(
                    title: .conferma,
                    action: {
        
                        self.updateModelExecutive(
                            itemModel: itemModel,
                            destinationPath: refreshPath,
                            encoder: encoder)
                    
                                        }))
        }
       
        
    }
    
    private func updateModelExecutive<T:MyProStarterPack_L1 & Codable>(
        itemModel: T,
        destinationPath: DestinationPath? = nil,
        encoder:Firestore.Encoder = Firestore.Encoder()) where T.VM == AccounterVM {
        
        let containerT = assegnaContainer(itemModel: itemModel)
  
        guard let _ = containerT.first(where: {$0.id == itemModel.id}) else {
                
                self.alertItem = AlertModel(title: "Errore", message: "Oggetto non presente nel database")
                return
            }
        
            let sub = itemModel.subCollection() as! CloudDataStore.SubCollectionKey
            
            Task {
                
             //   var item = itemModel
                
                // caso particolare IngredientModel
               /* if item is IngredientModel {
                    // Nota 29_10_23
                var ingredient = item as! IngredientModel
                    ingredient.id = UUID().uuidString // assegniamo un nuovo id per scongiurare che venga salvato nella main con il vecchio già esistente
                let oldID = item.id
                // eliminiamo il vecchio riferimento dalla subCollection
                try await self.subCollectionManager.deleteFromSubCollection(sub: sub, delete: oldID)
                    
                // sostituire il vecchio ingrediente con quello modificato nei piatti
                let allDish = self.allDishContainingIngredient(idIng: oldID)
                    
                if let id = try await self.ingredientsManager.checkAndPublish(ingredient: ingredient) { item.id = id } else { item.id = ingredient.id}
                    
                //rimpiazziamo il vecchio Id nei dish
                    let rigerateDish = allDish.compactMap({ $0.replaceIngredients(id: oldID, with: item.id)})
                    
                try await self.subCollectionManager.publishSubCollection(sub: .allMyDish, as: rigerateDish)
                    
 
                }*/
                
                try await self.subCollectionManager
                    .setDataSubCollectionSingleDocument(
                        to: sub,
                        item: itemModel,
                        throw: encoder)
                
                if let path = destinationPath {
                    
                    self.refreshPath(destinationPath: path)
                    
                }
            }

    }
    
    /// Permette di aggiornare un array di model
    func updateModelCollection<T:MyProStarterPack_L1 & Codable>(items:[T],sub:CloudDataStore.SubCollectionKey,destinationPath:DestinationPath? = nil) where T.VM == AccounterVM {
        
        Task {
            
            try await self.subCollectionManager.publishSubCollection(sub: sub, as: items)
            if let destPath = destinationPath {
                
                self.refreshPath(destinationPath: destPath)
                
            }
        }

    }
    
    ///Richiede un TemporaryModel, e oltre a salvare il piatto, salva anche gli ingredienti nel viewModel. Ideata per Modulo Importazione Veloce
    func dishAndIngredientsFastSave(item: TemporaryModel) /*throws*/ {

        Task {

        let rigenera = try await checkAnalizeAndRetrieve(temporaryModel: item)
            
        try await self.subCollectionManager
                .setDataSubCollectionSingleDocument(to: .allMyDish, item: rigenera.product)
            
        try await self.subCollectionManager
                .publishSubCollection(sub: .allMyIngredients, as: rigenera.ingredients)
        }

    }

    private func checkAnalizeAndRetrieve(temporaryModel:TemporaryModel) async throws -> (product:ProductModel,ingredients:[IngredientModel]) {
        // analizzare gli ingredienti / esistenti nel viewModel / esistenti nella library
       let ingredients = temporaryModel.ingredients
       let secondaryRif = temporaryModel.rifIngredientiSecondari
       
       let notInVM = ingredients.compactMap({
            if !self.isTheModelAlreadyExist(modelID: $0.id, path: \.db.allMyIngredients) { return $0 }
            else { return nil }
        })
        
       var ingRigenerated:[IngredientModel] = ingredients
       var secondaryRifRigenerated:[String] = secondaryRif
        
            for ingredient in notInVM {
                
                if let id = try await self.ingredientsManager.checkAndPublish(ingredient: ingredient) {
                    // esiste nella main e quindi lo rigeneriamo per la sub
                    var rigeneraING = ingredient
                    rigeneraING.id = id
                    
                    if let oldIndex = ingRigenerated.firstIndex(where: {$0.id == ingredient.id}) {
                        ingRigenerated[oldIndex] = rigeneraING
                    }
                    
                    if let index =  secondaryRifRigenerated.firstIndex(of: ingredient.id) {
                        secondaryRifRigenerated[index] = id
                    }
                }
        }
       
       let product = temporaryModel.generaProduct(from: ingRigenerated, and: secondaryRifRigenerated)
        
       return (product,ingRigenerated)
        
    }
    
    /// Manda un alert di conferma prima di eliminare l' Oggetto MyModelProtocol
    func deleteModel<T:MyProStarterPack_L1 & Codable>(itemModel: T,postDeleteAction:(@escaping() -> Void) = {} ) where T.VM == AccounterVM {
        
        self.alertItem = AlertModel(
            title: "Conferma Eliminazione",
            message: "Confermi di volere eliminare \(itemModel.intestazione)?",
            actionPlus: ActionModel(
                title: .elimina,
                action: {
                    withAnimation {
                        self.deleteModelExecution(itemModel: itemModel)
                        postDeleteAction()
                    }
                   
                }))

    }
    
    private func deleteModelExecution<T:MyProStarterPack_L1 & Codable>(itemModel: T) where T.VM == AccounterVM {
        

        Task {
            let sub = itemModel.subCollection() as! CloudDataStore.SubCollectionKey
            
            try await self.subCollectionManager.deleteFromSubCollection(sub: sub , delete: itemModel.id)
            self.alertItem = AlertModel(title: "Eliminazione Eseguita", message: "\(itemModel.intestazione) rimosso con Successo!")
        }

    }
    
}
/// save,update and delete Ingredient
extension AccounterVM {
    
    func updateIngredient(item:IngredientModel,refreshPath:DestinationPath? = nil) {
        
        Task {
            
            var ingredient = item
            ingredient.id = UUID().uuidString // assegniamo un nuovo id per scongiurare che venga salvato nella main con il vecchio già esistente
            
            let oldID = item.id
            // eliminiamo il vecchio riferimento dalla subCollection
            try await self.subCollectionManager.deleteFromSubCollection(sub: .allMyIngredients, delete: oldID)
            
            // sostituire il vecchio ingrediente con quello modificato nei piatti
            let allDish = self.allDishContainingIngredient(idIng: oldID)
            
            try await self.createIngredient(item: ingredient) { id in
                if let id { ingredient.id = id }
            }

            //rimpiazziamo il vecchio Id nei dish
            let rigerateDish = allDish.compactMap({ $0.replaceIngredients(id: oldID, with: ingredient.id)})
            
            try await self.subCollectionManager.publishSubCollection(
                sub: .allMyDish,
                as: rigerateDish)

            if let refreshPath {
                
                self.refreshPath(destinationPath: refreshPath)
            }
            
        } // chiusa task
    }
    
    /// handle id nel caso in cui questo ingrediente già esisteva nel cloud
    func createIngredient(item:IngredientModel,refreshPath:DestinationPath? = nil,handle:@escaping(_ id:String?) -> Void) async throws {
        
        Task {
            
            var ingredient = item
            
            if let id = try await self.ingredientsManager.checkAndPublish(ingredient: item) {
                ingredient.id = id
            }
            
            try await self.subCollectionManager
                .setDataSubCollectionSingleDocument(
                    to: .allMyIngredients,
                    item: ingredient)
            
            if ingredient.id != item.id { handle(ingredient.id) }
            else { handle(nil) }
            
            if let refreshPath {
                
                self.refreshPath(destinationPath: refreshPath)
            }
            
        }
    }
    
}

extension AccounterVM {
    
    /// ritorna l'id dell'eventuale prodotto
    func isASubOfReadyProduct(id ingredient:String) -> String? {
        
        let readyProduct = self.db.allMyDish.first(where: {$0.percorsoProdotto == .finito(ingredient)})
        
        return readyProduct?.id
    
    }
}
