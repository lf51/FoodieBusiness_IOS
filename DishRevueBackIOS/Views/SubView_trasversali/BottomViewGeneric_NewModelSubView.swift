//
//  OverlayTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/07/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import Firebase

/// Questa View è la bottom Standard - Reset Salva - per i Nuovi Modelli. E' una generic non in senso stretto. Esegue un check Preliminare prima di aprire la confirmationDialog. Rende obsoleto i disabled dei singoli oggetti. Permette di mandare tramite il checkPrelimare il segnale per un warning.
/*struct BottomViewGeneric_NewModelSubView<M:MyProStarterPack_L1 & Codable>: View where M.VM == AccounterVM {
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
                    
                  /*  self.viewModel.createItemModel(itemModel: self.itemModel)*/
                    self.viewModel.createModel(itemModel: self.itemModel)
                    self.salvaECreaPostAction()
                    
                }
                
                Button("Salva ed Esci", role: .none) {
                    
                    /*self.viewModel.createItemModel(itemModel: self.itemModel,destinationPath: self.destinationPath)*/
                    
                    self.viewModel.createModel(
                        itemModel: self.itemModel,
                        refreshPath: self.destinationPath)
                   
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
             
                    self.itemModel.id = UUID().uuidString

                    self.viewModel.createModel(
                        itemModel: self.itemModel,
                        refreshPath: self.destinationPath)
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
            
        self.viewModel.updateModel(itemModel: self.itemModel)

            self.salvaECreaPostAction() // BUG -> deve partire se dall'update non torna un errore - Da sistemare
        }
 
    }
    
    @ViewBuilder private func vbSaveEscButton() -> some View {
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
            self.viewModel.updateModel(
                itemModel: self.itemModel,
                refreshPath: self.destinationPath)
        }
        
    }

}*/ // deprecata 15_11_23

/// Questa View è la gemella della BottomViewGeneric, ma accetta due model. Ideata per il salvataggio del modello Ibrido.

