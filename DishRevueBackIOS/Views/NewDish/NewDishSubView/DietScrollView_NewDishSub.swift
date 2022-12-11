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
    // usiamo un observed per usare il viewModel nell'init
    @Binding var newDish: DishModel
  //  @Binding var confermaDiete: Bool
    
    let dietAvaible:[TipoDieta]
    let dietAvaibleString:[String]
    
    init(newDish:Binding<DishModel>,viewModel:AccounterVM) {
       
        _newDish = newDish
      //  _confermaDiete = confermaDiete
        self.viewModel = viewModel
     
        (self.dietAvaible,self.dietAvaibleString) = newDish.wrappedValue.returnDietAvaible(viewModel: viewModel)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_conVB(placeHolder: "Dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) {
                
                HStack {
                    
                    CSInfoAlertView(
                        imageScale: .large,
                        title: "Info Diete",
                        message: .dieteCompatibili)
                    
                    Toggle(isOn: self.$newDish.mostraDieteCompatibili) {
                        
                        HStack {
                            Spacer()
                            
                            Text(self.newDish.mostraDieteCompatibili ? "Visibile" : "Nascosto")
                                .font(.system(.callout, design: .monospaced))
                         /*   Image(systemName: confermaDiete ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(confermaDiete ? Color.green : Color.gray)
                                .imageScale(.medium) */
                        }
                        
                    }
                }
            }
            
            DietScrollCasesCmpatibility(currentDish: self.newDish, instanceCases: self.dietAvaible) {
                
                VStack(alignment:.leading) {

                    let string = self.newDish.mostraDieteCompatibili ? "Mostra nel piatto le diete compatibili" : "Non mostrare nel piatto le diete compatibili"
                        
                    Text("\(string): \(dietAvaibleString, format: .list(type: .and)).")
                               .bold(self.newDish.mostraDieteCompatibili)
                               .font(.caption)
                               .foregroundColor(self.newDish.mostraDieteCompatibili ? .green : .black)
                    
                    if !self.newDish.mostraDieteCompatibili {
  
                        // mod. 11.09
                     //   let diet = self.newDish.dieteCompatibili[0].simpleDescription()
                        
                        Text("Mostra nel piatto la compatibilità con una dieta Standard !!")
                              .underline()
                              .fontWeight(.semibold)
                              .font(.caption)
                              .foregroundColor(Color.black)
                        
                        // end 11.09
                    }
                }
            }

        }
        .onChange(of: self.dietAvaible, perform: { _ in
            self.newDish.mostraDieteCompatibili = false
        })
        .onChange(of: self.newDish.mostraDieteCompatibili) { newValue in
            
          // self.newDish.mostraDieteCompatibili = newValue
            
            if newValue && Self.mostraAlertDiete {
 
              /*  viewModel.alertItem = AlertModel(
                    title: "Mostra Diete",
                    message: "Sarà mostrata nel piatto la compatibilità con le diete: \(dietAvaibleString.formatted(.list(type: .and)))."
                        ) */
                
                viewModel.alertItem = AlertModel(
                    title: "Diete Compatibili",
                    message: "Visibile nel piatto la compatibilitò con le diete: \(dietAvaibleString.formatted(.list(type: .and))).",
                    actionPlus: ActionModel(title: .nonMostrare, action: {
                        Self.mostraAlertDiete = false
                    })
                        )
               // self.newDish.dieteCompatibili = self.dietAvaible
               
                 }
        }
    }
}


/*
struct DietScrollView_NewDishSub: View {
    
    // Modifica 26.08
   // @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var viewModel:AccounterVM
    // usiamo anche qui observedObject per utilizzarlo nell'init
    // End 26.08
    
    @Binding var newDish: DishModel
    @Binding var confermaDiete: Bool
    
    let dietAvaible:[TipoDieta]
    let dietAvaibleString:[String]
    
    init(newDish:Binding<DishModel>,confermaDiete:Binding<Bool>,viewModel:AccounterVM) {
       
        _newDish = newDish
        _confermaDiete = confermaDiete
        self.viewModel = viewModel
     
        (self.dietAvaible,self.dietAvaibleString) = newDish.wrappedValue.returnDietAvaible(viewModel: viewModel)
        
       /* (self.dietAvaible,self.dietAvaibleString) = TipoDieta.returnDietAvaible(ingredients: newDish.wrappedValue.ingredientiPrincipaliDEPRECATO,newDish.wrappedValue.ingredientiSecondariDEPRECATO) */
 
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
} */ // Backup 11.09 per deprecazione array DieteCompatibili
