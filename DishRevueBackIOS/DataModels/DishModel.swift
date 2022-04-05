//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation

struct DishModel: MyModelProtocol {
 
   static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.categoria == rhs.categoria &&
        lhs.aBaseDi == rhs.aBaseDi &&
        lhs.metodoCottura == rhs.metodoCottura &&
        lhs.tipologia == rhs.tipologia &&
        lhs.avaibleFor == rhs.avaibleFor &&
        lhs.allergeni == rhs.allergeni &&
        lhs.formatiDelPiatto == rhs.formatiDelPiatto
       
       // dobbiamo specificare tutte le uguaglianze altrimenti gli enumScroll non mi funzionano perchè non riesce a confrontare i valori
    }
    
    var id:String {self.intestazione.replacingOccurrences(of: " ", with: "").lowercased() }
  //  var id:String = UUID().uuidString // deprecated il 16.03.2022 --> Formarlo in altro Modo
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
   
    init(intestazione: String, aBaseDi: DishBase, categoria: DishCategoria, tipologia: DishTipologia) {
        
        self.intestazione = intestazione
        self.aBaseDi = aBaseDi
        self.categoria = categoria
        self.tipologia = tipologia
        
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.allergeni = []
        self.formatiDelPiatto = []
        
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
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
