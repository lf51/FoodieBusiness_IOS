//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//  Last deeper Modifing terminate 16.07

import SwiftUI

struct NewDishMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @State private var newDish: DishModel
    let backgroundColorView: Color
    
    let piattoArchiviato: DishModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    
    @State private var noIngredientsNeeded: Bool = false
    @State private var wannaAddIngredient: Bool = false
    
    @State private var areAllergeniOk: Bool = false
  //  @State private var confermaDiete: Bool
    
    init(newDish: DishModel,percorso:DishModel.PercorsoProdotto,backgroundColorView: Color, destinationPath:DestinationPath) {

        let localDish: DishModel
        
        if newDish.pricingPiatto.isEmpty {
            
            let newD: DishModel = {
                var new = newDish
                new.percorsoProdotto = percorso
                new.pricingPiatto = [DishFormat(type: .mandatory)]
                return new
            }()
            localDish = newD
    
        } else { localDish = newDish }
        
        _newDish = State(wrappedValue: localDish)
   
        self.piattoArchiviato = localDish

        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
    }
    
    var body: some View {
       
      //  CSZStackVB(title: self.newDish.intestazione == "" ? "Nuovo Piatto" : self.newDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {

             //   CSDivider()
                    
                    ScrollView { // La View Mobile

                        VStack(alignment:.leading) {
                                
                            IntestazioneNuovoOggetto_Generic(
                                    itemModel: $newDish,
                                    generalErrorCheck: generalErrorCheck,
                                    minLenght: 3,
                                    coloreContainer: Color("SeaTurtlePalette_2"))
 
                            BoxDescriptionModel_Generic(itemModel: $newDish, labelString: "Descrizione (Optional)", disabledCondition: wannaAddIngredient)
                            
                            CategoriaScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck)
                            
                            PannelloIngredienti_NewDishSubView(
                                newDish: newDish,
                                generalErrorCheck: generalErrorCheck,
                                wannaAddIngredient: $wannaAddIngredient,
                                noIngredientsNeeded: $noIngredientsNeeded)
                                
                            AllergeniScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck, areAllergeniOk: $areAllergeniOk)
 
                            DietScrollView_NewDishSub(newDish: $newDish,viewModel: viewModel)
 
                            DishSpecific_NewDishSubView(allDishFormats: $newDish.pricingPiatto, generalErrorCheck: generalErrorCheck)
 
                         //   Spacer()
                            
                            BottomViewGeneric_NewModelSubView(
                                itemModel: $newDish,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: piattoArchiviato,
                                destinationPath: destinationPath) {
                                    self.infoPiatto()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }

                            
                        }
                    .padding(.horizontal)
     
                    }
                    .zIndex(0)
                    .opacity(wannaAddIngredient ? 0.6 : 1.0)
                    .disabled(wannaAddIngredient)
    
                if wannaAddIngredient {
           
                   /* SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient, action: () -> Void) */
                    
                    SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient,
                        backgroundColorView: backgroundColorView,
                        actionTitle: "[+] Ingrediente") {
                            
                            viewModel.addToThePath(
                                destinationPath: destinationPath,
                                destinationView: .ingrediente(IngredientModel()))
                            
                        }
                    
                }
            
             //   CSDivider() // risolve il problema del cambio colore della tabView
            //    } // end ZStack Interno

                HStack {
                    Spacer()
                    Text(newDish.id)
                        
                    Image(systemName: newDish.id == piattoArchiviato.id ? "checkmark.circle" : "circle")
                }
                .font(.caption2)
                .foregroundColor(Color.black)
                .opacity(0.6)
                .padding(.horizontal)
                
                
           }
      
       // } // end ZStack Esterno
    }
    
    // Method
    
    private func resetAction() {
        
        // mod 11.09
        self.newDish = self.piattoArchiviato
       // self.confermaDiete = self.newDish.mostraDieteCompatibili // vedi nota vocale 11.09
   
        // end 11.09
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        self.newDish = {
           var newD = DishModel()
            newD.pricingPiatto = [DishFormat(type: .mandatory)]
            return newD
        }()
    }
    
    private func infoPiatto() -> Text {
                   
        let allIngredients = self.newDish.allIngredientsAttivi(viewModel: viewModel).map({$0.intestazione})
        let allAllergeni = self.newDish.calcolaAllergeniNelPiatto(viewModel: viewModel).map({$0.intestazione})
     /* // Mod 19.10
        let isBio = self.newDish.areAllIngredientBio(viewModel: viewModel) ? "💯Bio" : ""
        let areProdottiCongelati = self.newDish.areAllIngredientFreshOr(viewModel: viewModel) ? "" : "\nPotrebbe contenere ingredienti surgelati/congelati"
        */
        
        let isBio = self.newDish.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality:.biologico) ? "💯Bio" : ""
        let areProdottiCongelati = self.newDish.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.conservazione, quality: .altro) ? "" : "\nPotrebbe contenere ingredienti surgelati/congelati"
        // end modifiche 19.10
        
        return Text("\(self.newDish.intestazione) \(isBio)\nIngredienti (\(allIngredients.count)): \(allIngredients,format: .list(type: .and))\nAllergeni (\(allAllergeni.count)): \(allAllergeni,format: .list(type: .and))\(areProdottiCongelati)")
        
           // !!! Vedi consegna 11.09
        
        // Inserire l'eventuale Contiene prodotti congelati/surgelati
    }
    
   
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else { return false }
        
        guard checkCategoria() else { return false }
      
        guard checkIngredienti() else { return false }
       
        guard checkAllergeni() else { return false }
        
        // Il check della dieta non serve, poichè se non confermato dall'utente, andrà di default sulla dieta standard
        
        guard checkFormats() else { return false }
       
        if self.newDish.optionalComplete() { self.newDish.status = .completo(.disponibile)}
        else { self.newDish.status = .bozza(.disponibile) }
       
        return true
        
    }
    
    private func checkAllergeni() -> Bool {

        return self.areAllergeniOk
    }
    
    private func checkCategoria() -> Bool {
        
      // return self.newDish.categoriaMenuDEPRECATA != .defaultValue
        return !self.newDish.categoriaMenu.isEmpty
    }
    
    private func checkIngredienti() -> Bool {
        
        guard !self.noIngredientsNeeded else { return true }
        
        return !self.newDish.ingredientiPrincipali.isEmpty
    }
    
    private func checkIntestazione() -> Bool {
    
        return self.newDish.intestazione != ""
        // i controlli sono già eseguiti all'interno sulla proprietà temporanea, se il valore è stato passato al newDish vuol dire che è buono. Per cui basta controllare se l'intestazione è diversa dal valore vuoto

    }
    
    private func checkFormats() -> Bool {
         
        guard self.newDish.pricingPiatto.count > 1 else {
            
            let price = self.newDish.pricingPiatto[0].price
            
            return csCheckDouble(testo: price)
            
        }
        
        for format in self.newDish.pricingPiatto {
            
            if !csCheckStringa(testo: format.label, minLenght: 3) { return false }
            else if !csCheckDouble(testo: format.price) { return false }
            
            }
        return true
      }
    
   
}
struct NewDishMainView_Previews: PreviewProvider {

    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.inPausa)
        
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Tuorlo d'Uovo",
        descrizione: "",
        conservazione: .surgelato,
        produzione: .biologico,
        provenienza: .italia,
        allergeni: [.uova_e_derivati],
        origine: .animale,
        status: .completo(.disponibile)
       
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .bozza(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Pecorino D.O.P",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza(.inPausa)
       )
    
    static let dishSample:DishModel = {
       var dish = DishModel()
        dish.intestazione = "Trofie al Pesto"
        let dishPrice:DishFormat = {
            var price = DishFormat(type: .mandatory)
            price.price = "12.5"
            return price
        }()
        dish.pricingPiatto = [dishPrice]
        dish.mostraDieteCompatibili = true
       // dish.categoriaMenu = CategoriaMenu(nome: "PortataTest")
        dish.status = .bozza(.disponibile)
     
        dish.ingredientiPrincipali = [ingredientSample.id]
        dish.ingredientiSecondari = [ingredientSample3.id,ingredientSample4.id]
        dish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample2.id]
        return dish
        
    }()
    
    @StateObject static var viewModel:AccounterVM = {
   
      var viewM = AccounterVM()
        viewM.allMyDish = [dishSample]
        viewM.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
        return viewM
    }()
    
    static var previews: some View {
        
        NavigationStack {
            
            NewDishMainView(newDish: dishSample, percorso: .preparazioneFood, backgroundColorView: Color("SeaTurtlePalette_1"), destinationPath: .dishList)
            
        }.environmentObject(viewModel)
    }
}
/* // BackUp 04.10
struct NewDishMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
    @State private var newDish: DishModel
    let backgroundColorView: Color
    
    let piattoArchiviato: DishModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    
    @State private var noIngredientsNeeded: Bool = false
    @State private var wannaAddIngredient: Bool = false
    
    @State private var areAllergeniOk: Bool = false
  //  @State private var confermaDiete: Bool
    
    init(newDish: DishModel,backgroundColorView: Color, destinationPath:DestinationPath) {
        
        // modifiche 11.09
        let localDish: DishModel
        
        if newDish.pricingPiatto.isEmpty {
            
            let newD: DishModel = {
                var new = newDish
                new.pricingPiatto = [DishFormat(type: .mandatory)]
                return new
            }()
            localDish = newD
           // _newDish = State(wrappedValue: newD)
           // self.piattoArchiviato = newD
        } else { localDish = newDish }
        
        _newDish = State(wrappedValue: localDish)
      //  _confermaDiete = State(wrappedValue: localDish.mostraDieteCompatibili)
        self.piattoArchiviato = localDish
       
       /* let newD: DishModel = {
            var new = newDish
            if new.pricingPiatto.isEmpty {new.pricingPiatto = [DishFormat(type: .mandatory)]}
            return new
        }()
        _newDish = State(wrappedValue: newD)
        self.piattoArchiviato = newD
        */
        // end 11.09
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
    }
    
    var body: some View {
       
        CSZStackVB(title: self.newDish.intestazione == "" ? "Nuovo Piatto" : self.newDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {

                CSDivider()
                    
                    ScrollView { // La View Mobile

                        VStack(alignment:.leading) {
                                
                            IntestazioneNuovoOggetto_Generic(
                                    itemModel: $newDish,
                                    generalErrorCheck: generalErrorCheck,
                                    minLenght: 3,
                                    coloreContainer: Color("SeaTurtlePalette_2"))
 
                            BoxDescriptionModel_Generic(itemModel: $newDish, labelString: "Descrizione (Optional)", disabledCondition: wannaAddIngredient)
                            
                            CategoriaScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck)
                            
                            PannelloIngredienti_NewDishSubView(
                                newDish: newDish,
                                generalErrorCheck: generalErrorCheck,
                                wannaAddIngredient: $wannaAddIngredient,
                                noIngredientsNeeded: $noIngredientsNeeded)
                                
                            AllergeniScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck, areAllergeniOk: $areAllergeniOk, viewModel: viewModel)
 
                            DietScrollView_NewDishSub(newDish: $newDish,viewModel: viewModel)
 
                            DishSpecific_NewDishSubView(allDishFormats: $newDish.pricingPiatto, generalErrorCheck: generalErrorCheck)
 
                         //   Spacer()
                            
                            BottomViewGeneric_NewModelSubView(
                                itemModel: $newDish,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: piattoArchiviato,
                                destinationPath: destinationPath) {
                                    self.infoPiatto()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }

                                    
                         /*   BottomViewGeneric_NewModelSubView(generalErrorCheck:$generalErrorCheck, wannaDisableButtonBar:(newDish == piattoArchiviato)) {
                                infoPiatto()
                            } resetAction: {
                                csResetModel(modelAttivo: &self.newDish, modelArchiviato: self.piattoArchiviato)
                            } checkPreliminare: {
                                checkPreliminare()
                            } saveButtonDialogView: {
                                vbScheduleANewDish()
                            } */
                            
                        }
                    .padding(.horizontal)
     
                    }
                    .zIndex(0)
                    .opacity(wannaAddIngredient ? 0.6 : 1.0)
                    .disabled(wannaAddIngredient)
    
                if wannaAddIngredient {
           
                   /* SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient, action: () -> Void) */
                    
                    SelettoreMyModel<_,IngredientModel>(
                        itemModel: $newDish,
                        allModelList: ModelList.dishIngredientsList,
                        closeButton: $wannaAddIngredient,
                        backgroundColorView: backgroundColorView,
                        actionTitle: "[+] Ingrediente") {
                            
                            viewModel.addToThePath(
                                destinationPath: destinationPath,
                                destinationView: .ingrediente(IngredientModel()))
                            
                        }
                    
                }
            
             //   CSDivider() // risolve il problema del cambio colore della tabView
            //    } // end ZStack Interno

                HStack {
                    Spacer()
                    Text(newDish.id)
                        
                    Image(systemName: newDish.id == piattoArchiviato.id ? "checkmark.circle" : "circle")
                }
                .font(.caption2)
                .foregroundColor(Color.black)
                .opacity(0.6)
                .padding(.horizontal)
                
                
            }
      
        } // end ZStack Esterno
    }
    
    // Method
    
    private func resetAction() {
        
        // mod 11.09
        self.newDish = self.piattoArchiviato
       // self.confermaDiete = self.newDish.mostraDieteCompatibili // vedi nota vocale 11.09
   
        // end 11.09
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        self.newDish = {
           var newD = DishModel()
            newD.pricingPiatto = [DishFormat(type: .mandatory)]
            return newD
        }()
    }
    
    private func infoPiatto() -> Text {
                   
        let allIngredients = self.newDish.allIngredientsAttivi(viewModel: viewModel).map({$0.intestazione})
        let allAllergeni = self.newDish.calcolaAllergeniNelPiatto(viewModel: viewModel).map({$0.intestazione})
        
        let isBio = self.newDish.areAllIngredientBio(viewModel: viewModel) ? "💯Bio" : ""
        let areProdottiCongelati = self.newDish.areAllIngredientFreshOr(viewModel: viewModel) ? "" : "\nPotrebbe contenere ingredienti surgelati/congelati"
        
        return Text("\(self.newDish.intestazione) \(isBio)\nIngredienti (\(allIngredients.count)): \(allIngredients,format: .list(type: .and))\nAllergeni (\(allAllergeni.count)): \(allAllergeni,format: .list(type: .and))\(areProdottiCongelati)")
        
           // !!! Vedi consegna 11.09
        
        // Inserire l'eventuale Contiene prodotti congelati/surgelati
    }
    
   /* private func infoPiatto() -> Text {
           
        var stringIngredientiPrincipali:[String] = []
        var stringIngredientiSecondari:[String] = []
        var stringAllergeni:[String] = []
        
        var stringValueAllergeni = "Nessun allergene indicato negli ingredienti."
        
        for idIngredient in self.newDish.ingredientiPrincipali {
            
            if let stringValue = self.viewModel.nomeIngredienteFromId(id: idIngredient) {
                stringIngredientiPrincipali.append(stringValue)
            }
        }
        
        for ingredient in self.newDish.ingredientiSecondari {
            
            if let stringValue = self.viewModel.nomeIngredienteFromId(id: ingredient) {
                stringIngredientiSecondari.append(stringValue)
            }
        }
        
        if !self.newDish.allergeni.isEmpty {
            
            for allergene in self.newDish.allergeni {
                
                let stringValue = allergene.simpleDescription()
                stringAllergeni.append(stringValue)
                
            }
            stringValueAllergeni = "Indicata la presenza degli allergeni:"
        }
        
        return Text("\(self.newDish.intestazione)\n\(stringIngredientiPrincipali,format: .list(type: .and))\n\(stringValueAllergeni) \(stringAllergeni,format: .list(type: .and))")
            
           
    } */ // BackUp 11.09
    
 /*   private func infoPiatto() -> Text {
           
        var stringIngredientiPrincipali:[String] = []
        var stringIngredientiSecondari:[String] = []
        var stringAllergeni:[String] = []
        
        var stringValueAllergeni = "Nessun allergene indicato negli ingredienti."
        
        for ingredient in self.newDish.ingredientiPrincipaliDEPRECATO {
            
            let stringValue = ingredient.intestazione
            stringIngredientiPrincipali.append(stringValue)
            
        }
        
        for ingredient in self.newDish.ingredientiSecondariDEPRECATO {
            
            let stringValue = ingredient.intestazione
            stringIngredientiSecondari.append(stringValue)
            
        }
        
        if !self.newDish.allergeni.isEmpty {
            
            for allergene in self.newDish.allergeni {
                
                let stringValue = allergene.simpleDescription()
                stringAllergeni.append(stringValue)
                
            }
            stringValueAllergeni = "Indicata la presenza degli allergeni:"
        }
        
        return Text("\(self.newDish.intestazione)\n\(stringIngredientiPrincipali,format: .list(type: .and))\n\(stringValueAllergeni) \(stringAllergeni,format: .list(type: .and))")
            
           
    } */ // Deprecata 25.08
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else { return false }
        
        guard checkCategoria() else { return false }
      
        guard checkIngredienti() else { return false }
       
        guard checkAllergeni() else { return false }
        
        // Il check della dieta non serve, poichè se non confermato dall'utente, andrà di default sulla dieta standard
        
        guard checkFormats() else { return false }
       
        if self.newDish.optionalComplete() { self.newDish.status = .completo(.disponibile)}
        else { self.newDish.status = .bozza(.disponibile) }
       
        return true
        
    }
    
    private func checkAllergeni() -> Bool {

        return self.areAllergeniOk
    }
    
    private func checkCategoria() -> Bool {
        
      // return self.newDish.categoriaMenuDEPRECATA != .defaultValue
        return !self.newDish.categoriaMenu.isEmpty
    }
    
    private func checkIngredienti() -> Bool {
        
        guard !self.noIngredientsNeeded else { return true }
        
        return !self.newDish.ingredientiPrincipali.isEmpty
    }
    
    private func checkIntestazione() -> Bool {
    
        return self.newDish.intestazione != ""
        // i controlli sono già eseguiti all'interno sulla proprietà temporanea, se il valore è stato passato al newDish vuol dire che è buono. Per cui basta controllare se l'intestazione è diversa dal valore vuoto

    }
    
    private func checkFormats() -> Bool {
         
        guard self.newDish.pricingPiatto.count > 1 else {
            
            let price = self.newDish.pricingPiatto[0].price
            
            return csCheckDouble(testo: price)
            
        }
        
        for format in self.newDish.pricingPiatto {
            
            if !csCheckStringa(testo: format.label, minLenght: 3) { return false }
            else if !csCheckDouble(testo: format.price) { return false }
            
            }
        return true
      }
    
    /*
     @ViewBuilder private func vbScheduleANewDish() -> some View {
         
         if self.piattoArchiviato.intestazione == "" {
             // crea un Nuovo Oggetto
             Group {
                 
                 Button("Salva e Crea Nuovo", role: .none) {
                     
                 self.viewModel.createItemModel(itemModel: self.newDish)
                 self.newDish = DishModel()
                     
                 }
                 
                 Button("Salva ed Esci", role: .none) {
                     
                 self.viewModel.createItemModel(itemModel: self.newDish,destinationPath: destinationPath)
                 }

             }
         }
         
         else if self.piattoArchiviato.intestazione == self.newDish.intestazione {
             // modifica l'oggetto corrente
             
             Group { vbEditingSaveButton() }
         }
         
         else {
             
             Group {
                 
                 vbEditingSaveButton()
                 
                 Button("Salva come Nuovo Piatto", role: .none) {
                     
                 self.viewModel.createItemModel(itemModel: self.newDish,destinationPath: destinationPath)
                 }
             }
         }
     }
     
     @ViewBuilder private func vbEditingSaveButton() -> some View {
         
         Button("Salva Modifiche e Crea Nuovo", role: .none) {
             
         self.viewModel.updateItemModel(itemModel: self.newDish)
         self.newDish = DishModel()
         }
         
         Button("Salva Modifiche ed Esci", role: .none) {
             
         self.viewModel.updateItemModel(itemModel: self.newDish, destinationPath: destinationPath)
         }
         
         
     }
     */
} */ // BackUp 04.10 - Modifiche per switch con Ibrido Piatto/Ingrediente







