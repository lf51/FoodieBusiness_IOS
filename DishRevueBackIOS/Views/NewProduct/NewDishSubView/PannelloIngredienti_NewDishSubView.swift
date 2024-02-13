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
    let newDish: ProductModel
    let generalErrorCheck: Bool
    @Binding var wannaAddIngredient: Bool
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
                        
                        let condition:Bool = {
                            
                            newDish.ingredientiPrincipali == nil || newDish.ingredientiPrincipali!.isEmpty
                        }()
                        CS_ErrorMarkView(
                            generalErrorCheck: generalErrorCheck,
                            localErrorCondition: condition)

                                                
                    }
      
                }
 
                if let ingredients = self.newDish.ingredientiPrincipali {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        
                        HStack {
                            
                            ForEach(ingredients, id:\.self) { idIngredient in
                                
                             vbIngredientSmallRow(id: idIngredient)
                            
                            }
                            
                        }
                    }
                    
                }
                
                if generalErrorCheck {
   
                            Text("Il box degli ingredienti principali non può essere vuoto.\nPer inserire un prodotto senza ingredienti scegliere Composizione")
                                .italic()
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.leading)
                            
                }
                
            }
            
            VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
                
                CSLabel_conVB(placeHolder: "Ingredienti Secondari", imageNameOrEmojy: "curlybraces", backgroundColor: Color.black) { CSInfoAlertView(
                    imageScale: .large,
                    title: "Info",
                    message: .ingredienteSecondario) }

                if let ingredientsSec = self.newDish.ingredientiSecondari {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(ingredientsSec, id:\.self) { idIngredient in
                                
                                vbIngredientSmallRow(id: idIngredient)
                                
                                
                            }
                            
                        }
                    }
                }
               
      
            }
        }
    }
    
    // Method
    
    @ViewBuilder private func vbIngredientSmallRow(id:String) -> some View {

        let (model,sostituto) = checkPreliminareIngredientSmallRow(id: id)
        
        if let model {
            IngredientModel_SmallRowView(titolare: model, sostituto: sostituto)
        }
  
    }
    
    private func checkPreliminareIngredientSmallRow(id:String) -> (model:IngredientModel?,sostituto:IngredientModel?) {

        guard let ingredient = self.viewModel.modelFromId(id: id, modelPath: \.db.allMyIngredients) else { return (nil,nil)}
        
        guard ingredient.statusTransition == .inPausa,
        let offManager = newDish.offManager,
        let idSostituto = offManager.fetchSubstitute(for: id) else {
            return (ingredient,nil)
        }
        
       /* guard let offManager = newDish.offManager else {
            return (ingredient,nil)
        }*/
        
       /* guard let idSostituto = offManager.fetchSubstitute(for: id) else {
            return (ingredient,nil)
        }*/
                
       // guard idSostituto != nil else { return (ingredient,nil)}

       /* guard let modelSostituto = self.viewModel.ingredientFromId(id: idSostituto!) else {
            return (ingredient,nil)
                } */
        guard let modelSostituto = self.viewModel.modelFromId(id: idSostituto, modelPath: \.db.allMyIngredients),
              modelSostituto.statusTransition == .disponibile else { return (ingredient,nil) }
        
       /* guard modelSostituto.statusTransition == .disponibile else { return (ingredient,nil)}*/
                
        return (ingredient,modelSostituto)
        
    }
    
}



/*struct InfoGenerali_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGenerali_NewDishSubView()
    }
}
*/


