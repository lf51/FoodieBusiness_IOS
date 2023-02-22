//
//  EnumScrollCases.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/06/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/// Versione specifica della PropertyScrollCases per la DishTipologia.
struct DietScrollCasesCmpatibility<Content:View>: View {

    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDish: DishModel
    let allCases: [TipoDieta]
    let instanceCases:[TipoDieta]
   // let instanceCasesString:[String]
    let colorSelection: Color
    @ViewBuilder var content: Content
  
    init(currentDish: DishModel, allCases: [TipoDieta] = TipoDieta.allCases,instanceCases:[TipoDieta], colorSelection: Color = Color.clear, dieteConfermate: () -> Content) {
        
        self.currentDish = currentDish
        self.allCases = allCases
        self.colorSelection = colorSelection
        self.instanceCases = instanceCases
        self.content = dieteConfermate()
      //  self.instanceCasesString = instanceCasesString
    }
    
    var body: some View {
        
        VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(allCases) { type in
                        
                        let isSelected = self.checkSelectionOrContainer(type: type)
                        
                        CSText_tightRectangle(testo: type.simpleDescription(), fontWeight: isSelected ? .bold : .regular, textColor: Color.white, strokeColor: Color.gray, fillColor: colorSelection)
                            .opacity(isSelected ? 1.0 : 0.6)
                            .onTapGesture {
                                self.viewModel.alertItem = AlertModel(
                                    title: type.simpleDescription(),
                                    message: type.extendedDescription())
                            }
                           
                    }
                }
            }

            content
        }
    }
    
    private func checkSelectionOrContainer(type: TipoDieta) -> Bool {

        return self.instanceCases.contains(type)
        
    }
     
    /* private func showDescription() -> some View {
        
        var dietName:[String] = []
        
         for diet in self.instanceCases {
            
            dietName.append(diet.simpleDescription())
            
        }
        
         return Text("Diete compatibili: \(dietName, format: .list(type: .and)).")
             .fontWeight(.light)
             .font(.caption)
             .foregroundColor(.black)
        
        
    }*/

    
    
    
}

/* struct EnumScrollCases_Previews: PreviewProvider {
    static var previews: some View {
        EnumScrollCases(newDish: .constant(DishModel()))
    }
} */
