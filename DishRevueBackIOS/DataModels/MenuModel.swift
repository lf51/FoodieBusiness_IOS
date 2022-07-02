//
//  MenuModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import Foundation

struct MenuModel:MyModelStatusConformity {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.descrizione == rhs.descrizione &&
        lhs.dishIn == rhs.dishIn &&
        lhs.tipologia == rhs.tipologia &&
        lhs.isAvaibleWhen == rhs.isAvaibleWhen &&
        lhs.dataInizio == rhs.dataInizio &&
        lhs.dataFine == rhs.dataFine &&
        lhs.giorniDelServizio == rhs.giorniDelServizio &&
        lhs.oraInizio == rhs.oraInizio &&
        lhs.oraFine == rhs.oraFine
      
    }
    
    var id: String {self.intestazione.replacingOccurrences(of: " ", with: "").lowercased() }

    var intestazione: String = "" // Categoria Filtraggio
    var descrizione: String = ""
    
    var dishIn: [DishModel] = [] {willSet {status = newValue.isEmpty ? .bozza : .completo(.archiviato)}}
    
    var tipologia: TipologiaMenu? // Categoria di Filtraggio
    var status: StatusModel = .bozza
    
    var isAvaibleWhen: AvailabilityMenu? {willSet {giorniDelServizio = newValue == .dataEsatta ? [] : GiorniDelServizio.allCases } }
    
    var dataInizio: Date = Date() {willSet {dataFine = newValue.advanced(by: 604800)}} // data inizio del Menu, che contiene al suo interno anche l'ora (estrapolabile) in cui è stato creato
    var dataFine: Date = Date().advanced(by: 604800) // opzionale perchè possiamo non avere una fine in caso di data fissa
    var giorniDelServizio:[GiorniDelServizio] = [] // Categoria Filtraggio
    var oraInizio: Date = Date() {willSet {oraFine = newValue.advanced(by: 1800)}} // ora Inizio del Menu che contiene al suo interno la data (estrapolabile) in cui è stato creato
    var oraFine: Date = Date().advanced(by: 1800)

}


