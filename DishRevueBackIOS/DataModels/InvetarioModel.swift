//
//  InvetarioModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/09/22.
//

import Foundation
import SwiftUI

struct Inventario:Equatable {
    
    var ingInEsaurimento:[String] = []
    var ingEsauriti:[String] = []
    
    var cronologiaAcquisti:[String:[String]] = [:] // key = idIngrediente || Value = [date di acquisto]
    var lockedId:[String:[String]] = [:] // speculare a cronologiaAcquisti.Contiene per ogni chiava(data) un array degli id a cui è stato cambiato lo stato.
    
    func allInventario() -> [String] {
        
        let inArrivo = self.allInArrivo()
        
        return self.ingEsauriti + self.ingInEsaurimento + inArrivo
    }
    
    func allInArrivo() -> [String] {
        
        let today = csTimeFormatter().data.string(from: Date())
        
      //  return cronologiaAcquisti[today] ?? []
        let inArrivo = cronologiaAcquisti.filter({
            $0.value.contains(today)
        })
        return inArrivo.map({$0.key})
        
       /* var inArrivo:[String] = []
        
        for (k,v) in cronologiaAcquisti {
            
            if v.contains(today) { inArrivo.append(k) }
            
        }
        return inArrivo */
    }
    
    func inventarioFiltrato(viewModel:AccounterVM) -> EnumeratedSequence<[IngredientModel]> {
        
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
    }
    
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
            
            if key.contains(today) { return .inArrivo }
            else { return .inStock }
            
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
    
    private mutating func convertiStatoInArrivo(id:String) {
        
        self.ingInEsaurimento.removeAll(where: {$0 == id})
        self.ingEsauriti.removeAll(where: {$0 == id})
        
        let dataDiAcquisto = Date.now
        let dataInString = csTimeFormatter().data.string(from: dataDiAcquisto)

       /* guard self.cronologiaAcquisti[dataInString] != nil else {
            return self.cronologiaAcquisti[dataInString] = [id]
        }
        
        self.cronologiaAcquisti[dataInString]!.append(id) */
        
        guard self.cronologiaAcquisti[id] != nil else {
           return self.cronologiaAcquisti[id] = [dataInString]
        }
        
        self.cronologiaAcquisti[id]!.append(dataInString)
 
    }
    
    private mutating func convertiInEsaurito(idIngrediente:String) {
        
        if self.ingInEsaurimento.contains(idIngrediente) {
            
            self.ingInEsaurimento.removeAll(where: {$0 == idIngrediente})
           
        }
        
        self.ingEsauriti.append(idIngrediente)
        
    }
    
    
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
        
        return last ?? "nessuno"
        
      /* guard let key = self.cronologiaAcquisti[idIngrediente] else { return "nessuno"}
        
        let ultimoAcquisto = key.last
        
        return ultimoAcquisto ?? "nessuno" */
        
    }
    
    func logAcquisti(idIngrediente:String) -> [String] {
        
       /* var logDate:[String] = []
        
        for (stringDate,idCollection) in self.cronologiaAcquisti {
         
            if idCollection.contains(idIngrediente) { logDate.append(stringDate) }
            
        }
        return logDate */
        
       return self.cronologiaAcquisti[idIngrediente] ?? []
    }
    
    enum TransitoScorte:String {
        
        case inEsaurimento = "in esaurimento"
        case esaurito = "esaurite"
        case inStock = "in stock"
        case inArrivo = "acquistate"
        
        func orderValue() -> Int {
            
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
                return "acquistate"
            }
        }
        
        func imageAssociata() -> String {
            
            switch self {
                
            case .inStock:
                return "house"
            case .inEsaurimento:
                return "cart.badge.plus"
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
                return .yellow
            case .esaurito:
                return .red.opacity(0.6)
            case .inArrivo:
                return .green
            }
            
        }
    }
}
