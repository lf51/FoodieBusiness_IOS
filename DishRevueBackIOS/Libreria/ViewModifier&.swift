//
//  CSViewModifier.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/05/22.
//

import Foundation
import SwiftUI

/// Un overlay custom che contiene la logica per comprendere se trattasi di una modifica o una creazione al modello
struct CS_RemoteModelChange:ViewModifier {
    
    @EnvironmentObject var viewModel:AccounterVM
    let rifModel:String
   
    func body(content: Content) -> some View {

        content
            .overlay {
                
                if viewModel.remoteStorage.modelRif_modified.contains(rifModel) {
                    
                    CS_VelaShape()
                    .foregroundColor(Color.yellow)
                    .cornerRadius(5.0)
                    .opacity(0.6)
                    
                } else if viewModel.remoteStorage.modelRif_newOne.contains(rifModel) {
                    
                        CS_VelaShape()
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                        .cornerRadius(5.0)
                        .opacity(0.6)
        
                }
            }
    }
}

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


