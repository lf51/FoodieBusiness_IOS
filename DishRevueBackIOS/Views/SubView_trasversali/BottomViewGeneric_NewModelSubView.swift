//
//  OverlayTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/07/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/// Questa View è la bottom Standard - Reset Salva - per i Nuovi Modelli. E' una generic non in senso stretto. Esegue un check Preliminare prima di aprire la confirmationDialog. Rende obsoleto i disabled dei singoli oggetti. Permette di mandare tramite il checkPrelimare il segnale per un warning.
struct BottomViewGeneric_NewModelSubView<M:MyProStarterPack_L1>: View where M.VM == AccounterVM {
    // 15.09 da M:MyModelProtocol a M:MyProStarterPack_L1
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var itemModel: M
    @Binding var generalErrorCheck:Bool

    let itemModelArchiviato: M
    let destinationPath: DestinationPath
    var dialogType:SaveDialogType = .completo
    let description: () -> Text
    let resetAction: () -> Void
    let checkPreliminare: () -> Bool
    let salvaECreaPostAction: () -> Void
    
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
                titleVisibility: .visible) { preCallDialogButton() }
        
    }
    
    // Method

    @ViewBuilder private func preCallDialogButton() -> some View {
        
        switch self.dialogType {
            
        case .completo:
            saveButtonDialogView()
        case .ridotto:
            vbSaveEscButton()
        }
    }
    
    @ViewBuilder private func saveButtonDialogView() -> some View {

        let newModelName = self.itemModel.basicModelInfoInstanceAccess().nomeOggetto

        if itemModelArchiviato.intestazione == "" {
            // crea un Nuovo Oggetto
            Group {
                
                Button("Salva e Crea Nuovo", role: .none) {
                    
                    self.viewModel.createItemModel(itemModel: self.itemModel)
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
        
      /*  Button("Salva Modifiche ed Esci", role: .none) {
            
            self.viewModel.updateItemModel(itemModel: self.itemModel, destinationPath: self.destinationPath)
        } */
        
        vbSaveEscButton()
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.itemModel)

            self.salvaECreaPostAction() // BUG -> deve partire se dall'update non torna un errore - Da sistemare
        }
 
    }
    
    @ViewBuilder private func vbSaveEscButton() -> some View {
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
            self.viewModel.updateItemModel(itemModel: self.itemModel, destinationPath: self.destinationPath)
        }
        
    }

}

/// Questa View è la gemella della BottomViewGeneric, ma accetta due model. Ideata per il salvataggio del modello Ibrido.ItemModel deve essere un Dish e l'itemPlus un ingrediente per creare un ibrido.  11.07.23 La forma generica è totalmente inutile ma ormai la teniamo
struct BottomViewGenericPlus_NewModelSubView<M:MyProStarterPack_L1,M2:MyProStarterPack_L1>: View where M2.VM == AccounterVM, M.VM == AccounterVM {
    // 15.09 da M:MyModelProtocol a M:MyProStarterPack_L1
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var itemModel: M
    @Binding var itemModelPlus: M2
    @Binding var generalErrorCheck:Bool
   // let wannaDisableButtonBar: Bool
    let itemModelArchiviato: M
    let itemModelPlusArchiviato: M2
    let destinationPath: DestinationPath
    let description: () -> Text
    let resetAction: () -> Void
    let checkPreliminare: () -> Bool
    let salvaECreaPostAction: () -> Void
  //  @ViewBuilder var saveButtonDialogView: Content
    
    @State private var showDialog: Bool = false
    
    var body: some View {
        
        let condition: Bool = {
            itemModel == itemModelArchiviato &&
            itemModelPlus == itemModelPlusArchiviato
        }()
        
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
        .opacity(condition ? 0.6 : 1.0)
        .disabled(condition)
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

        let newModelName = self.itemModel.basicModelInfoInstanceAccess().nomeOggetto
        
        if itemModelArchiviato.intestazione == "" {
            // crea un Nuovo Oggetto
            Group {
                
                Button("Salva e Crea Nuovo", role: .none) {
                    
                    self.saveModels()
                   // self.viewModel.createItemModel(itemModel: self.itemModel)
                   // self.viewModel.createItemModel(itemModel: self.itemModelPlus)
                    self.salvaECreaPostAction()
                    
                }
                
                Button("Salva ed Esci", role: .none) {
                    self.saveModels(refreshPath: self.destinationPath)
                   // self.viewModel.createItemModel(itemModel: self.itemModelPlus)
                   // self.viewModel.createItemModel(itemModel: self.itemModel,destinationPath: self.destinationPath)
                   
                }

            }
        }
        
        else if self.itemModelArchiviato.intestazione == self.itemModel.intestazione {
            // modifica l'oggetto corrente
             vbEditingSaveButton()
        }
        
        else {
            
            Group {
                
                vbEditingSaveButton()
                
                Button("Salva come Nuovo \(newModelName)", role: .none) {
                    // Add 18.08
                    let newCommondId = UUID().uuidString
                    self.itemModel.id = newCommondId
                    self.itemModelPlus.id = newCommondId
                    // vedi NotaVocale 13.09
                    
                    // assegniamo un nuovo id e salviamo così un nuovo oggetto
                    // end
                    self.saveModels(refreshPath: self.destinationPath)
                  //  self.viewModel.createItemModel(itemModel: self.itemModelPlus)
                  //  self.viewModel.createItemModel(itemModel: self.itemModel,destinationPath: self.destinationPath)
                }
            }
        }
    }
    
    @ViewBuilder private func vbEditingSaveButton() -> some View {
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
            self.updateModels(refreshPath: self.destinationPath)
          //  self.viewModel.updateItemModel(itemModel: self.itemModelPlus)
          //  self.viewModel.updateItemModel(itemModel: self.itemModel, destinationPath: self.destinationPath)
        }
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
            self.updateModels()
            //self.viewModel.updateItemModel(itemModel: self.itemModelPlus)
            //self.viewModel.updateItemModel(itemModel: self.itemModel)
        
            self.salvaECreaPostAction()
        }
 
    }
    
    private func updateModels(refreshPath:DestinationPath? = nil) {
        
        self.viewModel.updateItemModel(itemModel: self.itemModelPlus) // ing di sistema
        self.viewModel.updateItemModel(itemModel: self.itemModel, destinationPath: refreshPath) // dish
       
    }
    
    private func saveModels(refreshPath:DestinationPath? = nil) {
        
        if var dish = self.itemModel as? DishModel {
            
            dish.ingredientiPrincipali = [itemModelPlus.id]
            self.viewModel.createItemModel(itemModel: self.itemModelPlus)
            self.viewModel.createItemModel(itemModel: dish,destinationPath: refreshPath)
            
            
        } else {
            self.viewModel.createItemModel(itemModel: self.itemModelPlus)
            self.viewModel.createItemModel(itemModel: self.itemModel,destinationPath: refreshPath)
            
        }
    }
    
}

/*
struct OverlayTEST_Previews: PreviewProvider {
    static var previews: some View {
        OverlayTEST()
    }
} */
