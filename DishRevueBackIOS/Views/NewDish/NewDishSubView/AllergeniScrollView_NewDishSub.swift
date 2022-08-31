//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct AllergeniScrollView_NewDishSub: View {
    // Modifica 26.08
   // @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var viewModel:AccounterVM
    // usiamo la observedObject perchè ci permette di passare il valore e inizializzare l'array degli allergeni nell'Init
    // End 26.08
    
    @Binding var newDish: DishModel
    let generalErrorCheck: Bool
    
    let allergeniIn:[AllergeniIngrediente]
    @Binding var areAllergeniOk: Bool
    
    init(newDish:Binding<DishModel>, generalErrorCheck:Bool, areAllergeniOk:Binding<Bool>,viewModel:AccounterVM) {
       
        _newDish = newDish
        self.generalErrorCheck = generalErrorCheck
        _areAllergeniOk = areAllergeniOk
        self.viewModel = viewModel
   
        self.allergeniIn = newDish.wrappedValue.calcolaAllergeniNelPiatto(viewModel: viewModel)
    }

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(
                placeHolder: "Allergeni",
                imageNameOrEmojy: "exclamationmark.shield",
                backgroundColor: Color.black) {
                    
                    Toggle(isOn: self.$areAllergeniOk) {
                        
                        HStack {
                            Spacer()
                            Text(self.areAllergeniOk ? "Confermato" : "Da Confermare")
                                .font(.system(.callout, design: .monospaced))
                            
                            CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.areAllergeniOk)
   
                        }
                    }
                }
            
            
            SimpleModelScrollGeneric_SubView(
                modelToShow: self.allergeniIn,
                fontWeight: .light,
                strokeColor: Color.red)
          /*  ScrollView(.horizontal, showsIndicators: false) {

                    HStack {
                        
                        ForEach(self.allergeniIn) { allergene in
                            
                            CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                            
                        }
                    }
            } */ // Deprecata 17.08
            
            VStack(alignment:.leading) {

                let string_1 = self.areAllergeniOk ? "Confermata" : "Non Confermata"
               
                let string_2 = self.allergeniIn.isEmpty ? "l'assenza" : "la presenza"
                    
                HStack(spacing:0) {
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
      /* .onChange(of: self.allergeniIn, perform: { _ in
            self.areAllergeniOk = false
        }) */
        .onChange(of: self.areAllergeniOk, perform: { newValue in
            
            if newValue {
             /*   let link = Link("Regolamento UE n.1169/2011", destination: URL(string: "https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:304:0018:0063:it:PDF")!) */
              
                viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: SystemMessage.allergeni.simpleDescription()
                )
                self.newDish.allergeni = self.allergeniIn
                
            } else {
                
                self.newDish.allergeni = []
            }
            
        })
        
    }
    
}
