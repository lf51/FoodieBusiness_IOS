//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation
import SwiftUI

struct MenuModel:MyProStarterPack_L0,MyProStatusPack_L1,MyProVisualPack_L0,MyProToolPack_L0,MyProDescriptionPack_L0/*MyModelStatusConformity */ {
    
    static func viewModelContainerStatic() -> ReferenceWritableKeyPath<AccounterVM, [MenuModel]> {
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
    var id: String = UUID().uuidString
    
    var intestazione: String = "" // Categoria Filtraggio
    var descrizione: String = ""
    
  //  var dishInDEPRECATO: [DishModel] = [] // deprecata in futuro - 17.09 /*{willSet {status = newValue.isEmpty ? .vuoto : .completo(.archiviato)}} */
    
    var rifDishIn: [String] = [] // riferimenti del piatti
    
    var tipologia: TipologiaMenu = .defaultValue // Categoria di Filtraggio
    var status: StatusModel = .bozza()
    
    var isAvaibleWhen: AvailabilityMenu = .defaultValue { willSet {giorniDelServizio = newValue == .dataEsatta ? [] : GiorniDelServizio.allCases } }
    
    var dataInizio: Date = Date() { willSet {
        dataFine = newValue.advanced(by: 604800)
    }} /*{ willSet {dataFine = newValue.advanced(by: 604800)}}*/// 19.09 // data inizio del Menu, che contiene al suo interno anche l'ora (estrapolabile) in cui è stato creato
    var dataFine: Date = Date().advanced(by: 604800) // opzionale perchè possiamo non avere una fine in caso di data fissa
    var giorniDelServizio:[GiorniDelServizio] = [] // Categoria Filtraggio
    var oraInizio: Date = Date() {willSet {oraFine = newValue.advanced(by: 1800)}} // deprecata in futuro // ora Inizio del Menu che contiene al suo interno la data (estrapolabile) in cui è stato creato
    var oraFine: Date = Date().advanced(by: 1800) // deprecata in futuro

  //  var fasceOrarie:[FasciaOraria] = [FasciaOraria()]
    
    // init
    
    init(tipologia:TipologiaMenu = .defaultValue) { // init del menu del giorno
      
        if tipologia != .defaultValue {
            
            if tipologia == .delGiorno {
                self.intestazione = "Menu del Giorno"
                self.descrizione = "Rielaborato giornalmente, aggiunge ai menu online dei Piatti del giorno."
            }
            else if tipologia == .delloChef {
                self.intestazione = "Menu dello Chef"
                self.descrizione = "Fra i piatti già contenuti in menu online, segnala quelli giornalmente consigliati dalla chef."
            }
            
            self.tipologia = tipologia
            self.status = .bozza(.disponibile)
            self.rifDishIn = []
            self.isAvaibleWhen = .dataEsatta
            self.dataInizio = Date()
            
            let giornoDataInizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: Date())
            self.giorniDelServizio = [giornoDataInizio]
            self.oraInizio = Date.distantFuture.advanced(by: -3540)
            self.oraFine = Date.distantFuture.advanced(by: 82740)
        }
        
    }
    
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
    
 
    
    
    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        let disabilita = self.rifDishIn.isEmpty
        
      return VStack {
            
            Button {
             //   viewModel[keyPath: navigationPath].append(DestinationPathView.categoriaMenu)
                
            } label: {
                HStack{
                    Text("Vedi Anteprima")
                    Image(systemName: "eye")
                }
            }.disabled(disabilita)
            
        }
    }
    
   /* func returnNewModel() -> (tipo: MenuModel, nometipo: String) {
        (MenuModel(), "Menu")
    } */
    
   /* func returnModelTypeName() -> String {
        "Menu"
    } */ // deprecata
    
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        MenuModel_RowView(menuItem: self)
    }
    
    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    func modelStatusDescription() -> String {
        "Menu (\(self.status.simpleDescription().capitalized))"
    }
    
    func viewModelContainerInstance() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM, [MenuModel]>, nomeContainer: String, nomeOggetto:String) {
        
        return (\.allMyMenu, "Lista Menu", "Menu")
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
    
    func isOnAir() -> Bool {
        
        // !! VEDI NOTA VOCALE 17.09 !!
        
        guard self.status.checkStatusTransition(check: .disponibile) else { return false }
        
        switch self.isAvaibleWhen {
            
        case .dataEsatta:
            return isOnAirDataEsatta()
        case .intervalloChiuso:
            return isOnAirClosedRange()
        case .intervalloAperto:
            return isOnAirOpenRange()
        case .noValue:
            return false
            
        }
        
    }
    
    private func isOnAirClosedRange() -> Bool { // lf51 18.09.22
        
        let(_,endDay,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        guard isOnTimeRange() else { return false }
        
        guard isInsideFromTheStartDay() else { return false }
        
        guard currentDay.year! == endDay.year! else {
            return currentDay.year! < endDay.year!
        }
        
        guard currentDay.month! == endDay.month! else {
            return currentDay.month! < endDay.month!
        }
        
        return currentDay.day! <= endDay.day!
        
    }
    
    private func isOnAirOpenRange() -> Bool { // lf51 18.09.22
        
        let(_,_,currentDay) = dateCalendario()
        let giorniServizioIntegerMap = self.giorniDelServizio.map({$0.orderValue()})
        
        guard giorniServizioIntegerMap.contains(currentDay.weekday!) else { return false }
        guard isOnTimeRange() else { return false }
        
        return isInsideFromTheStartDay()

        
        // !! NOTA VOCALE 17.09 !!
    }
    
    private func isOnAirDataEsatta() -> Bool { // lf51 18.09.22
        
        let(startDay,_,currentDay) = dateCalendario()
        let startDayPlain = [startDay.year!,startDay.month!,startDay.day!]
        let currentDayPlain = [currentDay.year!,currentDay.month!,currentDay.day!]
        
       // guard startDay == currentDay else { return false }
        guard startDayPlain == currentDayPlain else { return false }
        
        return isOnTimeRange()
        
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
    
    
    private func isOnTimeRange() -> Bool { // lf51 18.09.22
        
        let(startTime,endTime,currentTime) = timeCalendario()
        
        if (currentTime.hour! > startTime.hour!) && (currentTime.hour! < endTime.hour!) { return true }
        
        else if currentTime.hour! == startTime.hour! {
            if currentTime.minute! >= startTime.minute! { return true }
            else { return false }
        }
        else if currentTime.hour! == endTime.hour! {
            if currentTime.minute! < endTime.minute! { return true }
            else { return false }
        }
        else { return false }
        
    }
    
    private func dateCalendario() -> (startDay:DateComponents,endDay:DateComponents,currentDay:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startDay = calendario.dateComponents([.day,.month,.year], from: self.dataInizio)
        let endDay = calendario.dateComponents([.day,.month,.year], from: self.dataFine)
        let currentDay = calendario.dateComponents([.day,.month,.year,.weekday], from: Date.now)

        return(startDay,endDay,currentDay)
        
    }
    
    private func timeCalendario() -> (startTime:DateComponents,endTime:DateComponents,currentTime:DateComponents) { // lf51 18.09.22
        
        let calendario = Calendar(identifier: .gregorian)
        
        let startTime = calendario.dateComponents([.hour,.minute], from: self.oraInizio)
        let endTime = calendario.dateComponents([.hour,.minute], from: self.oraFine)
        let currentTime = calendario.dateComponents([.hour,.minute], from: Date.now)
        
        return(startTime,endTime,currentTime)
    }
    // Fine Metodi riguardanti la programmazione - onLine vs offLine
}


