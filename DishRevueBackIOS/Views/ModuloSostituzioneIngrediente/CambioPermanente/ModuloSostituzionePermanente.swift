//
//  DishListByIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/08/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

/*
 Case_1: elencoOff == nil
 Case_2: elencoOff != nil presenza di sostituzioni temporanee
 Case_3: elencoOff != nil && ingrediente da sostituire ha un sostituto temporaneo
 
 In ogni caso nel modulo non è possibile rimuovere l'ingrediente dal piatto. Potremmo ma lo riteniamo una opzione inutile.
 */
struct ModuloSostituzionePermanente: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let ingredienteCorrente:IngredientModel
    let destinationPath: DestinationPath
    let backgroundColorView: Color

    @State private var modelSostitutoGlobale: IngredientModel? = nil
    @State private var dishWithIngredient:[ProductModel] = []
   // @State private var isDeactive: Bool = true
    
    @State private var idProductModified:[String] = []
    @State private var replaceWithTemporary:[String] = []
    
    init(ingredientModelCorrente: IngredientModel, destinationPath:DestinationPath, backgroundColorView: Color) {
        
        self.ingredienteCorrente = ingredientModelCorrente
        
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
     
    }

    var body: some View {
        
        CSZStackVB(title: "Cambio Permanente", backgroundColorView: backgroundColorView) {
 
                VStack(alignment:.leading) {
  
                let mapArray = self.viewModel.ingredientListFilteredBy(
                    idIngredient: ingredienteCorrente.id,
                    ingredientStatus: [.disponibile,.inPausa])
   
                    CSLabel_conVB(
                        placeHolder: "Sostituire",
                        imageNameOrEmojy: "arrowshape.backward",
                        backgroundColor: Color.black) {
                    
                            HStack {
                              
                                Text(ingredienteCorrente.intestazione)
                                     .lineLimit(1)
                                     .foregroundStyle(Color.seaTurtle_4)

                                Image(systemName: "exclamationmark.circle")
                                    .imageScale(.medium)
                                    .foregroundStyle(Color.yellow)
                               
                            }
                            ._tightPadding()
                            .background(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.seaTurtle_1)
                                        )
                            
                            
                    }
                      //  .padding(.horizontal,20)
                    
                PickerSostituzioneIngrediente_SubView(
                    mapArray: mapArray,
                    modelSostitutoGlobale: $modelSostitutoGlobale,
                    imageOrEmoji: "arrowshape.forward")
                    .clipped() // altrimenti ha un background fino al notch
        
                ScrollView(showsIndicators: false) {
                    
                    ForEach($dishWithIngredient) { $dish in
                        
                    let (idSostitutoGlobaleChecked,nomeSostitutoGlobale) = self.checkSostitutoGlobale(currentDish: dish)
                        
                    ModuloSP_RowSub(
                            dish:$dish,
                            idProductModified:$idProductModified,
                            replaceWithTemporary:$replaceWithTemporary,
                            nomeIngredienteCorrente: self.ingredienteCorrente.intestazione,
                            idSostitutoGlobale: idSostitutoGlobaleChecked,
                            nomeSostitutoGlobale: nomeSostitutoGlobale,
                            idIngredienteCorrente: self.ingredienteCorrente.id,
                            mapArray: mapArray)
                                .id(modelSostitutoGlobale)

                    }
                }
       
             Spacer()

                    BottomDialogView {
                       //self.switchDescription()
                        self.descriptionCambioPermanente()
                    } disableConditions: {
                        //(self.isDeactive,false,false)
                        self.disableCondition()
                    } secondaryAction: {
                        self.resetAction()
                    } primaryDialogAction: {
                        self.saveButtonDialogView()
                    }
                    .clipped()
                    
                    
            }
           
            .padding(.horizontal,20)
               
  
        }
       /* .onChange(of: self.dishWithIngredient) { _ , newArray in
            
            var allCheck:Bool = true
            
            for dish in newArray {
                
                    if dish.idIngredienteDaSostituire != nil {
                        allCheck = false
                        break
                    }
                    
                
            }
            self.isDeactive = allCheck
        }*/
        
        /*.onChange(of: self.idProductModified) { _ , newArray in
            
            self.isDeactive = newArray.count == 0
        }
        .onChange(of: self.replaceWithTemporary) { _ , newArray in
            
            
           // self.isDeactive = newArray.count == 0
        }*/
        .onAppear {
            self.compilaListaPiatti()
          
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color.yellow)
                    
                    CSInfoAlertView(
                        imageScale: .large,
                        title: "Info",
                        message: .sostituzionePermanenteING)
                }//.padding(.horizontal)

            }
        }
    }
    
    // viewBuilder
    
    @ViewBuilder private func saveButtonDialogView() -> some View {
 
        csBuilderDialogButton {
            
            DialogButtonElement(
                label: .saveEsc) {
                   // self.switchAction()
                    self.saveActionPermanente()
                }
        }
        

    }
    
    // method
    
    private func disableCondition() -> (Bool,Bool,Bool) {
        
        let noModified = self.idProductModified.count == 0
        let noReplace = self.replaceWithTemporary.count == 0
        
        let general = noModified && noReplace
        
        return (general,false,false)
        
    }
    
    private func compilaListaPiatti() {
    
        let productList = self.viewModel.dishFilteredByIngrediet(idIngredient: ingredienteCorrente.id)
        
        let updatedList: [ProductModel] = productList.compactMap { product in
            
            var updated = product
            updated.prepareForPermanentSubstitution(for: ingredienteCorrente.id)
            return updated
        }
            
        self.dishWithIngredient = updatedList
        
    }
    
    private func descriptionCambioPermanente() -> (breve:Text,estesa:Text) {
        
       let dishCount = self.dishWithIngredient.count
       let modifiedCount = self.idProductModified.count
       let transformedCount = self.replaceWithTemporary.count
       let noVariation = dishCount - (modifiedCount + transformedCount)
        
        let string1 = csSwitchSingolarePlurale(checkNumber: modifiedCount, wordSingolare: "prodotto", wordPlurale: "prodotti")
        let string2 = csSwitchSingolarePlurale(checkNumber: noVariation, wordSingolare: "prodotto", wordPlurale: "prodotti")
        let string3 = csSwitchSingolarePlurale(checkNumber: transformedCount, wordSingolare: "prodotto", wordPlurale: "prodotti")
        
        let string4 = noVariation == 0 ? "L'ingrediente \(ingredienteCorrente.intestazione) sarà posto 'out of stock'" : "Lo stato dell'ingrediente \(ingredienteCorrente.intestazione) non sarà mutato."
        
        let infoEstesa = Text("Cambi Permanenti:\nL'ingrediente \(self.ingredienteCorrente.intestazione) sarà rimosso e sostituito in \(modifiedCount) \(string1) su \(dishCount).\nSarà reso permanente il cambio temporaneo in \(transformedCount) \(string3) su \(dishCount).\nRimarrà invariato in \(noVariation) \(string2) su \(dishCount).\n\(string4)")
        
        let infoBreve = Text("Cambi !! Permanenti !!\nConversione: \(transformedCount) su \(dishCount).\nRimozione e Sostituzione: \(modifiedCount) su \(dishCount).\nInvariati: \(noVariation) su \(dishCount).")
        
        return (infoBreve,infoEstesa)
    }
   /* private func descriptionCambioPermanente() -> (breve:Text,estesa:Text) {
        
       let dishCount = self.dishWithIngredient.count
       var dishLeavedActive = 0
       var dishModified = 0
       var dishWhreRemoved = 0
        
        for dish in self.dishWithIngredient {
            
            let off = dish.elencoIngredientiOff ?? [:]
            
            if dish.idIngredienteDaSostituire == nil {
                dishLeavedActive += 1
               // dishWhreRemoved -= 1
            }
            
            else if off.keys.contains(self.ingredienteCorrente.id) { dishModified += 1 }
            
            else { dishWhreRemoved += 1}
  
        }
        
        let string1 = csSwitchSingolarePlurale(checkNumber: dishModified, wordSingolare: "prodotto", wordPlurale: "prodotti")
        let string2 = csSwitchSingolarePlurale(checkNumber: dishLeavedActive, wordSingolare: "prodotto", wordPlurale: "prodotti")
        let string3 = csSwitchSingolarePlurale(checkNumber: dishWhreRemoved, wordSingolare: "prodotto", wordPlurale: "prodotti")
        let string4 = dishLeavedActive == 0 ? "L'ingrediente \(ingredienteCorrente.intestazione) sarà posto 'out of stock'" : "Lo stato dell'ingrediente \(ingredienteCorrente.intestazione) non sarà mutato."
        
        let infoEstesa = Text("Cambi Permanenti:\nL'ingrediente \(self.ingredienteCorrente.intestazione) sarà rimosso e sostituito in \(dishModified) \(string1) su \(dishCount).\nSarà soltanto rimosso in \(dishWhreRemoved) \(string3) su \(dishCount).\nRimarrà attivo in \(dishLeavedActive) \(string2) su \(dishCount).\n\(string4)")
        
        let infoBreve = Text("Cambi !! Permanenti !!\nSolo Rimozione: \(dishWhreRemoved) su \(dishCount).\nRimozione e Sostituzione: \(dishModified) su \(dishCount).\nLasciato Attivo in \(dishLeavedActive) \(string2) su \(dishCount).")
        
        return (infoBreve,infoEstesa)
    }*/ // backup 01_02_24
    
    private func saveActionPermanente() {
        
        let productToSave:[ProductModel] = self.dishWithIngredient.compactMap({
            if self.idProductModified.contains($0.id) { return $0 }
            else if self.replaceWithTemporary.contains($0.id) { return $0 }
            else { return nil }
        })
        
        var dishUpdated:[ProductModel] = []
        let allChanged = productToSave.count == self.dishWithIngredient.count
        
        for dish in productToSave {
        
            let (path,posizione) = dish.individuaPathIngrediente(idIngrediente: self.ingredienteCorrente.id)
            
            let cleanDish = {
                var cleanCopy = dish
                
                if let sostituto = cleanCopy.elencoIngredientiOff?[self.ingredienteCorrente.id] {
                    
                    cleanCopy[keyPath:path!]![posizione!] = sostituto
                    cleanCopy.elencoIngredientiOff?[self.ingredienteCorrente.id] = nil
                    
                } // else { cleanCopy[keyPath:path!]!.remove(at: posizione!) }

                return cleanCopy
            }()
            
            dishUpdated.append(cleanDish)
    
        }
 
            Task {
           
                do {
                    
                    self.viewModel.isLoading = true
                    
                    try await self.viewModel.updateModelCollection(
                                items: dishUpdated,
                                sub: .allMyDish,
                                merge: false,
                                destinationPath: self.destinationPath)
                        
                        if allChanged {
                            // aggiorniamo status ingrediente
                        self.viewModel.isLoading = true
                            
                    try await self.ingredienteCorrente.changeAndUpdateStatus(status: .outOfStock, viewModel: self.viewModel)
                            
                        }

                    self.viewModel.logMessage = "Prodotti aggiornati con successo"
                    
                } catch let error {
                    
                    self.viewModel.isLoading = nil
                    self.viewModel.logMessage = error.localizedDescription
                }
                
            }
    }
    
    private func resetAction() {
 
        self.modelSostitutoGlobale = nil
     //   self.isPermamente = false
        /*self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: ingredienteCorrente.id)*/
        self.idProductModified = []
        self.replaceWithTemporary = []
        self.compilaListaPiatti()
        
        // Spiegato il funzionamento in Nota Vocale il 10.08
    }
    
    private func checkSostitutoGlobale(currentDish: ProductModel) ->(idChecked:String?,nome:String?) {
        
        guard let modelSostitutoGlobale else { return (nil,nil) }
        
        // 01.09
        let idSostitutoGlobale = modelSostitutoGlobale.id
        let nameSostitutoGlobale = modelSostitutoGlobale.intestazione
        
        guard let off = currentDish.elencoIngredientiOff else {
            return (idSostitutoGlobale,nameSostitutoGlobale)
        }
        
        guard off[self.ingredienteCorrente.id] != idSostitutoGlobale else {return (idSostitutoGlobale,nameSostitutoGlobale) }
        // Vedi Nota 01.09
        // end 01.09
        
        let checkIn = currentDish.checkIngredientsIn(idIngrediente: idSostitutoGlobale)
        
        if checkIn { return (nil,nameSostitutoGlobale) }
        else { return (idSostitutoGlobale,nameSostitutoGlobale)}
        
    }
    
}
/*
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
        status: .completo(.disponibile))
    
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
    
    static var dishItem: ProductModel = {
        
        var newDish = ProductModel()
        newDish.intestazione = "Spaghetti alla Carbonara"
        newDish.status = .completo(.disponibile)
        newDish.ingredientiPrincipali = [ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample3.id,ingredientSample4.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample2.id]
        
        return newDish
    }()
    
    static var dishItem2: ProductModel = {
        
        var newDish = ProductModel()
        newDish.intestazione = "Trofie al Pesto"
        newDish.status = .bozza()
        newDish.ingredientiPrincipali = [ingredientSample3.id]
        newDish.ingredientiSecondari = [ingredientSample.id,ingredientSample4.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample5.id]
      //  newDish.sostituzioneIngredientiTemporanea = ["guancialenero":"Prezzemolo"]
        
        return newDish
    }()
    
    static var dishItem3: ProductModel = {
        
        var newDish = ProductModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id,ingredientSample3.id]
        
        return newDish
    }()

    
    @StateObject static var viewModel:AccounterVM = {
        let user = UserRoleModel()
        var viewM = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))
        viewM.db.allMyDish = [dishItem,dishItem2,dishItem3]
        viewM.db.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4,ingredientSample5 ]
        return viewM
    }()
    
    static var previews: some View {
        NavigationStack {
            
            DishListByIngredientView(ingredientModelCorrente: ingredientSample3, isPermanente: true, destinationPath: DestinationPath.ingredientList, backgroundColorView: Color.seaTurtle_1)
                
        }.environmentObject(viewModel)
    }
}*/  // BackUp 08.09
