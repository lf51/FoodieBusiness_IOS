//
//  SwitchListeIngredientiPiatto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

/* // BACKUP 10.05
struct SwitchListeIngredientiPiattoD<M1:MyModelProtocol>: View {
    
    @Binding var newDish: M1
    @Binding var listaDaMostrare: ModelList
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack{
                
                Text("Ingredienti Principali")
                    .fontWeight(listaDaMostrare == .ingredientiPrincipali ? .bold : .light)
                    .lineLimit(1)
                
                Spacer()
                
                CSButton_image(
                    activationBool: listaDaMostrare == .ingredientiPrincipali,
                    frontImage: "eye.fill",
                    backImage: "eye.slash.fill",
                    imageScale: .medium,
                    backColor: Color.blue,
                    frontColor: Color.gray) {
                        withAnimation {
                            listaDaMostrare = .ingredientiPrincipali
                        }
                    }
                                
             /*   Text("(\(self.newDish.ingredientiPrincipali.count))")
                    .fontWeight(.light)
                    .padding(.horizontal) */
                
                Image(systemName:"circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.mint)
                
            }._tightPadding()
            
            HStack {
                
                Text("Ingredienti Secondari")
                    .fontWeight(listaDaMostrare == .ingredientiSecondari ? .bold : .light)
                    .lineLimit(1)
                
                Spacer()
                
                CSButton_image(
                    activationBool: listaDaMostrare == .ingredientiSecondari,
                    frontImage: "eye.fill",
                    backImage: "eye.slash.fill",
                    imageScale: .medium,
                    backColor: Color.blue,
                    frontColor: Color.gray) {
                        withAnimation {
                            listaDaMostrare = .ingredientiSecondari
                        }
                    }
     
             /*   Text("(\(self.newDish.ingredientiSecondari.count))")
                    .fontWeight(.light)
                    .padding(.horizontal) */
                
                Image(systemName:"circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.orange)
                
            }._tightPadding()
            
        }
        
    }
} */

/*
struct SwitchListeIngredientiPiatto_Previews: PreviewProvider {
    static var previews: some View {
        SwitchListeIngredientiPiatto(newDish: DishModel(), listaDaMostrare: ElencoListeIngredienti.allFromCommunity)
    }
}
*/
