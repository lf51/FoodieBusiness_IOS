//
//  InvetarioModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/09/22.
//

import Foundation
import SwiftUI
import Firebase

struct Inventario:Equatable,MyProCloudPack_L1 {

    // Nota 02.10
    // Nota 21.11 -> Modifiche da fare
    var id:String
    
    var ingInEsaurimento:[String]
    var ingEsauriti:[String]
    var archivioNotaAcquisto: [String:String] // key:IdIngrediente || Value: Nota per l'acquisto
    
    var cronologiaAcquisti:[String:[String]] // key = idIngrediente || Value = [date di acquisto + nota] -> Creiamo una stringa combinata invece che una tupla e la scomponiamo con un algoritmo che separa la data dalla nota

    var lockedId:[String:[String]] // speculare a cronologiaAcquisti.Contiene per ogni chiava(data) un array degli id a cui è stato cambiato lo stato.
    
    /// L'archivio ingredienti in esaurimento rende obsoleto l'uso di un archivio dell'inventario quando creiamo la lista della spesa. E' un dizionario che dovrà funzionare con una sola chiave, la data corrente.
    var archivioIngInEsaurimento: [String:[String]] // key:DataCorrente || value = [id ingredienti Esauriti depennati]
    
    init(id: String, ingInEsaurimento: [String], ingEsauriti: [String], archivioNotaAcquisto: [String : String], cronologiaAcquisti: [String : [String]], lockedId: [String : [String]], archivioIngInEsaurimento: [String : [String]]) {
        
        // Non dovrebbe essere in uso. Deprecabile
        
        self.id = id
        self.ingInEsaurimento = ingInEsaurimento
        self.ingEsauriti = ingEsauriti
        self.archivioNotaAcquisto = archivioNotaAcquisto
        self.cronologiaAcquisti = cronologiaAcquisti
        self.lockedId = lockedId
        self.archivioIngInEsaurimento = archivioIngInEsaurimento
    }
    
    init() {
        
        self.id = "userInventario"
        self.ingInEsaurimento = []
        self.ingEsauriti = []
        self.archivioNotaAcquisto = [:]
        self.cronologiaAcquisti = [:]
        self.lockedId = [:]
        self.archivioIngInEsaurimento = [:]
        
    }
    
    // MyProCloudPack_L1
    
    init(frDoc: QueryDocumentSnapshot) {
        
        self.id = frDoc.documentID
        
        self.ingInEsaurimento = frDoc[DataBaseField.ingInEsaurimento] as? [String] ?? []
        self.ingEsauriti = frDoc[DataBaseField.ingEsauriti] as? [String] ?? []
        self.archivioNotaAcquisto = frDoc[DataBaseField.archivioNotaAcquisto] as? [String:String] ?? [:]
        self.cronologiaAcquisti = frDoc[DataBaseField.cronologiaAcquisti] as? [String:[String]] ?? [:]
        self.lockedId = frDoc[DataBaseField.lockedId] as? [String:[String]] ?? [:]
        self.archivioIngInEsaurimento = frDoc[DataBaseField.archivioIngInEsaurimento] as? [String:[String]] ?? [:]
        
    }
    
