//
//  DishListByIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/08/22.
//

import SwiftUI

/*
struct SostituzioneING_MainView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
  // let nomeIngredienteCorrente: String
  // let idIngredienteCorrente: String
    
    let destinationPath: DestinationPath
    let backgroundColorView: Color

    @State private var modelDaSostituire: IngredientModel?
    @State private var modelSostitutoGlobale: IngredientModel? = nil
    @State private var dishWithIngredient:[DishModel] = []
    @State private var isDeactive: Bool = true
    
    init(ingredientModelCorrente: IngredientModel? = nil, destinationPath:DestinationPath, backgroundColorView: Color) {
        
        _modelDaSostituire = State(wrappedValue: ingredientModelCorrente)
    //  self.nomeIngredienteCorrente = ingredientModelCorrente!.intestazione
    //  self.idIngredienteCorrente = ingredientModelCorrente.id
        
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
     
    }
 
    @State private var isPermamente: Bool = false
    @State private var test: String = "Start" // da eliminare
    @State private var testOnChange: String = "Start"
    @State private var testOnChangeDISH: Int = 0
    
    var body: some View {
        
        CSZStackVB(title: isPermamente ? "Cambio Permanente" : "Cambio Temporaneo", backgroundColorView: backgroundColorView) {
 
                VStack(alignment:.leading) {
                    Text("On Appear: \(test)")
                    Text("OnChange: \(testOnChange)")
                    Text("OnChangeDish \(testOnChangeDISH)")
                    let allTheIngredients = self.viewModel.allMyIngredients
                    
                    Toggle(isOn: $isPermamente) {

                        HStack {
                           
                            Text(isPermamente ? "Cambio Permanente" : "Cambio Temporaneo")
                                .italic(!isPermamente)
                                .bold(isPermamente)
                                //.font(.body)
                            
                            CSInfoAlertView(
                                imageScale: .large,
                                title: "Info",
                                message: .sostituzioneTemporaneaING)
                            Spacer()
                            Image(systemName: isPermamente ? "exclamationmark.circle" : "clock")
                                .imageScale(.large)
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                           
                        }
                    }
                    
                    PickerSostituzioneIngrediente_SubView(
                        mapArray: allTheIngredients,
                        modelSostitutoGlobale: $modelDaSostituire,
                        placeHolder: "Cambia",
                        imageOrEmoji: "arrowshape.backward")
                           // .background(Color.red)
                            .clipped()
                    
                    if modelDaSostituire != nil {
     
                        let mapArray = self.viewModel.ingredientListFilteredBy(idIngredient: modelDaSostituire!.id, ingredientStatus:.disponibile)
                        
                        PickerSostituzioneIngrediente_SubView(
                            mapArray: mapArray,
                            modelSostitutoGlobale: $modelSostitutoGlobale,
                            placeHolder: "Con",
                            imageOrEmoji: "arrowshape.right.fill")
                           // .background(Color.green)
                                .clipped() // altrimenti ha un background fino al notch

                        ScrollView(showsIndicators: false) {
                            
                            ForEach($dishWithIngredient) { $dish in
                                
                                let (idSostitutoGlobaleChecked,nomeSostitutoGlobale) = self.checkSostitutoGlobale(currentDish: dish)
                                
                                DishChangingIngredient_RowSubView(
                                    dish:$dish,
                                    isDeactive: $isDeactive,
                                    isPermanente: isPermamente,
                                    nomeIngredienteCorrente: modelDaSostituire!.intestazione,
                                    idSostitutoGlobale: idSostitutoGlobaleChecked,
                                    nomeSostitutoGlobale: nomeSostitutoGlobale,
                                    idIngredienteCorrente: modelDaSostituire!.id,
                                    mapArray: mapArray)
                                        .id(modelSostitutoGlobale)
                              //  .id(modelDaSostituire)
                                        
                            
                                // l'uso dell'id è una soluzione trovata grazie all'overradeStateTEST per permettere l'aggiornamento della view sottostante
                            }
                        }.onAppear {

                                self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: modelDaSostituire!.id)
                            
                                self.test = "On Appear Locale"
                        }
                        .onDisappear {
                            
                            self.test = "On Disappear Locale"
                        }
                        .onChange(of: self.modelDaSostituire, perform: {_ in
                            
                          //  if modelDaSostituire != nil {
                                self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: modelDaSostituire!.id)
                        //    }
                            
                            self.testOnChange = self.modelDaSostituire?.id ?? "Start"
                        })
                        .onChange(of: self.dishWithIngredient, perform: { newArray in
                            
                            var allCheck:Bool = true
                            
                            for dish in newArray {
                                
                                if dish.elencoIngredientiOff[modelDaSostituire!.id] != nil {
                                    allCheck = false
                                    break
                                }
                            }
                            self.isDeactive = allCheck
                            self.testOnChangeDISH += 1
                        })
                        
                    } else {
                        
                        Text("Scegli un ingrediente da Sostituire")
                            .italic()
                            .foregroundColor(Color.black)
                    }

                    Spacer()
                       
                   BottomView_DLBIVSubView(
                       destinationPath: self.destinationPath,
                       isDeActive: isDeactive) {
                          // self.description()
                       } resetAction: {
                           self.resetAction()
                       } saveAction: {
                           self.saveAction()
                       }
                     //  .background(Color.red)
                       .clipped() // altrimenti ha un background fino alla base
                    
                    
            }
            .padding(.horizontal,20)

        }
       /* .onChange(of: self.dishWithIngredient, perform: { newArray in
            
            var allCheck:Bool = true
            
            for dish in newArray {
                
                if dish.elencoIngredientiOff[modelDaSostituire!.id] != nil {
                    allCheck = false
                    break
                }
            }
            self.isDeactive = allCheck
        }) */
       /* .onChange(of: self.modelDaSostituire, perform: { _ in
            
            if modelDaSostituire != nil {
                self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: modelDaSostituire!.id)
            }
            
            self.test = "on Change general"
        }) */
      /* .onAppear {
            
            if modelDaSostituire != nil {
                self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: modelDaSostituire!.id)
            }
        //   self.test = "On Appear Generale"
        } */
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                
                Image(systemName: isPermamente ? "exclamationmark.circle" : "clock")
                    .imageScale(.large)
                    .foregroundColor(Color("SeaTurtlePalette_3"))
                
               /* CSInfoAlertView(
                    imageScale: .large,
                    title: "Info",
                    message: .sostituzioneTemporaneaING) */

            }
        }

        
        
    }
    
    // method
    
 
    private func description() -> Text {
        
    guard modelDaSostituire != nil else { return Text("") }
        
       let dishCount = self.dishWithIngredient.count
       var dishModified = 0
        
        for dish in self.dishWithIngredient {
            
            if dish.elencoIngredientiOff.keys.contains(modelDaSostituire!.id) { dishModified += 1 }
  
        }
        
        let string = dishModified == 1 ? "piatto" : "piatti"
        let string2 = dishModified == dishCount ? "" : "Dove non indicato, l'ingrediente \(modelDaSostituire!.intestazione) sarà mostrato senza un sostituto. "
        
        return Text("Per l'ingrediente \(modelDaSostituire!.intestazione) è stato indicato un sostituto in \(dishModified) \(string) su \(dishCount).\n\(string2)")
    }
    
    private func saveAction() {
        
        guard modelDaSostituire != nil else { return }
        
        for dish in self.dishWithIngredient {
            
            let cleanDish = {
               var cleanCopy = dish
                cleanCopy.idIngredienteDaSostituire = nil
                return cleanCopy
            }()
            
            self.viewModel.updateItemModel(itemModel: cleanDish)
            
        }
        
      if let currentIngredientModel = {
          var current = self.viewModel.modelFromId(id: modelDaSostituire!.id, modelPath: \.allMyIngredients)
            current?.status = .completo(.inPausa) // !!!!!
         
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
 
        guard modelDaSostituire != nil else { return }
        
        self.modelSostitutoGlobale = nil
        self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: modelDaSostituire!.id)
        
        // Spiegato il funzionamento in Nota Vocale il 10.08
    }
    
    private func checkSostitutoGlobale(currentDish: DishModel) ->(idChecked:String?,nome:String?) {
        
        guard modelDaSostituire != nil else { return (nil,nil)}
        
        guard self.modelSostitutoGlobale != nil else { return (nil,nil) }
        
        // 01.09
        let idSostitutoGlobale = self.modelSostitutoGlobale!.id
        let nameSostitutoGlobale = self.modelSostitutoGlobale!.intestazione
        
        guard currentDish.elencoIngredientiOff[modelDaSostituire!.id] != idSostitutoGlobale else {return (idSostitutoGlobale,nameSostitutoGlobale) }
        // Vedi Nota 01.09
        // end 01.09
        
        let checkIn = currentDish.checkIngredientsIn(idIngrediente: idSostitutoGlobale)
        
        if checkIn { return (nil,nameSostitutoGlobale) }
        else { return (idSostitutoGlobale,nameSostitutoGlobale)}
        
    }
    
}

