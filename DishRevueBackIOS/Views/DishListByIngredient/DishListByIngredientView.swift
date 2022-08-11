//
//  DishListByIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/08/22.
//

import SwiftUI

struct DishListByIngredientView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let nomeIngredienteCorrente: String
    let backgroundColorView: Color
    let idIngredienteCorrente: String
    let destinationPath: DestinationPath
    
   // @State private var idSostitutoGlobale: String? = nil // id
    @State private var modelSostitutoGlobale: IngredientModel? = nil
    @State private var isBeenAChoice: Bool = false
    @State private var showInfo: Bool = false
    
    @State private var dishWithIngredient:[DishModel] = []
    
    
    init(ingredientModelCorrente: IngredientModel, destinationPath:DestinationPath, backgroundColorView: Color) {
        
        self.nomeIngredienteCorrente = ingredientModelCorrente.intestazione
        self.backgroundColorView = backgroundColorView
        self.idIngredienteCorrente = ingredientModelCorrente.id
        self.destinationPath = destinationPath
     
    }

    
    @State private var change:Int = 0 // test
    
    var body: some View {
        
        CSZStackVB(title: "Cambio Temporaneo", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                let mapArray = self.viewModel.ingredientsFilteredByIngredient(idIngredient: idIngredienteCorrente).allMinusThat
                
                PickerSostituzioneIngrediente_SubView(mapArray: mapArray, modelSostitutoGlobale: $modelSostitutoGlobale)
                
              //  CSDivider()
                Text("Change: \(self.change)")
                //
                
                ScrollView(showsIndicators: false) {
                    
                    ForEach($dishWithIngredient) { $dish in
                  
                       /* let (isThereChoice,idSostitutoGlobaleChecked,nomeSostitutoGlobale) = self.checkSostitutoGlobale(currentDish: dish)*/
                        let (modelSostitutoGlobaleChecked,nomeSostitutoGlobale) = self.checkSostitutoGlobale(currentDish: dish)
                        
                        DishChangingIngredient_RowSubView(
                            dish:$dish,
                            nomeIngredienteCorrente: self.nomeIngredienteCorrente,
                            modelSostitutoGlobale: modelSostitutoGlobaleChecked,
                            isThereChoice: isBeenAChoice,
                            nomeSostitutoGlobale: nomeSostitutoGlobale,
                            idIngredienteCorrente: self.idIngredienteCorrente,
                            mapArray: mapArray).id(self.modelSostitutoGlobale)
                        //.id(self.isBeenAChoice)
                        //.id(self.modelSostitutoGlobale)
                        // l'uso dell'id è una soluzione trovata grazie all'overradeStateTEST per permettere l'aggiornamento della view sottostante
                    }
                }
       
             Spacer()
                
            BottomView_DLBIVSubView(
                destinationPath: self.destinationPath) {
                    self.description()
                } resetAction: {
                    self.resetAction()
                } saveAction: {
                    self.saveAction()
                }
                
            }
            .disabled(showInfo)
            .padding(.horizontal)
            
            if showInfo {
                
                VStack {
                    
                    Spacer()
                    
                    Text("Per ragioni di carenza temporanea, l'utente ha la facoltà qui di sostituire temporaneamente, ma senza limiti di tempo, un ingrediente con un altro.\n\nNella lista ingredienti di ciascun piatto saranno così visualizzati entrambi gli elementi, l'ingrediente sostituito e il sostituto, fino a quando l'utente, tornato nuovamente disponibile l'ingrediente carente, non provvederà manualmente ad annullare la sostituzione.\n\nIl cambio può essere unico, ossia un solo sostituto per tutti i piatti, oppure può essere scelto un sostituto differente per ogni piatto.")
                        .font(.body)
                        .fontWeight(.bold)
                        .lineSpacing(10.0)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(Color.black)
                                .opacity(0.8)
                               
                        )
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }.padding(.horizontal)
            }

            
            
        }
        /*.onChange(of: self.modelSostitutoGlobale, perform: { newValue in
            
            if newValue != nil {self.isBeenAChoice = true}
            
        }) */
        .onChange(of: self.dishWithIngredient, perform: { _ in
            
            self.change += 1 // test
            // il cambiamento nei piatti viene visto, possiamo provare a usare questo per gestire l'input "isThereAChange" per variare le descrizioni e sistemare il reset
            
        })
        .onAppear {
            self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: idIngredienteCorrente)
          
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    self.showInfo.toggle()
                } label: {

                        Text(showInfo ? "Chiudi Info" : "Vedi Info")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("SeaTurtlePalette_3"))
      
                }

            }
        }

        
        
    }
    
    // method
 
    private func description() -> Text {
        
       let dishCount = self.dishWithIngredient.count
       var dishModified = 0
        
        for dish in self.dishWithIngredient {
           
          /*  if dish.sostituzioneIngredientiTemporanea[self.idIngredienteCorrente] != "" { dishModified += 1 } */
            for (key,value) in dish.elencoIngredientiOff {
                
                if key == self.idIngredienteCorrente && value != nil {dishModified += 1}
                
            }
            
            
         //   if dish.elencoIngredientiOff[self.idIngredienteCorrente] != nil {dishModified += 1}
            
        }
        
        let string = dishModified == 1 ? "piatto" : "piatti"
        let string2 = dishModified == dishCount ? "" : "Dove non indicato, l'ingrediente \(self.nomeIngredienteCorrente) sarà mostrato tagliato e senza un sostituto. "
        
        return Text("Per l'ingrediente \(self.nomeIngredienteCorrente) è stato indicato un sostituto in \(dishModified) \(string) su \(dishCount).\n\(string2)")
    }
    
    private func saveAction() {
        
        for dish in self.dishWithIngredient {
            
            self.viewModel.updateItemModel(itemModel: dish)
            
        }
        self.viewModel.refreshPath(destinationPath: self.destinationPath)
        
    }
    
    private func resetAction() {
        
      //  self.modelSostitutoGlobale = self.modelSostitutoGlobale == "" ? nil : ""
       /* self.modelSostitutoGlobale = self.modelSostitutoGlobale != nil ? self.modelSostitutoGlobale : nil */
        
        self.modelSostitutoGlobale = nil
        self.isBeenAChoice = false
        self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: idIngredienteCorrente)
        
        // Spiegato il funzionamento in Nota Vocale il 10.08
    }
    
    private func checkSostitutoGlobale(currentDish: DishModel) ->(model:IngredientModel?,nome:String) {
        
        guard self.modelSostitutoGlobale != nil else { return (nil,"") }
       // guard self.idSostitutoGlobale != "" else { return (false,"","") }
        
        let checkIn = currentDish.checkIngredientsIn(idIngrediente: self.modelSostitutoGlobale!.id)
        let nameSostitutoGlobale = self.modelSostitutoGlobale!.intestazione
        
        if checkIn { return (nil,nameSostitutoGlobale)}
        else { return (self.modelSostitutoGlobale!,nameSostitutoGlobale)}
        
    }
    
  /*  private func checkSostitutoGlobale(currentDish: DishModel) ->(choice:Bool,id:String,nome:String) {
        
        guard self.modelSostitutoGlobale != nil && self.modelSostitutoGlobale != "" else { return (false,"","") }
       // guard self.idSostitutoGlobale != "" else { return (false,"","") }
        
        let checkIn = currentDish.checkIngredientsIn(idIngrediente: self.modelSostitutoGlobale!)
        let nameSostitutoGlobale = self.viewModel.findModelFromId(id: self.modelSostitutoGlobale!)
        
        if checkIn { return (true, "",nameSostitutoGlobale)}
        else { return (true,self.modelSostitutoGlobale!,nameSostitutoGlobale)}
        
    } */
}

