//
//  NewDishIbridView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/10/22.
//

import SwiftUI

struct NewDishIbridView: View {

   // @EnvironmentObject var viewModel: AccounterVM
    @Environment(\.openURL) private var openURL
    
    @ObservedObject var viewModel:AccounterVM
    
    @State private var newDish: DishModel
    @State private var ingredienteDiSistema:IngredientModel
    let backgroundColorView: Color
    
    let piattoArchiviato: DishModel // per il reset
    let ingredienteDSArchiviato: IngredientModel
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    
  //  @State private var noIngredientsNeeded: Bool = false //
  //  @State private var wannaAddIngredient: Bool = false //
    
    @State private var areAllergeniOk: Bool = false
    @State private var wannaAddAllergeni: Bool = false
  //  @State private var confermaDiete: Bool
    
    init(newDish: DishModel,percorso:DishModel.PercorsoProdotto, backgroundColorView: Color, destinationPath:DestinationPath, observedVM:AccounterVM) {

        self.viewModel = observedVM
        
        let localDish: DishModel
        let systemIngredient: IngredientModel
 
        if newDish.status == .bozza() {
            
            let newD: DishModel = {
                var new = newDish
                new.ingredientiPrincipali = [newDish.id]
                new.pricingPiatto = [DishFormat(type: .mandatory)]
                new.percorsoProdotto = percorso
                return new
            }()
            localDish = newD
            systemIngredient = IngredientModel(id:newDish.id)
    
        } else {
            localDish = newDish
            systemIngredient = observedVM.modelFromId(id: newDish.id, modelPath: \.allMyIngredients) ?? IngredientModel(id: newDish.id)
            
        }
        
        self.piattoArchiviato = localDish
        self.ingredienteDSArchiviato = systemIngredient
        _newDish = State(wrappedValue: localDish)
        _ingredienteDiSistema = State(wrappedValue: systemIngredient)
       
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath

    }
    
