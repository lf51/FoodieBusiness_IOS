//
//  DishModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import Foundation

struct DishModel: Identifiable {
    
    var id:String = UUID().uuidString
    
    var name: String
    var ingredientiPrincipali: [String] // i macro ingredienti classici di una ricetta
    var ingredientiSecondari: [String] // un maggior dettaglio sugli ingredienti usanti in preparazione // Esempio cotoletta panata nel Burro piuttosto che nell'Olio di Oliva o Olio di Semi
    
    //var tempoDiAttesa: Int? // Ha tante sfaccettature, occorerebbe parlarne prima con dei Ristoratori
    
    var quantità: Double?
   // var dishIcon: String // Icona standard dei piatti che potremmo in realtà associare direttamente alla categoria
    var images: [String] // immagini caricate dal ristoratore o dai clienti // da gestire
    
    var type: [DishType]
    var category: DishCategory
    var allergeni: [Allergeni]
    
    // una proprietà che lo inserisce in un menu, ovvero in un ristorante
    
    init() { // init di un piatto nuovo e "vuoto"
        
        self.name = ""
        self.ingredientiPrincipali = ["No Ingredient"]
        self.ingredientiSecondari = [""]
        self.images = []
        self.type = [.noType]
        self.category = .noCategory
        self.allergeni = [.noAllergeni]
    }
   
}

enum DishCategory:String {
    // Potremmo associare l'icona standard ad ogni categoria
    case antipasto
    case primo
    case secondo
    case contorno
    case pizza
    case tavolaCalda
    case bevanda
    case dessert
    
    case noCategory

}

enum DishType:String {
    // Potremmo Associare un icona ad ogni Tipo
    
    case carne // contiene carne o derivati (latte e derivati)
    case pesce // contiene pesce
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegano // può contenere solo vegetali
    case milkFree // può contenere carne o pesce - Non può contenere latte&derivati
    
    case noType
}

enum Allergeni:String {
    
    //Potremmo associare un icona ad ogni allergene
    
    case arachidi_e_derivati
    case fruttaAguscio
    case latte_e_derivati
    case molluschi
    case pesce
    case sesamo
    case soia
    case crostacei
    case glutine
    case lupini
    case senape
    case sedano
    case anidride_solforosa_e_solfiti
    case uova_e_derivati
    
    case noAllergeni
}
