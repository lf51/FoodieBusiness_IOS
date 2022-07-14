//
//  OverlayTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/07/22.
//

import SwiftUI

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
    


}

/*
struct OverlayTEST_Previews: PreviewProvider {
    static var previews: some View {
        OverlayTEST()
    }
} */