    var body: some View {
       
            VStack {

                    ScrollView { // La View Mobile

                        VStack(alignment:.leading) {
                                
                            IntestazioneNuovoOggetto_Generic(
                                    itemModel: $newDish,
                                    generalErrorCheck: generalErrorCheck,
                                    minLenght: 3,
                                    coloreContainer: Color("SeaTurtlePalette_2"))
 
                            BoxDescriptionModel_Generic(itemModel: $newDish, labelString: "Descrizione (Optional)", disabledCondition: wannaAddAllergeni)
                            
                            CategoriaScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck)
                            
                          
                            Group {   // Innesto
                                
                                OrigineScrollView_NewIngredientSubView(nuovoIngrediente: self.$ingredienteDiSistema, generalErrorCheck: generalErrorCheck)
                                
                                AllergeniScrollView_NewIngredientSubView(
                                    nuovoIngrediente: self.$ingredienteDiSistema,
                                    generalErrorCheck: generalErrorCheck,
                                    areAllergeniOk: $areAllergeniOk,
                                    wannaAddAllergene: $wannaAddAllergeni)
                                
                                ConservazioneScrollView_NewIngredientSubView(
                                    nuovoIngrediente: self.$ingredienteDiSistema,
                                    generalErrorCheck: generalErrorCheck)
                                
                                ProduzioneScrollView_NewIngredientSubView(nuovoIngrediente: self.$ingredienteDiSistema)
                                
                                ProvenienzaScrollView_NewIngredientSubView(nuovoIngrediente: self.$ingredienteDiSistema)
                            } // end Innesti
                           
             
 
                            DietScrollView_NewDishSub(newDish: $newDish,viewModel: viewModel)
 
                            DishSpecific_NewDishSubView(allDishFormats: $newDish.pricingPiatto, generalErrorCheck: generalErrorCheck)
 
                         //   Spacer()
                            
                          /* BottomViewGeneric_NewModelSubView(
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
                                } */
                            BottomViewGenericPlus_NewModelSubView(
                                itemModel: $newDish,
                                itemModelPlus: $ingredienteDiSistema,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: piattoArchiviato,
                                itemModelPlusArchiviato: ingredienteDSArchiviato,
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
                    .opacity(wannaAddAllergeni ? 0.6 : 1.0)
                    .disabled(wannaAddAllergeni)
    
                if wannaAddAllergeni {
           
                    SelettoreMyModel<_,AllergeniIngrediente>(
                        itemModel: $ingredienteDiSistema,
                        allModelList: ModelList.ingredientAllergeniList,
                        closeButton: $wannaAddAllergeni,
                        backgroundColorView: backgroundColorView,
                        actionTitle: "Normativa") {
                            if let url = URL(string: "https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:304:0018:0063:it:PDF") {
                                            openURL(url)
                                        }
                        }
                    
                }
                
     

                HStack {
                    Spacer()
                    Text(newDish.id)
                        
                    Image(systemName: newDish.id == ingredienteDiSistema.id ? "checkmark.circle" : "circle")
                }
                .font(.caption2)
                .foregroundColor(Color.black)
                .opacity(0.6)
                .padding(.horizontal)
                
                
           }
      
       // } // end ZStack Esterno
    }
    
    // Method
    
    private func resetAction() { // Ok
        
        // mod 11.09
        self.newDish = self.piattoArchiviato
        self.ingredienteDiSistema = self.ingredienteDSArchiviato
       // self.confermaDiete = self.newDish.mostraDieteCompatibili // vedi nota vocale 11.09
   
        // end 11.09
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() { // ok
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        (self.newDish,self.ingredienteDiSistema) = {
           var newD = DishModel()
            newD.pricingPiatto = [DishFormat(type: .mandatory)]
            let newIng = IngredientModel(id:newD.id)
            newD.ingredientiPrincipali = [newD.id]
            return (newD,newIng)
        }()
       // self.ingredienteDiSistema = IngredientModel(id:self.newDish.id)
    }
    
    private func infoPiatto() -> Text { // Ok
        
       let string = csInfoIngrediente(areAllergeniOk: self.areAllergeniOk, nuovoIngrediente: self.ingredienteDiSistema)
        
        return Text("\(self.newDish.intestazione) (Prodotto Finito)\n\(string)")
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
        
        guard checkIntestazione() else { return false }
        
        guard checkCategoria() else { return false }
      
      //  guard checkIngredienti() else { return false }
       
        guard checkAllergeni() else { return false }
        
        // Il check della dieta non serve, poichè se non confermato dall'utente, andrà di default sulla dieta standard
        
        guard checkFormats() else { return false }
        
        // Ingrediente
        guard checkOrigine() else { return false }
        guard checkConservazione() else { return false }
        
        //
       
        if allConditionSoddisfatte() {
           
            self.newDish.status = .completo(.disponibile)
            
        } else {
            self.newDish.status = .bozza(.disponibile)
        }
        // l'ingrediente di Sistema resterà al suo status iniziale Bozza(nil) -> 04.10 - Vediamo come gira
       
        return true
        
    }
    
    private func allConditionSoddisfatte() -> Bool {
        
        self.ingredienteDiSistema.produzione != .defaultValue &&
        self.ingredienteDiSistema.provenienza != .defaultValue &&
        self.newDish.optionalComplete()
        
    }
    
    private func checkConservazione() -> Bool {
        
        self.ingredienteDiSistema.conservazione != .defaultValue
    }
    
    private func checkOrigine() -> Bool {
        
         self.ingredienteDiSistema.origine != .defaultValue
        
    }
    
    private func checkAllergeni() -> Bool {

        return self.areAllergeniOk
    }
    
    private func checkCategoria() -> Bool {
        
      // return self.newDish.categoriaMenuDEPRECATA != .defaultValue
        return !self.newDish.categoriaMenu.isEmpty
    }
    
   /* private func checkIngredienti() -> Bool {
        
        guard !self.noIngredientsNeeded else { return true }
        
        return !self.newDish.ingredientiPrincipali.isEmpty
    } */
    
    private func checkIntestazione() -> Bool {
    
        let intestazione = self.newDish.intestazione
        
        self.ingredienteDiSistema.intestazione = "(PF)\(intestazione)"
        return intestazione != ""
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
struct NewDishIbridView_Previews: PreviewProvider {

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
            
            NewDishIbridView(newDish: dishSample, percorso: .prodottoFinito, backgroundColorView: Color("SeaTurtlePalette_1"), destinationPath: .dishList, observedVM: viewModel)
            
        }.environmentObject(viewModel)
    }
}