struct SostituzioneING_MainView_Previews: PreviewProvider {
    
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
        status: .bozza(.inPausa)
       
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .completo(.disponibile))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Pecorino D.O.P",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .completo(.disponibile)
       )
    
    @State static var ingredientSample5 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza(.disponibile)
       )
    
    static var dishItem: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Spaghetti alla Carbonara"
        newDish.status = .completo(.disponibile)
        newDish.ingredientiPrincipali = [ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample3.id,ingredientSample4.id]
      //  newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample2.id]
        
        return newDish
    }()
    
    static var dishItem2: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Trofie al Pesto"
        newDish.status = .bozza(.disponibile)
        newDish.ingredientiPrincipali = [ingredientSample3.id]
        newDish.ingredientiSecondari = [ingredientSample.id,ingredientSample4.id]
      //  newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample5.id]
      //  newDish.sostituzioneIngredientiTemporanea = ["guancialenero":"Prezzemolo"]
        
        return newDish
    }()
    
    static var dishItem3: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id,ingredientSample3.id]
        
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
            
         // SostituzioneING_MainView(ingredientModelCorrente: ingredientSample3, destinationPath: DestinationPath.ingredientList, backgroundColorView: Color("SeaTurtlePalette_1"))
            
            SostituzioneING_MainView(destinationPath: DestinationPath.ingredientList, backgroundColorView: Color("SeaTurtlePalette_1"))
                
        }.environmentObject(viewModel)
    }
}

*/
