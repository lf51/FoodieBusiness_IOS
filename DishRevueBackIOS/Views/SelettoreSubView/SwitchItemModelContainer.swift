//
//  SwitchListeIngredientiPiatto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct SwitchItemModelContainer: View {
    
   // @Binding var newDish: M1
   // @Binding var listaDaMostrare: ModelList
    let itemModelList: [ModelList]
    @Binding var listaDaMostrare: String
   
    var body: some View {
        
        VStack(alignment: .leading) {
                        
            vbShowContainersRow()
       
        }
        
    }
    
    // Method
    
    @ViewBuilder func vbShowContainersRow() -> some View {
        
        ForEach(itemModelList, id:\.self) { list in
            
            ContainerRowLabel(itemModelList: list, listaDaMostrare: $listaDaMostrare)
            
        }
    }
    
    
}


///Label di un Container composta da TextLabel + Count  Elementi Container + Button per vedere contenuto + ColorLabel
struct ContainerRowLabel: View {
    
    let itemModelList: ModelList
    @Binding var listaDaMostrare: String
    
    var body: some View {
        
        HStack{
            
            Text(itemModelList.returnAssociatedValue().0)
                .fontWeight(listaDaMostrare == itemModelList.returnAssociatedValue().0 ? .bold : .light)
                .lineLimit(1)
            
            Spacer()
            
            CSButton_image(
                activationBool: listaDaMostrare == itemModelList.returnAssociatedValue().0,
                frontImage: "eye.fill",
                backImage: "eye.slash.fill",
                imageScale: .medium,
                backColor: Color.blue,
                frontColor: Color.gray) {
                    withAnimation {
                        listaDaMostrare = itemModelList.returnAssociatedValue().0
                    }
                }
                            
         /*   Text("(\(self.newDish.ingredientiPrincipali.count))")
                .fontWeight(.light)
                .padding(.horizontal) */
            
            Image(systemName:"circle.fill")
                .imageScale(.large)
                .foregroundColor(Color.red)
            
        }._tightPadding()
        
        
        
    }
    
    
    
}


/*
struct SwitchListeIngredientiPiatto_Previews: PreviewProvider {
    static var previews: some View {
        SwitchListeIngredientiPiatto(newDish: DishModel(), listaDaMostrare: ElencoListeIngredienti.allFromCommunity)
    }
}
*/
