//
//  Allergeni.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/03/22.
//

import Foundation

enum Allergeni: MyEnumProtocol, MyModelProtocol {

    var intestazione: String {get{ self.simpleDescription() } set{ }}
    var descrizione: String { get {self.extendedDescription() ?? "noDescription"} set { } }
    
    static var allCases: [Allergeni] = [.arachidi_e_derivati,.anidride_solforosa_e_solfiti,.crostacei,.fruttaAguscio,.glutine,.latte_e_derivati,.lupini,.molluschi,.pesce,.sedano,.senape,.sesamo,.soia,.uova_e_derivati]
    static var defaultValue: Allergeni = Allergeni.noValue
    
    //Potremmo associare un icona ad ogni allergene e utilizzare la simpleDescription() al posto dei RawValue
    case arachidi_e_derivati
    case fruttaAguscio
    case latte_e_derivati
    case molluschi
    case crostacei
    case pesce
    case uova_e_derivati
    case sesamo
    case soia
    case glutine
    case lupini
    case senape
    case sedano
    case anidride_solforosa_e_solfiti
    
    case noValue // lo usiamo per avere un valore di default Nullo
 
    var id: String { self.createId() }
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .arachidi_e_derivati: return "Arachidi & derivati"
        case .fruttaAguscio: return "Frutta a guscio"
        case .latte_e_derivati: return "Latte & derivati"
        case .molluschi: return "Molluschi"
        case .pesce: return "Pesce"
        case .sesamo: return "Sesamo"
        case .soia: return "Soia"
        case .crostacei: return "Crostacei"
        case .glutine: return "Glutine"
        case .lupini: return "Lupini"
        case .senape: return "Senape"
        case .sedano: return "Sedano"
        case .anidride_solforosa_e_solfiti: return "Anidride Solforosa & Solfiti"
        case .uova_e_derivati: return "Uova & derivati"
        case .noValue: return "Nessun Allergene"
        
        }
        
    }
    
    func extendedDescription() -> String? {
        print("Dentro DishAllergeni. DescrizioneEstesa non sviluppata")
        return nil
    }
    
    func createId() -> String {
        
        self.simpleDescription().replacingOccurrences(of: " ", with: "").lowercased() // standardizziamo le stringhe ID in lowercases senza spazi
    }
    
}
