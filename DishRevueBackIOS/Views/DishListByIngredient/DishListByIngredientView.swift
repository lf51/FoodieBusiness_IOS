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
    let idIngredienteCorrente: String
    let destinationPath: DestinationPath
    let backgroundColorView: Color

    @State private var modelSostitutoGlobale: IngredientModel? = nil
    @State private var dishWithIngredient:[DishModel] = []
    @State private var isDeactive: Bool = true
    
    init(ingredientModelCorrente: IngredientModel, destinationPath:DestinationPath, backgroundColorView: Color) {
        
        self.nomeIngredienteCorrente = ingredientModelCorrente.intestazione
        self.idIngredienteCorrente = ingredientModelCorrente.id
        
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
     
    }
    
    var body: some View {
        
        CSZStackVB(title: "Cambio Temporaneo", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                let mapArray = self.viewModel.ingredientsFilteredByIngredientAndStatus(idIngredient: idIngredienteCorrente)
                
                PickerSostituzioneIngrediente_SubView(mapArray: mapArray, modelSostitutoGlobale: $modelSostitutoGlobale)

                ScrollView(showsIndicators: false) {
                    
                    ForEach($dishWithIngredient) { $dish in

                        let (idSostitutoGlobaleChecked,nomeSostitutoGlobale) = self.checkSostitutoGlobale(currentDish: dish)
                        
                        DishChangingIngredient_RowSubView(
                            dish:$dish,
                            isDeactive: $isDeactive,
                            nomeIngredienteCorrente: self.nomeIngredienteCorrente,
                            idSostitutoGlobale: idSostitutoGlobaleChecked,
                            nomeSostitutoGlobale: nomeSostitutoGlobale,
                            idIngredienteCorrente: self.idIngredienteCorrente,
                            mapArray: mapArray).id(self.modelSostitutoGlobale)
                        // l'uso dell'id è una soluzione trovata grazie all'overradeStateTEST per permettere l'aggiornamento della view sottostante
                    }
                }
       
             Spacer()
                
            BottomView_DLBIVSubView(
                destinationPath: self.destinationPath,
                isDeActive: isDeactive) {
                    self.description()
                } resetAction: {
                    self.resetAction()
                } saveAction: {
                    self.saveAction()
                }
                
            }
            .padding(.horizontal)
  
        }
        .onChange(of: self.dishWithIngredient, perform: { newArray in
            
            var allCheck:Bool = true
            
            for dish in newArray {
                
                if dish.elencoIngredientiOff[self.idIngredienteCorrente] != nil {
                    allCheck = false
                    break
                }
            }
            self.isDeactive = allCheck
        })
        .onAppear {
            self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: idIngredienteCorrente)
          
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                CSInfoAlertView(
                    imageScale: .large,
                    title: "Info",
                    message: .sostituzioneIngrediente)

            }
        }

        
        
    }
    
    // method
 
    private func description() -> Text {
        
       let dishCount = self.dishWithIngredient.count
       var dishModified = 0
        
        for dish in self.dishWithIngredient {
            
            if dish.elencoIngredientiOff.keys.contains(self.idIngredienteCorrente) { dishModified += 1 }
  
        }
        
        let string = dishModified == 1 ? "piatto" : "piatti"
        let string2 = dishModified == dishCount ? "" : "Dove non indicato, l'ingrediente \(self.nomeIngredienteCorrente) sarà mostrato senza un sostituto. "
        
        return Text("Per l'ingrediente \(self.nomeIngredienteCorrente) è stato indicato un sostituto in \(dishModified) \(string) su \(dishCount).\n\(string2)")
    }
    
    private func saveAction() {
        
        for dish in self.dishWithIngredient {
            
            let cleanDish = {
               var cleanCopy = dish
                cleanCopy.idIngredienteDaSostituire = nil
                return cleanCopy
            }()
            
            self.viewModel.updateItemModel(itemModel: cleanDish)
            
        }
        
      if let currentIngredientModel = {
          var current = self.viewModel.modelFromId(id: self.idIngredienteCorrente, modelPath: \.allMyIngredients)
            current?.status = .completo(.inPausa)
            return current
      }() {
          
          self.viewModel.updateItemModel(itemModel: currentIngredientModel, destinationPath: self.destinationPath)
          
      } else {
            self.viewModel.alertItem = AlertModel(
                title: "Errore",
                message: "L'ingrediente corrente non esiste come modello nel viewModel.")
        }
        
    }
    
    private func resetAction() {
 
        self.modelSostitutoGlobale = nil
        self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: idIngredienteCorrente)
        
        // Spiegato il funzionamento in Nota Vocale il 10.08
    }
    
    private func checkSostitutoGlobale(currentDish: DishModel) ->(idChecked:String?,nome:String?) {
        
        guard self.modelSostitutoGlobale != nil else { return (nil,nil) }
        
        let idSostitutoGlobale = self.modelSostitutoGlobale!.id
        let nameSostitutoGlobale = self.modelSostitutoGlobale!.intestazione
        
        let checkIn = currentDish.checkIngredientsIn(idIngrediente: idSostitutoGlobale)
        
        if checkIn { return (nil,nameSostitutoGlobale) }
        else { return (idSostitutoGlobale,nameSostitutoGlobale)}
        
    }
    
}

