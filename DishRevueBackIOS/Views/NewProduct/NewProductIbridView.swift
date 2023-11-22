//
//  NewProductIbridView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/11/23.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import Firebase
import MyPackView_L0

struct NewProductIbridView: View {

    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var viewModel:AccounterVM

    @Binding var productModel:ProductModel
    @State private var ingredienteSottostante:IngredientModel?
    
    let backgroundColorView: Color
    let lockIngredientEdit:Bool
   // let saveDialogType:SaveDialogType
    
    @State private var productArchiviato: ProductModel // per il reset
    @State private var sottostanteArchiviato: IngredientModel?
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    
    @State private var areAllergeniOk: Bool = false
    @State private var wannaOpenPopOver: Bool = false
    @State private var uploadDishFormat:Bool = false

    @Binding var disabilitaPicker:Bool
    
    @FocusState private var modelField:ModelField?
    
    private var countProgress:Double {
        
        var count = self.productModel.countProgress
        
        if let ingredienteSottostante {
            
            if ingredienteSottostante.conservazione != .defaultValue { count += 0.125}
            if ingredienteSottostante.origine != .defaultValue {
                count += 0.125
            }
           
        }
        return count
    }
    
    init(
        newDish:Binding<ProductModel>,
        sottostante:IngredientModel? = nil,
        lockEditSottostante:Bool = false,
        disabilitaPicker:Binding<Bool>,
        backgroundColorView: Color,
        destinationPath:DestinationPath,
        saveDialogType:SaveDialogType) {
                        
        _productModel = newDish
        _productArchiviato = State(wrappedValue: newDish.wrappedValue)

        _ingredienteSottostante = State(wrappedValue: sottostante)
        _sottostanteArchiviato = State(wrappedValue: sottostante)
            
        _disabilitaPicker = disabilitaPicker
            
        self.lockIngredientEdit = lockEditSottostante
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
      //  self.saveDialogType = saveDialogType
    }

