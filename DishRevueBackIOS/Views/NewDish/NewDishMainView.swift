//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//  Last deeper Modifing terminate 16.07

import SwiftUI
import MyFoodiePackage

struct NewDishMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    
   // @State private var newDish: DishModel
    @Binding var newDish: DishModel
    let backgroundColorView: Color
    
    @State private var piattoArchiviato: DishModel // per il reset
    let destinationPath: DestinationPath
    let saveDialogType:SaveDialogType
    
    @State private var generalErrorCheck: Bool = false
    
  //  @State private var noIngredientsNeeded: Bool = false
    @State private var wannaAddIngredient: Bool = false
    
    @State private var areAllergeniOk: Bool = false
  //  @State private var confermaDiete: Bool
    @Binding var disabilitaPicker:Bool
    
    init(
        newDish: Binding<DishModel>,
        disabilitaPicker:Binding<Bool>,
       // percorso:DishModel.PercorsoProdotto,// deprecato
        backgroundColorView: Color,
        destinationPath:DestinationPath,
        saveDialogType:SaveDialogType) {
        
           /* let localDish: DishModel = {
               
                if newDish.status == .bozza() {
                    
                    var new = newDish
                    new.percorsoProdotto = percorso
                    return new
                } else { return newDish }
                
            }() */
  
       //_newDish = State(wrappedValue: localDish)
        _newDish = newDish
        _piattoArchiviato = State(wrappedValue: newDish.wrappedValue)

        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
        self.saveDialogType = saveDialogType
        _disabilitaPicker = disabilitaPicker
    }
    
    // Update 10.02.23 DishFormat
     
    @State private var uploadDishFormat:Bool = false
     // update 10.02
    
    // 17.02.23 Focus State
    @FocusState private var modelField:ModelField?
    

    // 17.02
    
    var body: some View {

            VStack {
                
                if disabilitaPicker {
                    ProgressView(value: self.newDish.countProgress) {
                        Text("Completo al: \(self.newDish.countProgress,format: .percent)")
                            .font(.caption)
                    }
                }

                ScrollView(showsIndicators:false) { // La View Mobile

                    VStack(alignment:.leading,spacing: .vStackBoxSpacing) {
                                
                            IntestazioneNuovoOggetto_Generic(
                                    itemModel: $newDish,
                                    generalErrorCheck: generalErrorCheck,
                                    minLenght: 3,
                                    coloreContainer: .seaTurtle_2)
                                .focused($modelField, equals: .intestazione)
 
                            BoxDescriptionModel_Generic(
                                itemModel: $newDish,
                                labelString: "Racconta il \(self.newDish.percorsoProdotto.simpleDescription()) (Optional)",
                                disabledCondition: wannaAddIngredient,
                                modelField: $modelField)
                                .focused($modelField, equals: .descrizione)
                            
                            CategoriaScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck)
                            
                            PannelloIngredienti_NewDishSubView(
                                newDish: newDish,
                                generalErrorCheck: generalErrorCheck,
                                wannaAddIngredient: $wannaAddIngredient)
                                
                            AllergeniScrollView_NewDishSub(newDish: $newDish, generalErrorCheck: generalErrorCheck, areAllergeniOk: $areAllergeniOk)
 
                            DietScrollView_NewDishSub(newDish: $newDish,viewModel: viewModel)
 
                            DishSpecific_NewDishSubView(allDishFormats: $newDish.pricingPiatto, openUploadFormat: $uploadDishFormat, generalErrorCheck: generalErrorCheck)

                            BottomViewGeneric_NewModelSubView(
                                itemModel: $newDish,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: piattoArchiviato,
                                destinationPath: destinationPath,
                                dialogType: self.saveDialogType) {
                                    self.infoPiatto()
                                } resetAction: {
                                    self.resetAction()
                                } checkPreliminare: {
                                    self.checkPreliminare()
                                } salvaECreaPostAction: {
                                    self.salvaECreaPostAction()
                                }

                            
                        }
                       //.padding(.horizontal,.csHlenght)
                    //    .csHpadding()
                        
     
                    }
                .scrollDismissesKeyboard(.immediately)
                  //  .zIndex(0)
                 //  .opacity(wannaAddIngredient ? 0.6 : 1.0)
                  //  .disabled(wannaAddIngredient)

                HStack {
                    
                    Spacer()
                    Text(newDish.id)
                        
                    Image(systemName: newDish.id == piattoArchiviato.id ? "equal.circle" : "circle")
                }
                .font(.caption2)
                .foregroundColor(Color.black)
                .opacity(0.6)
              //  .padding(.horizontal)
                
                
           }
            .csHpadding()
            .onChange(of: self.newDish, perform: { newValue in
                self.disabilitaPicker = newValue != piattoArchiviato
            })
            .popover(isPresented: $wannaAddIngredient,attachmentAnchor: .point(.top)) {
                VistaIngredientiEspansa_Selectable(
                    currentDish: $newDish,
                    backgroundColorView: backgroundColorView,
                    rowViewSize: .normale(700),
                    destinationPath: destinationPath)
                .presentationDetents([.fraction(0.85)])
            }
            .popover(isPresented: $uploadDishFormat,attachmentAnchor: .point(.top)) {
                
                DishFormatUploadLabel(
                    allDishFormat: $newDish.pricingPiatto,backgroundColorView: backgroundColorView)
                .presentationDetents([.fraction(0.60)])

                
            }
         
       // } // end ZStack Esterno
    }
    
    // Method
    
    private func resetAction() {
                
        self.newDish = self.piattoArchiviato
       // self.confermaDiete = self.newDish.mostraDieteCompatibili // vedi nota vocale 11.09
   
        // end 11.09
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
    }
    
    private func salvaECreaPostAction() {
        
        self.generalErrorCheck = false
        self.areAllergeniOk = false
        
        let new:DishModel = {
            let currentDishType = self.newDish.percorsoProdotto
            var dish = DishModel()
            dish.percorsoProdotto = currentDishType
            return dish
        }()
        
        self.newDish = new
        self.piattoArchiviato = new // Nota 26.06.23

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
        
        guard checkIntestazione() else {
            self.modelField = .intestazione
            return false }
        
        guard checkCategoria() else {
            return false }
      
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
       // return !self.newDish.categoriaMenu.isEmpty
        return self.newDish.categoriaMenu != CategoriaMenu.defaultValue.id
    }
    
    private func checkIngredienti() -> Bool {
        
      //  guard !self.noIngredientsNeeded else { return true }
        
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

/*
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
      //  dish.pricingPiatto = [dishPrice]
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
       // return viewM
        return testAccount
    }()
    
    static var previews: some View {
        
        NavigationStack {
            
            NewDishMainView(newDish: dishSample, percorso: .preparazioneFood, backgroundColorView: Color.seaTurtle_1, destinationPath: .dishList,saveDialogType: .completo)
            
        }.environmentObject(viewModel)
    }
}*/
