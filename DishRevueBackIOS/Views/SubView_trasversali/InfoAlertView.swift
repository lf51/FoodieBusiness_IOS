//
//  InfoAlertView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/08/22.
//

import SwiftUI
import MyPackView_L0

/// Un info Point al Tap. L'info è mostrata da un Alert classico, senza action. Il messaggio veicolato è di tipo SystemMessage
struct CSInfoAlertView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    var imageScale: Image.Scale = .medium
    let title: String
    let message: SystemMessage
    
    var body: some View {
        
        Image(systemName: "info.circle.fill")
            .imageScale(imageScale)
            .bold()
            .foregroundColor(Color.white)
            .onTapGesture {
                    self.viewModel.alertItem = AlertModel(
                        title: title,
                        message: message.simpleDescription() )
                
            }
    }
}

/*
struct InfoAlertView_Previews: PreviewProvider {
    static var previews: some View {
        InfoAlertView()
    }
} */
