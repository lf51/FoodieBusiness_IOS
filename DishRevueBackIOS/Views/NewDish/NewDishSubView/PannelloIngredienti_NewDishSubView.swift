//
//  InfoGenerali_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0
// Ultima pulizia codice 01.03.2022

struct PannelloIngredienti_NewDishSubView: View {
    
    // Add 25.08
    @EnvironmentObject var viewModel: AccounterVM
    //
    let newDish: DishModel
    let generalErrorCheck: Bool
    @Binding var wannaAddIngredient: Bool
  //  @Binding var noIngredientsNeeded: Bool

    var body: some View {
        
        VStack(alignment: .leading,spacing: .vStackBoxSpacing) {

            VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {

                CSLabel_conVB(placeHolder: "Ingredienti Principali", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) {

                    HStack {

                        CSButton_image(
                            frontImage: "plus.circle",
                            imageScale: .large,
                            frontColor: .seaTurtle_3) {
                                withAnimation(.default) {
                                    self.wannaAddIngredient.toggle()
                                  //  self.noIngredientsNeeded = false
                                }
                            }
                        
                       /* CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: (newDish.ingredientiPrincipali.isEmpty && !noIngredientsNeeded)) */
                        CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.ingredientiPrincipali.isEmpty)

                                                
                    }
      
                }
 
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack {
                        
                        ForEach(self.newDish.ingredientiPrincipali, id:\.self) { idIngredient in
                            
                         vbIngredientSmallRow(id: idIngredient)
                        
                        }
                        
                    }
                }
                
                if generalErrorCheck {
   
                            Text("Il box degli ingredienti principali non può essere vuoto.\nPer inserire un prodotto senza ingredienti scegliere Prodotto di Terzi")
                                .italic()
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.leading)
                            
                }
                
               /* if generalErrorCheck && self.newDish.ingredientiPrincipali.isEmpty {
                                            
                        if !self.newDish.ingredientiSecondari.isEmpty {
                            
                            Text("Il box degli ingredienti principali non può essere vuoto.")
                                .italic()
                                .font(.headline)
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.leading)
                            
                        } else {
                            
                            Toggle(isOn: $noIngredientsNeeded) {
                                Text("Forza il salvataggio senza ingredienti {ø}")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)
                                    .multilineTextAlignment(.leading)
                            }
                            
                        }
                } */
                
            }
            
            VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
                
                CSLabel_conVB(placeHolder: "Ingredienti Secondari", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) { CSInfoAlertView(
                    imageScale: .large,
                    title: "Info",
                    message: .ingredienteSecondario) }

                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(self.newDish.ingredientiSecondari, id:\.self) { idIngredient in
                                
                                vbIngredientSmallRow(id: idIngredient)
                                
                                
                            }
                            
                        }
                    }
               // }
      
            }
        }
    }
    
    // Method
    
    @ViewBuilder private func vbIngredientSmallRow(id:String) -> some View {

        let (model,sostituto) = checkPreliminareIngredientSmallRow(id: id)
        
        if model != nil {
            IngredientModel_SmallRowView(titolare: model!, sostituto: sostituto)
        }
  
    }
    
    private func checkPreliminareIngredientSmallRow(id:String) -> (model:IngredientModel?,sosituto:IngredientModel?) {

        guard let ingredient = self.viewModel.modelFromId(id: id, modelPath: \.currentProperty.db.allMyIngredients) else { return (nil,nil)}
      /*  guard let ingredient = self.viewModel.ingredientFromId(id: id) else {
            return (nil,nil)
        }*/
        
        guard ingredient.status.checkStatusTransition(check: .inPausa) else {
            return (ingredient,nil)
        }
        
        let idSostituto = self.newDish.elencoIngredientiOff[id]
                
        guard idSostituto != nil else { return (ingredient,nil)}

       /* guard let modelSostituto = self.viewModel.ingredientFromId(id: idSostituto!) else {
            return (ingredient,nil)
                } */
        guard let modelSostituto = self.viewModel.modelFromId(id: idSostituto!, modelPath: \.currentProperty.db.allMyIngredients) else { return (ingredient,nil) }
        
        guard modelSostituto.status.checkStatusTransition(check: .disponibile) else { return (ingredient,nil)}
                
        return (ingredient,modelSostituto)
        
    }
    
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/


