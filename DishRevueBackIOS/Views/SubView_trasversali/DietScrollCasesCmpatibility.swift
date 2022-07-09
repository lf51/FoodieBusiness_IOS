//
//  EnumScrollCases.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/06/22.
//

import SwiftUI

/// Versione specifica della PropertyScrollCases per la DishTipologia.
struct DietScrollCasesCmpatibility: View {

    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDish: DishModel
    let allCases: [DishTipologia]
    let instanceCases:[DishTipologia]
    let colorSelection: Color
  
    init(currentDish: DishModel, allCases: [DishTipologia] = DishTipologia.allCases, colorSelection: Color = Color.clear) {
        
        self.currentDish = currentDish
        self.allCases = allCases
        self.colorSelection = colorSelection
        self.instanceCases = DishTipologia.checkDietAvaible(ingredients: currentDish.ingredientiPrincipali,currentDish.ingredientiSecondari)
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(allCases) { type in
                        
                        let isSelected = self.checkSelectionOrContainer(type: type)
                        
                        CSText_tightRectangle(testo: type.simpleDescription(), fontWeight: isSelected ? .bold : .regular, textColor: Color.white, strokeColor: Color.gray, fillColor: colorSelection)
                            .opacity(isSelected ? 1.0 : 0.6)
                            .onTapGesture {
                                self.viewModel.alertItem = AlertModel(
                                    title: type.simpleDescription(),
                                    message: type.extendedDescription() ?? "")
                            }
                           
                    }
                }
            }

            showDescription()
            
        }
    }
    
    private func checkSelectionOrContainer(type: DishTipologia) -> Bool {

        return self.instanceCases.contains(type)
        
    }
     
     private func showDescription() -> some View {
        
        var dietName:[String] = []
        
         for diet in self.instanceCases {
            
            dietName.append(diet.simpleDescription())
            
        }
        
         return Text("Diete compatibili: \(dietName, format: .list(type: .and)).")
             .fontWeight(.light)
             .font(.caption)
             .foregroundColor(.black)
        
        
    }

    
    
    
}

/* struct EnumScrollCases_Previews: PreviewProvider {
    static var previews: some View {
        EnumScrollCases(newDish: .constant(DishModel()))
    }
} */
