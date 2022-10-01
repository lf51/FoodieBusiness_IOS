//
//  ModelloIngrediente.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/02/22.
//

import Foundation
import SwiftUI

// Creare Oggetto Ingrediente

struct IngredientModel:MyProToolPack_L0,MyProVisualPack_L1,MyProDescriptionPack_L0,MyProStatusPack_L1 /*MyModelStatusConformity */ {
   
  static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [IngredientModel]> {
        return \.allMyIngredients
    }
    
  static func == (lhs: IngredientModel, rhs: IngredientModel) -> Bool {
       return
      lhs.id == rhs.id &&
      lhs.intestazione == rhs.intestazione &&
      lhs.descrizione == rhs.descrizione &&
      lhs.conservazione == rhs.conservazione &&
      lhs.produzione == rhs.produzione &&
      lhs.provenienza == rhs.provenienza &&
      lhs.allergeni == rhs.allergeni &&
      lhs.origine == rhs.origine &&
      lhs.status == rhs.status
    //  lhs.inventario == rhs.inventario
   
    }
    
   // var id: String { creaID(fromValue: self.intestazione) } // Deprecata 18.08
    var id: String = UUID().uuidString

    var intestazione: String = ""
    var descrizione: String = ""
    
    var conservazione: ConservazioneIngrediente = .defaultValue
    var produzione: ProduzioneIngrediente = .defaultValue
    var provenienza: ProvenienzaIngrediente = .defaultValue
    
    var allergeni: [AllergeniIngrediente] = []
    var origine: OrigineIngrediente = .defaultValue
    
    var status: StatusModel = .bozza()
    
   // var inventario:Inventario = Inventario()

    // Method
    
    func modelStringResearch(string: String) -> Bool {
        self.intestazione.lowercased().contains(string)
    }
    
    func returnModelRowView() -> some View {
        IngredientModel_RowView(item: self)
    }

    func creaID(fromValue: String) -> String {
        fromValue.replacingOccurrences(of: " ", with: "").lowercased()
    } // deprecata in futuro
    
    func modelStatusDescription() -> String {
        "Ingrediente (\(self.status.simpleDescription().capitalized))"
    } // deprecata in futuro
    
    func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [IngredientModel]>, nomeContainer: String, nomeOggetto:String, imageAssociated:String) {
        
        return (\.allMyIngredients, "Lista Ingredienti", "Ingrediente","leaf")
    }

    func pathDestination() -> DestinationPathView {
        DestinationPathView.ingrediente(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        VStack {
            
            let statoScorte = viewModel.inventarioScorte.statoScorteIng(idIngredient: self.id)
            let ultimoAcquisto = viewModel.inventarioScorte.dataUltimoAcquisto(idIngrediente: self.id)
            
            Menu {
                
                Button("in Esaurimento") {
                    viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inEsaurimento)
                }.disabled(statoScorte != .inStock)
                
                Button("Esaurite") {
                    viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .esaurito)
                }.disabled(statoScorte == .esaurito || statoScorte == .inArrivo)
                
                if statoScorte == .esaurito || statoScorte == .inEsaurimento {
                    
                    Button("Rimetti in Stock") {
                        viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: self.id, nuovoStato: .inStock)
                    }
                }
                
                Text("Ultimo Acquisto:\n\(ultimoAcquisto)")
                
                Button("Cronologia Acquisti") {
                    viewModel[keyPath: navigationPath].append(DestinationPathView.vistaCrologiaAcquisti(self))
                }
                
            } label: {
                HStack{
                    Text("Scorte \(statoScorte.simpleDescription())")
                    Image(systemName: statoScorte.imageAssociata())
                }
            }

            Button {
                
                viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneING(self))
                
            } label: {
                HStack{
                    Text("Cambio Temporaneo")
                    /*Image(systemName: "arrowshape.turn.up.backward.badge.clock")*/
                    Image(systemName: "clock")
                }
            }
            
            Button {

                viewModel[keyPath: navigationPath].append(DestinationPathView.moduloSostituzioneING(self,isPermanente: true))
                
            } label: {
                HStack{
                    Text("Cambio Permanente")
                    Image(systemName: "exclamationmark.circle")
                  /*  Image(systemName: "arrow.left.arrow.right.circle") */
                }
            }
            
            
        }
    }
    
    
    /// Permette di sovrascrivere l'immagine associata all'origine con una immagine riferita agli allergeni che rispecchia meglio il prodotto - pensata e costruita per l'ingredientRow
    func associaImmagine() -> String {
        
        var allergeneDiServizio:AllergeniIngrediente = .defaultValue
        
        if self.origine == .animale {
            
            if self.allergeni.contains(where: {
                
                $0 == .pesce || $0 == .crostacei || $0 == .molluschi
                
            }) { allergeneDiServizio = .pesce }
            
            else if self.allergeni.contains(where: {
                
                $0 == .latte_e_derivati
                
            }) { allergeneDiServizio = .latte_e_derivati }
            
            else if self.allergeni.contains(where: {
                
                $0 == .uova_e_derivati
                
            }) { allergeneDiServizio = .uova_e_derivati }
            
            else { return self.origine.imageAssociated() }
            
        } else {
            
            if self.allergeni.contains(where: {
                
                $0 == .glutine
                
            }) { allergeneDiServizio = .glutine }
            
            else if self.allergeni.contains(where: {
                
                $0 == .arachidi_e_derivati || $0 == .fruttaAguscio
                
            }) { allergeneDiServizio = .arachidi_e_derivati }
            
            else { return self.origine.imageAssociated()}
    
        }
 
            return allergeneDiServizio.imageAssociated()
    }
    
    /// ritorna true se tutte le proprietà optional sono state compilate, e dunque il modello è completo.
    func optionalComplete() -> Bool {
        
        self.descrizione != "" &&
        self.produzione != .defaultValue &&
        self.provenienza != .defaultValue
    }
}