/*struct BottomViewGenericPlus_NewModelSubView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var productModel: ProductModel
    @Binding var ingredienteSottostante: IngredientModel?
    @Binding var generalErrorCheck:Bool
   // let wannaDisableButtonBar: Bool
    let productArchiviato: ProductModel
    let sottostanteArchiviato: IngredientModel?
    let destinationPath: DestinationPath
    var dialogType:SaveDialogType = .completo
    
    let description: () -> Text
    let resetAction: () -> Void
    let checkPreliminare: () -> Bool
    let salvaECreaPostAction: () -> Void
    
    @State private var showDialog: Bool = false
    
    var body: some View {
        
        let condition: Bool = {
            productModel == productArchiviato &&
            ingredienteSottostante == sottostanteArchiviato
            // da articolare
        }()
        
        HStack {

            description()
                .italic()
                .fontWeight(.light)
                .font(.caption)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                self.showDialog = checkPreliminare()
               /* let check = checkPreliminare()
                if check { self.showDialog = true}
                else { self.generalErrorCheck = true }*/
            }
        }
        .opacity(condition ? 0.6 : 1.0)
        .disabled(condition)
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
            vbSaveEscButton { refresh in
                
                self.viewModel.updateModel(
                    itemModel: self.productModel,
                    refreshPath: refresh)
            }
        }
    }
    /// Casi Possibili:
    /// • Salvataggio nuova preparazione
    /// • Modifica nuova preparazione
    /// • Salva nuova composizione / Modifica composizione
    /// • Salva nuovo prodotto finito / salva nuovo ingrediente associato
    /// • Modifica prodotto finito / NON salva ingrediente associato
    /// • Crea nuovo prodotto finito da ingrediente esistente / NON SALVARE Ingrediente
    @ViewBuilder private func saveButtonDialogView() -> some View {

    let percorso = self.productModel.percorsoProdotto.returnTypeCase()
    
    switch percorso {
        
    case .preparazione:
        managePreparazione()
    case .composizione(_):
        manageComposizione()
    case .finito(_):
        manageProdottoFinito()
    }
}
    
    @ViewBuilder private func vbSaveButton(action:@escaping(_ refreshPath:DestinationPath?) -> Void ) -> some View {
        
        Button("Salva ed Esci", role: .none) {
            
           // self.saveModels(refreshPath: self.destinationPath)
            action(self.destinationPath)

        }
        
        Button("Salva e Crea Nuovo", role: .none) {
            
           // self.saveModels()
            action(nil)

            self.salvaECreaPostAction()
        }
 
    }
    
    @ViewBuilder private func vbSaveEscButton(action:@escaping(_ refreshPath:DestinationPath?) -> Void) -> some View {
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
            action(self.destinationPath)
        }
        
    }
    
    @ViewBuilder private func vbEditingButton(action:@escaping(_ refreshPath:DestinationPath?) -> Void) -> some View {
        
      /*  Button("Salva Modifiche ed Esci", role: .none) {
            
          //  self.updateModels(refreshPath: self.destinationPath)
            action(self.destinationPath)

        }*/
        vbSaveEscButton { refreshPath in
            action(refreshPath)
        }
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
           // self.updateModels()
            action(nil)
        
            self.salvaECreaPostAction()
        }
 
    }
    
    @ViewBuilder private func vbRenewButton(action:@escaping() -> Void) -> some View {
        
        let newModelName = self.productModel.basicModelInfoInstanceAccess().nomeOggetto

        Button("Salva come Nuovo \(newModelName)", role: .none) {
           
            action()
            
        }
        
    }
        
   @ViewBuilder private func managePreparazione() -> some View {
        
        let oldIntestazione = self.productArchiviato.intestazione
        let currentIntestazione = self.productModel.intestazione
        
        if oldIntestazione == "" {
            // Trattassi di nuova Preparazione
            vbSaveButton { refresh in
                self.viewModel.createModel(
                    itemModel: self.productModel,
                    refreshPath: refresh)
            }
        }
        else if currentIntestazione == oldIntestazione {
            // trattasi di modifica a preparazione esistente
            vbEditingButton { refresh in
                
                self.viewModel.updateModel(
                    itemModel: self.productModel,
                    refreshPath: refresh)
            }
        }
        else {
            // trattasi di modifica che permette il salvataggio come nuovo prodotto
            Group {
                
                vbEditingButton { refresh in
                    
                    self.viewModel.updateModel(
                        itemModel: self.productModel,
                        refreshPath: refresh)
                }
                
                vbRenewButton {
                    
                    let currentProduct:ProductModel = {
                        var prop = self.productModel
                        prop.id = UUID().uuidString
                        return prop
                    }()
                    
                    self.viewModel.createModel(
                        itemModel: currentProduct,
                        refreshPath: self.destinationPath)
                    
                }
            }
        }

    }
    
   @ViewBuilder private func manageComposizione() -> some View {
        
        var currentProduct:ProductModel = {
            
            var prod = self.productModel
            prod.percorsoProdotto = .composizione(ingredienteSottostante)
            return prod
        }()
       
       let customEncoder:Firestore.Encoder = {
            let encoder = Firestore.Encoder()
            encoder.userInfo[IngredientModel.codingInfo] = MyCodingCase.full
            return encoder
        }()
        
        if self.productModel.percorsoProdotto.associatedValue() != nil {
            // trattasi di una modifica
            if self.productModel.intestazione == self.productArchiviato.intestazione {
                // modifica
                vbEditingButton { refresh in
                
                    self.viewModel.updateModel(
                        itemModel: currentProduct,
                        refreshPath: refresh,
                        encoder: customEncoder)
                    
                }
           
            } else {
                // Possibilità di creare uno nuovo da esistente
                Group {
                    
                    vbEditingButton { refresh in
                    
                        self.viewModel.updateModel(
                            itemModel: currentProduct,
                            refreshPath: refresh,
                            encoder: customEncoder)
                        
                    }
                    
                    vbRenewButton {
                        
                        let nuovoSottostante:IngredientModel = {
                            var new = self.ingredienteSottostante! // deve esserci
                            new.id = UUID().uuidString
                            return new
                            
                        }()
                        currentProduct.id = UUID().uuidString
                        currentProduct.percorsoProdotto = .composizione(nuovoSottostante)
                        
                        self.viewModel.createModel(
                            itemModel: currentProduct,
                            refreshPath: self.destinationPath,
                            encoder: customEncoder)
                    }
                }
            }
            
        } else {
            // trattasi di nuova composizione
            vbSaveButton { refresh in
            
                self.viewModel.createModel(
                    itemModel: currentProduct,
                    refreshPath: refresh,
                    encoder: customEncoder)
            }
        }

    }
    
   @ViewBuilder private func manageProdottoFinito() -> some View {
    // Salva come nuovo non abilitato
       var currentProduct = self.productModel
      // var idSottostante = self.ingredienteSottostante?.id
       
    if self.productModel.percorsoProdotto.associatedValue() != nil {
        // trattasi di una modifica al rpdotto. Il sosttostante non è stato toccato
        vbEditingButton { refresh in
        
            self.viewModel.updateModel(
                itemModel: currentProduct,
                refreshPath: refresh)
        }
        
    } else if let ingredienteSottostante {
        // trattasi di un nuovo pF
        vbSaveButton { refresh in
            
            Task {
                
                var idSottostante = ingredienteSottostante.id
                
                try await self.viewModel.manageIngredientCreation(item:ingredienteSottostante) { id in
                    
                    if let id { idSottostante = id  }
 
                }
                
                currentProduct.percorsoProdotto = .finito(idSottostante)
                
                self.viewModel.createModel(
                    itemModel: currentProduct,
                    refreshPath: refresh)
                
            }

        }

    }

}

    
}*/// deprecata 14_11_23

/*
struct OverlayTEST_Previews: PreviewProvider {
    static var previews: some View {
        OverlayTEST()
    }
} */

/*
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

}*/ // BackUp 27_10_23


