//
//  OverlayTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/07/22.
//

import SwiftUI

/// Questa View è la bottom Standard - Reset Salva - per i Nuovi Modelli. E' una generic non in senso stretto
struct BottomViewGeneric_NewModelSubView<Content: View>: View {
    
    let wannaDisableSaveButton: Bool
    let menuDescription: () -> Text
    let resetAction: () -> Void
    @ViewBuilder var saveButtonDialogView: Content
    
    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            menuDescription()
                .italic()
                .fontWeight(.light)
                .font(.caption)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) { self.showDialog = true }
           .opacity(self.wannaDisableSaveButton ? 0.6 : 1.0)
           .disabled(self.wannaDisableSaveButton)
            
        }
        .padding(.vertical)
        .confirmationDialog(
                menuDescription(),
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
