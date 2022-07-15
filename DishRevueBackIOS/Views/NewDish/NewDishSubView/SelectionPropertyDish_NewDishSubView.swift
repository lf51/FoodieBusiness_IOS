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
    
    @State private var confermaDiete: Bool = false
   // @State private var areAllergeniOk: Bool = false
    
    init(newDish:Binding<DishModel>, generalErrorCheck:Bool) {
       
        _newDish = newDish
        self.generalErrorCheck = generalErrorCheck
        (self.dietAvaible,self.dietAvaibleString) = DishTipologia.returnDietAvaible(ingredients: newDish.wrappedValue.ingredientiPrincipali,newDish.wrappedValue.ingredientiSecondari)
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            VStack {
                
                CSLabel_conVB(
                    placeHolder: "Allergeni",
                    imageNameOrEmojy: "allergens",
                    backgroundColor: Color.black) {
                        
                        Toggle(isOn: self.$newDish.areAllergeniOk) {
                            
                            HStack {
                                Spacer()
                                Text("Dare Conferma")
                                    .font(.system(.callout, design: .monospaced))
                                
                                CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.newDish.areAllergeniOk)
                              /*  if generalErrorCheck && !areAllergeniOk {
                                    
                                    CS_ErrorMarkViewDEPRECATO(checkError: !areAllergeniOk)
                                    
                                } else {
                                    
                                    Image(systemName: "allergens")
                                        .imageScale(.medium)
                                    
                                } */
                            }
                        }
                    }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    if newDish.allergeni.isEmpty {
                        
                        Text("Nessun Allergene Indicato negli Ingredienti")
                            .italic()
                            .fontWeight(.light)
                            .font(.caption)
                            .foregroundColor(Color.black)
                        
                    } else {
                        
                        HStack {
                            
                            ForEach(newDish.allergeni) { allergene in
                                
                                CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                                
                            }
                        }
                    }
                    
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
                
                
               
                
                
              /*  Text("Diete Confermate: \(self.newDish.dieteCompatibili.debugDescription)")
                    .font(.caption) */
                
              /*  PropertyScrollCasesPlus(cases: DishTipologia.allCases, dishCollectionProperty: newDish.tipologiaDieta) */
                
                
                /*   ScrollView(.horizontal, showsIndicators: false) {
                 
                 HStack {
                 
                 ForEach(newDish.tipologiaDieta) { dieta in
                 
                 CSText_tightRectangle(testo: dieta.simpleDescription(), fontWeight: .light, textColor: Color.white, strokeColor: Color.gray, fillColor: Color.clear)
                 /*  .onTapGesture {
                  self.descrizioneDieta = dieta.extendedDescription() ?? ""
                  self.mostraDescrizioneDieta.toggle()
                  } */
                 
                 }
                 }
                 
                 } */
                
             /*   if self.mostraDescrizioneDieta {
                    
                    Text(descrizioneDieta)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .italic()
                        .foregroundColor(Color.black)
                    
                }*/
                
            }
            
          /*  VStack(alignment:.leading) {
                
                CSLabel_1Button(placeHolder: "Adattabile ad una dieta", imageNameOrEmojy: "person.fill", backgroundColor: Color.black)
                
                PropertyScrollCases(cases: DishAvaibleFor.allCases, dishCollectionProperty: self.$newDish.avaibleFor, colorSelection: Color.blue.opacity(0.8))
                
                showExtendedDescription()
            } */
            
            
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
    
    // Method
    
   /* private func resetDieteCompatibili(withAlert:Bool) {
        
        viewModel.alertItem = AlertModel(
            title: "Piatto Standard",
            message: "Contiene ingredienti di orgine animale, pesce, latte e/o derivati."
                )
        self.newDish.dieteCompatibili = [.standard]
        
    } */
    
   /* @ViewBuilder private func showExtendedDescription() -> some View {
        
        VStack(alignment:.leading) {
            
            ForEach(self.newDish.avaibleFor) { diet in
                
                Text(diet.extendedDescription() ?? "")
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundColor(Color.black)
                
            }
            
        }
        
    } */
    
}
/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
