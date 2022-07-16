//
//  CSViewModifier.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/05/22.
//

import Foundation
import SwiftUI

/// Se il generalErrorCheck è true esegue un controllo sulla localErrorCondition, e se ques'ultima è true mostra un exclamationMark in overlay
struct CS_ErrorMarkModifier:ViewModifier {
    
    let generalErrorCheck:Bool
    let localErrorCondition:Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
           CS_ErrorMarkView(
            generalErrorCheck: generalErrorCheck,
            localErrorCondition: localErrorCondition)
           .offset(x: 10, y: -10)
            }
    }
    
}


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
                    .multilineTextAlignment(.leading)
                    
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
