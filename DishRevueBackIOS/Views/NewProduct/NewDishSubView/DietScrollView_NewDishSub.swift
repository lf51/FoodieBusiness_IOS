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

    let sottostante:IngredientModel?
    let dietAvaible:[TipoDieta]
    let dietAvaibleString:[String]
    
    init(newDish:Binding<ProductModel>,sottostante:IngredientModel? = nil,viewModel:AccounterVM) {
       
        _newDish = newDish
        self.viewModel = viewModel
        self.sottostante = sottostante
     
        if let sottostante {
            
            (self.dietAvaible,self.dietAvaibleString) =  newDish.wrappedValue.returnDietAvaible(viewModel: viewModel, byPassShowCompatibility: true,throwSottostante: sottostante)
        } else {
            
            (self.dietAvaible,self.dietAvaibleString) =  newDish.wrappedValue.returnDietAvaible(viewModel: viewModel, byPassShowCompatibility: true)
        }

    }
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: .vStackLabelBodySpacing) {
            let isStandardDish = dietAvaible.isEmpty
            
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
            
            DietScrollCasesCmpatibility(
                currentDish: self.newDish,
                instanceCases: self.dietAvaible) {
                
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
        
        let isStandardDish = dietAvaible.isEmpty
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
                    Text("Mostra il piatto senza alcuna compatibilità !!")
                          .underline()
                          .fontWeight(.semibold)
                          .font(.caption)
                          .foregroundStyle(Color.black)
                         
                }
                
            }
            
         }
    }
}
