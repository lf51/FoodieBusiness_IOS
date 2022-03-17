//
//  BaseModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

// Modello base da caricare da un Json

struct BaseModelloIngrediente {
    
    var id: String {self.nome.replacingOccurrences(of: " ", with: "").lowercased() }
    
    let nome: String
    
}

func load<T:Decodable>(_ filename:String) -> T {
    
    let data:Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {fatalError("Non è possibile trovare \(filename) in the main bundle") }
    
    do {
        data = try Data(contentsOf: file)
    } catch {fatalError("Non è possibile caricare il file \(filename)") }
    
    do { let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {fatalError("Impossibile eseguire il PARSE sul file \(filename) as \(T.self):\n\(error)") }
    
}
