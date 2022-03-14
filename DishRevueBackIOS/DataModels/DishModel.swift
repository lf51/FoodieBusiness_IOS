//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation

struct DishModel: Identifiable {
    
    var id:String = UUID().uuidString
    var status: DishStatus // in beta
    
    var name: String
    
    var ingredientiPrincipali: [ModelloIngrediente]
    var ingredientiSecondari: [ModelloIngrediente]
    
    // var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    // var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var categoria: DishCategoria
    var aBaseDi: DishBase
    var metodoCottura: DishCookingMethod
    var tipologia: DishTipologia
    var avaibleFor: [DishAvaibleFor]
    var allergeni: [Allergeni]
    var formatiDelPiatto: [DishFormato]
    
    var restaurantWhereIsOnMenu: [PropertyModel] = []
    
    var alertItem: AlertModel?
    
    init() { // init di un piatto nuovo e "vuoto"
        
        self.name = ""
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.aBaseDi = .defaultValue
        self.categoria = .defaultValue
        self.allergeni = []
        self.formatiDelPiatto = []
        self.tipologia = .defaultValue
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
        
        self.status = .programmato(day: [.lunedi,.martedi,.mercoledi,.giovedi,.domenica(ora:DateInterval(start: .now, end: .distantFuture))])
        
    }
   
}

enum DishStatus {
    
    case bozza // non ancora completo
 //   case pubblico // Rimette in moto da una Pausa
 //   case inPausa // Mette in Pausa una Pubblicazione
    case programmato(day:[GiorniDellaSettimana]) // pubblico in modo condizionato

}

/* Case Programmato :
 
 Giorni della settimana
 Pranzo / cena / colazione
 Da data a data specifica
 
 */

enum GiorniDellaSettimana {
    
    case lunedi,martedi,mercoledi,giovedi,venerdi,sabato,domenica(ora: DateInterval  )
   
    
}

