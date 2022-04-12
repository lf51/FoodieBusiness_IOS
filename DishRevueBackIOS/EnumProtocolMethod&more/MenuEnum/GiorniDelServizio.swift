//
//  GiorniDelServizio.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import Foundation

enum GiorniDelServizio: MyEnumProtocol, MyEnumProtocolMapConform {

    static var allCases:[GiorniDelServizio] = [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato,.domenica]
    static var defaultValue: GiorniDelServizio = .lunedi
   // static var allDayService: [GiorniDelServizio] = [.lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato,.domenica] // abbiamo creato questo array uguale ma diverso dall'AllCases per aprire in futuro lo spazio ad un array con i giorni di attività escluso il giorno di riposo
    var id: String {self.createId()}
    
    case lunedi
    case martedi
    case mercoledi
    case giovedi
    case venerdi
    case sabato
    case domenica
    
    func simpleDescription() -> String {
        
        switch self {
        case .lunedi:
            return "Lunedi"
        case .martedi:
            return "Martedi"
        case .mercoledi:
            return "Mercoledi"
        case .giovedi:
            return "Giovedi"
        case .venerdi:
            return "Venerdi"
        case .sabato:
            return "Sabato"
        case .domenica:
            return "Domenica"
        }
    }
    
    func extendedDescription() -> String? {
        print("Dentro GiorniDelServizio. DescrizioneEstesa non sviluppata")
        return nil
    }
    
    func shortDescription() -> String {
        
        switch self {
            
        case .lunedi:
            return "L"
        case .martedi:
            return "M"
        case .mercoledi:
            return "M"
        case .giovedi:
            return "G"
        case .venerdi:
            return "V"
        case .sabato:
            return "S"
        case .domenica:
            return "D"
        }
        
    }
    
    func createId() -> String {
        
        self.simpleDescription().lowercased()
    }
    
    func imageAssociated() -> String? {
        
        switch self {
            
        case .lunedi:
            return "l.circle"
        case .martedi:
            return "m.circle"
        case .mercoledi:
            return "m.circle"
        case .giovedi:
            return "g.circle"
        case .venerdi:
            return "v.circle"
        case .sabato:
            return "s.circle"
        case .domenica:
            return "d.circle"
        }
    }
    
    func returnTypeCase() -> GiorniDelServizio {
        
      return self // ritorniamo il self perchè al momento (07.04.2022) non ci sono valori associati ai case
    }
    
    func orderValue() -> Int {
        
        switch self {
            
        case .lunedi:
            return 1
        case .martedi:
            return 2
        case .mercoledi:
            return 3
        case .giovedi:
            return 4
        case .venerdi:
            return 5
        case .sabato:
            return 6
        case .domenica:
            return 7
        }
        
    }
}
