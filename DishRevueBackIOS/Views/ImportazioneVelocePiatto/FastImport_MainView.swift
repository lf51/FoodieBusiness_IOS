//
//  ImportazioneVeloceDishIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/05/22.
//

import SwiftUI

struct FastImport_MainView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var allFastDish: [DishModel] = []
    
    let backgroundColorView: Color
    @State private var text: String = ""
    
    @State private var isUpdateDisable: Bool = true
    @State private var showSubString: Bool = false
 
    var body: some View {
        
        CSZStackVB(title: "Importazione Rapida", backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider(isVisible: true)
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {

                        CSDivider(isVisible: true) // senza il testo del texeditor va su e si disallinea
                      
                        TextEditor(text: $text)
                            .font(.system(.body,design:.rounded))
                            .foregroundColor(Color.black)
                            .autocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                            .csTextEditorBackground {
                                Color.white.opacity(0.2)
                            }
                            .cornerRadius(5.0)
                            .frame(height: 150)
                            .onChange(of: text) { _ in
                             self.isUpdateDisable = false
                            }
                
                        HStack {
                            
                            CSButton_tight(title: "Estrai", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.mint) {
                                estrapolaStringhe()
                                csHideKeyboard()
                                self.isUpdateDisable = true
                                withAnimation {
                                    showSubString = true
                                }
                            }
                            .opacity(self.isUpdateDisable ? 0.6 : 1.0)
                            .disabled(self.isUpdateDisable)
 
                            Spacer()

                            Text("N°Piatti:\(allFastDish.count)")
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.medium)
                                .foregroundColor(Color.white.opacity(0.6))
                            
                        } // Barra dei Bottoni
                        
                        if showSubString {
                            
                            ScrollView(.horizontal,showsIndicators: false) {
                                
                                HStack {
                                    
                                    ForEach($allFastDish) { $fastDish in
                                        
                                        CSZStackVB_Framed(frameWidth: 380, rateWH: 1.5) {
                                            
                                            VStack {
                                                FastImport_CorpoScheda(fastDish: $fastDish) { newDish in
                                                    withAnimation(.spring()) {
                                                        fastSave(item: newDish)
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                        }
                                    
                                    }
                                  
                                }
                            }
    
                        } // Chiusa ifshoSubstring
                       
                Spacer()
                       // Text("\(manipolaStringa())")
                    }.padding(.horizontal)
                    
                }
       
            }
       
        }
    }
    
    // Method
    
    private func fastSave(item: DishModel) {
        
        do {
            
            try self.viewModel.dishAndIngredientsFastSave(item: item)
            let localIndex = self.allFastDish.firstIndex(of: item)
            self.allFastDish.remove(at: localIndex!)
            
            self.reBuildIngredientContainer()
            
        } catch _ {
            
            viewModel.alertItem = AlertModel(
                title: "Errore - Piatto Esistente",
                message: "Modifica il nome del piatto nell'Editor ed estrai nuovamente il testo.")
            
        }
 
    }
    
    /// reBuilda il container Piatto aggiornando gli ingredienti, sostituendo i vecchi ai "nuovi"
    private func reBuildIngredientContainer() {
        
        var newDishContainer:[DishModel] = []
        var newDish:DishModel = DishModel()
        
        for dish in self.allFastDish {
            
            newDish = dish
            newDish.ingredientiPrincipali = []
            
            for ingredient in dish.ingredientiPrincipali {
                
                if let oldIngredient = viewModel.checkExistingModel(model: ingredient).1 { newDish.ingredientiPrincipali.append(oldIngredient) } else {newDish.ingredientiPrincipali.append(ingredient) }
       
            }
            
            newDishContainer.append(newDish)
            
        }
        
        self.allFastDish = newDishContainer
   
    }
    
    private func estrapolaStringhe() {
         
     self.allFastDish = []
     
     let containerDish = self.text.split(separator: ".")
        print("containerDish: \(containerDish.description)")
        for dish in containerDish {

            let step_3b = dish.replacingOccurrences(of: "*", with: "")
            
            var ingredientContainer = step_3b.split(separator: ",")
            
            let dishTitle = String(ingredientContainer[0]).lowercased()
            let cleanedDishTitle = csStringCleaner(string: dishTitle)
            ingredientContainer.remove(at: 0)
            
            var step_5:[IngredientModel] = []
            
            for subString in ingredientContainer {

                let sub = String(subString).lowercased()
                let newSub = csStringCleaner(string: sub)
                
                let ingredient = IngredientModel(nome: newSub.capitalized)
                
                if let oldIngredient = viewModel.checkExistingModel(model: ingredient).1 {
                    
                    step_5.append(oldIngredient)
   
                } else {step_5.append(ingredient)}
         
             }
            
            let fastDish:DishModel = {
                
                var dish = DishModel()
                dish.intestazione = cleanedDishTitle.capitalized
                dish.ingredientiPrincipali = step_5
                return dish
                
            }()

            self.allFastDish.append(fastDish)
            print("Dentro Estrapola/Fine Ciclo piatto: \(cleanedDishTitle)")
        }
     
    }
 
    
}

struct FastImportMainView_Previews: PreviewProvider {
    static var previews: some View {
    
        NavigationView {
            FastImport_MainView(backgroundColorView: Color.cyan)
                
        }
         //   Color.cyan
    
    }
}