struct DishListByIngredientView_Previews: PreviewProvider {
    
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .carneAnimale,
        status: .completo(.archiviato),
        idIngredienteDiRiserva: "merluzzo"
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .pesce,
        status: .completo(.inPausa),
        idIngredienteDiRiserva: "guancialenero"
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .completo(.pubblico))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .latteAnimale,
        status: .vuoto,
        idIngredienteDiRiserva: "basilico")
    
    
    static var dishItem: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Spaghetti alla Carbonara"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample,ingredientSample2]
        newDish.ingredientiSecondari = [ingredientSample3,ingredientSample4]
        
        return newDish
    }()
    
    static var dishItem2: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Trofie al Pesto"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample3]
        newDish.ingredientiSecondari = [ingredientSample,ingredientSample4]
      //  newDish.sostituzioneIngredientiTemporanea = ["guancialenero":"Prezzemolo"]
        
        return newDish
    }()
    
    static var dishItem3: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4,ingredientSample]
        newDish.ingredientiSecondari = [ingredientSample2]
        
        return newDish
    }()

    
    @StateObject static var viewModel:AccounterVM = {
   
      var viewM = AccounterVM()
        viewM.allMyDish = [dishItem,dishItem2,dishItem3]
        viewM.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4 ]
        return viewM
    }()
    
    static var previews: some View {
        NavigationStack {
            
            DishListByIngredientView(ingredientModelCorrente: ingredientSample3, destinationPath: DestinationPath.ingredientList, backgroundColorView: Color("SeaTurtlePalette_1"))
                
        }.environmentObject(viewModel)
    }
}

