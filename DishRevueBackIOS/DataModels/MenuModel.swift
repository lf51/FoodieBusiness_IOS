//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation
import SwiftUI
import Firebase

struct MenuModel:MyProStatusPack_L1,MyProToolPack_L1,MyProDescriptionPack_L0,MyProVisualPack_L1,MyProCloudPack_L1/*MyModelStatusConformity */ {
     
    static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [MenuModel]> {
        return \.allMyMenu
    }
    
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
       // lhs.dishInDEPRECATO == rhs.dishInDEPRECATO &&
        lhs.rifDishIn == rhs.rifDishIn &&
        lhs.tipologia == rhs.tipologia &&
        lhs.status == rhs.status &&
        lhs.isAvaibleWhen == rhs.isAvaibleWhen &&
        lhs.dataInizio == rhs.dataInizio &&
        lhs.dataFine == rhs.dataFine &&
        lhs.giorniDelServizio == rhs.giorniDelServizio &&
        lhs.oraInizio == rhs.oraInizio &&
        lhs.oraFine == rhs.oraFine
      //  lhs.fasceOrarie == rhs.fasceOrarie
      
    }
    
 //   var id: String {self.intestazione.replacingOccurrences(of: " ", with: "").lowercased() } // deprecated 15.07
    
 //   var id: String { creaID(fromValue: self.intestazione) } // Deprecata 18.08
    var id: String
    
    var intestazione: String // Categoria Filtraggio
    var descrizione: String
    
  //  var dishInDEPRECATO: [DishModel] = [] // deprecata in futuro - 17.09 /*{willSet {status = newValue.isEmpty ? .vuoto : .completo(.archiviato)}} */
    
    var rifDishIn: [String] // riferimenti del piatti
    
    var tipologia: TipologiaMenu // Categoria di Filtraggio
    var status: StatusModel
    
    var isAvaibleWhen: AvailabilityMenu { willSet { giorniDelServizio = newValue == .dataEsatta ? [] : GiorniDelServizio.allCases } }
    
    var dataInizio: Date { willSet {
        dataFine = newValue.advanced(by: 604800)
    }} /*{ willSet {dataFine = newValue.advanced(by: 604800)}}*/// 19.09 // data inizio del Menu, che contiene al suo interno anche l'ora (estrapolabile) in cui è stato creato
    var dataFine: Date // opzionale perchè possiamo non avere una fine in caso di data fissa
    var giorniDelServizio:[GiorniDelServizio] // Categoria Filtraggio
    var oraInizio: Date { willSet {oraFine = newValue.advanced(by: 1800)} } // deprecata in futuro // ora Inizio del Menu che contiene al suo interno la data (estrapolabile) in cui è stato creato
    var oraFine: Date // deprecata in futuro

  //  var fasceOrarie:[FasciaOraria] = [FasciaOraria()]
    
    // init
    
    init() {
        
        let currentDate = Date()
        
        self.id = UUID().uuidString
        self.intestazione = ""
        self.descrizione = ""
        self.tipologia = .defaultValue
        self.status = .bozza()
        self.rifDishIn = []
        self.isAvaibleWhen = .defaultValue
        self.dataInizio = currentDate
        self.dataFine = currentDate.advanced(by: 604800)
        self.giorniDelServizio = []
        self.oraInizio = currentDate
        self.oraFine = currentDate.advanced(by: 1800)
        
    }
    
    init(tipologiaDiSistema:TipologiaMenu.DiSistema) {
        
        let currentDate = Date()
        
        switch tipologiaDiSistema {
        case .delGiorno:
            self.tipologia = .allaCarta(.delGiorno)
        case .delloChef:
            self.tipologia = .allaCarta(.delloChef)
        }
        
        self.id = UUID().uuidString
        self.intestazione = tipologiaDiSistema.shortDescription()
        self.descrizione = tipologiaDiSistema.modelDescription()
        self.status = .bozza(.disponibile)
        self.rifDishIn = []
        self.isAvaibleWhen = .dataEsatta
        self.dataInizio = currentDate
        self.dataFine = currentDate.advanced(by: 604800)
        let giornoDataInizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: currentDate)
        self.giorniDelServizio = [giornoDataInizio]
        self.oraInizio = Date.distantFuture.advanced(by: -3540)
        self.oraFine = Date.distantFuture.advanced(by: 82740)
        
    }
    
    
  /* init(tipologia:TipologiaMenu = .defaultValue) { // init del menu del giorno
      
        let currentDate = Date()
        
        if tipologia != .defaultValue {
            
            if tipologia == .allaCarta(.delGiorno) {
                self.intestazione = "Menu del Giorno"
                self.descrizione = "Rielaborato giornalmente, aggiunge ai menu online dei Piatti del giorno."
            }
            else if tipologia == .allaCarta(.delloChef) {
                self.intestazione = "Menu dello Chef"
                self.descrizione = "Fra i piatti già inseriti in altri menu, segnala quelli giornalmente consigliati dalla chef."
            }
            
            self.id = UUID().uuidString
            self.tipologia = tipologia
            self.status = .bozza(.disponibile)
            self.rifDishIn = []
            self.isAvaibleWhen = .dataEsatta
            self.dataInizio = currentDate
            self.dataFine = currentDate.advanced(by: 604800)
            
            let giornoDataInizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: currentDate)
            self.giorniDelServizio = [giornoDataInizio]
            self.oraInizio = Date.distantFuture.advanced(by: -3540)
            self.oraFine = Date.distantFuture.advanced(by: 82740)
            
        } else {
            
            self.id = UUID().uuidString
            self.intestazione = ""
            self.descrizione = ""
            self.tipologia = .defaultValue
            self.status = .bozza()
            self.rifDishIn = []
            self.isAvaibleWhen = .defaultValue
            self.dataInizio = currentDate
            self.dataFine = currentDate.advanced(by: 604800)
            self.giorniDelServizio = []
            self.oraInizio = currentDate
            self.oraFine = currentDate.advanced(by: 1800)
            
            
        }
        
    } */ // Deprecato 21.11
    
    // Struct interne 20.09 --> Valutare Spostamento/Mantenimento qui
   /* struct FasciaOraria:Hashable {
        let title:String?
        var oraInizio:Date = Date() {willSet {oraFine = newValue.advanced(by: 1800)}}
        var oraFine:Date = Date().advanced(by: 1800)
        
        init(title: String? = nil) {
            self.title = title
          
        }
    } */
    // Method
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
       // let tipologiaInt = frDoc[DataBaseField.tipologia] as? Int ?? 0
        let statusInt = frDoc[DataBaseField.status] as? Int ?? 0
        let availabilityInt = frDoc[DataBaseField.isAvaibleWhen] as? Int ?? 0
        let giorniInt = frDoc[DataBaseField.giorniDelServizio] as? [Int] ?? []
        
        self.id = frDoc.documentID
        self.intestazione = frDoc[DataBaseField.intestazione] as? String ?? ""
        self.descrizione = frDoc[DataBaseField.descrizione] as? String ?? ""
        self.rifDishIn = frDoc[DataBaseField.rifDishIn] as? [String] ?? []
        
      //  self.tipologia = TipologiaMenu // DA FARE -> Il Salvataggio è eterogeneo
        self.tipologia = .defaultValue // SISTEMARE
        
        self.status = StatusModel.convertiInCase(fromNumber: statusInt)
        self.isAvaibleWhen = AvailabilityMenu.convertiInCase(fromNumber: availabilityInt)
        self.giorniDelServizio = giorniInt.map({GiorniDelServizio.fromOrderValue(orderValue: $0)})
        
        self.dataInizio = frDoc[DataBaseField.dataInizio] as? Date ?? .now
        self.dataFine = frDoc[DataBaseField.dataFine] as? Date ?? .now
        self.oraInizio = frDoc[DataBaseField.oraInizio] as? Date ?? .now
        self.oraFine = frDoc[DataBaseField.oraFine] as? Date ?? .now
    }
    
    func documentDataForFirebaseSavingAction() -> [String:Any] {
        
        let documentData:[String:Any] = [
            
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.rifDishIn : self.rifDishIn,
            DataBaseField.tipologia : self.tipologia.orderAndStorageValuePlus(), // Nota 16.11
            DataBaseField.status : self.status.orderAndStorageValue(),
            DataBaseField.isAvaibleWhen : self.isAvaibleWhen.orderAndStorageValue(),
            DataBaseField.giorniDelServizio : self.giorniDelServizio.map({$0.orderAndStorageValue()}),
            DataBaseField.dataInizio : self.dataInizio,
            DataBaseField.dataFine : self.dataFine,
            DataBaseField.oraInizio : self.oraInizio,
            DataBaseField.oraFine : self.oraFine
        
        ]
        return documentData
    }
    
    struct DataBaseField {
        
        static let intestazione = "intestazione"
        static let descrizione = "descrizione"
        static let rifDishIn = "rifDish"
        static let tipologia = "tipologia" // Nota 16.11
        static let status = "status"
        static let isAvaibleWhen = "isAvaibleWhen"
        static let giorniDelServizio = "giorniDelServizio"
        static let dataInizio = "dataInizio"
        static let dataFine = "dataFine"
        static let oraInizio = "oraInizio"
        static let oraFine = "oraFine"
        
        
    }
    
