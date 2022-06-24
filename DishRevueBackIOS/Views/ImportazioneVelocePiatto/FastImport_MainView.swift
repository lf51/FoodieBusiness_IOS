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
   // @State private var showSubString: Bool = false
 
    var body: some View {
        
        CSZStackVB(title: "Piatto + Ingredienti", backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider()
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {

                        CSDivider() // senza il testo del texeditor va su e si disallinea
                      
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
                            
                            CSButton_tight(title: "Estrai", fontWeight: .semibold, titleColor: Color("SeaTurtlePalette_4"), fillColor: Color("SeaTurtlePalette_2")) {
                                estrapolaStringhe()
                                csHideKeyboard()
                                self.isUpdateDisable = true
                              /*  withAnimation {
                                    showSubString = true
                                } */
                            }
                            .opacity(self.isUpdateDisable ? 0.6 : 1.0)
                            .disabled(self.isUpdateDisable)
 
                            Spacer()

                            Text("N°Piatti:\(allFastDish.count)")
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.medium)
                                .foregroundColor(Color.white.opacity(0.6))
                            
                        } // Barra dei Bottoni
                        
                        if !allFastDish.isEmpty {
                            
                            TabView { // Risolto bug 23.06.2022 Se allFastDish è vuoto, con la TabView andiamo in crash.
                                
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
                            .frame(height:570)
                            .tabViewStyle(PageTabViewStyle())
                            
                        } // Chiusa if
                        
                Spacer()
                 
                    }//.padding(.horizontal)
                    
                }
                CSDivider()
            }.padding(.horizontal)
       
        }
    }
    
    // Method
 
    private func fastSave(item: DishModel) {
 
        do {
            
            try self.viewModel.dishAndIngredientsFastSave(item: item)

            let localAllFastDish:[DishModel] = self.allFastDish.filter {$0.id != item.id}
 
            if !localAllFastDish.isEmpty {
                self.reBuildIngredientContainer(localAllFastDish: localAllFastDish)
            }  else {self.allFastDish = localAllFastDish}

        } catch _ {
            
            viewModel.alertItem = AlertModel(
                title: "Errore - Piatto Esistente",
                message: "Modifica il nome del piatto nell'Editor ed estrai nuovamente il testo.")
            
        }
 
    }
    
    /// reBuilda il container Piatto aggiornando gli ingredienti, sostituendo i vecchi ai "nuovi"
    private func reBuildIngredientContainer(localAllFastDish:[DishModel]) {
        
        var newDishContainer:[DishModel] = []
        var newDish:DishModel = DishModel()
        
        for dish in localAllFastDish {
            
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
    
        NavigationStack {
            FastImport_MainView(backgroundColorView: Color.cyan)
                
        }
         //   Color.cyan
    
    }
}