    var body: some View {
       
            VStack {
                
                if self.disabilitaPicker {
                    ProgressView(value: self.countProgress) {
                        Text("Completo al: \(self.countProgress,format: .percent)")
                            .font(.caption)
                    }

                }
                                
                ScrollView(showsIndicators:false) { // La View Mobile

                    VStack(alignment:.leading,spacing: .vStackBoxSpacing) {
                                
                            IntestazioneNuovoOggetto_Generic(
                                    itemModel: $productModel,
                                    generalErrorCheck: generalErrorCheck,
                                    minLenght: 3,
                                    coloreContainer: .seaTurtle_2)
                            .focused($modelField, equals: .intestazione)
                            .opacity(lockIngredientEdit ? 0.6 : 1.0)
                            .disabled(lockIngredientEdit)
 
                        let isComposizione = self.productModel.percorsoProdotto.returnTypeCase() == .composizione()
                        
                            BoxDescriptionModel_Generic(
                                itemModel: $productModel,
                                labelString: self.productModel.percorsoProdotto.boxDescription(),
                                disabledCondition: wannaOpenPopOver,
                                generalErrorCheck: isComposizione ? generalErrorCheck : false,
                                modelField: $modelField)
                            .focused($modelField, equals: .descrizione)
                            
                            CategoriaScrollView_NewDishSub(
                                newDish: $productModel,
                                generalErrorCheck: generalErrorCheck)
                            
                        if let ingredienteSottostante {
                            
                            let sottostante = Binding { ingredienteSottostante } set: { self.ingredienteSottostante = $0}
                            
                         //   Group {   // Innesto
                                
                                OrigineScrollView_NewIngredientSubView(
                                    nuovoIngrediente: sottostante,
                                    generalErrorCheck: generalErrorCheck)
                                    .opacity(lockIngredientEdit ? 0.6 : 1.0)
                                    .disabled(lockIngredientEdit)
                                
                                AllergeniScrollView_NewIngredientSubView(
                                    nuovoIngrediente: sottostante,
                                    generalErrorCheck: generalErrorCheck,
                                    lockEdit: lockIngredientEdit,
                                    areAllergeniOk: $areAllergeniOk,
                                    wannaAddAllergene: $wannaOpenPopOver)
                                
                                ConservazioneScrollView_NewIngredientSubView(
                                    nuovoIngrediente: sottostante,
                                    generalErrorCheck: generalErrorCheck)
                                .opacity(lockIngredientEdit ? 0.6 : 1.0)
                                .disabled(lockIngredientEdit)
                                
                                ProduzioneScrollView_NewIngredientSubView(
                                    nuovoIngrediente: sottostante)
                                    .opacity(lockIngredientEdit ? 0.6 : 1.0)
                                    .disabled(lockIngredientEdit)
                                
                                ProvenienzaScrollView_NewIngredientSubView(
                                    nuovoIngrediente: sottostante)
                                    .opacity(lockIngredientEdit ? 0.6 : 1.0)
                                    .disabled(lockIngredientEdit)
                          //  } // end Innesti
                            
                        } else {
                            
                            PannelloIngredienti_NewDishSubView(
                                newDish: productModel,
                                generalErrorCheck: generalErrorCheck,
                                wannaAddIngredient: $wannaOpenPopOver)
                            .id(productModel.ingredientiPrincipali)
                            
                            AllergeniScrollView_NewDishSub(newDish: $productModel, generalErrorCheck: generalErrorCheck, areAllergeniOk: $areAllergeniOk)
                            
                        }

                            DietScrollView_NewDishSub(
                                newDish: $productModel,
                                sottostante: ingredienteSottostante,
                                viewModel: viewModel)

                            DishSpecific_NewDishSubView(
                                allDishFormats: $productModel.pricingPiatto,
                                openUploadFormat: $uploadDishFormat,
                                generalErrorCheck: generalErrorCheck)

                        
                        BottomDialogView {
                            self.infoPiatto()
                        } disableConditions: {
                            self.disableCondition()
                        } secondaryAction: {
                            self.resetAction()
                        } preDialogCheck: {
                            let check = self.checkPreliminare()
                            if check { return check }
                            else {
                                self.generalErrorCheck = true
                                return false
                            }
                        } primaryDialogAction: {
                            self.vbSaveButtonDialogView()
                        }

                        }
                  //  .padding(.horizontal)
     
                    }
                .scrollDismissesKeyboard(.immediately)
   
                HStack {
                    Spacer()
                    Text(productModel.id)
                        
                    Image(systemName: productModel.id == productArchiviato.id ? "equal.circle" : "circle")
                }
                .font(.caption2)
                .foregroundStyle(Color.black)
                .opacity(0.6)
                //.padding(.horizontal)
                
                
           }
            .csHpadding()
            .onChange(of: self.productModel){ _, newValue in
                self.disabilitaPicker = checkDisabilityPicker()
            }
            .onChange(of: self.ingredienteSottostante){ _, newValue in
                self.disabilitaPicker = checkDisabilityPicker()
            }
            .popover(isPresented: $wannaOpenPopOver,attachmentAnchor: .point(.top),arrowEdge: .bottom) {
                
                if let ingredienteSottostante {
                    let sottostante = Binding {
                        ingredienteSottostante
                    } set: { self.ingredienteSottostante = $0 }

                    VistaAllergeni_Selectable(
                        allergeneIn: sottostante.allergeni,
                        backgroundColor: backgroundColorView)
                    .presentationDetents([.fraction(0.85)])
                    //.presentationDetents([.large])
                    
                } else {
                    
                    VistaIngredientiEspansa_Selectable(
                        currentDish: $productModel,
                        backgroundColorView: backgroundColorView,
                        rowViewSize: .normale(700),
                        destinationPath: destinationPath)
                    .presentationDetents([.fraction(0.85)])
                    
                }
                
            }
            .popover(isPresented: $uploadDishFormat,attachmentAnchor: .point(.top)) {
                
                DishFormatUploadLabel(
                    allDishFormat: $productModel.pricingPiatto,
                    backgroundColorView: backgroundColorView)
                .presentationDetents([.fraction(0.60)])

            }
      
       // } // end ZStack Esterno
    }

    // Method

    private func disableCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
        
       let general = self.productModel == self.productArchiviato &&
        self.ingredienteSottostante == self.sottostanteArchiviato
        
