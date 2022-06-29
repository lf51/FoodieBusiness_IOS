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
    
    var propertiesWhereIsUsed: [PropertyModel] = [] // doppia scrittura con MenuIn in PropertyModel // DEPRECATA IN FUTURO
    var dishIn: [DishModel] = [] // doppia scrittura con MenuWhereIsIn in DishModel
    
    var intestazione: String = "Menu Vuoto - Intestazione"
    var descrizione: String = ""
    
    var tipologia: TipologiaMenu = .defaultValue
    
    var isAvaibleWhen: AvailabilityMenu = .defaultValue
    var dataInizio: Date = Date() // ruolo duplice, data inizio e data esatta
    var dataFine: Date = Date().advanced(by: 604800) // opzionale perchè possiamo non avere una fine in caso di data fissa
    var giorniDelServizio:[GiorniDelServizio] = []
    var oraInizio: Date = Date()
    var oraFine: Date = Date().advanced(by: 1800)
    
    var status: StatusModel = .bozza
    
    var alertItem: AlertModel? // Deprecata -> Spostata nel ViewModel

    init() {
        
    }
    
    init (nome: String, tipologia: TipologiaMenu, giorniDelServizio: [GiorniDelServizio]) {
        
        self.intestazione = nome
        self.tipologia = tipologia
        self.giorniDelServizio = giorniDelServizio
        
    }
    
}


