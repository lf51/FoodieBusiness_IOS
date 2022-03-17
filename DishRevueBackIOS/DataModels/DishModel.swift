//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation

struct DishModel: CustomGridAvaible {
    
    static func == (lhs: DishModel, rhs: DishModel) -> Bool {
        lhs.intestazione == rhs.intestazione
    }
    
    var id:String = UUID().uuidString // deprecated il 16.03.2022 --> l'overload del == non funziona con l'id in questa forma, non funziona nel senso che mi fa saltare la modifica dell'intestazione nel NewDish. Usando l'intestazione invece funziona
   // var status: DishStatus // in beta
    
    var intestazione: String
    
    var menuWhereIsIn: [MenuModel] = [] // doppia scrittura con
    var ingredientiPrincipali: [IngredientModel]
    var ingredientiSecondari: [IngredientModel]
    
    // var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    // var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var categoria: DishCategoria
    var aBaseDi: DishBase
    var metodoCottura: DishCookingMethod
    var tipologia: DishTipologia
    var avaibleFor: [DishAvaibleFor]
    var allergeni: [DishAllergeni]
    var formatiDelPiatto: [DishFormato]
    
   // var restaurantWhereIsOnMenu: [PropertyModel] = []
    
    var alertItem: AlertModel?
    
    init() { // init di un piatto nuovo e "vuoto"
        
        self.intestazione = ""
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.aBaseDi = .defaultValue
        self.categoria = .defaultValue
        self.allergeni = []
        self.formatiDelPiatto = []
        self.tipologia = .defaultValue
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
        
     //   self.status = .programmato(day: [.lunedi,.martedi,.mercoledi,.giovedi,.domenica(ora:DateInterval(start: .now, end: .distantFuture))])
        
    }
   
}
/*
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
*/
