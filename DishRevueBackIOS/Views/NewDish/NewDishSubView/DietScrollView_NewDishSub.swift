//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct DietScrollView_NewDishSub: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var newDish: DishModel
    
    let dietAvaible:[DishTipologia]
    let dietAvaibleString:[String]
    
    @State private var confermaDiete: Bool = false
    
    init(newDish:Binding<DishModel>) {
       
        _newDish = newDish
     
        (self.dietAvaible,self.dietAvaibleString) = DishTipologia.returnDietAvaible(ingredients: newDish.wrappedValue.ingredientiPrincipali,newDish.wrappedValue.ingredientiSecondari)
 
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_conVB(placeHolder: "Dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) {
                
                Toggle(isOn: $confermaDiete) {
                    
                    HStack {
                        Spacer()
                        
                        Text(confermaDiete ? "Confermato" : "Non Confermato")
                            .font(.system(.callout, design: .monospaced))
                     /*   Image(systemName: confermaDiete ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(confermaDiete ? Color.green : Color.gray)
                            .imageScale(.medium) */
                    }
                    
                }
            }
            
            DietScrollCasesCmpatibility(currentDish: self.newDish, instanceCases: self.dietAvaible) {
                
                VStack(alignment:.leading) {

                    let string = self.confermaDiete ? "Diete Confermate" : "Diete compatibili"
                        
                    Text("\(string): \(dietAvaibleString, format: .list(type: .and)).")
                               .bold(self.confermaDiete)
                               .font(.caption)
                               .foregroundColor(self.confermaDiete ? .green : .black)
                    
                    if !self.confermaDiete {
  
                        let diet = self.newDish.dieteCompatibili[0].simpleDescription()
                        
                        Text("Confermata dieta \(diet)")
                              .underline()
                              .fontWeight(.semibold)
                              .font(.caption)
                              .foregroundColor(Color.black)
                    }
                }
            }

        }
        .onChange(of: self.dietAvaible, perform: { _ in
            self.confermaDiete = false
        })
        
        .onChange(of: self.confermaDiete) { newValue in
            if newValue {
 
                viewModel.alertItem = AlertModel(
                    title: "Conferma Diete",
                    message: "Si conferma la compatibilità del Piatto con le diete: \(dietAvaibleString.formatted(.list(type: .and)))."
                        )
                self.newDish.dieteCompatibili = self.dietAvaible
                 }
            else {
                
                self.newDish.dieteCompatibili = [.standard]
            }

        }
    }
}