        return (general,false,false)
    }
    
    private func checkDisabilityPicker() -> Bool {
        
        self.productModel != self.productArchiviato ||
        self.ingredienteSottostante != self.sottostanteArchiviato
        
    }
    
    private func resetAction() { // Ok
        
        // mod 11.09
        self.productModel = self.productArchiviato
        self.ingredienteSottostante = self.sottostanteArchiviato
       // self.confermaDiete = self.newDish.mostraDieteCompatibili // vedi nota vocale 11.09
   
        // end 11.09
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() { // ok
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
                
        var newProduct:ProductModel = ProductModel()
        var newSottostante:IngredientModel?
        
        let currentDishType = self.productModel.percorsoProdotto.returnTypeCase()
        
        switch currentDishType {
        case .preparazione:
            newSottostante = nil
            newProduct.percorsoProdotto = .preparazione
        case .composizione(_):
            newSottostante = IngredientModel()
            newProduct.percorsoProdotto = .composizione()
            
        case .finito(_):
            newSottostante = IngredientModel()
            newProduct.percorsoProdotto = .finito()
        }

        self.productModel = newProduct
        self.ingredienteSottostante = newSottostante
        
        self.productArchiviato = newProduct
        self.sottostanteArchiviato = newSottostante
    }
    
    private func infoPiatto() -> (breve:Text,estesa:Text) { // Ok
        
        guard let ingredienteSottostante else {
            return (Text("breve_INFOPIATTO"),Text("estesa_INFOPIATTO"))
            
        }
        
       let string = csInfoIngrediente(areAllergeniOk: self.areAllergeniOk, nuovoIngrediente: ingredienteSottostante)
       let stringProduct = self.productModel.percorsoProdotto.simpleDescription()
        
        return (Text("\(self.productModel.intestazione) (\(stringProduct))\n\(string)"),Text("ERROR") )
    }
    
   /* private func infoPiatto() -> Text {
                   
        let allIngredients = self.newDish.allIngredientsAttivi(viewModel: viewModel).map({$0.intestazione})
        let allAllergeni = self.newDish.calcolaAllergeniNelPiatto(viewModel: viewModel).map({$0.intestazione})
        
        let isBio = self.newDish.areAllIngredientBio(viewModel: viewModel) ? "💯Bio" : ""
        let areProdottiCongelati = self.newDish.areAllIngredientFreshOr(viewModel: viewModel) ? "" : "\nPotrebbe contenere ingredienti surgelati/congelati"
        
        return Text("\(self.newDish.intestazione) \(isBio)\nIngredienti (\(allIngredients.count)): \(allIngredients,format: .list(type: .and))\nAllergeni (\(allAllergeni.count)): \(allAllergeni,format: .list(type: .and))\(areProdottiCongelati)")
        
           // !!! Vedi consegna 11.09
        
        // Inserire l'eventuale Contiene prodotti congelati/surgelati
    } */
    
   
    private func checkPreliminare() -> Bool { //Ok
        
        guard checkIntestazione() else {
            self.modelField = .intestazione
            return false }
        
        guard checkDescrizione() else {
            self.modelField = .descrizione
            return false }
        
        guard checkCategoria() else { return false }
      
        guard checkIngredienti() else { return false }
       
        guard checkAllergeni() else { return false }
        
        guard checkFormats() else { return false }
        
        // Ingrediente
        guard checkOrigine() else { return false }
        guard checkConservazione() else { return false }
        
        allConditionSoddisfatte()
 
        return true // Nota 18_11_23
        
    }
    
   /* private func checkNotExistSimilar() -> Bool {
       
        switch self.productModel.percorsoProdotto {

        case .preparazione:
           return check(by: self.productModel)
        case .composizione(_):
            var item = self.productModel
            item.percorsoProdotto = .composizione(ingredienteSottostante)
            return check(by: item)
        case .finito(_):
            if let ingredienteSottostante {
                return check(by: ingredienteSottostante)
            } else { return false }
        }
    }
    
    private func check<T:MyProStarterPack_L1&Codable>(by element:T) -> Bool where T.VM == AccounterVM {
        
        if self.viewModel.checkModelNotInVM(itemModel: element) { return true }
        else {
            self.viewModel.alertItem = AlertModel(
                 title: "Controllare",
                 message: "Hai già creato un Prodotto con questo nome e caratteristiche")
             
           return false
            }
    }*/
    
    private func allConditionSoddisfatte() {
        
        var status:StatusModel = .noStatus
        
        if self.productModel.optionalComplete() {
            status = .completo(.disponibile)
        } else {
            status = .bozza(.disponibile)
        }
        
        if self.productModel.percorsoProdotto.returnTypeCase() == .finito() {
            self.ingredienteSottostante?.status = status
        }
        self.productModel.status = status

    }
    
    private func checkDescrizione() -> Bool {
        
        if self.productModel.percorsoProdotto.returnTypeCase() == .composizione() {
            
            let condition = self.productModel.descrizione == nil ? false : self.productModel.descrizione != ""
            return condition
        }
        return true
    }
    
    private func checkConservazione() -> Bool {
        
        self.ingredienteSottostante?.conservazione != .defaultValue
    }
    
    private func checkOrigine() -> Bool {
        
         self.ingredienteSottostante?.origine != .defaultValue
        
    }
    
    private func checkAllergeni() -> Bool {

        return self.areAllergeniOk
    }
    
    private func checkCategoria() -> Bool {
        
      // return self.newDish.categoriaMenuDEPRECATA != .defaultValue
        return !self.productModel.categoriaMenu.isEmpty
    }
    
    private func checkIngredienti() -> Bool {
        
        guard self.productModel.percorsoProdotto == .preparazione else { return true }
        
        if let ingredientiPrincipali = self.productModel.ingredientiPrincipali {
            
            return !ingredientiPrincipali.isEmpty
            
        } else { return false }
        
    }
    
    private func checkIntestazione() -> Bool {
    
        let intestazione = self.productModel.intestazione
        
        if self.productModel.percorsoProdotto.returnTypeCase() == .finito() {
            self.ingredienteSottostante?.intestazione = intestazione
        }
        
        return intestazione != ""
 
    }
    
    private func checkFormats() -> Bool {
         
        guard self.productModel.pricingPiatto.count > 1 else {
            
            let price = self.productModel.pricingPiatto[0].price
            
            return csCheckDouble(testo: price)
            
        }
        
        for format in self.productModel.pricingPiatto {
            
            if !csCheckStringa(testo: format.label, minLenght: 3) { return false }
            else if !csCheckDouble(testo: format.price) { return false }
            
            }
        return true
      }
    

    
    // ViewBuilder
    
   @ViewBuilder private func vbSaveButtonDialogView() -> some View {

let percorso = self.productModel.percorsoProdotto.returnTypeCase()

switch percorso {
    
case .preparazione:
    managePreparazione()
case .composizione(_):
    manageComposizione()
case .finito(_):
    manageProdottoFinito()
}
}
    
   @ViewBuilder private func managePreparazione() -> some View {
        
        let oldIntestazione = self.productArchiviato.intestazione
        let currentIntestazione = self.productModel.intestazione
       
    csBuilderDialogButton {
        
        // nuova Preparazione
        DialogButtonElement(
            label: .saveNew) {
                oldIntestazione == ""
            } action: {
                
                self.viewModel.createModelOnSub(
                    itemModel: self.productModel)
                
                self.salvaECreaPostAction()
            }
        
        DialogButtonElement(
            label: .saveEsc) {
                oldIntestazione == ""
            } action: {
                self.viewModel.createModelOnSub(
                    itemModel: self.productModel,
                    refreshPath: self.destinationPath)
            }

        // modifica a preparazione esistente
        
        DialogButtonElement(
            label: .saveModEsc) {
                oldIntestazione != ""
                
            } action: {
                self.viewModel.updateModelOnSub(
                    itemModel: self.productModel,
                    refreshPath: self.destinationPath)
            }
        
        DialogButtonElement(
            label: .saveModNew) {
                oldIntestazione != ""
            } action: {
                self.viewModel.updateModelOnSub(
                    itemModel: self.productModel)
                self.salvaECreaPostAction()
            }
        
        // trattasi di modifica che permette il salvataggio come nuovo prodotto
        
        DialogButtonElement(
            label: .saveAsNew,
            extraLabel: "Prodotto") {
                oldIntestazione != "" &&
                currentIntestazione != oldIntestazione
            } action: {
                
                let currentProduct:ProductModel = {
                    var prop = self.productModel
                    prop.id = UUID().uuidString
                    return prop
                }()
                
                self.viewModel.createModelOnSub(
                    itemModel: currentProduct,
                    refreshPath: self.destinationPath)
            }
        
        
        
    }// chiusa result builder
    

    }
    
   @ViewBuilder private func manageComposizione() -> some View {
        
        var currentProduct:ProductModel = {
            
            var prod = self.productModel
            prod.percorsoProdotto = .composizione(ingredienteSottostante)
            return prod
        }()
       
       let customEncoder:Firestore.Encoder = {
            let encoder = Firestore.Encoder()
            encoder.userInfo[IngredientModel.codingInfo] = MyCodingCase.inbound
            return encoder
        }()
  
       csBuilderDialogButton {
           
           // nuova composizione
           
           DialogButtonElement(
               label: .saveNew) {
                   self.productModel.percorsoProdotto.associatedValue() == nil
               } action: {
                   self.viewModel.createModelOnSub(
                       itemModel: currentProduct,
                       encoder: customEncoder)
                   self.salvaECreaPostAction()
               }
           
           DialogButtonElement(
               label: .saveEsc) {
                   self.productModel.percorsoProdotto.associatedValue() == nil
               } action: {
                   self.viewModel.createModelOnSub(
                       itemModel: currentProduct,
                       refreshPath: self.destinationPath,
                       encoder: customEncoder)
               }
           
           // modifica esistente
           
           DialogButtonElement(
               label: .saveModNew) {
                   self.productModel.percorsoProdotto.associatedValue() != nil
               } action: {
                   self.viewModel.updateModelOnSub(
                       itemModel: currentProduct,
                       encoder: customEncoder)
                   self.salvaECreaPostAction()
               }
           
           DialogButtonElement(
               label: .saveModEsc) {
                   self.productModel.percorsoProdotto.associatedValue() != nil
               } action: {
                   self.viewModel.updateModelOnSub(
                       itemModel: currentProduct,
                       refreshPath: self.destinationPath,
                       encoder: customEncoder)
               }
           
           
           // Possibilità di creare uno nuovo da esistente
           
           DialogButtonElement(
               label: .saveAsNew,
               extraLabel: "Prodotto") {
                   (self.productModel.percorsoProdotto.associatedValue() != nil) && self.productModel.intestazione != self.productArchiviato.intestazione
               } action: {
                   
                   let nuovoSottostante:IngredientModel = {
                       var new = self.ingredienteSottostante! // deve esserci
                       new.id = UUID().uuidString
                       return new
                       
                   }()
                   currentProduct.id = UUID().uuidString
                   currentProduct.percorsoProdotto = .composizione(nuovoSottostante)
                   
                   self.viewModel.createModelOnSub(
                       itemModel: currentProduct,
                       refreshPath: self.destinationPath,
                       encoder: customEncoder)
               }

       } // chiude resultBuilder

    }
    
   @ViewBuilder private func manageProdottoFinito() -> some View {
      
       csBuilderDialogButton {
           // Salva come nuovo non abilitato
           // nuovo pF
           DialogButtonElement(
            label: .saveNew) {
                self.productModel.percorsoProdotto.associatedValue() == nil
            } action: {
                manageSaveSottostante(refresh: nil)
                self.salvaECreaPostAction()
            }

           DialogButtonElement(
            label: .saveEsc) {
                self.productModel.percorsoProdotto.associatedValue() == nil
            } action: {
                manageSaveSottostante(refresh: self.destinationPath)
            }
           
           // trattasi di una modifica al rpdotto. Il sosttostante non è stato toccato
           
           DialogButtonElement(
            label: .saveModNew) {
                self.productModel.percorsoProdotto.associatedValue() != nil
            } action: {
                self.viewModel.updateModelOnSub(
                    itemModel: self.productModel)
                self.salvaECreaPostAction()
            }

           DialogButtonElement(
            label: .saveModEsc) {
                self.productModel.percorsoProdotto.associatedValue() != nil
            } action: {
                self.viewModel.updateModelOnSub(
                    itemModel: self.productModel,
                    refreshPath: self.destinationPath)
            }

       }// chiusa result builder
       
}
    
    private func manageSaveSottostante(refresh:DestinationPath?) {
        
        guard let ingredienteSottostante else { return }
        
        Task {
            
            var currentProduct = self.productModel
                
            let idSottostante = ingredienteSottostante.id
                
               try await self.viewModel.createIngredient(item:ingredienteSottostante) { id in
                    
                   if let id {
                       currentProduct.percorsoProdotto = .finito(id)
                       
                   } else {
                       
                       currentProduct.percorsoProdotto = .finito(idSottostante)
                   }
                   
                   self.viewModel.createModelOnSub(
                       itemModel: currentProduct,
                       refreshPath: refresh)

                }

        }
            
    }
}
