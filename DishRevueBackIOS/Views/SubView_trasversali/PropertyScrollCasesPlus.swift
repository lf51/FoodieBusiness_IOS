//
//  EnumScrollCases.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/06/22.
//

import SwiftUI

struct PropertyScrollCasesPlus: View {

    @Binding var newDish: DishModel
  //  @Binding var bindingSelector: Bool
    private let colorSelection: Color = Color.yellow
    
    @State private var currentDiet: DishTipologia = DishTipologia.defaultValue
    @State private var localCollectionProperty: [DishAvaibleForDiet] = []
    @State private var showBarraSostituzioni: Bool = false
    
  /*  init(dishCollectionProperty: Binding<[DishAvaibleForDiet]>, colorSelection: Color) {
        
        self.enumCases = cases
        _newDishCollectionProperty = dishCollectionProperty
        self.colorSelection = colorSelection
      //  _bindingSelector = bindingSelector

    } */
  
    var body: some View {
        
        VStack(alignment:.leading) {
            
            if !showBarraSostituzioni {
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack {
                        
                        ForEach(DishTipologia.allCases) { diet in
                            
                            CSText_bigRectangle(testo: diet.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: self.checkSelectionOrContainer(type: diet) ? Color.clear : Color.blue, fillColor: self.checkSelectionOrContainer(type: diet) ? colorSelection : Color.clear)
                                .onTapGesture {
                                  //  self.addingValueTo(newValue: type)
                                    withAnimation {
                                        self.currentDiet = diet
                                        self.showBarraSostituzioni = true
                                    }
                                   
                                }
                        }
                    }
                }
            } else {
                
                VStack(alignment:.leading) {
                    
                    Text(currentDiet.simpleDescription())
            
                  //  creaElencoSostituzioni()
                    
                    
                    
                }
               
                
                
            }
            
           /* if let extendedDescription = newDishSingleProperty.extendedDescription() {
                
                Text(extendedDescription)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .italic()
                    .foregroundColor(Color.black)
            } */
       
        }
    }
    
    // Method
    
    
   /* private func creaElencoSostituzioni() -> some View {
        
        let ingredientiPiatto = self.newDish.ingredientiPrincipali + self.newDish.ingredientiSecondari
        
        var ingredientiDaSostituire: [IngredientModel] = []
        
        for ingredient in ingredientiPiatto {
            
            if ingredient.origine == .vegetale { }
            
            
            
        }
        
        
        
    } */
    
    
    func checkSelectionOrContainer(type: DishTipologia) -> Bool {

      //  self.newDishCollectionProperty.contains(type)
        self.localCollectionProperty.contains { $0.diet == type }
    }
     
  /*  func addingValueTo(newValue: T) {
            
            withAnimation(.default) {
              
                if !self.newDishCollectionProperty.contains(newValue) {
                    
                    self.newDishCollectionProperty.append(newValue)
                    
                } else {
                    
                    let indexValue = self.newDishCollectionProperty.firstIndex(of: newValue)
                    self.newDishCollectionProperty.remove(at: indexValue!)
                    
                }
                
                print("Lista of generic T-Type: \(self.newDishCollectionProperty.description)")
           
            }
        
      
    } */

    
    
    
}

/* struct EnumScrollCases_Previews: PreviewProvider {
    static var previews: some View {
        EnumScrollCases(newDish: .constant(DishModel()))
    }
} */
