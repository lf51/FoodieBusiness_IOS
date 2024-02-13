//
//  ImportazioneVeloceDishIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/05/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct FastImport_MainView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let backgroundColorView: Color
    
    @State private var allFastDish: [TemporaryModel]?
    @State private var text: String = ""
    
    @State private var disableView:Bool?
    
    @State private var isUpdateDisable: Bool = true
    @State private var tabViewHeight:CGFloat = 200
    
    @State private var localScrollPosition:Int?
    @State private var childScrollItem:TemporaryModel.ID?
    
    var body: some View {
        
        CSZStackVB(title: "Preparazioni", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
               CSDivider()
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {

                        TextEditor(text: $text)
                            .font(.system(.body,design:.rounded))
                            .foregroundStyle(Color.black)
                            .autocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                            .csTextEditorBackground {
                                Color.white.opacity(0.2)
                            }
                            .cornerRadius(5.0)
                            .frame(height: 125)
                            .onChange(of: text) {
                             self.isUpdateDisable = false
                            }
                            .id(0)
                        
                        HStack {
                            
                            CSButton_tight(title: "Estrai", fontWeight: .semibold, titleColor: Color.seaTurtle_4, fillColor: Color.seaTurtle_2) {
                               
                                withAnimation {
                                    getString()

                                }
                             
                            }
                            .opacity(self.isUpdateDisable ? 0.3 : 1.0)
                            .disabled(self.isUpdateDisable)
 
                            CSInfoAlertView(imageScale: .large, title: "Guida Formato", message: .formattazioneInserimentoVeloce)
                            
                            Spacer()

                            Group {
                                Text("Prodotti:\(allFastDish?.count ?? 0)")
                                   /* .font(.system(.subheadline, design: .monospaced))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.white.opacity(0.6))*/
                                
                                Text("-")
                                
                                Text("Ing:\(ingCount())")
                                   /* .font(.system(.subheadline, design: .monospaced))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.white.opacity(0.6))*/
                            }
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.white.opacity(0.6))
                        
                            
                        } // Barra dei Bottoni
                        .id(1)
                        
                        if let allFastDish {
                            
                            TemporaryModelRow(
                                allFastDish: allFastDish,
                                tabViewHeight: tabViewHeight,
                                localScrollPosition:$childScrollItem)
                              //  .id(2)
                                .id(allFastDish)
                            
 
                        } // Chiusa if
                        
                        Spacer()
                 
                    }//.padding(.horizontal)
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $localScrollPosition,anchor: .bottom)
                .onChange(of: childScrollItem) {
                    withAnimation {
                        self.localScrollPosition = 1
                    }
                }
               // .edgesIgnoringSafeArea(.all)
                CSDivider()
            }
            .csHpadding()
            .opacity(disableView ?? false ? 0.4 : 1.0)
            .disabled(disableView ?? false)
            
      //  CSDivider()
        }
        .onAppear {
            
            if self.viewModel.db.allMyCategories.isEmpty {
                self.disableView = true
                self.viewModel.alertItem = AlertModel(title: "Action Required", message: "Per creare piatti e ingredienti in blocco è necessario avere almeno una categoria menu", actionPlus: ActionModel(title: .prosegui, action: {
                    self.viewModel.addToThePath(destinationPath: .dishList, destinationView: .categoriaMenu)
                }))
            }
            
        }
        .onDisappear {
            self.disableView = nil
        }
    }
    
    // Method
    
    private func getString() {
        
        do {
            try self.estrapolaStringhe()
            self.postEstrapolaAction()
            
        } catch let error {
            csHideKeyboard()
            self.isUpdateDisable = true
            self.viewModel.logMessage = error.localizedDescription
        }
    }
    
    private func ingCount() -> Int {
        
        guard let allFastDish else { return 0}
        
        var count:Int = 0
        for model in allFastDish {
            
           let modelCount = model.ingredients.count
            count += modelCount
        }
        return count
    }
    
    private func estrapolaStringhe() throws {
         // 09_11_23 aboliamo la possibilità di creare prodotti finiti
     self.allFastDish = nil
     var allTemprary:[TemporaryModel] = []
     
     let containerDish = self.text.split(separator: ".")
        
        for dish in containerDish {

            let step_3b = dish.replacingOccurrences(of: "*", with: "")
            
            var ingredientContainer = step_3b.split(separator: ",")
            
            let dishTitle = String(ingredientContainer[0]).lowercased()
            let cleanedDishTitle = csStringCleaner(string: dishTitle)
            
            // update 11.02.24
            
            let fastDish:ProductModel = {
                 
                 var dish = ProductModel()
                 dish.intestazione = cleanedDishTitle
     
                 return dish
                 
             }()
            
            let checkExistence = self.viewModel.checkExistingUniqueModelName(model: fastDish).0
            
            guard !checkExistence else {
                throw CS_GenericError.modelNameAlreadyIn(cleanedDishTitle)
            }
            // end update 11.02.24
            
            ingredientContainer.remove(at: 0)
            
            guard !ingredientContainer.isEmpty else {

                throw CS_GenericError.fastImportDishWithNoIng
              
            }
            
            var step_5:[IngredientModel] = []
                
                for subString in ingredientContainer {

                    let sub = String(subString).lowercased()
                    let newSub = csStringCleaner(string: sub)
                    
                    let ingredient = {
                        var newIngredient = IngredientModel()
                        newIngredient.intestazione = newSub
                        return newIngredient
                    }()

                    if let oldIngredient = viewModel.checkExistingUniqueModelName(model: ingredient).1 {
                        
                        step_5.append(oldIngredient)
       
                    } else {step_5.append(ingredient)}
                             
                 }

           /* let fastDish:ProductModel = {
                
                var dish = ProductModel()
                dish.intestazione = cleanedDishTitle
    
                return dish
                
            }()*/
            
            let temporaryDish: TemporaryModel = TemporaryModel(
                dish: fastDish,
                ingredients: step_5)
            
            allTemprary.append(temporaryDish)
        }
        // impostiamo la altezza della tabView sulla base del piatto che ha il maggior numero di ingredienti. Le tabview ci hanno dato problemi di rendering (18/06/2023) e devono avere tutte la stessa altezza. E dovranno avere dunque l'altezza maggiore altrimenti parte del contenuto va sotto il resto. Abbiamo tolto lo scroll interno alla tab perchè non funzionava bene e senza fissare il nome del piatto aveva anche poco tempo. Vedi nota vocale 18.06.23
        let maxIngredientsIn = allTemprary.map({$0.ingredients.count}).max()
        let maxIn = CGFloat(maxIngredientsIn ?? 0)
        
        self.tabViewHeight += (maxIn * 200)
        self.allFastDish = allTemprary
        
    }
 
    private func postEstrapolaAction() {
        
        csHideKeyboard()
        self.isUpdateDisable = true

        viewModel.alertItem = AlertModel(
            title: "⚠️ Attenzione",
            message: SystemMessage.allergeni.simpleDescription())
        
    }
        
}

