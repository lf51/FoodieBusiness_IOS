//
//  BottomDialogView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 13/11/23.
//

import Foundation
import SwiftUI
import MyPackView_L0

struct BottomDialogView<Content:View>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var showDialog: Bool = false
    
    var primaryButtonTitle:String = "Salva"
    var secondaryButtonTitle:String = "Reset"
    var paddingVerticalValue:CGFloat? = .none
    
    let description: () -> (breve:Text,estesa:Text)
    let disableConditions: () -> (general:Bool?,primary:Bool,secondary:Bool?)
    var secondaryAction: (() -> Void)? = nil
    var preDialogCheck: (() -> Bool) = { true }
    let primaryDialogAction: () -> Content
    
    var body: some View {
       
        HStack {
                
            description().breve
                .italic()
                .fontWeight(.light)
                .font(.caption)
                .multilineTextAlignment(.leading)

            Spacer()
            
            Group {
                
                if let secondaryAction  {
                    
                    CSButton_tight(
                        title: secondaryButtonTitle,
                        fontWeight: .light,
                        titleColor: Color.red,
                        fillColor: Color.clear) {
                        
                        withAnimation {
                            secondaryAction()
                        }
                    }
                    .opacity(disableConditions().secondary ?? false ? 0.6 : 1.0)
                    .disabled(disableConditions().secondary ?? false)
                    
                }

                CSButton_tight(
                    title: primaryButtonTitle,
                    fontWeight: .bold,
                    titleColor: Color.white,
                    fillColor: Color.blue) {
                    self.showDialog = preDialogCheck()
                 
                }
                .opacity(disableConditions().primary ? 0.6 : 1.0)
                .disabled(disableConditions().primary)
            }
            .opacity(disableConditions().general ?? false ? 0.6 : 1.0)
            .disabled(disableConditions().general ?? false)
        }
        .padding(.vertical,paddingVerticalValue)
        .confirmationDialog(
            description().estesa,
                isPresented: $showDialog,
                titleVisibility: .visible) { primaryDialogAction() }
        
    }
 
}
