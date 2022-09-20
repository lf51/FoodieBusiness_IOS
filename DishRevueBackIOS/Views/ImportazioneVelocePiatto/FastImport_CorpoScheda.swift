//
//  FastImport_CorpoScheda.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import SwiftUI

struct FastImport_CorpoScheda:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    // Modifiche 28.08
  //  @Binding var fastDish: DishModel
   // let saveAction: (_ :DishModel) -> Void
    @Binding var temporaryModel: TemporaryModel
    let saveAction: (_ :TemporaryModel) -> Void
    // End 28.08
    

    @State private var areAllergeniOk: Bool = false
    @State private var dishPrice: String = ""

    @State private var checkError: Bool = false // una sorta di interruttore generale. Quando è su true, viene verificato se il form è incompleto

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(placeHolder: "Crea Nuovo Piatto:", imageNameOrEmojy: "fork.knife.circle", backgroundColor: Color.black) {

              //  Group { // 16.09
                HStack {
                
                    Spacer()
                    
                    CSButton_image(frontImage: "doc.badge.plus", imageScale: .large, frontColor: Color.white) { self.checkBeforeSave() }
                        ._tightPadding()
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.5))
                                .shadow(radius: 5.0)
                    )
                }
                
            }
  
                VStack(alignment:.leading) {
                    
                    Text(temporaryModel.dish.intestazione)
                            .font(.title)
                            .foregroundColor(Color.white)

                    HStack {

                        CS_Picker(
                            selection: $temporaryModel.categoriaMenu,
                            customLabel: "Categoria",
                            dataContainer: viewModel.categoriaMenuAllCases,//CategoriaMenu.allCases,
                            backgroundColor: Color.white.opacity(0.5))
                            .csWarningModifier(
                                isPresented: checkError) {
                                    self.temporaryModel.categoriaMenu == .defaultValue
                                   /* self.temporaryModel.dish.categoriaMenuDEPRECATA == .defaultValue */
                                    }

                     /*   csVbSwitchImageText(string: temporaryModel.dish.categoriaMenuDEPRECATA.imageAssociated()) */
                        csVbSwitchImageText(string: temporaryModel.categoriaMenu.imageAssociated())
                        
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
                            .csWarningModifier(
                                isPresented: checkError) {
                                  //  self.fastDish.formatiDelPiatto.isEmpty
                                    self.temporaryModel.dish.pricingPiatto.isEmpty
                                }

             
                            }
                           
                       }

            CSLabel_conVB(placeHolder: "Ingredienti:",imageNameOrEmojy: "leaf", backgroundColor: Color.black) {
               
                Toggle(isOn: self.$areAllergeniOk) {
                        
                    HStack(alignment:.bottom) {
                            Spacer()
                            Text("Conferma")
                                .font(.system(.callout, design: .monospaced))
                                .lineLimit(1)
   
                            Image(systemName: "allergens")
                                .imageScale(.medium)
                                .foregroundColor(Color.black)
  
                        }
                        .csWarningModifier(isPresented: checkError) {
                            !self.areAllergeniOk
                        }
                        
                    }
            }
            
            ScrollView(showsIndicators: false) {
                
                ForEach($temporaryModel.ingredients) { $ingredient in
                    
                  /*  let isIngredientOld = viewModel.checkExistingUniqueModelID(model: ingredient).0 */
                    let isIngredientOld = viewModel.isTheModelAlreadyExist(model: ingredient)
                    
                    FastImport_IngredientRow(ingredient: $ingredient,areAllergeniOk: $areAllergeniOk, checkError: checkError, isIngredientOld: isIngredientOld){ idIngredient in
                        self.addSecondary(id: idIngredient)
                      
                    }
                    .disabled(isIngredientOld)
                    .blur(radius: isIngredientOld ? 0.8 : 0.0)
                    .overlay(alignment:.center) {
                        if isIngredientOld{
                            
                            HStack {
                                Image(systemName: "lock")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35,alignment: .bottom)
                                   //.imageScale(.large)
                                    .foregroundColor(Color.white)
                                   // .blur(radius: 0.8)
                                Text("Esistente")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.white)
                            }
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

    private func addSecondary(id:String) -> Bool {
        
        if let index = self.temporaryModel.rifIngredientiSecondari.firstIndex(of: id) {
            
           self.temporaryModel.rifIngredientiSecondari.remove(at: index)
           return false
           
        } else {
            
            self.temporaryModel.rifIngredientiSecondari.append(id)
            return true 
        }
                
    }
    
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
                
    //    temporaryModel.dish.status = .completo(.archiviato)
        
        self.saveAction(temporaryModel)
        
    }
    
    private func checkAreDishPropertyOk() -> Bool {
// 13.09
        self.temporaryModel.categoriaMenu != .defaultValue && !self.temporaryModel.dish.pricingPiatto.isEmpty
       /* self.temporaryModel.dish.categoriaMenuDEPRECATA != .defaultValue && !self.temporaryModel.dish.pricingPiatto.isEmpty */
        
    }
    
    private func checkAreIngredientsOk() -> Bool {
        
        for ingredient in temporaryModel.ingredients {
            
            let origineOk = ingredient.origine != .defaultValue
            let conservazioneOk = ingredient.conservazione != .defaultValue
            // modifica 05.08
          //  let produzioneOk = ingredient.produzione != .defaultValue
          //  let provenienzaOk = ingredient.provenienza != .defaultValue
            
         //   if !origineOk || !conservazioneOk || !produzioneOk || !provenienzaOk {
                if !origineOk || !conservazioneOk  {
                print("CheckAreIngredientsOk -> \(ingredient.intestazione) non completo")
                return false}
        }
        
        return true
    }
    
    private func updateDishPrice() {
        
        // creiamo un piatto in formato standard "Unico", per una persona e senza indicazione di peso.
     //   self.fastDish.pricingPiatto = [] // deprecata 24.08
        guard self.dishPrice != "" else {return}
        guard csCheckDouble(testo: self.dishPrice) else { return }

        let formatoDish: DishFormat = {
            var newFormat = DishFormat(type: .mandatory)
            newFormat.price = self.dishPrice
            return newFormat
            
        }()
        
        self.temporaryModel.dish.pricingPiatto.append(formatoDish)
        print("Update DishPrice")
        
    }
   /* private func updateDishPrice() {
        
        // creiamo un piatto in formato standard "Unico", per una persona e senza indicazione di peso.
        self.fastDish.formatiDelPiatto = []
        guard self.dishPrice != "" else {return}
        guard csCheckDouble(testo: self.dishPrice) else { return }
        
        let formatoDish: DishFormato = .unico("n/d", "1", self.dishPrice)
        
        self.fastDish.formatiDelPiatto.append(formatoDish)
        print("Update DishPrice")
        
    } */ // deprecata 16.07
    
    
}

/*
struct FastImport_CorpoScheda_Previews: PreviewProvider {
    static var previews: some View {
        FastImport_CorpoScheda()
    }
}
*/


