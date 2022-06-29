//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

// Modifiche 14.02

import Foundation


struct DishModel:MyModelStatusConformity {
     
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
   static func == (lhs: DishModel, rhs: DishModel) -> Bool {
       
        lhs.id == rhs.id &&
        lhs.intestazione == rhs.intestazione &&
        lhs.ingredientiPrincipali == rhs.ingredientiPrincipali &&
        lhs.ingredientiSecondari == rhs.ingredientiSecondari &&
        lhs.categoria == rhs.categoria && // deprecata
        lhs.categoriaMenu == rhs.categoriaMenu &&
        lhs.aBaseDi == rhs.aBaseDi &&
        lhs.metodoCottura == rhs.metodoCottura &&
        lhs.tipologia == rhs.tipologia &&
        lhs.avaibleFor == rhs.avaibleFor &&
        lhs.allergeni == rhs.allergeni &&
        lhs.formatiDelPiatto == rhs.formatiDelPiatto &&
        lhs.status == rhs.status &&
        lhs.rating == rhs.rating
       
       // dobbiamo specificare tutte le uguaglianze altrimenti gli enumScroll non mi funzionano perchè non riesce a confrontare i valori
    }
    
    var id:String {self.intestazione.replacingOccurrences(of: " ", with: "").lowercased() }
  //  var id:String = UUID().uuidString // deprecated il 16.03.2022 --> Formarlo in altro Modo
   // var status: DishStatus // in beta
    
    var intestazione: String
    var descrizione: String = ""
    var alertItem: AlertModel? // Deprecata -> alert spostati nel viewModel
    
    var menuWhereIsIn: [MenuModel] = [] // doppia scrittura con -> Deprecata in futuro
    var ingredientiPrincipali: [IngredientModel]
    var ingredientiSecondari: [IngredientModel]
    
    // var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    // var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var categoria: DishCategoria // Deprecata
    var categoriaMenu: CategoriaMenu
    var aBaseDi: OrigineIngrediente // Deprecato in futuro --> Abbiamo spostato e rinominato il DishBase in OrigineIngrediente. Qui non saraà più necessario
    
    
    var metodoCottura: DishCookingMethod // Deprecato in futuro
    var tipologia: DishTipologia // Deprecato in futuro --> Deriveremo il tipo di piatto dall'origine degli ingredienti
    var avaibleFor: [DishAvaibleFor]
  //  var allergeni: [Allergeni] // DEPRECATED 19.05.2022 Li deriviamo dagli Ingredienti
    var allergeni: [AllergeniIngrediente] { // la forma = {}() per funzionare necessita il lazy, ma al momento non funziona perchè le rowModel passano delle Var/let, quando passeranno delle State magari funzionerà
        
        var allergeniPiatto:[AllergeniIngrediente] = []
        
        for ingredient in self.ingredientiPrincipali {
            let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni
            allergeniPiatto.append(contentsOf: allergeneIngre)
        }
        
        for ingredient in self.ingredientiSecondari {
            let allergeneIngre:[AllergeniIngrediente] = ingredient.allergeni
            allergeniPiatto.append(contentsOf: allergeneIngre)
        }
        
        let setAllergeniPiatto = Set(allergeniPiatto)
        print("Calcolo Allergeni Piatto \(self.intestazione)")
        return Array(setAllergeniPiatto)
        
    } // Abbiamo spostato gli allergeni nell'ingrediente, quindi il piatto li deriva
    
    lazy var tipologiaDieta:[DishTipologia] = {
        
    print("tipologiaDieta -> lazy var in dishModel")
        
        let dieteOk = DishTipologia.checkDietAvaible(ingredients: self.ingredientiPrincipali,self.ingredientiSecondari)
        
        return dieteOk
    }()
    
    var formatiDelPiatto: [DishFormato]

    var rating: String
    var status: StatusModel
   // var restaurantWhereIsOnMenu: [PropertyModel] = []
    
    
    
    init() { // init di un piatto nuovo e "vuoto" -> Necessario per creare nuovi piatti @State
        
        self.intestazione = ""
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.aBaseDi = .defaultValue
        self.categoria = .defaultValue
      //  self.allergeni = []
        self.formatiDelPiatto = []
        self.tipologia = .defaultValue
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
        self.rating = "9.5"
        self.status = .bozza
        
        self.categoriaMenu = .defaultValue
     //   self.status = .programmato(day: [.lunedi,.martedi,.mercoledi,.giovedi,.domenica(ora:DateInterval(start: .now, end: .distantFuture))])
    }
    
    init(intestazione: String) { // necessario nella creazione veloce
        
        self.intestazione = intestazione
        
        self.ingredientiPrincipali = []
        self.ingredientiSecondari = []
        self.aBaseDi = .defaultValue
        self.categoria = .defaultValue
      //  self.allergeni = []
        self.formatiDelPiatto = []
        self.tipologia = .defaultValue
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
        self.rating = ""
        self.status = .bozza
        
        self.categoriaMenu = .defaultValue
    }
    
   
    init(intestazione: String, aBaseDi: OrigineIngrediente, categoria: DishCategoria, tipologia: DishTipologia, status: StatusModel) {
        
        self.intestazione = intestazione
        self.aBaseDi = aBaseDi
        self.categoria = categoria
        self.tipologia = tipologia
        
        self.ingredientiPrincipali = [IngredientModel(nome: "Guanciale"),IngredientModel(nome: "Pecorino D.O.P"),  IngredientModel(nome: "Uova")] // riempito per Test
        self.ingredientiSecondari = [IngredientModel(nome: "Pepe Nero"),IngredientModel(nome: "Prezzemolo")] // riempito per Test
      //  self.allergeni = [.latte_e_derivati,.glutine,.uova_e_derivati] // riempito per Test
        self.formatiDelPiatto = []
        
        self.avaibleFor = []
        self.metodoCottura = .defaultValue
        self.rating = "8.5"
        
        self.status = status
        
        self.categoriaMenu = .defaultValue
    }
  


    
}


