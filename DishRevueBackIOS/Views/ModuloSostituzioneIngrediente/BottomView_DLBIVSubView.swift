//
//  BottomView_DLBIVSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/09/22.
//

import SwiftUI

/// DLBIV == DishListByIngredientView
struct BottomView_DLBIVSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let destinationPath: DestinationPath
    let isDeActive: Bool
    let description: () -> Text
    let resetAction: () -> Void
    let saveAction: () -> Void

    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description()
                .italic()
                .fontWeight(.light)
                .font(.caption)
                .multilineTextAlignment(.leading)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                self.showDialog = true
             
            }
        }
        .opacity(isDeActive ? 0.6 : 1.0)
        .disabled(isDeActive)
        .padding(.vertical)
        .confirmationDialog(
            description(),
                isPresented: $showDialog,
                titleVisibility: .visible) { saveButtonDialogView() }
        
    }
    
    // Method
    @ViewBuilder private func saveButtonDialogView() -> some View {
 
                Button("Salva ed Esci", role: .none) {
                    
                    self.saveAction()
                }

    }
   
}