/*struct FastImportMainView_Previews: PreviewProvider {
   
   static let dish:ProductModel = ProductModel()
   static let ingredients:[IngredientModel] = [IngredientModel()]
    
    
    @State static var allDish:[TemporaryModel] = [
    
        TemporaryModel(dish: dish, ingredients: ingredients),
        TemporaryModel(dish: dish, ingredients: ingredients)
    
    ]
    
    static var previews: some View {
    
        NavigationStack {
          //  FastImport_MainView(backgroundColorView: Color.seaTurtle_1)
            TemporaryModelRow(allFastDish: allDish,tabViewHeight: 200)
                
        }.environmentObject(AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID")))
         //   Color.cyan
    
    }
}*/

private struct TemporaryModelRow:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @State private var allFastDish:[TemporaryModel]
    let tabViewHeight:CGFloat
    
    @Binding var localScrollPosition:TemporaryModel.ID?
    
    init(
        allFastDish: [TemporaryModel],
        tabViewHeight: CGFloat,
        localScrollPosition: Binding<TemporaryModel.ID?>) {
      
        _allFastDish = State(wrappedValue: allFastDish)
        self.tabViewHeight = tabViewHeight
        _localScrollPosition = localScrollPosition
    }
    
    var body: some View {
        
        
        ScrollView(.horizontal,showsIndicators: false) {
            
            LazyHStack {
                
                ForEach($allFastDish) { $fastDish in
                    
                   /* let checkExistence = self.viewModel.checkExistingUniqueModelName(model: fastDish.dish).0*/
                    
                    VStack {
                        FastImport_CorpoScheda(temporaryModel: $fastDish) { newDish in
                            withAnimation(.spring()) {
                                fastSave(item: newDish)
                            }
                        }
                      
                        Spacer()
                    }
                    .frame(height:tabViewHeight)
                    .containerRelativeFrame(.horizontal)
                   /* .csModifier(checkExistence) { view in
                        view
                            .opacity(0.6)
                            .overlay(alignment: .topLeading) {
                                HStack {
                                  //  Spacer()
                                    Text("Esistente")
                                        .bold()
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.seaTurtle_1)
                                        .lineLimit(1)
                                        .padding(.horizontal,100)
                                   // Spacer()
                                }
                                .background(content: {
                                    Color.black.opacity(0.8)
                                })
                                .rotationEffect(Angle.degrees(-45))
                                .offset(x: -70, y: 80)
                            }
                            .disabled(true)
 
                    }*/ // deprecato 11.02.24
                    
                } // chiusa forEach
  
            }// chiusa lazyHastack
            .scrollTargetLayout()

        }
        .scrollPosition(id: $localScrollPosition,anchor: .center)
        .scrollTargetBehavior(.viewAligned)

    }
    
    // method
    
    private func fastSave(item: TemporaryModel)  {
        
        Task {
            
            do {
                
                DispatchQueue.main.async {
                    self.viewModel.isLoading = true
               }
                
                try await self.viewModel.dishAndIngredientsFastSave(item: item)
                
                let localAllFastDish:[TemporaryModel] = self.allFastDish.filter {$0.id != item.id}
                
                if !localAllFastDish.isEmpty {
                    self.reBuildIngredientContainer(localTemporaryModel: localAllFastDish)
                }  else {self.allFastDish = localAllFastDish}
                
            } catch let error {
               // print("\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.viewModel.isLoading = nil
                    self.viewModel.logMessage = error.localizedDescription
               }
                
            }
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
}