//
    
    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let disabilita = self.rifDishIn.isEmpty
        
        let dishCount = viewModel.allMyDish.count
        let dishInMenu = self.rifDishIn.count
        
      return VStack {
            
            Button {
             //   viewModel[keyPath: navigationPath].append(DestinationPathView.categoriaMenu)
                
            } label: {
                HStack{
                    Text("Anteprima")
                    Image(systemName: "eye")
                }
            }.disabled(disabilita)
          
          Button {
              viewModel[keyPath: navigationPath].append(DestinationPathView.vistaPiattiEspansa(self))
              
          } label: {
              HStack{
                  Text("Espandi Piatti (\(dishInMenu)/\(dishCount))")
                  Image(systemName: "fork.knife.circle")
              }
          }.disabled(dishCount == 0)
            
        }
    }
    
   /* func returnNewModel() -> (tipo: MenuModel, nometipo: String) {
        (MenuModel(), "Menu")
    } */
    
   /* func returnModelTypeName() -> String {
        "Menu"
    } */ // deprecata
    
    // MyProSearchPack
    
    static func sortModelInstance(lhs: MenuModel, rhs: MenuModel,condition:FilterPropertyModel.SortCondition?,readOnlyVM:AccounterVM) -> Bool {
        
        switch condition {
            
        case .alfabeticoDecrescente:
            return lhs.intestazione < rhs.intestazione
            
        case .dataInizio:
           return lhs.dataInizio < rhs.dataInizio
            
        case .mostContaining:
            return lhs.rifDishIn.count > rhs.rifDishIn.count
            
        case .topRated:
           return lhs.mediaValorePiattiInMenu(readOnlyVM: readOnlyVM) >
            rhs.mediaValorePiattiInMenu(readOnlyVM: readOnlyVM)
            
        case .dataFine:
            return lhs.dataFine < rhs.dataFine
            
        case .topPriced:
            return lhs.tipologia.returnMenuPriceValue().asDouble >
            rhs.tipologia.returnMenuPriceValue().asDouble
            
        default:
            return lhs.intestazione < rhs.intestazione
        }
    }
    
    func modelStringResearch(string: String,readOnlyVM:AccounterVM?) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)

        guard readOnlyVM != nil else { return conditionOne }
        
        let allDish = readOnlyVM?.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.allMyDish)
       
        guard let allD = allDish else { return conditionOne }
        
        let mapped = allD.map({$0.intestazione.lowercased()})
        let allChecked = mapped.filter({$0.contains(ricerca)})
        
        let conditionTwo = !allChecked.isEmpty
        
        return conditionOne || conditionTwo
    }
    
    private func preCallIsOnAir(filterValue:MenuModel.OnlineStatus?) -> Bool {
    
        switch filterValue {
        case .online:
            return isOnAir(checkTimeRange: false)
        case .offline:
            return !isOnAir(checkTimeRange: false)
            
        default:
            return true
        }
        
    }
    
    func modelPropertyCompare(filterProperty: FilterPropertyModel, readOnlyVM: AccounterVM) -> Bool {
        
        self.modelStringResearch(string: filterProperty.stringaRicerca,readOnlyVM: readOnlyVM) &&
        self.preCallIsOnAir(filterValue: filterProperty.onlineOfflineMenu) &&
        filterProperty.compareStatusTransition(localStatus: self.status) &&
        filterProperty.compareCollectionToProperty(localCollection: self.giorniDelServizio, filterProperty: \.giornoServizio) &&
        filterProperty.comparePropertyToProperty(local: self.tipologia, filter: \.tipologiaMenu) &&
        filterProperty.comparePropertyToProperty(local: self.isAvaibleWhen, filter: \.rangeTemporaleMenu)
    
        
    }
    
    
    // end SearchPack
    
    func returnModelRowView(rowSize:RowSize) -> some View {
        MenuModel_RowView(menuItem: self,rowSize: rowSize)
    }
    
    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func modelStatusDescription() -> String {
        "Menu (\(self.status.simpleDescription().capitalized))"
    }
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [MenuModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.allMyMenu, "Lista Menu", "Menu","menucard")
    }

    func pathDestination() -> DestinationPathView {
        
        DestinationPathView.menu(self)
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// ritorna lo status associato al livello di completamento.
    func optionalComplete() -> Bool {
        
        self.descrizione != ""
    }
    
    // Metodi riguardanti la programmazione - onLine vs offLine
    
    /// Di default il check del timeRange viene effettuato. Se messo su false non viene eseguito e dunque viene controllato solo la compatibilità con i giorni. Utile per il monitor Servizio
    func isOnAir(checkTimeRange:Bool = true) -> Bool {
        
        // !! VEDI NOTA VOCALE 17.09 !! UPDATE 03.10 - Nota Vocale !!
        
        guard self.status.checkStatusTransition(check: .disponibile) else { return false }
        
        switch self.isAvaibleWhen {
            
        case .dataEsatta:
            return isOnAirDataEsatta(checkTimeRange: checkTimeRange)
        case .intervalloChiuso:
            return isOnAirClosedRange(checkTimeRange: checkTimeRange)
        case .intervalloAperto:
            return isOnAirOpenRange(checkTimeRange: checkTimeRange)
        case .noValue:
            return false
            
        }
        
    }
 
    private func isOnAirClosedRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
        let(_,endDay,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        guard isOnTimeRange(checkTimeRange: checkTimeRange) else { return false }
        
        guard isInsideFromTheStartDay() else { return false }
        
        guard currentDay.year! == endDay.year! else {
            return currentDay.year! < endDay.year!
        }
        
        guard currentDay.month! == endDay.month! else {
            return currentDay.month! < endDay.month!
        }
        
        return currentDay.day! <= endDay.day!
        
        
    }
    
    private func isOnAirOpenRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
        let(_,_,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderAndStorageValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        guard isOnTimeRange(checkTimeRange: checkTimeRange) else { return false }
        
        return isInsideFromTheStartDay()

        
        // !! NOTA VOCALE 17.09 !!
    }
    
    private func isOnAirDataEsatta(checkTimeRange:Bool) -> Bool { // lf51 18.09.22
        
       /* let(startDay,_,currentDay) = dateCalendario()
        let startDayPlain = [startDay.year!,startDay.month!,startDay.day!]
        let currentDayPlain = [currentDay.year!,currentDay.month!,currentDay.day!]
        
       // guard startDay == currentDay else { return false }
        guard startDayPlain == currentDayPlain else { return false } */
        
        let calendario = Calendar(identifier: .gregorian)
       // let currentDate = Date()
       /* let sameYear = calendario.isDate(currentDate, equalTo: self.dataInizio, toGranularity: .year)
        guard sameYear else { return false }
        let sameMonth = calendario.isDate(currentDate, equalTo: self.dataInizio, toGranularity: .month)
        guard sameMonth else { return false }
        let sameDay = calendario.isDate(currentDate, equalTo: self.dataInizio, toGranularity: .day)
        guard sameDay else { return false } */
        let isSame = calendario.isDateInToday(self.dataInizio)
        guard isSame else { return false }
        return isOnTimeRange(checkTimeRange: checkTimeRange)
        
    }

    private func isInsideFromTheStartDay() -> Bool { // lf51 18.09.22
        
        let(startDay,_,currentDay) = dateCalendario()
        
        guard currentDay.year! == startDay.year! else {
            
            return currentDay.year! > startDay.year! }
        
        guard currentDay.month! == startDay.month! else {
            
            return currentDay.month! > startDay.month!
        }
        
        return currentDay.day! >= startDay.day!
    }
    
    private func isOnTimeRange(checkTimeRange:Bool) -> Bool { // lf51 18.09.22 // deprecata 05.10
        
        guard checkTimeRange else { return true } // !! Nota Vocale 03.10
         
      //  let(startTime,endTime,currentTime) = timeCalendario() // deprecata 29.10
        
      /* if (currentTime.hour! > startTime.hour!) && (currentTime.hour! < endTime.hour!) { return true }
        
        else if (currentTime.hour! == startTime.hour!) && (currentTime.hour! == endTime.hour!) {
            if (currentTime.minute! >= startTime.minute!) && (currentTime.minute! < endTime.minute!) { return true }
            else { return false }
        }
        
        else if currentTime.hour! == startTime.hour! {
            if currentTime.minute! >= startTime.minute! { return true }
            else { return false }
        }
        else if currentTime.hour! == endTime.hour! {
            if currentTime.minute! < endTime.minute! { return true }
            else { return false }
        }
        else { return false } */
        /*
        let absoluteStart = (startTime.hour! * 60) + startTime.minute!
        let absoluteEnd = (endTime.hour! * 60) + endTime.minute!
        let absoluteCurrent = (currentTime.hour! * 60) + currentTime.minute!
        */ // deprecata 29.10
        let absoluteStart = csTimeConversione(data: self.oraInizio)
        let absoluteEnd = csTimeConversione(data: self.oraFine)
        let absoluteCurrent = csTimeConversione(data: Date.now)
        
        if (absoluteCurrent >= absoluteStart) && (absoluteCurrent < absoluteEnd) { return true }
        else { return false }
        
    }
  
    
    private func dateCalendario() -> (startDay:DateComponents,endDay:DateComponents,currentDay:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startDay = calendario.dateComponents([.day,.month,.year], from: self.dataInizio)
        let endDay = calendario.dateComponents([.day,.month,.year], from: self.dataFine)
        let currentDay = calendario.dateComponents([.day,.month,.year,.weekday], from: Date.now)

        return(startDay,endDay,currentDay)
        
    }

  /* private func timeCalendario() -> (startTime:DateComponents,endTime:DateComponents,currentTime:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startTime = calendario.dateComponents([.hour,.minute], from: self.oraInizio)
        let endTime = calendario.dateComponents([.hour,.minute], from: self.oraFine)
        let currentTime = calendario.dateComponents([.hour,.minute], from: Date.now)
        
       
        return(startTime,endTime,currentTime)
    } */ // Deprecata 29.10 -> Sostituita da csTimeConversione
    
    // Test 05.10
   
    func timeScheduleInfo() -> (isOnAirNow:Bool,nextCheck:TimeInterval,invalidateForEver:Bool,countDown:Int) {
        //Nota 06.10 - Da rielaborare. Occorre rielaborare tutte le funzioni che portano all'isOnAir per ottenere maggiorni informazioni, di modo da schedulare meglio il timer ed eventualmente invalidarlo
        let isOn = self.isOnAir()
        
        guard isOn else { return (false,1.0,false,0)} // provvisorio }
        
       /* let(_,end,current) = timeCalendario()
        
        let currentHourInMinute = (current.hour! * 60) + current.minute!
        let endHourInMinute = (end.hour! * 60) + end.minute! */ // deprecato 29.10
        let currentHourInMinute = csTimeConversione(data: Date.now)
        let endHourInMinute = csTimeConversione(data: self.oraFine)
        
        let differenceToEnd = endHourInMinute - currentHourInMinute
            
       return (true,60.0,false,differenceToEnd)
        
    }
    

    // end Test 05.10
    // Fine Metodi riguardanti la programmazione - onLine vs offLine
    
    /// Ritorna la media dei voti dei piatti contenuti. La media è pesata, tiene conto del numero di recensioni.
    func mediaValorePiattiInMenu(readOnlyVM:AccounterVM) -> Double {
        
        let allDish = readOnlyVM.modelCollectionFromCollectionID(collectionId: self.rifDishIn, modelPath: \.allMyDish)
        
        let allAvaibleDish = allDish.filter({
            $0.percorsoProdotto != .prodottoFinito &&
            $0.status.checkStatusTransition(check: .disponibile) })
        
        let tuttiVotiPesati = allAvaibleDish.map({$0.topRatedValue(readOnlyVM: readOnlyVM)})
        let tuttiPesi = allAvaibleDish.map({Double($0.rifReviews.count)})
        
        let sommaVotiPesati = csSommaValoriCollection(collectionValue: tuttiVotiPesati)
        let sommaPesi = csSommaValoriCollection(collectionValue: tuttiPesi)
        
        let media = sommaVotiPesati / sommaPesi
        return media
    }
    
    enum OnlineStatus:MyProEnumPack_L0 {

        static var allCases:[OnlineStatus] = [.online,.offline]
        
        case online,offline
        
        func simpleDescription() -> String {
            switch self {
            case .online:
                return "Online"
            case .offline:
                return "Offline"
            }
        }
        
        func returnTypeCase() -> MenuModel.OnlineStatus {
            self
        }
        
        func orderAndStorageValue() -> Int {
            switch self {
            case .online:
                return 1
            case .offline:
                return 0
            }
        }
    }
} // end Model




