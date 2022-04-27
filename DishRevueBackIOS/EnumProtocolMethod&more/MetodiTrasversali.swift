//
//  MethodTrasversali.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import Foundation
import SwiftUI

func csLoad<T:Decodable>(_ filename:String) -> T {
    
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

func csValidateValue(value: String, convalidaAsDouble: Bool) -> Bool {
   
   if convalidaAsDouble {
       
       if let righValue = Double(value.replacingOccurrences(of: ",", with: ".")) { if righValue >= 0 {return true} else {return false} } else {return false}
       
   } else {
       // convalida Int
       if let rightValue = Int(value) { if rightValue > 0 {return true} else {return false} } else {return false}
       
   }
}

func csTimeFormatter() -> (ora:DateFormatter,data:DateFormatter) {
    
    let time = DateFormatter()
    time.timeStyle = .short
    
    let date = DateFormatter()
    date.dateStyle = .long
    
    return (time,date)
    
}

/// se l'alertModel non possiede una action ritorna un Alert comunicativo. Default ActionTitle "Prosegui"
/*func csSendAlert(alertModel: AlertModel) -> Alert {
   
   guard alertModel.actionPlus != nil else {
       
       return Alert(
           title: Text(alertModel.title),
           message: Text(alertModel.message))
       
   }
    
    let actionTitle: Text
    
    switch alertModel.actionPlus!.title {
        
    case .elimina:
        actionTitle = Text("Elimina").foregroundColor(Color.red)
   
    default: actionTitle = Text(alertModel.actionPlus!.title.rawValue.capitalized)
        
    }
    
       return Alert(
              title: Text(alertModel.title),
              message: Text(alertModel.message),
              primaryButton: Alert.Button.cancel(),
              secondaryButton: Alert.Button.default(
                actionTitle,
                action: (alertModel.actionPlus!.action)))

} */

/// Ritorna un array di case unici (ripuliti dai valori Associati, dai duplicati, e ordinati) di ENUM conformi al MyEnumProtocolMapConform [lf51]
/// - Parameter array: array description
/// - Returns: description
func csRipulisciArray<T:MyEnumProtocolMapConform>(array:[T]) -> [T] {
    
    var arrayCentrifugato:[T] = []
    
    for eachCase in array {
        
        let element:T = eachCase.returnTypeCase()
        arrayCentrifugato.append(element)
        
    }
    
    let secondStep = Array(Set(arrayCentrifugato))
    let lastStep = secondStep.sorted{$0.orderValue() < $1.orderValue()}
    
   return lastStep
}
