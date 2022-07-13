//
//  DishCategory.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum DishTipologia: MyEnumProtocol,MyEnumProtocolMapConform/*, MyModelProtocol*/ {
    
    
    
    var intestazione: String {get{ self.simpleDescription() } set{ }}
    var descrizione: String { get {self.extendedDescription() ?? "noDescription"} set { } }
   // var status: StatusModel = .bozza // Non serve a niente. Da Sistemare
    
    static var allCases: [DishTipologia] = [/*.standard,*/.vegetariano,.vegariano,.vegano,.glutenFree]
    static var defaultValue: DishTipologia = DishTipologia.standard

    case standard // contiene di tutto
    
    case vegetariano // può contenere latte&derivati - Non può contenere carne o pesce
    case vegariano // non contiene latte animale e prodotti derivati
    case vegano // può contenere solo vegetali
    case glutenFree // lo usiamo per avere un valore di default Nullo
    
    var id: String { self.createId()}
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .standard: return "Standard"
        case .vegetariano: return "Vegetariana"
        case .vegariano: return "Vegariana"
        case .vegano: return "Vegana"
        case .glutenFree: return "Senza Glutine"
        
        }
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func extendedDescription() -> String? {
        
        switch self {
            
        case .standard: return "Contenente ingredienti di origine animale e suoi derivati"
        case .vegetariano: return "Priva di ingredienti di origine animale (escluso latte e derivati) e pesce."
        case .vegariano: return "Priva di latte animale e ingredienti derivati."
        case .vegano: return "Contenente solo ingredienti di origine vegetale."
        case .glutenFree: return "Priva di Glutine."
        
        }
        
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .standard:
            return nil
        case .vegetariano:
            return nil
        case .vegariano:
            return nil
        case .vegano:
            return nil
        case .glutenFree:
            return nil
        }
    }
    
    func returnTypeCase() -> DishTipologia {
        print("dentro DishTipologia ReturnType")
        return self
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .standard:
            return 5
        case .vegetariano:
            return 1
        case .vegariano:
            return 2
        case .vegano:
            return 3
        case .glutenFree:
            return 4
        }
    }
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
    static func returnDietAvaible(ingredients: [IngredientModel]...) -> (inDishTipologia:[DishTipologia],inStringa:[String]) {

        // step 1 ->
        
        var animalOrFish: [IngredientModel] = []
        var milkIn: [IngredientModel] = []
        var glutenIn: [IngredientModel] = []
        
        for list in ingredients {
            
            for ingredient in list {
                
                if ingredient.origine != .vegetale {
                    if ingredient.allergeni.contains(.latte_e_derivati) { milkIn.append(ingredient) }
                    else { animalOrFish.append(ingredient) }
                            }

                if ingredient.allergeni.contains(.glutine) { glutenIn.append(ingredient)}
            }
        }

        // step 2 -->
        
        var dieteOk:[DishTipologia] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
        
        if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
        else if milkIn.isEmpty { dieteOk.append(.vegariano)}
        else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
        else {dieteOk.append(.standard) }
 
        var dieteOkInStringa:[String] = []
 
        for diet in dieteOk {
            
            let stringDiet = diet.simpleDescription()
            dieteOkInStringa.append(stringDiet)
       
        }
    
        return (dieteOk,dieteOkInStringa)
    }
    
    /// Controlla l'origine degli ingredienti e restituisce un array con le diete compatibili
   /* static func checkDietAvaible(ingredients: [IngredientModel]...) -> [DishTipologia] {

        // step 1 ->
        
        var animalOrFish: [IngredientModel] = []
        var milkIn: [IngredientModel] = []
        var glutenIn: [IngredientModel] = []
        
        for list in ingredients {
            
            for ingredient in list {
                
                if ingredient.origine != .vegetale {
                    if ingredient.allergeni.contains(.latte_e_derivati) { milkIn.append(ingredient) }
                    else { animalOrFish.append(ingredient) }
                            }

                if ingredient.allergeni.contains(.glutine) { glutenIn.append(ingredient)}
            }
        }

        // step 2 -->
        
        var dieteOk:[DishTipologia] = []
        
        if glutenIn.isEmpty {dieteOk.append(.glutenFree)}
        
        if milkIn.isEmpty && animalOrFish.isEmpty {dieteOk.append(contentsOf: [.vegano,.vegariano,.vegetariano])}
        else if milkIn.isEmpty { dieteOk.append(.vegariano)}
        else if animalOrFish.isEmpty {dieteOk.append(.vegetariano)}
        else {dieteOk.append(.standard) }
 
        return dieteOk
    } */ // Deprecata 11.07 Trasformata in returnDietAvaible()
}
