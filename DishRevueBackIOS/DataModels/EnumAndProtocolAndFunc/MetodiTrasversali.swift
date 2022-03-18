//
//  MethodTrasversali.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import Foundation

func myLoad<T:Decodable>(_ filename:String) -> T {
    
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

func myValidateValue(value: String, convalidaAsDouble: Bool) -> Bool {
   
   if convalidaAsDouble {
       
       if let righValue = Double(value) { if righValue >= 0 {return true} else {return false} } else {return false}
       
   } else {
       // convalida Int
       if let rightValue = Int(value) { if rightValue > 0 {return true} else {return false} } else {return false}
       
   }
}

func myTimeFormatter() -> (ora:DateFormatter,data:DateFormatter) {
    
    let time = DateFormatter()
    time.timeStyle = .short
    
    let date = DateFormatter()
    date.dateStyle = .long
    
    return (time,date)
    
}
