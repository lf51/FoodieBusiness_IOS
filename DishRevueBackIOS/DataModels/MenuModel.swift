//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation
import SwiftUI

struct MenuModel:MyModelStatusConformity {
    
    func returnNewModel() -> (tipo: MenuModel, nometipo: String) {
        (MenuModel(), "Nuovo Menu")
    }
    
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
    
    func viewModelContainer() -> (pathContainer: ReferenceWritableKeyPath<AccounterVM, [MenuModel]>, nomeContainer: String, nomeOggetto:String) {
        
        return (\.allMyMenu, "Lista Menu", "Menu")
    }

    func pathDestination() -> DestinationPathView {
        
        DestinationPathView.menu(self)
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.dishIn == rhs.dishIn &&
        lhs.tipologia == rhs.tipologia &&
        lhs.status == rhs.status &&
        lhs.isAvaibleWhen == rhs.isAvaibleWhen &&
        lhs.dataInizio == rhs.dataInizio &&
        lhs.dataFine == rhs.dataFine &&
        lhs.giorniDelServizio == rhs.giorniDelServizio &&
        lhs.oraInizio == rhs.oraInizio &&
        lhs.oraFine == rhs.oraFine
      
    }
    
 //   var id: String {self.intestazione.replacingOccurrences(of: " ", with: "").lowercased() } // deprecated 15.07
    
    var id: String { creaID(fromValue: self.intestazione) }

    var intestazione: String = "" // Categoria Filtraggio
    var descrizione: String = ""
    
    var dishIn: [DishModel] = [] /*{willSet {status = newValue.isEmpty ? .vuoto : .completo(.archiviato)}} */
    
    var tipologia: TipologiaMenu = .noValue // Categoria di Filtraggio
    var status: StatusModel = .vuoto
    
    var isAvaibleWhen: AvailabilityMenu = .defaultValue { willSet {giorniDelServizio = newValue == .dataEsatta ? [] : GiorniDelServizio.allCases } }
    
    var dataInizio: Date = Date() {willSet {dataFine = newValue.advanced(by: 604800)}} // data inizio del Menu, che contiene al suo interno anche l'ora (estrapolabile) in cui è stato creato
    var dataFine: Date = Date().advanced(by: 604800) // opzionale perchè possiamo non avere una fine in caso di data fissa
    var giorniDelServizio:[GiorniDelServizio] = [] // Categoria Filtraggio
    var oraInizio: Date = Date() {willSet {oraFine = newValue.advanced(by: 1800)}} // ora Inizio del Menu che contiene al suo interno la data (estrapolabile) in cui è stato creato
    var oraFine: Date = Date().advanced(by: 1800)

}


