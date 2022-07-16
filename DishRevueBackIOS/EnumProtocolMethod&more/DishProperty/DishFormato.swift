//
//  DishFormati.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

struct DishFormat: Hashable /*Identifiable, Equatable */ {
    
    var label: String
    var price: String
    
    let type: DishFormatType
   
    init(type: DishFormatType) {
        self.label = ""
        self.price = ""
        self.type = type
    }
    
}

enum DishFormatType {
    
    case mandatory,opzionale
}

/*
enum DishFormato: MyEnumProtocol, Hashable {
    
    static var defaultValue: DishFormato = DishFormato.custom("","n/d", "1", "n/d")
    
    static var allCases: [DishFormato] = [.unico("n/d","1","n/d"),.doppio("n/d","1","n/d"),.piccolo("n/d","1","n/d"),.medio("n/d","1","n/d"),.grande("n/d","1","n/d")]
    
    case unico(_ grammi:String, _ pax:String, _ prezzo: String)
    case doppio(_ grammi:String, _ pax:String, _ prezzo: String)
    
    case piccolo(_ grammi:String, _ pax:String, _ prezzo: String)
    case medio(_ grammi:String, _ pax:String, _ prezzo: String)
    case grande(_ grammi:String, _ pax:String, _ prezzo: String)
    
    case custom(_ nome: String, _ grammi: String, _ pax: String, _ prezzo: String)
   
    var id: String { self.createId() }
    
    func showAssociatedValue() -> (peso:String,porzioni:String,prezzo:String) {
        
        switch self {
            
        case .unico(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .doppio(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .piccolo(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .medio(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .grande(let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
        case .custom(_, let grammi, let porzioni, let prezzo):
            return (peso:grammi,porzioni:porzioni,prezzo:prezzo)
            
        }
        
    }

    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .unico: return "Unico"
        case .piccolo: return "Piccolo"
        case .medio: return "Medio"
        case .grande: return "Grande"
        case .doppio: return "Double"
        case .custom(let nome, _,_,_): return nome.capitalized
                        
        }
    }

    func extendedDescription() -> String? {
        print("Dentro DishFormato. DescrizioneEstesa non sviluppata")
        return nil
    }

    func isTagliaAlreadyIn(newDish: DishModel) -> Bool  {
        
        newDish.formatiDelPiatto.contains { taglia in
            
            taglia.id == self.id // controlliamo che l'array tagliaPiatto non contenga già un elemento con lo stesso id.
            
        }
        
    }
    
    func isSceltaBloccata(newDish: DishModel) -> Bool {
        
        // prima opzione
        guard !newDish.formatiDelPiatto.isEmpty else {return false}
        //
        
        let sceltaCorrente = self.id
        let listaDelleTaglie = newDish.formatiDelPiatto.map {$0.id}
        let set_listaDelleTaglie = Set(listaDelleTaglie)
        
        let avaibleList: Set<String> =  ["unico", "double", "piccolo", "medio", "grande"]
        let avaibleSubList_1: Set<String> = ["unico", "double"]
        let avaibleSubList_2: Set<String> = ["piccolo", "medio", "grande"]
    
        if set_listaDelleTaglie.isDisjoint(with: avaibleList) {
            
            if avaibleList.contains(sceltaCorrente) { return true } else { return false }
        }
        
        else {
            
            if set_listaDelleTaglie.isDisjoint(with: avaibleSubList_1) {
                
                if avaibleSubList_2.contains(sceltaCorrente) {return false} else {return true}
                
            } else {
                
                if avaibleSubList_1.contains(sceltaCorrente) {return false } else {return true}
                
            }
        }
    }
    
    func qualeComboIsAvaible() -> String {
        
        let avaibleList =  ["unico", "double", "piccolo", "medio", "grande"]
        var avaibleSubList_1 = ["unico", "double"]
        var avaibleSubList_2 = ["piccolo", "medio", "grande"]
        
        if !avaibleList.contains(self.id) {
            
            return "La specifica \"\(self.simpleDescription())\" è utilizzabile solo in combinazione con altre specifiche Custom"
        }
        
        else if avaibleSubList_1.contains(self.id) {
            
            let index = avaibleSubList_1.firstIndex(of: self.id)
            avaibleSubList_1.remove(at: index!)
            
            return "La specifica \"\(self.simpleDescription())\" è utilizzabile solo in combinazione con la specifica \(avaibleSubList_1.description)"
        }
        
        else {
            
            let index = avaibleSubList_2.firstIndex(of: self.id)
            avaibleSubList_2.remove(at: index!)
            
            return "La specifica \"\(self.simpleDescription())\" è utilizzabile solo in combinazione con le specifiche \(avaibleSubList_2.description)"
            
        }
        
    }
    
    static func isCustomCaseNameOriginal(customName: String) -> Bool {
        
        let allCasesId = allCases.map({$0.id})
        let ipotetingCustomNameId = customName.replacingOccurrences(of:" ", with:"").lowercased()
        
        if allCasesId.contains(ipotetingCustomNameId) { return false } else { return true}
        
    }
    
} */ // Deprecato 16.07