struct DishListByIngredientView_Previews: PreviewProvider {
    
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.disponibile)
        
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Tuorlo d'Uovo",
        descrizione: "",
        conservazione: .surgelato,
        produzione: .convenzionale,
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
        status: .completo(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Pecorino D.O.P",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .completo(.inPausa)
       )
    
    @State static var ingredientSample5 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .completo(.disponibile)
       )
    
    static var dishItem: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Spaghetti alla Carbonara"
        newDish.status = .completo(.disponibile)
        newDish.ingredientiPrincipali = [ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample3.id,ingredientSample4.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample2.id]
        
        return newDish
    }()
    
    static var dishItem2: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Trofie al Pesto"
        newDish.status = .completo(.disponibile)
        newDish.ingredientiPrincipali = [ingredientSample3.id]
        newDish.ingredientiSecondari = [ingredientSample.id,ingredientSample4.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample5.id]
      //  newDish.sostituzioneIngredientiTemporanea = ["guancialenero":"Prezzemolo"]
        
        return newDish
    }()
    
    static var dishItem3: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id]
        
        return newDish
    }()

    
    @StateObject static var viewModel:AccounterVM = {
   
      var viewM = AccounterVM()
        viewM.allMyDish = [dishItem,dishItem2,dishItem3]
        viewM.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4,ingredientSample5 ]
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
    
    @Binding var dish: DishModel
    @Binding var isDeactive: Bool
    
    let nomeIngredienteCorrente: String
    let idIngredienteCorrente: String
    
    let idSostitutoGlobale: String?
    let nomeSostitutoGlobale: String?
   
    let mapArray: [IngredientModel]
    @State private var nomeSostitutoLocale: String?
    
    init(dish: Binding<DishModel>,isDeactive:Binding<Bool>, nomeIngredienteCorrente: String, idSostitutoGlobale: String?,nomeSostitutoGlobale:String?, idIngredienteCorrente: String, mapArray:[IngredientModel]) {

        _dish = dish
        _isDeactive = isDeactive
        self.nomeIngredienteCorrente = nomeIngredienteCorrente
        self.idSostitutoGlobale = idSostitutoGlobale
        self.nomeSostitutoGlobale = nomeSostitutoGlobale
        self.idIngredienteCorrente = idIngredienteCorrente
        self.mapArray = mapArray
        
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {

            HStack {
                
                GenericItemModel_RowViewMask(model: self.dish,pushImage: "arrow.left.arrow.right.circle") {
                    ForEach(mapArray,id:\.self) { ingredient in

                        let (isIngredientIn,isIngredientSelected) = isInAndSelected(idIngredient: ingredient.id)
                        
                        Button {
                            self.action(isIngredientSelected: isIngredientSelected, idIngredient: ingredient.id, nomeIngrediente: ingredient.intestazione)
                        } label: {
                            HStack {
                                Text(ingredient.intestazione)
                                    .foregroundColor(Color.black)
                                
                                Image(systemName: isIngredientSelected ? "checkmark.circle" : "circle")
                                
                            }
                        }.disabled(isIngredientIn && !isIngredientSelected)
                    }
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
        .onAppear {

            self.dish.idIngredienteDaSostituire = self.idIngredienteCorrente
            self.dish.elencoIngredientiOff[self.idIngredienteCorrente] = self.idSostitutoGlobale
// BUG 31.08 da risolvere. Vedi Nota Vocale 31.08
        }
        
    }
    
    // Method
    
    private func action(isIngredientSelected:Bool,idIngredient:String,nomeIngrediente:String) {
        
        self.dish.elencoIngredientiOff[self.idIngredienteCorrente] = isIngredientSelected ? nil : idIngredient
        self.nomeSostitutoLocale = isIngredientSelected ? nil : nomeIngrediente

    }
    
    private func isInAndSelected(idIngredient:String) -> (isIn:Bool,isSelect:Bool) {
        
        let isIngredientIn = self.dish.checkIngredientsIn(idIngrediente: idIngredient)
        let isIngredientSelected = self.dish.elencoIngredientiOff[self.idIngredienteCorrente] == idIngredient
 
        return (isIngredientIn,isIngredientSelected)
    }
    
    private func descriptionSostituzioneIngrediente() -> Text {
        
        if self.dish.elencoIngredientiOff[self.idIngredienteCorrente] == nil {
            
            if idSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeIngredienteCorrente) sarà mostrato in pausa senza un sostituto.")
            }
            
           else if nomeSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeSostitutoGlobale!) è già presente nel piatto. Selezionare un altro elemento altrimenti l'ingrediente \(nomeIngredienteCorrente) sarà mostrato in pausa senza un sostituto.")
                
            } else {
                
                return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto.")
            }
  
        } else {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
        }
    }
    
}

/// DLBIV == DishListByIngredientView
struct BottomView_DLBIVSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let destinationPath: DestinationPath
    let isDeActive: Bool
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
             
            }
        }
        .opacity(isDeActive ? 0.6 : 1.0)
        .disabled(isDeActive)
        .padding(.vertical)
        .confirmationDialog(
            description(),
                isPresented: $showDialog,
                titleVisibility: .visible) { saveButtonDialogView() }
        
    }
    
    // Method
    @ViewBuilder private func saveButtonDialogView() -> some View {
 
                Button("Salva ed Esci", role: .none) {
                    
                    self.saveAction()
                }

    }
   
}
