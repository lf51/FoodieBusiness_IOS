//
//  ConservazioneIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum ConservazioneIngrediente:MyProEnumPack_L2 /*: MyEnumProtocol, MyEnumProtocolMapConform */{

    static var allCases: [ConservazioneIngrediente] = [.altro,.congelato,.surgelato]
    static var defaultValue: ConservazioneIngrediente = .noValue // deprecato in futuro togliere dal protocollo
    
    var id: String {self.createId()}

    case congelato
    case surgelato
    case altro
    case noValue
 
    func simpleDescription() -> String {
      /*  print("Dentro Conservazione Ingrediente .simpleDescription() di \(self.hashValue)") */
        
        switch self {

        case .surgelato: return "Surgelato"
        case .congelato: return "Congelato"
        case .altro: return "Altro"
        case .noValue: return ""
            
        }
        
    }
    
  /*  var test:String {
        
        print("Dentro Conservazione Ingrediente .TEST di \(self.hashValue)")
        
        switch self {
        case .congelato:
            return "soca"
        case .surgelato:
            return "forti"
        case .altro:
            return "cu a pompa"
        case .noValue:
            return "kiù fotti"
        }
    } */ // !! NOTA 16.09 !! abbiamo ragionato sul consolidare l'intestazione delle struct con la simpleDescription delle Enum, e la descrizione delle struct con la extendedDescription delle Enum Il punto di raccordo sono le computed. Da un punto di vista di "fatica di calcolo" non sembra esserci grossa differenza per la macchina. Necessita il tutto un pò di chiarezza mentale e di codice e dunque la postPoniamo a quando il codice sarà più pulito e si potrà procedere con calma ai consolidamenti nei protocolli !!!
    
    func extendedDescription() -> String {
        
        switch self {
            
        case .congelato:
            return "potrebbe essere Congelato"
        case .surgelato:
            return "potrebbe essere Surgelato"
        case .altro:
            return "è conservato fresco o in altro modo"
        case .noValue: return ""

        }

    }
    
    func createId() -> String {
        self.simpleDescription().replacingOccurrences(of:" ", with: "").lowercased()
    }
    
    func returnTypeCase() -> ConservazioneIngrediente { self }
    
    func imageAssociated() -> String {
       
        switch self {
        
        case .congelato:
            return "🥶"
        case .surgelato:
            return "❄️"
        case .altro:
            return "☀️"//"🌞"//"🌀" //heart"
        case .noValue:
            return "circle.slash"
   
        }
     
    }
    
    func orderValue() -> Int {
        
        switch self {
        
        case .congelato:
            return 2
        case .surgelato:
            return 1
        case .altro:
            return 3
        case .noValue:
            return 0
      
        }
    }
    
}
