//
//  Extension.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation
import SwiftUI
import MyPackView_L0


extension View {
    
    /// lf51 -> Se isPresented e localErrorCondition are true, mostra un warning in overlay TopTrailing
    func csWarningModifier(isPresented:Bool, localErrorCondition:() -> Bool) -> some View {
        
        self.modifier(CS_ErrorMarkModifier(generalErrorCheck: isPresented, localErrorCondition: localErrorCondition()))
          //  .offset(x: 10, y: -10)
    }
    
    
    /// lf51 - Send an Alert
    func csAlertModifier(isPresented: Binding<Bool>, item: AlertModel?) -> some View {
        
        self.modifier(CS_AlertModifier(isPresented: isPresented, item: item))
        
    }
    
    /// Layers the given views behind this ``TextEditor``.
    func csTextEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V : View {
            self
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .background(content())
        }
    
  /*  func csCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
          clipShape( RoundedCorner(radius: radius, corners: corners) )
      } // 27.01.23 Ricollocata ib MyPackView */
    
    /// Mette una vela alla Model Row per notificare che è stato creato nella sessione o che è stato modificato
    func csOverlayModelChange(rifModel:String) -> some View {
        
        self.modifier(CS_RemoteModelChange(rifModel: rifModel))
    }
    
    /// Padding orizzontale da 10 punti
    func csHpadding() -> some View {
        
        self.modifier(CustomHpadding())
        
    }

    
}

#if canImport(Charts)
extension UICollectionReusableView {
    
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
#endif

extension CGFloat {
    
    static let vStackLabelBodySpacing:CGFloat = 5
    static let vStackBoxSpacing:CGFloat = 10
    
}
