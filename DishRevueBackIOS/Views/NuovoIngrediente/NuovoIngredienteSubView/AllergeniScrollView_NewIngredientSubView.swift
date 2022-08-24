//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct AllergeniScrollView_NewIngredientSubView: View {
    
    @Binding var nuovoIngrediente: IngredientModel
    let generalErrorCheck: Bool
    
    @Binding var areAllergeniOk: Bool
    @Binding var wannaAddAllergene: Bool

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(placeHolder: "Allergeni", imageNameOrEmojy: "exclamationmark.shield", backgroundColor: Color.black) {
                
                HStack {
          
                    CSButton_image(
                        frontImage: "plus.circle",
                        imageScale: .large,
                        frontColor: Color("SeaTurtlePalette_3")) {
                            withAnimation(.default) {
                                self.wannaAddAllergene.toggle()
                            }
                        }
                    
                    Toggle(isOn: self.$areAllergeniOk) {
                        
                        HStack {
                            Spacer()
                            Text(self.areAllergeniOk ? "Confermato" : "Da Confermare")
                                .font(.system(.callout, design: .monospaced))
                            
                            CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.areAllergeniOk)

                        }
                    }

                }

            }
                    
            if self.nuovoIngrediente.allergeni.isEmpty {
                Text("Non contiene Allergeni")
                    .font(.caption)
                    .fontWeight(.light)
                    .italic()
                    .foregroundColor(Color.black)
            }
            else {SimpleModelScrollGeneric_SubView(modelToShow: self.nuovoIngrediente.allergeni, fontWeight: .semibold, strokeColor: Color.red)}
            
            
        }.onChange(of: self.nuovoIngrediente.allergeni) { _ in
            self.areAllergeniOk = false 
        }

    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
