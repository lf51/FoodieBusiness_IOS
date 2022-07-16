//
//  InfoGenerali_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct PannelloIngredienti_NewDishSubView: View {
    
    let newDish: DishModel
    let generalErrorCheck: Bool
    @Binding var wannaAddIngredient: Bool?

    var body: some View {
        
        VStack(alignment: .leading) {

            VStack {

                CSLabel_conVB(placeHolder: "Ingredienti Principali", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) {
              
                    HStack {
                        
                        CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.ingredientiPrincipali.isEmpty)
                        
                        Spacer()
                        
                        NavigationLink(value: DestinationPathView.ingrediente(IngredientModel())) {
                            Image(systemName: "plus.circle")
                                .imageScale(.large)
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                        }
  
                    //   Spacer()
                        
                        Button {
                            withAnimation(.default) {
                                self.wannaAddIngredient?.toggle()
                            }
                        } label: {
                            Text("Edit")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }
                        .buttonStyle(.borderedProminent)
                                                
                    }
      
                }
                
                if !self.newDish.ingredientiPrincipali.isEmpty {
                    
                    IngredientHScroll_View(inhredientsToShow: self.newDish.ingredientiPrincipali, baseColor: Color.mint)
                }
            }
            
            VStack(alignment:.leading) {
                
                CSLabel_1Button(placeHolder: "Ingredienti Secondari", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black)
                
                if self.newDish.ingredientiSecondari.isEmpty {
                    
                    Text("Ingredienti usati anche in piccole quantità nella preparazione del piatto.")
                        .italic()
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundColor(Color.black)

                } else {
                    
                    IngredientHScroll_View(inhredientsToShow: self.newDish.ingredientiSecondari, baseColor: Color.yellow)
                }
      
            }
        }
    }
    
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/
