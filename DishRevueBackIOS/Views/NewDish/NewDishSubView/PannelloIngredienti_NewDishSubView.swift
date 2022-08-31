//
//  InfoGenerali_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct PannelloIngredienti_NewDishSubView: View {
    
    // Add 25.08
    @EnvironmentObject var viewModel: AccounterVM
    //
    
    let newDish: DishModel
    let generalErrorCheck: Bool
    @Binding var wannaAddIngredient: Bool

    var body: some View {
        
        VStack(alignment: .leading) {

            VStack(alignment:.leading) {

                CSLabel_conVB(placeHolder: "Ingredienti Principali", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) {
              
               //     Spacer()
                    
                    HStack {
                        

                     //   Spacer()
                      /*  CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.ingredientiPrincipali.isEmpty) */
  
                    /*   NavigationLink(value: DestinationPathView.ingrediente(IngredientModel())) {
                            Image(systemName: "plus.circle")
                                .imageScale(.large)
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                        } */
  
                    //  Spacer()
                        
                        CSButton_image(
                            frontImage: "plus.circle",
                            imageScale: .large,
                            frontColor: Color("SeaTurtlePalette_3")) {
                                withAnimation(.default) {
                                    self.wannaAddIngredient.toggle()
                                }
                            }
                        
                        CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.ingredientiPrincipali.isEmpty)
                      /*  Button {
                            withAnimation(.default) {
                                self.wannaAddIngredient?.toggle()
                            }
                        } label: {
                            Text("Edit")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }
                        .buttonStyle(.borderedProminent) */
                                                
                    }
      
                }
                
             /*   if !self.newDish.ingredientiPrincipali.isEmpty {
                    
                    SimpleModelScrollGeneric_SubView(modelToShow: self.newDish.ingredientiPrincipali, fillColor: Color.mint)
                } */ // deprecata 17.08
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack {
                        
                        ForEach(self.newDish.ingredientiPrincipali, id:\.self) { idIngredient in
                            
                            if let ingredient = viewModel.ingredientFromId(id: idIngredient) {
                                IngredientModel_RowView(item: ingredient)
                            }
                        
                        }
                        
                    }
                }
                
            }
            
            VStack(alignment:.leading) {
                
                CSLabel_conVB(placeHolder: "Ingredienti Secondari", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) { CSInfoAlertView(
                    imageScale: .large,
                    title: "Info",
                    message: .ingredienteSecondario) }
                
               /* CSLabel_1Button(placeHolder: "Ingredienti Secondari", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) */
                
            //    if self.newDish.ingredientiSecondari.isEmpty {
                    
                /*    Text("I secondari sono ingredienti usati anche in piccole quantità nella preparazione del piatto.")
                        .italic()
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundColor(Color.black) */

             //   } else {
                    
                  /*  SimpleModelScrollGeneric_SubView(modelToShow: self.newDish.ingredientiSecondari, fillColor: Color.yellow) */
                    // deprecata 17.08
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(self.newDish.ingredientiSecondari, id:\.self) { idIngredient in
                                
                                if let ingredient = self.viewModel.ingredientFromId(id: idIngredient) {
                                    IngredientModel_RowView(item: ingredient)
                                }
                                
                                
                            }
                            
                        }
                    }
               // }
      
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


