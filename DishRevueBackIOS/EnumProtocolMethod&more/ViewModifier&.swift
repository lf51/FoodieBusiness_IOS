//
//  CSViewModifier.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/05/22.
//

import Foundation
import SwiftUI

struct CS_AlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let item: AlertModel?
    
    func body(content: Content) -> some View {
        
     content
            .alert(Text(item?.title ?? "NoTitle"), isPresented: $isPresented, presenting: item) { alert in
                
                if alert.actionPlus != nil {
                    
                    Button(
                        role: .destructive) {
                            alert.actionPlus?.action()
                        } label: {
                            Text(alert.actionPlus?.title.rawValue.capitalized ?? "")
                        }
                }
          
            } message: { alert in
                Text(alert.message)
            }
        
    }
}


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