    func documentDataForFirebaseSavingAction() -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.ingInEsaurimento : self.ingInEsaurimento,
            DataBaseField.ingEsauriti : self.ingEsauriti,
            DataBaseField.archivioNotaAcquisto : self.archivioNotaAcquisto,
            DataBaseField.cronologiaAcquisti : self.cronologiaAcquisti,
            DataBaseField.lockedId : self.lockedId,
            DataBaseField.archivioIngInEsaurimento : self.archivioIngInEsaurimento

        ]
        
        return documentData
    }
    
    struct DataBaseField {
        
        static let ingInEsaurimento = "ingInEsaurimento"
        static let ingEsauriti = "ingEsauriti"
        static let archivioNotaAcquisto = "archivioNotaAcquisto"
        static let cronologiaAcquisti = "cronologiaAcquisti"
        static let lockedId = "lockedId"
        static let archivioIngInEsaurimento = "archivioIngInEsaurimento"
        
    }
    
    //
    
    // Method
    
    func allInventario() -> [String] {
        
        let inArrivo = self.allInArrivo()
        
        return self.ingEsauriti + self.ingInEsaurimento + inArrivo
    }
    
    func allInArrivo() -> [String] {
        
        let today = csTimeFormatter().data.string(from: Date())
        
       /*let inArrivo = cronologiaAcquisti.filter({
            $0.value.contains(today)
        }) */
        let inArrivo = cronologiaAcquisti.filter({
            $0.value.contains(where: {$0.hasPrefix(today)})
        })
        
        
        return inArrivo.map({$0.key})
        
       /* var inArrivo:[String] = []
        
        for (k,v) in cronologiaAcquisti {
            
            if v.contains(today) { inArrivo.append(k) }
            
        }
        return inArrivo */
    }
    
 /*   func inventarioFiltrato(viewModel:AccounterVM) -> EnumeratedSequence<[IngredientModel]> {
        
          let allIDing = self.allInventario()
          let allING = viewModel.modelCollectionFromCollectionID(collectionId: allIDing, modelPath: \.allMyIngredients)
          
        let allVegetable = allING.filter({ $0.origine.returnTypeCase() == .vegetale })
        let allMeat = allING.filter({
              $0.origine.returnTypeCase() == .animale &&
              !$0.allergeni.contains(.latte_e_derivati) &&
              !$0.allergeni.contains(.molluschi) &&
              !$0.allergeni.contains(.pesce) &&
              !$0.allergeni.contains(.crostacei)
          })
        let allFish = allING.filter({
              $0.allergeni.contains(.molluschi) ||
              $0.allergeni.contains(.pesce) ||
              $0.allergeni.contains(.crostacei)
          })
          
        let allMilk = allING.filter({
              $0.origine.returnTypeCase() == .animale &&
              $0.allergeni.contains(.latte_e_derivati)
          })
        
         /* allVegetable.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
           allMilk.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
           
           allMeat.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
       
           allFish.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           }) */
        
        return (allVegetable + allMilk + allMeat + allFish).enumerated()
    } */
    
  /*  func inventarioFiltrato(viewModel:AccounterVM) -> EnumeratedSequence<[IngredientModel]> {
        
          let allIDing = self.allInventario()
          let allING = viewModel.modelCollectionFromCollectionID(collectionId: allIDing, modelPath: \.allMyIngredients)
          
          var allVegetable = allING.filter({ $0.origine.returnTypeCase() == .vegetale })
          var allMeat = allING.filter({
              $0.origine.returnTypeCase() == .animale &&
              !$0.allergeni.contains(.latte_e_derivati) &&
              !$0.allergeni.contains(.molluschi) &&
              !$0.allergeni.contains(.pesce) &&
              !$0.allergeni.contains(.crostacei)
          })
          var allFish = allING.filter({
              $0.allergeni.contains(.molluschi) ||
              $0.allergeni.contains(.pesce) ||
              $0.allergeni.contains(.crostacei)
          })
          
          var allMilk = allING.filter({
              $0.origine.returnTypeCase() == .animale &&
              $0.allergeni.contains(.latte_e_derivati)
          })
        
          allVegetable.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
           allMilk.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
           
           allMeat.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
       
           allFish.sort(by: {
               viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id).orderValue() > viewModel.inventarioScorte.statoScorteIng(idIngredient: $1.id).orderValue()
           })
        
        return (allVegetable + allMilk + allMeat + allFish).enumerated()
    } */
    
    func statoScorteIng(idIngredient:String) -> Inventario.TransitoScorte {
        
        //let today = csTimeFormatter().data.string(from: Date())
        
        if ingInEsaurimento.contains(idIngredient) {
            
            return .inEsaurimento
        }
        
        else if ingEsauriti.contains(idIngredient) {
            
            return .esaurito
        }
        
      /*  else if let key = cronologiaAcquisti[today] {
            
            if key.contains(idIngredient) { return .inArrivo }
            else { return .inStock}
        } */
        
        else if let key = cronologiaAcquisti[idIngredient] {
            
            let today = csTimeFormatter().data.string(from: Date())
            
           /* if key.contains(today) { return .inArrivo }
            else { return .inStock } */ // 14.10 modifica
            let filterKey = key.filter({$0.hasPrefix(today)})
            if filterKey.isEmpty { return .inStock}
            else { return .inArrivo }

            
        }
        
        
      /*  else if cronologiaAcquisti[idIngredient] != nil {
            
            let today = csTimeFormatter().data.string(from: Date())
            
            if cronologiaAcquisti[idIngredient]!.contains(today) { return .inArrivo } else { return .inStock }
        } */
        
        else {
            return .inStock
        }
        
    }
    
    mutating func cambioStatoScorte(idIngrediente:String,nuovoStato:Inventario.TransitoScorte) {
        
        switch nuovoStato {
            
        case .inEsaurimento:
            self.ingInEsaurimento.append(idIngrediente) // usata nel menuInterattivo
        case .esaurito:
            convertiInEsaurito(idIngrediente: idIngrediente) // usata nel menuInterattivo
        case .inArrivo:
            convertiStatoInArrivo(id: idIngrediente) // usata in lista della spesa
        case .inStock:
            reverseInStock(id: idIngrediente)
        }
    }
    
    private mutating func reverseInStock(id:String) {
        // riporta in stock in caso di errore nel menu interattivo. Funziona solo da ingredienti in esaurimento o esauriti
        if self.ingInEsaurimento.contains(id) {
            self.ingInEsaurimento.removeAll(where: {$0 == id})
            
        } else if self.ingEsauriti.contains(id) {
            self.ingEsauriti.removeAll(where: {$0 == id})
        }
        
    }
    
   /* private mutating func convertiStatoInArrivoDEPRECATA(id:String) {
        
        let dataDiAcquisto = Date.now
        let dataInString = csTimeFormatter().data.string(from: dataDiAcquisto)
      
        if self.ingInEsaurimento.contains(id) {
            
            self.ingInEsaurimento.removeAll(where: {$0 == id})
           
            if self.archivioIngInEsaurimento[dataInString] != nil {
                self.archivioIngInEsaurimento[dataInString]!.append(id)
            } else {
                self.archivioIngInEsaurimento = [dataInString:[id]]
            }
            
        } else {
            self.ingEsauriti.removeAll(where: {$0 == id})
        }

       /* guard self.cronologiaAcquisti[dataInString] != nil else {
            return self.cronologiaAcquisti[dataInString] = [id]
        }
        
        self.cronologiaAcquisti[dataInString]!.append(id) */
        
        guard self.cronologiaAcquisti[id] != nil else {
           return self.cronologiaAcquisti[id] = [dataInString]
        }
        
        self.cronologiaAcquisti[id]!.append(dataInString)
 
    } */ // deprecata 14.10
    private mutating func convertiStatoInArrivo(id:String) {
        
        let dataDiAcquisto = Date.now
        // 14.10
        let dataInString = csTimeFormatter().data.string(from: dataDiAcquisto)
     
        var dataPlusNota:String
        
        if let theKey = self.archivioNotaAcquisto[id] {
            
            dataPlusNota = theKey.hasPrefix(dataInString) ? theKey : dataInString
            
        } else {
            dataPlusNota = dataInString
        }
        // end 14.10
        
     //   let dataPlusNota = "\(dataInString)-\(nota)"
        // end Test
        
        if self.ingInEsaurimento.contains(id) {
            
            self.ingInEsaurimento.removeAll(where: {$0 == id})
           
            if self.archivioIngInEsaurimento[dataInString] != nil {
                self.archivioIngInEsaurimento[dataInString]!.append(id)
            } else {
                self.archivioIngInEsaurimento = [dataInString:[id]]
            }
            
        } else {
            self.ingEsauriti.removeAll(where: {$0 == id})
        }

        guard self.cronologiaAcquisti[id] != nil else {
           return self.cronologiaAcquisti[id] = [dataPlusNota]
        }
        
        self.cronologiaAcquisti[id]!.append(dataPlusNota)

    }
    
    private mutating func convertiInEsaurito(idIngrediente:String) {
        
        if self.ingInEsaurimento.contains(idIngrediente) {
            
            self.ingInEsaurimento.removeAll(where: {$0 == idIngrediente})
           
        }
        
        self.ingEsauriti.append(idIngrediente)
        
    }
    
    /// ritorna la data dell'ultimo acquisto associato ad un idIngrediente
    func dataUltimoAcquisto(idIngrediente:String) -> String { // torna data in forma di stringa
        
      /*  var allDate:[TimeInterval:Date] = [:]
        
        let today = Date()
        for (stringDate,idCollection) in self.cronologiaAcquisti {
            
            if idCollection.contains(idIngrediente) {
                if let date:Date = csTimeFormatter().data.date(from: stringDate) {
                    let distanceFromToday = date.distance(to: today)
                    allDate[distanceFromToday] = date }
            }
        }
        
        if let smallerTimeInterval = allDate.keys.min() {
            
            let closerDate = allDate[smallerTimeInterval]!
            let closerDateString = csTimeFormatter().data.string(from: closerDate)
            
            return closerDateString
        } else {
            return "nessuno"
        } */
        
        let last = self.cronologiaAcquisti[idIngrediente]?.last
        
        // innesto 18.10
     /*   guard last?.contains("|") ?? false else { return last ?? "nessuno"}
        
        let split = last?.split(separator: "|")
        return String(split?[0] ?? "nessuno") */
      return splitDateFromNote(stringa: last ?? "nessuno").data
        
        //
     //   return last ?? "nessuno"
        
      /* guard let key = self.cronologiaAcquisti[idIngrediente] else { return "nessuno"}
        
        let ultimoAcquisto = key.last
        
        return ultimoAcquisto ?? "nessuno" */
        
    }
    
    /// riceve la stringa di una nota e ne separa le due parti, la data dalla nota in se.
    func splitDateFromNote(stringa: String) -> (data:String,nota:String) {
        
        guard stringa.contains("|") else { return (stringa,"Nessuna Nota")}
        
        let split = stringa.split(separator: "|")
        let data = String(split[0])
        let nota = String(split[1])
        return (data,nota)
        
    }
    
    /// ritorna la cronologia degli acquisti associati ad un idingrediente, ossia un array di date-note
    func logAcquisti(idIngrediente:String) -> [String] {
        
       /* var logDate:[String] = []
        
        for (stringDate,idCollection) in self.cronologiaAcquisti {
         
            if idCollection.contains(idIngrediente) { logDate.append(stringDate) }
            
        }
        return logDate */
        
       return self.cronologiaAcquisti[idIngrediente] ?? []
    }
    
    /// ricava la nota associato ad un id ed una data
    func estrapolaNota(idIngrediente:String,currentDate:String) -> String {
        
        if let nota = self.archivioNotaAcquisto[idIngrediente] {
            
            if nota.hasPrefix(currentDate) {
                let prefixCount = currentDate.count
                var cleanNote = nota
                cleanNote.removeFirst(prefixCount + 1) // plus One per eliminare il | di demarcazione che mi viene utile per separare gli elementi nella cronologia acqisti
                return cleanNote
            } else { return "" }
            
        } else { return "" }
            
        
     //   return self.archivioNotaAcquisto[idIngrediente] ?? ""
        
    }
    

    
    
    enum TransitoScorte:String,MyProEnumPack_L0 {
        
        static var allCases:[TransitoScorte] = [.inStock,.inArrivo,.inEsaurimento,.esaurito]
        
        case inEsaurimento = "in esaurimento"
        case esaurito = "esaurite"
        case inStock = "in stock"
        case inArrivo = "in arrivo"
        
        func orderAndStorageValue() -> Int {
            
            switch self {
                
            case .inStock:
                return 0
            case .inEsaurimento:
                return 1
            case .esaurito:
                return 2
            case .inArrivo:
                return 0
            }

        }
        
        func simpleDescription() -> String {
         
            switch self {
                
            case .inStock:
                return "in Stock"
            case .inEsaurimento:
                return "ai minimi"
            case .esaurito:
                return "terminate"
            case .inArrivo:
                return "in arrivo"
            }
        }
        
        func returnTypeCase() -> Inventario.TransitoScorte {
            self
        }
        
        func imageAssociata() -> String {
            
            switch self {
                
            case .inStock:
                return "house"
            case .inEsaurimento:
                return "clock.badge.exclamationmark"
            case .esaurito:
                return "alarm.waves.left.and.right"
            case .inArrivo:
                return "creditcard"
            }
        }
        
        func coloreAssociato() -> Color {
            
            switch self {
                
            case .inStock:
                return Color("SeaTurtlePalette_3")
            case .inEsaurimento:
                return .yellow.opacity(0.7)
            case .esaurito:
                return .red.opacity(0.6)
            case .inArrivo:
                return .green.opacity(0.7)
            }
            
        }
    }
}
