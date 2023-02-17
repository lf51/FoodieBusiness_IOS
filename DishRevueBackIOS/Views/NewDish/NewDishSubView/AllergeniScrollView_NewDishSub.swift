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
   // @ObservedObject var viewModel:AccounterVM
    // usiamo la observedObject perchè ci permette di passare il valore e inizializzare l'array degli allergeni nell'Init
    // End 26.08
    
    @Binding var newDish: DishModel
    let generalErrorCheck: Bool
    
 //   let allergeniInDEPRECATA:[AllergeniIngrediente]
    @Binding var areAllergeniOk: Bool
    
  /*  init(newDish:Binding<DishModel>, generalErrorCheck:Bool, areAllergeniOk:Binding<Bool>,viewModel:AccounterVM) {
       
        _newDish = newDish
        self.generalErrorCheck = generalErrorCheck
        _areAllergeniOk = areAllergeniOk
        self.viewModel = viewModel
   
    //    self.allergeniInDEPRECATA = newDish.wrappedValue.calcolaAllergeniNelPiatto(viewModel: viewModel)
    } */

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(
                placeHolder: "Allergeni",
                imageNameOrEmojy: "exclamationmark.shield",
                backgroundColor: Color.black) {
                    
                    HStack {
                        Toggle(isOn: self.$areAllergeniOk) {
                            
                            HStack {
                              /*  Spacer()
                                Text(self.areAllergeniOk ? "Confermato" : "Confermare")
                                    .font(.system(.callout, design: .monospaced)) */
                                
                                Spacer()
                                
                               // Text("Confermare:")
                                 //   .font(.system(.callout, design: .monospaced))
                                    
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
            
          /*  let allergeniIn = self.newDish.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
            
            SimpleModelScrollGeneric_SubView(
                modelToShow: allergeniIn,
                fontWeight: .light,
                strokeColor: Color.red) */
          /*  ScrollView(.horizontal, showsIndicators: false) {

                    HStack {
                        
                        ForEach(self.allergeniIn) { allergene in
                            
                            CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                            
                        }
                    }
            } */ // Deprecata 17.08
            
            VStack(alignment:.leading) {

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
             /*   let link = Link("Regolamento UE n.1169/2011", destination: URL(string: "https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:304:0018:0063:it:PDF")!) */
              
             /*   viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: SystemMessage.allergeni.simpleDescription()
                ) */
                
                viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: SystemMessage.allergeni.simpleDescription(),
                    actionPlus: ActionModel(title: .nonMostrare, action: {
                        Self.showAlertAllergene = false
                    }))
              //  self.newDish.allergeni = self.allergeniIn
                
            } /* else {
                
                self.newDish.allergeni = []
            } */
            
        })
        
    }
    
}
