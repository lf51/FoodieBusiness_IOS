//
//  Extension.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 27/04/22.
//

import Foundation
import SwiftUI


extension View {
    
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
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
          clipShape( RoundedCorner(radius: radius, corners: corners) )
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


