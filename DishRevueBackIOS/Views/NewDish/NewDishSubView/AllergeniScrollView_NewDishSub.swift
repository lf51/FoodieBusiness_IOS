//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct AllergeniScrollView_NewDishSub: View {
    
    static var showAlertAllergene:Bool = true
    // Modifica 26.08
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var newDish: DishModel
    let generalErrorCheck: Bool

    @Binding var areAllergeniOk: Bool

    var body: some View {
        
        VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
            
            CSLabel_conVB(
                placeHolder: "Allergeni",
                imageNameOrEmojy: "exclamationmark.shield",
                backgroundColor: Color.black) {
                    
                    HStack {
                        Toggle(isOn: self.$areAllergeniOk) {
                            
                            HStack {

                                Spacer()

                                Text("No")
                                    .bold(!self.areAllergeniOk)
                                    .foregroundColor(.black)
                                    .opacity(self.areAllergeniOk ? 0.4 : 1.0)
                                
                                CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.areAllergeniOk)
       
                            }
                        }
                        Text("Si")
                             .bold(self.areAllergeniOk)
                             .foregroundColor(.black)
                             .opacity(!self.areAllergeniOk ? 0.4 : 1.0)
                    }
                }
            
            VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {

                let allergeniIn = self.newDish.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
                
                SimpleModelScrollGeneric_SubView(
                    modelToShow: allergeniIn,
                    fontWeight: .light,
                    strokeColor: Color.red)
                
                HStack(spacing:0) {
                    
                    let string_1 = self.areAllergeniOk ? "Confermata" : "Non Confermata"
                    let string_2 = allergeniIn.isEmpty ? "l'assenza" : "la presenza"
                    
                    Text("\(string_1) \(string_2) ")
                        .bold(self.areAllergeniOk)
                        .underline(self.areAllergeniOk, color: Color.black)
                            
                         Text("di Allergeni negli Ingredienti.")
                   }
                    .italic()
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundColor(Color.black)

            }
      
        }
        .onChange(of: self.newDish.ingredientiPrincipali, perform: { _ in
            self.areAllergeniOk = false
        })
        .onChange(of: self.newDish.ingredientiSecondari, perform: { _ in
            self.areAllergeniOk = false
        })
        .onChange(of: self.areAllergeniOk, perform: { newValue in
            
            if newValue && Self.showAlertAllergene {

                viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: SystemMessage.allergeni.simpleDescription(),
                    actionPlus: ActionModel(title: .nonMostrare, action: {
                        Self.showAlertAllergene = false
                    }))
            }
        })
        
    }
    
}
