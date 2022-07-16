//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct SelectionPropertyDish_NewDishSubView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var newDish: DishModel
    let generalErrorCheck: Bool
    
    let dietAvaible:[DishTipologia]
    let dietAvaibleString:[String]
    let allergeniIn:[AllergeniIngrediente]
    
    @State private var confermaDiete: Bool = false
    
    init(newDish:Binding<DishModel>, generalErrorCheck:Bool) {
       
        _newDish = newDish
        self.generalErrorCheck = generalErrorCheck
    
        (self.dietAvaible,self.dietAvaibleString) = DishTipologia.returnDietAvaible(ingredients: newDish.wrappedValue.ingredientiPrincipali,newDish.wrappedValue.ingredientiSecondari)
        self.allergeniIn = AllergeniIngrediente.returnAllergeniIn(ingredients: newDish.wrappedValue.ingredientiPrincipali,newDish.wrappedValue.ingredientiSecondari)
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            VStack(alignment:.leading) {
                
                CSLabel_conVB(
                    placeHolder: "Allergeni",
                    imageNameOrEmojy: "allergens",
                    backgroundColor: Color.black) {
                        
                        Toggle(isOn: self.$newDish.areAllergeniOk) {
                            
                            HStack {
                                Spacer()
                                Text(self.newDish.areAllergeniOk ? "Confermato" : "Da Confermare")
                                    .font(.system(.callout, design: .monospaced))
                                
                                CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.newDish.areAllergeniOk)
       
                            }
                        }
                    }
                
                ScrollView(.horizontal, showsIndicators: false) {

                        HStack {
                            
                            ForEach(self.allergeniIn) { allergene in
                                
                                CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                                
                            }
                        }
                }
                
                VStack(alignment:.leading) {

                    let string_1 = self.newDish.areAllergeniOk ? "Confermata" : "Non Confermata"
                   
                    let string_2 = self.allergeniIn.isEmpty ? "l'assenza" : "la presenza"
                        
                    HStack(spacing:0) {
                        Text("\(string_1) \(string_2) ")
                            .bold(self.newDish.areAllergeniOk)
                            .underline(self.newDish.areAllergeniOk, color: Color.black)
                                
                             Text("di Allergeni negli Ingredienti.")
                       }
                        .italic()
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundColor(Color.black)
    
                }
          
            }
            
            VStack(alignment: .leading) {
                
                CSLabel_conVB(placeHolder: "Categoria Menu", imageNameOrEmojy: "list.bullet.below.rectangle", backgroundColor: Color.black) {
                    
                    HStack {
                        
                        NavigationLink(value: DestinationPathView.categoriaMenu) {
                            Image(systemName: "arrow.up.forward.app")
                                .imageScale(.medium)
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                        }
                        
                        CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: newDish.categoriaMenu == .defaultValue)
                    }
                    
                }
                
                PropertyScrollCases(cases:viewModel.categoriaMenuAllCases, dishSingleProperty: self.$newDish.categoriaMenu, colorSelection: Color.green.opacity(0.8))
                
            }
            
            VStack(alignment: .leading) {
                
                /*  CSLabel_1Button(placeHolder: "Adatto ad una dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) */
                CSLabel_conVB(placeHolder: "Dieta", imageNameOrEmojy: "person.fill.checkmark", backgroundColor: Color.black) {
                    
                    Toggle(isOn: $confermaDiete) {
                        
                        HStack {
                            Spacer()
                            
                            Text(confermaDiete ? "Confermato" : "Non Confermato")
                                .font(.system(.callout, design: .monospaced))
                            Image(systemName: confermaDiete ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(confermaDiete ? Color.green : Color.gray)
                                .imageScale(.medium)
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
            
        }
        .onChange(of: self.dietAvaible, perform: { _ in
            self.confermaDiete = false
        })
        .onChange(of: self.allergeniIn, perform: { _ in
            self.newDish.areAllergeniOk = false
        })
        .onChange(of: self.newDish.areAllergeniOk, perform: { newValue in
            
            if newValue {
                
                viewModel.alertItem = AlertModel(
                    title: "⚠️ Conferma Allergeni",
                    message: "Articolo di legge"
                )
                self.newDish.allergeni = self.allergeniIn
                
            } else {
                
                self.newDish.allergeni = []
            }
            
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
    
    // Method
        
}
/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