struct DishChangingIngredient_RowSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    // @State private var dish: DishModel
    @Binding var dish: DishModel
    
    let nomeIngredienteCorrente: String
    //   let idSostitutoGlobale: String  // id del sostituto globale che viene passato
    let modelSostitutoGlobale: IngredientModel?
    let isThereChoice: Bool
    let nomeSostitutoGlobale: String
    let idIngredienteCorrente: String
    let mapArray: [IngredientModel]
    
    //  @State private var nomeSostituto: String = "" // il sostituto del singolo piatto
    
    init(dish: Binding<DishModel>, nomeIngredienteCorrente: String, modelSostitutoGlobale: IngredientModel?, isThereChoice:Bool,nomeSostitutoGlobale:String, idIngredienteCorrente: String, mapArray:[IngredientModel]) {
        
        // _dish = State(wrappedValue: dish)
        _dish = dish
        
        self.nomeIngredienteCorrente = nomeIngredienteCorrente
        // self.idSostitutoGlobale = idSostitutoGlobale
        self.modelSostitutoGlobale = modelSostitutoGlobale
        self.isThereChoice = isThereChoice
        self.nomeSostitutoGlobale = nomeSostitutoGlobale
        self.idIngredienteCorrente = idIngredienteCorrente
        self.mapArray = mapArray
        
    }
    
    @State private var changeLocal: Int = 0 // test
    
    var body: some View {
        
        VStack(alignment:.leading) {
            Text("Choice: \(isThereChoice.description)")
            Text("model: \(self.modelSostitutoGlobale?.intestazione ?? "nil")")
            Text("ChangeLocal: \(changeLocal)")
            HStack {
                
                dish.returnModelRowView()
                    .overlay(alignment: .bottomTrailing) {
                        
                        Menu {
                            
                            ForEach(mapArray,id:\.self) { ingredient in
                                
                                //  let (isIngredientIn,isIngredientSelected) = isInAndSelected(idIngredient: ingredient.id)
                                let (isIngredientIn,isIngredientSelected) = isInAndSelected(ingredientModel: ingredient)
                                
                                Button {
                                    self.action(isIngredientSelected: isIngredientSelected, ingredient: ingredient)
                                } label: {
                                    HStack {
                                        Text(ingredient.intestazione)
                                            .foregroundColor(Color.black)
                                        
                                        Image(systemName: isIngredientSelected ? "checkmark.circle" : "circle")
                                        
                                    }
                                }.disabled(isIngredientIn)
                            }
                            
                        } label: {
                            Image(systemName: "arrow.left.arrow.right.circle")
                                .imageScale(.large)
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                            
                        }.offset(x:10,y:15)
                    }
                
                Spacer()
                
                // spazio disponibile in orizzontale || lasciato per motivi di allineamento che saltava, può eventuale tornare utile per inserirci qualcosa che al momento non so.
                
            }.padding(.vertical,5)
            
            descriptionSostituzioneIngrediente()
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.leading)
            
            
        }
        .onChange(of: dish, perform: { _ in
            self.changeLocal += 1 // test
        })
        .onAppear{
            
            /*   if self.modelSostitutoGlobale != nil {
             self.dish.elencoIngredientiOff[idIngredienteCorrente] = self.modelSostitutoGlobale
             } else {
             self.dish.elencoIngredientiOff[idIngredienteCorrente] = nil
             } */
            self.dish.elencoIngredientiOff[idIngredienteCorrente] = self.modelSostitutoGlobale
            
            
            
            //   self.dish.sostituzioneIngredientiTemporanea[idIngredienteCorrente] = idSostitutoGlobale
        }
        
    }
    
    // Method
    
    private func action(isIngredientSelected:Bool,ingredient:IngredientModel) {
        
        guard self.dish.elencoIngredientiOff[self.idIngredienteCorrente] != nil else { return }
        
        
        self.dish.elencoIngredientiOff[self.idIngredienteCorrente] = isIngredientSelected ? nil : ingredient
        //  self.isThereChoice += 1
    }
    
    private func isInAndSelected(ingredientModel: IngredientModel) -> (isIn:Bool,isSelect:Bool) {
        
        let isIngredientIn = self.dish.checkIngredientsIn(idIngrediente: ingredientModel.id)
        //   let isIngredientSelected = self.dish.sostituzioneIngredientiTemporanea[idIngredienteCorrente] == idIngredient
        
        var isIngredientSelected = false
        
        if self.dish.elencoIngredientiOff[idIngredienteCorrente] != nil {
            
            isIngredientSelected = self.dish.elencoIngredientiOff[idIngredienteCorrente]! == ingredientModel
        }
        
        return (isIngredientIn,isIngredientSelected)
    }
    
    private func descriptionSostituzioneIngrediente() -> Text {
        
        guard self.dish.elencoIngredientiOff.keys.contains(self.idIngredienteCorrente) else { return Text("Oops.. qualcosa è andato storto at the beginning") }
        
        let value:IngredientModel? = self.dish.elencoIngredientiOff[self.idIngredienteCorrente]!
        
        if value == nil && !isThereChoice {
            
            return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto..")
            
        }
        
        else if value == nil && isThereChoice {
            
            return Text("L'ingrediente \(nomeSostitutoGlobale) è già presente nel piatto. Selezionare un altro elemento altrimenti l'ingrediente \(nomeIngredienteCorrente) sarà omesso senza alternativa.")
            
        }
        
        else if value != nil {
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà sostituito dal \(value!.intestazione).")
            
        }
        
        else { return Text("Oops.. qualcosa è andato storto at the end")}
    }
    
}
    
    /*
    private func descriptionSostituzioneIngrediente() -> Text {
        
        let idSostituto = self.dish.sostituzioneIngredientiTemporanea[self.idIngredienteCorrente]
        let nomeSostituto = self.viewModel.findModelFromId(id: idSostituto ?? "")
        
        if idSostituto == "" {
            
            if isThereChoice {
  
                return Text("L'ingrediente \(nomeSostitutoGlobale) è già presente nel piatto. Selezionare un altro elemento altrimenti l'ingrediente \(nomeIngredienteCorrente) sarà omesso senza alternativa.")
                
            } else {
                
                return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto..")
            }
            
        } else {
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà sostituito dal \(nomeSostituto).")
            
        }
        
    } */ // deprecata 11.08
        
  
  /*  private func descriptionSostituzioneIngrediente(sostitutoGlobalOrlocal:String) -> Text {
         
        if self.sostitutoGlobale == "" && self.sostitutoLocale == "" {
            
            return Text("Selezionare un Ingrediente in sostituzione..") }
            
        else if sostitutoGlobalOrlocal == "" {

            return Text("L'ingrediente \(self.sostitutoGlobale) è già presente nel piatto. Selezionare un altro elemento altrimenti l'ingrediente \(ingredientModelCorrente.intestazione) sarà omesso senza alternativa.")
        }
        
        else {
            
            return Text("L'ingrediente \(ingredientModelCorrente.intestazione) sarà sostituito dal \(sostitutoGlobalOrlocal).")
            
        } */
        

       
        
      /*   guard nomeSostitutoGlobale != "" else {
             return Text("Selezionare un Ingrediente in sostituzione") }
         
         if nomeSostitutoGlobale == sostitutoChecked {
             
             return Text("L'ingrediente \(ingredientModelCorrente.intestazione) sarà sostituito dal \(sostitutoChecked)")
             
         } else {
             
             return Text("L'ingrediente selezionato è già presente fra gli ingredienti del piatto. Selezionare un altro elemento altrimenti l'ingrediente \(ingredientModelCorrente.intestazione) sarà omesso senza alternativa.")
         } */
         
     
        
  /*  private func sostitutoArrayAfterCheck() -> String {
          
         let sostitutoGlobalOrLocal = self.sostitutoLocale == "" ? self.sostitutoGlobale : self.sostitutoLocale

         guard sostitutoGlobalOrLocal != "" else { return ""}
              
         let condition = checkIngredientsIn(nomeIngrediente: sostitutoGlobalOrLocal)
        
         if condition { return "" }
         else { return sostitutoGlobalOrLocal }
     
      } */
    
 /*
   private func sostitutoArrayAfterCheck() -> (String,[String]) {
         
        let sostitutoGlobalOrLocal = self.sostitutoLocale == "" ? self.sostitutoGlobale : self.sostitutoLocale

        let mapArray:[String] = {

           let filterArray = self.viewModel.allMyIngredients.filter({$0.id != idIngredienteCorrente})
            
            return filterArray.map({$0.intestazione})
        }()

        guard sostitutoGlobalOrLocal != "" else { return ("",mapArray) }
             
        let condition = checkIngredientsIn(nomeIngrediente: sostitutoGlobalOrLocal)
       
        if condition { return ("",mapArray) }
        else { return (sostitutoGlobalOrLocal,mapArray) }
    
     } */ // BackUp 08.08
    
   /* private func checkIngredientsIn(nomeIngrediente:String) -> Bool {
        
        let allTheIngredients = self.dish.ingredientiPrincipali + self.dish.ingredientiSecondari
 
        let temporaryId:String = self.ingredientModelCorrente.creaID(fromValue: nomeIngrediente)

        let condition = allTheIngredients.contains(where: {$0.id == temporaryId })
        
        return condition
    } // Maybe deprecata */
    



struct BottomView_DLBIVSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let destinationPath: DestinationPath
    let description: () -> Text
    let resetAction: () -> Void
    let saveAction: () -> Void

    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description()
                .italic()
                .fontWeight(.light)
                .font(.caption)
                .multilineTextAlignment(.leading)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                self.showDialog = true
               // else { self.generalErrorCheck = true }
            }
        }
      //  .opacity(itemModel == itemModelArchiviato ? 0.6 : 1.0)
       // .disabled(itemModel == itemModelArchiviato)
        .padding(.vertical)
        .confirmationDialog(
            description(),
                isPresented: $showDialog,
                titleVisibility: .visible) { saveButtonDialogView() }
        
    }
    
    // Method
    
    /// Reset Crezione Modello - Torna un modello Vuoto o il Modello Senza Modifiche


    @ViewBuilder private func saveButtonDialogView() -> some View {
 
                Button("Salva ed Esci", role: .none) {
                    
                    self.saveAction()
                }

    }
    

    
    
}
