//
//  FastImport_CorpoScheda.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import SwiftUI

struct FastImport_CorpoScheda:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var fastDish: DishModel
    let saveAction: (_ :DishModel) -> Void

    @State private var areAllergeniOk: Bool = false
    @State private var dishPrice: String = ""

    @State private var checkError: Bool = false // una sorta di interruttore generale. Quando è su true, viene verificato se il form è incompleto

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(placeHolder: "Crea Nuovo Piatto:", imageNameOrEmojy: "fork.knife.circle", backgroundColor: Color.black) {

                Group {
                    
                    Spacer()
                    
                    CSButton_image(frontImage: "doc.badge.plus", imageScale: .large, frontColor: Color.white) { checkBeforeSave() }
                        ._tightPadding()
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.5))
                                .shadow(radius: 5.0)
                    )
                }
                
            }
  
                VStack(alignment:.leading) {
                    
                        Text(fastDish.intestazione)
                            .font(.title)
                            .foregroundColor(Color.white)

                    HStack {

                        csVbSwitchImageText(string: fastDish.categoria.imageAssociated())
                        
                        CS_Picker(
                            selection: $fastDish.categoria,
                            customLabel: "Categoria..",
                            dataContainer: DishCategoria.allCases,
                            backgroundColor: Color.white.opacity(0.5))
                        .overlay(alignment:.topTrailing) {
                            if checkError {
                                let isCategoriaDefault = self.fastDish.categoria == .defaultValue
                                CS_ErrorMark(checkError: isCategoriaDefault )
                                        .offset(x: 10, y: -10)
                            }

                        }
                        
                        Spacer()
  
                        CSTextField_6(
                            textFieldItem: $dishPrice,
                            placeHolder: "0.00",
                            image: "eurosign.circle",
                            showDelete: false,
                            keyboardType: .decimalPad,
                            conformeA: .decimale) {
                                self.updateDishPrice()
                            }
                            .fixedSize()
                            .overlay(alignment:.topTrailing) {
                                if checkError {
                                    let isPriceEmpty = self.fastDish.formatiDelPiatto.isEmpty
                                    CS_ErrorMark(checkError: isPriceEmpty)
                                        .offset(x: 10, y: -10)
                                    }
                                
                                }
             
                            }
                           
                       }

            CSLabel_conVB(placeHolder: "Ingredienti:",imageNameOrEmojy: "leaf", backgroundColor: Color.black) {
               
                    Toggle(isOn: $areAllergeniOk) {
                        
                        HStack {
                            Spacer()
                            Text("Conferma")
                                .font(.system(.callout, design: .monospaced))
   
                            if checkError && !areAllergeniOk {
                                
                                CS_ErrorMark(checkError: !areAllergeniOk)
                                
                            } else {
                                
                                Image(systemName: "allergens")
                                    .imageScale(.medium)
                                
                            }
                            
                            
                          /*  if !checkError {
                               
                                Image(systemName: "allergens")
                                    .imageScale(.medium)
                                
                            } else {
                                
                                CS_ErrorMark(checkError: !areAllergeniOk)
                                
                            } */

                        }
                        
                    }
                    
            }
            
            ScrollView(showsIndicators: false) {
                
                ForEach($fastDish.ingredientiPrincipali) { $ingredient in
                    
                    let isIngredientOld = viewModel.checkExistingModel(model: ingredient).0
                    
                    FastImport_IngredientRow(ingredient: $ingredient, checkError: checkError, isIngredientOld: isIngredientOld)
                    .disabled(isIngredientOld)
                    .blur(radius: isIngredientOld ? 0.8 : 0.0)
                    .overlay(alignment:.topTrailing) {
                        if isIngredientOld{
                            
                            Image(systemName: "lock")
                                .imageScale(.large)
                                .foregroundColor(Color.white)
                                .blur(radius: 0.8)
                        }
                    }
                    
                        Divider()
                         
                        }
                
                }
        }.onTapGesture {
            csHideKeyboard()
        }
    }
    
    // Method

    private func checkBeforeSave() {
        
        guard checkAreDishPropertyOk() else {
            
            self.checkError = true
            return }
        
        guard checkAreIngredientsOk() else {
            
            self.checkError = true
            return }
        
        guard self.areAllergeniOk else {
            
            self.checkError = true
            return }
                
        self.saveAction(fastDish)
        
    }
    
    private func checkAreDishPropertyOk() -> Bool {
        
        self.fastDish.categoria != .defaultValue && !self.fastDish.formatiDelPiatto.isEmpty
        
    }
    
    private func checkAreIngredientsOk() -> Bool {
        
        for ingredient in fastDish.ingredientiPrincipali {
            
            let origineOk = ingredient.origine != .defaultValue
            let conservazioneOk = ingredient.conservazione != .defaultValue
            
            if !origineOk || !conservazioneOk {
                print("CheckAreIngredientsOk -> \(ingredient.intestazione) non completo")
                return false}
        }
        
        return true
    }
    
    
    private func updateDishPrice() {
        
        // creiamo un piatto in formato standard "Unico", per una persona e senza indicazione di peso.
        self.fastDish.formatiDelPiatto = []
        guard self.dishPrice != "" else {return}
        guard csCheckDouble(testo: self.dishPrice) else { return }
        
        let formatoDish: DishFormato = .unico("n/d", "1", self.dishPrice)
        
        self.fastDish.formatiDelPiatto.append(formatoDish)
        print("Update DishPrice")
        
    }
    
    
}

/*
struct FastImport_CorpoScheda_Previews: PreviewProvider {
    static var previews: some View {
        FastImport_CorpoScheda()
    }
}
*/


