//
//  FastImport_CorpoScheda.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import SwiftUI

struct FastImport_CorpoScheda:View {
    
    //@EnvironmentObject var viewModel: AccounterVM
    @Binding var fastDish: DishModel
    let saveAction: (_ :DishModel) -> Void

    @State private var areAllergeniOk: Bool = false
    @State private var dishPrice: String = ""
    private var dishPriceChanged: Bool {
        dishPrice != ""
    }
        
    @State private var isPriceEmpty: Bool = false
    @State private var isCategoriaDefault: Bool = false
    @State private var allergeniConfermati: Bool = true // NON è un duplicato di areAllergeniOk. Serve!
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(placeHolder: "Nome Piatto", imageNameOrEmojy: "fork.knife.circle", backgroundColor: Color.black) {
                                
                CSButton_image(frontImage: "doc.badge.plus", imageScale: .large, frontColor: Color.blue) { checkBeforeSave() }
                
            }
  
                VStack(alignment:.leading) {
                           
                 //   HStack {
                        
                        CSText_tightRectangle(testo: fastDish.intestazione, fontWeight: .semibold, textColor: Color.white, strokeColor: Color.blue, fillColor: Color.yellow)
                        
                    /*    Spacer()
                        
                       

                        
         
                        } */

                    HStack {
                        
                 
                            csVbSwitchImageText(string: fastDish.categoria.imageAssociated())
                            CS_Picker(selection: $fastDish.categoria,customLabel: "Categoria..", dataContainer: DishCategoria.allCases)
                            if isCategoriaDefault {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(Color.yellow)
                            }
                        
                        
                        
                    /*    csVbSwitchImageText(string: fastDish.categoria.imageAssociated())
                            .font(.subheadline)
                        
                        Text(fastDish.categoria.simpleDescriptionSingolare())
                            .font(.system(.subheadline, design: .monospaced)) */
                           
                        Spacer()
                        
                        if isPriceEmpty {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .imageScale(.medium)
                                .foregroundColor(Color.yellow)
                        }
                        
                        CSTextField_6(
                            textFieldItem: $dishPrice,
                            placeHolder: "0.00",
                            image: "eurosign.circle",
                            showDelete: false,
                            keyboardType: .numbersAndPunctuation,
                            conformeA: .decimale) {
                                self.updateDishPrice()
                            }
                            .fixedSize()
                 
                        
                            }
                           
                       }

            CSLabel_conVB(placeHolder: "Ingredienti:",imageNameOrEmojy: "leaf", backgroundColor: Color.black) {
               
                    Toggle(isOn: $areAllergeniOk) {
                        
                        HStack {
                            Spacer()
                            Text("Conferma")
                            
                            if allergeniConfermati {
                                
                                Image(systemName: "allergens")
                                
                            } else {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(Color.yellow)
                            }
                        }
                        
                    }
                    
            }
            
            ScrollView(showsIndicators: false) {
                
                ForEach($fastDish.ingredientiPrincipali) { $ingredient in
                         
                        FastImport_IngredientRow(ingredient: $ingredient)
                        Divider()
                         
                        }
                
                }
                
            
         
        }
    

    }
    
    // Method
    
    private func checkBeforeSave() {
        
        var scoreValue:Int = 0
        
        if self.fastDish.formatiDelPiatto.isEmpty {
            self.isPriceEmpty = true
            scoreValue += 1
        } else {self.isPriceEmpty = false }
       
        if self.fastDish.categoria == .defaultValue {
            self.isCategoriaDefault = true
            scoreValue += 1
        } else { self.isCategoriaDefault = false }
        
        if !self.areAllergeniOk {
            self.allergeniConfermati = false
            scoreValue += 1
        } else { self.allergeniConfermati = true }
        
        guard scoreValue == 0 else { return }
        
        self.saveAction(fastDish)
        
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
