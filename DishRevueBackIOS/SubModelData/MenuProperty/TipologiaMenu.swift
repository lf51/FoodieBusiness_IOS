//
//  TipologiaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

enum PaxMenuFisso:MyProEnumPack_L1 /*:MyEnumProtocolMapConform */ {
    
    static var defaultValue: PaxMenuFisso = .uno
    static var allCases: [PaxMenuFisso] = [.uno,.due]
    
    case uno
    case due
    
    func simpleDescription() -> String {
        
        switch self {
        case .uno:
            return "1"
        case .due:
            return "2"
        }
    }
    
    func extendedDescription() -> String {
        
        switch self {
        case .uno:
            return "una persona"
        case .due:
            return "due persone"
        }
    }
    
    func imageAssociated() -> String {
        
        switch self {
        case .uno:
            return "person.fill"
        case .due:
            return "person.2.fill"
        }
    }
    
    func returnTypeCase() -> PaxMenuFisso {
        PaxMenuFisso.uno
    }
    
    func orderValue() -> Int {
        switch self {
        case .uno:
            return 1
        case .due:
            return 2
        }
    }
}


enum TipologiaMenu:Identifiable, Equatable,MyProEnumPack_L2 /*: MyEnumProtocol, MyEnumProtocolMapConform*/ {
   
    static var allCases: [TipologiaMenu] = [.allaCarta(),.fisso(persone: .uno, costo: "n/d")]
    static var defaultValue: TipologiaMenu = .noValue
    
    var id:String {self.createId()}
    
    case fisso(persone:PaxMenuFisso,costo: String)
    case allaCarta(TipologiaMenu.DiSistema? = nil)
  //  case delGiorno
   // case delloChef
    
    case noValue
    
    func returnMenuPriceValue() -> (asString:String,asDouble:Double) {
        
        switch self {
        case .fisso(_, let costo):
            let dCost = Double(costo) ?? 0.0
            return (costo,dCost)
        default:
            return ("0.00",0.0)
        }
    }
    
    func simpleDescription() -> String {
        
        switch self {
        case .fisso:
            return "Fisso"
        case .allaCarta(let value):
            let string = value == nil ? "Alla Carta" : value!.simpleDescription()
            return string
      //  case .delGiorno:
        //   return "piatti del Giorno"
       // case .delloChef:
        //    return "i consigliati"
        case .noValue:
            return "Selezionare tipologia menu"

        }
    }
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .fisso(let persone, let costo):
            return "Il costo del menu è di \(formattaPrezzo(price: costo)) per \(persone.extendedDescription())."
        case .allaCarta:
            return "Il costo del menu non è predeterminato."
      //  case .delGiorno:
        //    return "Vedi Info"
       // case .delloChef:
         //   return "Vedi info"
        case .noValue:
            return "Selezionare tipologia menu"
           
        }

    }
    
    // Valutiamo di Renderla Pubblica, anche se al momento 21.09 abbiamo potuto utilizzare il format con il currencyCode. Qui richiederebbe di modificare una funzione che viene dal protocollo ed è troppo SBATTI
    private func formattaPrezzo(price:String) -> String {
        
        let currencyCode = Locale.current.currency?.identifier ?? "EUR"
        let newPrice:String
 
        if let point = price.firstIndex(of: ".") {
            
            let pre = price.prefix(upTo: point)
            let post = price.suffix(from: point)
          //  let post2 = post.replacingOccurrences(of: ",", with: ".")
            
            if post.count == 1 { newPrice = pre.appending("\(post)00")}
            else if post.count == 2 { newPrice = pre.appending("\(post)0") }
            else { newPrice = pre.appending("\(post)") }
            
        } else {
            newPrice = price.appending(".00")
        }
           
        return "\(currencyCode) \(newPrice)"
    }
    
    func createId() -> String {
       // self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased()
        self.returnTypeCase().simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // Vedi Nota 09.11
    }
    
    func editingAvaible() -> Bool {
        
        switch self {
            
        case .fisso:
            return true
        default:
            return false
        }
        
    }
    
    func returnTypeCase() -> Self {
        
        switch self {
            
        case .fisso(_,_):
            return .fisso(persone: .uno, costo: "n/d")
        
        case .allaCarta(_):
            return .allaCarta()
            
        case .noValue:
            return self
            
        }
    }
    
    func imageAssociated() -> String {
        
        switch self {
            
        case .fisso(_, _):
            return "dollarsign.circle"
            
        case .allaCarta(let value):
            let image = value == nil ? "cart" : value!.imageAssociated()
            return image
      //  case .delGiorno:
        //    return "clock.arrow.circlepath"
     //   case .delloChef:
       //     return "mustache.fill" //"👨🏻‍🍳"
        case .noValue:
            return "gear.badge.xmark"
        }
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .fisso(_, _):
            return 1
        case .allaCarta:
            return 2
      //  case .delGiorno:
        //    return 3
      //  case .delloChef:
       //     return 4
        case .noValue:
           return 0
        }
    }
    
    func isDiSistema() -> Bool {
      //  self == .delGiorno ||
      //  self == .delloChef
        self == .allaCarta(.delGiorno) ||
        self == .allaCarta(.delloChef)
    }
    
    enum DiSistema {
        
        case delGiorno,delloChef
        
        func returnTipologiaMenu() -> TipologiaMenu {
            
            switch self {
                case .delGiorno:
               // return TipologiaMenu.delGiorno
                    return TipologiaMenu.allaCarta(.delGiorno)
                case .delloChef:
                    return TipologiaMenu.allaCarta(.delloChef)
            }
        }
        
        func simpleDescription() -> String {
            
            switch self {
                
                case .delGiorno:
                    return "piatti del Giorno"
                case .delloChef:
                    return "i consigliati"
                
            }
        }
        
        func extendedDescription() -> String {
            
            switch self {
                case .delGiorno:
                    return "Menu con i piatti del Giorno."
                case .delloChef:
                    return "Menu con i piatti consigliati dallo Chef 👨🏻‍🍳."
                
            }
        }
        
        func shortDescription() -> String {
            
            switch self {
                case .delGiorno:
                    return "Menu del Giorno"
                case .delloChef:
                    return "Menu dello Chef"
                
            }
        }
        
        func imageAssociated() -> String {
            
            switch self {
                
                case .delGiorno:
                    return "clock.arrow.circlepath"
                case .delloChef:
                    return "mustache.fill" //"👨🏻‍🍳"
    
            }
        }

       
    }
    
}
