//
//  ImportazioneVeloceDishIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/05/22.
//

import SwiftUI

struct FastImport_MainView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var allFastDish: [TemporaryModel] = []
    let backgroundColorView: Color
    @State private var text: String = "Spaghetti alla carbonara,pecorino dop,prezzemolo,tuorlo d'uovo,pepe nero, sale.Bucatini alla matriciana,guanciale,pepe nero,sale."
    
    @State private var isUpdateDisable: Bool = true
    var body: some View {
        
        CSZStackVB(title: "Inserimento Veloce", backgroundColorView: backgroundColorView) {
            
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
                               
                                self.estrapolaStringhe()
                                self.postEstrapolaAction()
                             
                            }
                            .opacity(self.isUpdateDisable ? 0.6 : 1.0)
                            .disabled(self.isUpdateDisable)
 
                            CSInfoAlertView(imageScale: .large, title: "Guida Formato", message: .formattazioneInserimentoVeloce)
                            
                            Spacer()

                            Text("N°Piatti:\(allFastDish.count)")
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.medium)
                                .foregroundColor(Color.white.opacity(0.6))
                            
                        } // Barra dei Bottoni
                        
                        if !allFastDish.isEmpty {
                            
                            TabView { // Risolto bug 23.06.2022 Se allFastDish è vuoto, con la TabView andiamo in crash.
                                
                                ForEach($allFastDish) { $fastDish in
                                    
                                  //  CSZStackVB_Framed(frameWidth: 380, rateWH: 1.5) {
                                    CSZStackVB_Framed(frameWidth:1200) {
                                        
                                        VStack {
                                            FastImport_CorpoScheda(temporaryModel: $fastDish) { newDish in
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
                            .frame(height:800)
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
 
    private func fastSave(item: TemporaryModel) {
 
        do {
            
            try self.viewModel.dishAndIngredientsFastSave(item: item)

            let localAllFastDish:[TemporaryModel] = self.allFastDish.filter {$0.id != item.id}
 
            if !localAllFastDish.isEmpty {
                self.reBuildIngredientContainer(localTemporaryModel: localAllFastDish)
            }  else {self.allFastDish = localAllFastDish}

        } catch _ {
            
            viewModel.alertItem = AlertModel(
                title: "Errore - Piatto Esistente",
                message: "Modifica il nome del piatto nell'Editor ed estrai nuovamente il testo.")
            
        }
 
    }
 
    /// reBuilda il container Piatto aggiornando gli ingredienti, sostituendo i vecchi ai "nuovi"
    private func reBuildIngredientContainer(localTemporaryModel:[TemporaryModel]) {
        
        var newTemporaryContainer:[TemporaryModel] = []
        var newTemporaryModel:TemporaryModel?
        
        for model in localTemporaryModel {
            
            newTemporaryModel = model
            newTemporaryModel?.ingredients = []
          //  newDish.ingredientiPrincipaliDEPRECATO = []
            
            for ingredient in model.ingredients {
                
                if let oldIngredient = viewModel.checkExistingUniqueModelName(model: ingredient).1 { newTemporaryModel?.ingredients.append(oldIngredient) } else {newTemporaryModel?.ingredients.append(ingredient) }
       
            }
            
            newTemporaryContainer.append(newTemporaryModel!)
            
        }
        
        self.allFastDish = newTemporaryContainer
   
    }
    /*
    /// reBuilda il container Piatto aggiornando gli ingredienti, sostituendo i vecchi ai "nuovi"
    private func reBuildIngredientContainer(localAllFastDish:[DishModel]) {
        
        var newDishContainer:[DishModel] = []
        var newDish:DishModel = DishModel()
        
        for dish in localAllFastDish {
            
            newDish = dish
            newDish.ingredientiPrincipaliDEPRECATO = []
            
            for ingredient in dish.ingredientiPrincipaliDEPRECATO {
                
                if let oldIngredient = viewModel.checkExistingUniqueModelID(model: ingredient).1 { newDish.ingredientiPrincipaliDEPRECATO.append(oldIngredient) } else {newDish.ingredientiPrincipaliDEPRECATO.append(ingredient) }
       
            }
            
            newDishContainer.append(newDish)
            
        }
        
        self.allFastDish = newDishContainer
   
    } */ // Deprecata 28.08
    
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
                
                let ingredient = {
                   var newIngredient = IngredientModel()
                    newIngredient.intestazione = newSub.capitalized
                    newIngredient.status = .bozza(.disponibile) // 07.09 !!!!
                    return newIngredient
                }()
                
                // Modifica 28.08
                
                if let oldIngredient = viewModel.checkExistingUniqueModelName(model: ingredient).1 {
                    
                    step_5.append(oldIngredient)
   
                } else {step_5.append(ingredient)}
                
              /*  if let oldIngredient = viewModel.checkExistingModel(model: ingredient).1 {
                    
                    step_5.append(oldIngredient)
   
                } else {step_5.append(ingredient)} */
                
                // End 28.08
         
             }
            
            let fastDish:DishModel = {
                
                var dish = DishModel()
                dish.intestazione = cleanedDishTitle.capitalized
                dish.status = .bozza(.disponibile) // 07.09 !!!
              //  dish.ingredientiPrincipaliDEPRECATO = step_5
                return dish
                
            }()
            
            let temporaryDish: TemporaryModel = TemporaryModel(dish: fastDish, ingredients: step_5)
            

            self.allFastDish.append(temporaryDish)
            print("Dentro Estrapola/Fine Ciclo piatto: \(cleanedDishTitle)")
        }
     
    }
 
    private func postEstrapolaAction() {
        
        csHideKeyboard()
        self.isUpdateDisable = true
        viewModel.alertItem = AlertModel(
            title: "⚠️ Attenzione",
            message: SystemMessage.allergeni.simpleDescription())
        
    }
    
}

struct FastImportMainView_Previews: PreviewProvider {
    static var previews: some View {
    
        NavigationStack {
            FastImport_MainView(backgroundColorView: Color("SeaTurtlePalette_1"))
                
        }.environmentObject(AccounterVM())
         //   Color.cyan
    
    }
}





