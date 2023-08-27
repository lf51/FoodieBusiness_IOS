//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct AllergeniScrollView_NewIngredientSubView: View {
    
    static var showAlertAllergene:Bool = true
    
    @EnvironmentObject var viewModel:AccounterVM
    @Binding var nuovoIngrediente: IngredientModel
    let generalErrorCheck: Bool
    
    @Binding var areAllergeniOk: Bool
    @Binding var wannaAddAllergene: Bool

    var body: some View {
        
        VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
            
            CSLabel_conVB(placeHolder: "Allergeni", imageNameOrEmojy: "exclamationmark.shield", backgroundColor: Color.black) {
                
                HStack {
          
                    CSButton_image(
                        frontImage: "plus.circle",
                        imageScale: .large,
                        frontColor: Color.seaTurtle_3) {
                            withAnimation(.default) {
                                self.wannaAddAllergene.toggle()
                            }
                        }
                    
                    Toggle(isOn: self.$areAllergeniOk) {
                        
                        HStack {
                            Spacer()
                         /*   Text(/*self.areAllergeniOk ? "Confermato" :*/ "Confermare:")
                                .font(.system(.callout, design: .monospaced)) */
                         //   Spacer()
                            Text("No")
                                .bold(!self.areAllergeniOk)
                                .foregroundStyle(Color.black)
                                .opacity(self.areAllergeniOk ? 0.4 : 1.0)
                            
                            CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.areAllergeniOk)

                        }
                    }
                    
                   Text("Si")
                        .bold(self.areAllergeniOk)
                        .foregroundStyle(Color.black)
                        .opacity(!self.areAllergeniOk ? 0.4 : 1.0)

                }

            }
            // Innesto 06.10
            
          /*  if self.nuovoIngrediente.allergeni.isEmpty {
                Text("Non contiene Allergeni")
                    .font(.caption)
                    .fontWeight(.light)
                    .italic()
                    .foregroundStyle(Color.black)
            }
            else {SimpleModelScrollGeneric_SubView(modelToShow: self.nuovoIngrediente.allergeni, fontWeight: .semibold, strokeColor: Color.red)} */
            
            VStack(alignment:.leading) {

                let allergens = self.nuovoIngrediente.allergeni ?? []
                
                SimpleModelScrollGeneric_SubView(
                    modelToShow: allergens /*self.nuovoIngrediente.allergeni*/,
                    fontWeight: .semibold,
                    strokeColor: Color.red)
                
                HStack(spacing:0) {
                    
                    let string_1 = self.areAllergeniOk ? "Confermata" : "Non Confermata"
                   // let string_2 = self.nuovoIngrediente.allergeni.isEmpty ? "l'assenza" : "la presenza"
                    let string_2 = allergens.isEmpty ? "l'assenza" : "la presenza"
                    
                    Text("\(string_1) \(string_2) ")
                        .bold(self.areAllergeniOk)
                        .underline(self.areAllergeniOk, color: Color.black)
                            
                         Text("di Allergeni negli Ingredienti.")
                   }
                    .italic()
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundStyle(Color.black)

            }
            
            
        }.onChange(of: self.nuovoIngrediente.allergeni) {
            self.areAllergeniOk = false 
        }
        .onChange(of: self.areAllergeniOk, { _, newValue in
            if newValue && Self.showAlertAllergene {
  
                viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: SystemMessage.allergeni.simpleDescription(),
                    actionPlus: ActionModel(title: .nonMostrare, action: {
                        Self.showAlertAllergene = false
                    }))
            }
        })
        /*.onChange(of: self.areAllergeniOk, perform: { newValue in
            
            if newValue && Self.showAlertAllergene {
  
                viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: SystemMessage.allergeni.simpleDescription(),
                    actionPlus: ActionModel(title: .nonMostrare, action: {
                        Self.showAlertAllergene = false
                    }))
            }
        })*/

    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
