//
//  NewPropertyMainView_GoogleMaps.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/06/23.
//

import SwiftUI
// Le mappe di google sono più affidabile, ma al momento 17/06/2023 non abbiamo uno swiftPackage ufficiale e non lo abbiamo usato fin ora e non abbiamo intenzione di farlo di utilizzare cocoapod. D'altrone in questa prima versione la registrazione della proprietà serve a poco e credo sia anche slegata dai menu e dalla loro pubblcazione. Servirà quando l'utente finale navigherà fra i menu e dovrà conoscere a quale proprietà appartengono
struct NewPropertyMainView_GoogleMaps: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NewPropertyMainView_GoogleMaps_Previews: PreviewProvider {
    static var previews: some View {
        NewPropertyMainView_GoogleMaps()
    }
}
