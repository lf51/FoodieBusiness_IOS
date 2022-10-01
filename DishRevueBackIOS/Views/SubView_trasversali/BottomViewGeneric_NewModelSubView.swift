//
//  OverlayTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/07/22.
//

import SwiftUI

/// Questa View è la bottom Standard - Reset Salva - per i Nuovi Modelli. E' una generic non in senso stretto. Esegue un check Preliminare prima di aprire la confirmationDialog. Rende obsoleto i disabled dei singoli oggetti. Permette di mandare tramite il checkPrelimare il segnale per un warning.
struct BottomViewGeneric_NewModelSubView<M:MyProStarterPack_L1>: View {
    // 15.09 da M:MyModelProtocol a M:MyProStarterPack_L1
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var itemModel: M
    @Binding var generalErrorCheck:Bool
   // let wannaDisableButtonBar: Bool
    let itemModelArchiviato: M
    let destinationPath: DestinationPath
    let description: () -> Text
    let resetAction: () -> Void
    let checkPreliminare: () -> Bool
    let salvaECreaPostAction: () -> Void
  //  @ViewBuilder var saveButtonDialogView: Content
    
    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description()
                .italic()
                .fontWeight(.light)
                .font(.caption)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                let check = checkPreliminare()
                if check { self.showDialog = true}
                else { self.generalErrorCheck = true }
            }
        }
        .opacity(itemModel == itemModelArchiviato ? 0.6 : 1.0)
        .disabled(itemModel == itemModelArchiviato)
        .padding(.vertical)
        .confirmationDialog(
                description(),
                isPresented: $showDialog,
                titleVisibility: .visible) { saveButtonDialogView() }
        
    }
    
    // Method
    
    /// Reset Crezione Modello - Torna un modello Vuoto o il Modello Senza Modifiche
 /*  private func resetAction() {
      
        self.itemModel = itemModelArchiviato
      //  modelAttivo = modelArchiviato
    } */

    @ViewBuilder private func saveButtonDialogView() -> some View {
        
      //  let (_,newModelName) = self.itemModel.returnNewModel()
      /*  let newModelName = self.itemModel.returnNewModel().nometipo */
       // let newModelName = self.itemModel.returnModelTypeName()
        let newModelName = self.itemModel.basicModelInfoInstanceAccess().nomeOggetto
        
        if itemModelArchiviato.intestazione == "" {
            // crea un Nuovo Oggetto
            Group {
                
                Button("Salva e Crea Nuovo", role: .none) {
                    
                    self.viewModel.createItemModel(itemModel: self.itemModel)
                 //   self.generalErrorCheck = false
                  //  self.itemModel = newModelType
                    self.salvaECreaPostAction()
                    
                }
                
                Button("Salva ed Esci", role: .none) {
                    
                    self.viewModel.createItemModel(itemModel: self.itemModel,destinationPath: self.destinationPath)
                }

            }
        }
        
        else if self.itemModelArchiviato.intestazione == self.itemModel.intestazione {
            // modifica l'oggetto corrente
            
            Group { vbEditingSaveButton() }
        }
        
        else {
            
            Group {
                
                vbEditingSaveButton()
                
                Button("Salva come Nuovo \(newModelName)", role: .none) {
                    // Add 18.08
                    self.itemModel.id = UUID().uuidString
                    // vedi NotaVocale 13.09
                    
                    // assegniamo un nuovo id e salviamo così un nuovo oggetto
                    // end
                    self.viewModel.createItemModel(itemModel: self.itemModel,destinationPath: self.destinationPath)
                }
            }
        }
    }
    
    @ViewBuilder private func vbEditingSaveButton() -> some View {
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
            self.viewModel.updateItemModel(itemModel: self.itemModel, destinationPath: self.destinationPath)
        }
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.itemModel)
           // self.generalErrorCheck = false
          //  self.itemModel = modelVuoto
            self.salvaECreaPostAction() // BUG -> deve partire se dall'update non torna un errore - Da sistemare
        }
 
    }
    
    
}



/*
/// Questa View è la bottom Standard - Reset Salva - per i Nuovi Modelli. E' una generic non in senso stretto. Esegue un check Preliminare prima di aprire la confirmationDialog. Rende obsoleto i disabled dei singoli oggetti. Permette di mandare tramite il checkPrelimare il segnale per un warning.
struct BottomViewGeneric_NewModelSubView<Content: View>: View {
    
    @Binding var generalErrorCheck:Bool
    let wannaDisableButtonBar: Bool
    let description: () -> Text
    let resetAction: () -> Void
    let checkPreliminare: () -> Bool
    @ViewBuilder var saveButtonDialogView: Content
    
    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description()
                .italic()
                .fontWeight(.light)
                .font(.caption)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                let check = checkPreliminare()
                if check { self.showDialog = true}
                else { self.generalErrorCheck = true }
            }
        }
        .opacity(wannaDisableButtonBar ? 0.6 : 1.0)
        .disabled(wannaDisableButtonBar)
        .padding(.vertical)
        .confirmationDialog(
                description(),
                isPresented: $showDialog,
                titleVisibility: .visible) { saveButtonDialogView }
        
    }
    
    // Method
    


} */ // Deprecata 20.07

/*
struct OverlayTEST_Previews: PreviewProvider {
    static var previews: some View {
        OverlayTEST()
    }
} */
