//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct DietScrollView_NewDishSub: View {
    
    static var mostraAlertDiete:Bool = true
    
    @ObservedObject var viewModel:AccounterVM
    @Binding var newDish: ProductModel

    let dietAvaible:[TipoDieta]
    let dietAvaibleString:[String]
    
    init(newDish:Binding<ProductModel>,viewModel:AccounterVM) {
       
        _newDish = newDish
        self.viewModel = viewModel
     
        (self.dietAvaible,self.dietAvaibleString) =  newDish.wrappedValue.returnDietAvaible(viewModel: viewModel, byPassShowCompatibility: true)
        
       
    }
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: .vStackLabelBodySpacing) {
            let isStandardDish = dietAvaible.contains(.standard)
            
            CSLabel_conVB(placeHolder: "Diete Compatibili", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) {

                HStack {
                    
                    let showDiet = self.newDish.mostraDieteCompatibili
                    
                    CSInfoAlertView(
                        imageScale: .large,
                        title: "Info Diete",
                        message: .dieteCompatibili)
                    
                    Toggle(isOn: self.$newDish.mostraDieteCompatibili) {
                        
                        HStack{
                            Spacer()
   
                            Text("No")
                                .bold(!showDiet)
                                .foregroundStyle(Color.black)
                                .opacity(showDiet ? 0.4 : 1.0)

                        }
                        
                    }.disabled(isStandardDish)
                    
                    Text("Si")
                         .bold(showDiet)
                         .foregroundStyle(Color.black)
                         .opacity(!showDiet ? 0.4 : 1.0)
                    
                }
            }
            
            DietScrollCasesCmpatibility(currentDish: self.newDish, instanceCases: self.dietAvaible) {
                
               /* VStack(alignment:.leading) {

                    let string = self.newDish.mostraDieteCompatibili ? "Mostra nel piatto le diete compatibili" : "Non mostrare nel piatto le diete compatibili"
                        
                    Text("\(string): \(dietAvaibleString, format: .list(type: .and)).")
                               .bold(self.newDish.mostraDieteCompatibili)
                               .font(.caption)
                               .foregroundStyle(self.newDish.mostraDieteCompatibili ? .green : .black)
                    
                    if !self.newDish.mostraDieteCompatibili {

                        Text("Il piatto viene mostrato compatibile con una dieta Standard !!")
                              .underline()
                              .fontWeight(.semibold)
                              .font(.caption)
                              .foregroundStyle(Color.black)
  
                    }
                } */ // deprecata 25.06
                
             vbLogicText()
            }

        }
       /* .onChange(of: self.dietAvaible, perform: { _ in
            self.newDish.mostraDieteCompatibili = false
        })*/
        .onChange(of: self.newDish.mostraDieteCompatibili) { _ , newValue in

            if !newValue && Self.mostraAlertDiete {
 
                viewModel.alertItem = AlertModel(
                    title: "Nascondi Diete Compatibili",
                    message: "Non sarà visibile nel piatto la compatibilitò con le diete: \(dietAvaibleString.formatted(.list(type: .and))).",
                    actionPlus: ActionModel(title: .nonMostrare, action: {
                        Self.mostraAlertDiete = false
                    })
                        )

                 }
        }
    }
    
    // Method
    
    @ViewBuilder private func vbLogicText() -> some View {
        
        let isStandardDish = dietAvaible.contains(.standard)
        let showDiet = self.newDish.mostraDieteCompatibili
    
        let standardString = "Il piatto è compatibile soltanto ad una dieta Standard !"
    
        VStack(alignment:.leading) {

            if isStandardDish {
                
                Text(standardString)
                    .underline()
                    .fontWeight(.semibold)
                    .font(.caption)
                    .foregroundStyle(Color.black)
                
            } else {
                
                let string = showDiet ? "Mostra nel piatto le diete compatibili" : "Non mostrare nel piatto le diete compatibili"
                
                Text("\(string): \(dietAvaibleString, format: .list(type: .and)).")
                           .bold(showDiet)
                           .font(.caption)
                           .foregroundStyle(showDiet ? .green : .black)
                
                if !showDiet {
                    Text("Mostra il piatto come compatibile soltanto ad una dieta Standard !!")
                          .underline()
                          .fontWeight(.semibold)
                          .font(.caption)
                          .foregroundStyle(Color.black)
                         
                }
                
            }
            
         }
    }
}
