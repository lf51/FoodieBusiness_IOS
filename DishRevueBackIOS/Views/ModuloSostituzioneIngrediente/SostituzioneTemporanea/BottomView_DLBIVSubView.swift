//
//  BottomView_DLBIVSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/09/22.
//

import SwiftUI
import MyPackView_L0

/// DLBIV == DishListByIngredientView
struct BottomView_DLBIVSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
  //  let destinationPath: DestinationPath
    let isDeActive: Bool
    let description: () -> (breve:Text,estesa:Text)
    let resetAction: () -> Void
    let saveAction: () -> Void

    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description().breve
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
            description().estesa,
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


struct BottomView_ConVB<Content:View>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    var primaryButtonTitle:String = "Salva"
    var secondaryButtonTitle:String = "Reset"
    var paddingVerticalValue:CGFloat? = .none
    let isDeActive: () -> (general:Bool?,primary:Bool,secondary:Bool?)
    let description: () -> (breve:Text,estesa:Text)
    var secondaryAction: (() -> Void)? = nil
    let primaryDialogAction: () -> Content

    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description().breve
                .italic()
                .fontWeight(.light)
                .font(.caption)
                .multilineTextAlignment(.leading)

            Spacer()
            
            Group {
                
                if secondaryAction != nil {
                    
                    CSButton_tight(title: secondaryButtonTitle, fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) {
                        
                        withAnimation {
                            self.secondaryAction!()
                        }
                    }
                    .opacity(isDeActive().secondary ?? false ? 0.6 : 1.0)
                    .disabled(isDeActive().secondary ?? false)
                    
                }

                CSButton_tight(title: primaryButtonTitle, fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                    self.showDialog = true
                 
                }
                .opacity(isDeActive().primary ? 0.6 : 1.0)
                .disabled(isDeActive().primary)
            }
            .opacity(isDeActive().general ?? false ? 0.6 : 1.0)
            .disabled(isDeActive().general ?? false)
        }
        .padding(.vertical,paddingVerticalValue)
        .confirmationDialog(
            description().estesa,
                isPresented: $showDialog,
                titleVisibility: .visible) { primaryDialogAction() }
        
    }
 
}
