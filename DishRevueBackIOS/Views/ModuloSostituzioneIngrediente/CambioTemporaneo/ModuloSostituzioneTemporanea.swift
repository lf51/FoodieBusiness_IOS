//
//  ModuloSostituzioneTemporanea.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/01/24.
//  Created by Calogero Friscia on 06/08/22.

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct ModuloSostituzioneTemporanea: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let ingredienteCorrente:IngredientModel
    let destinationPath: DestinationPath
    let backgroundColorView: Color

    @State private var modelSostitutoGlobale: IngredientModel? = nil
    @State private var dishWithIngredient:[ProductModel] = []
   // @State private var isDeactive: Bool = true
    
    @State private var idProductModified:[String] = []
    
    init(ingredientModelCorrente: IngredientModel, destinationPath:DestinationPath, backgroundColorView: Color) {
        
        self.ingredienteCorrente = ingredientModelCorrente
        
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
     
    }

    var body: some View {
        
        CSZStackVB(title: "Cambio Temporaneo", backgroundColorView: backgroundColorView) {
 
                VStack(alignment:.leading) {
                   
                let mapArray = self.viewModel.ingredientListFilteredBy(
                    idIngredient: ingredienteCorrente.id,
                    ingredientStatus: [.disponibile])
   
                    CSLabel_conVB(
                        placeHolder: "Sostituire",
                        imageNameOrEmojy: "arrowshape.backward",
                        backgroundColor: Color.black) {
                    
                            HStack {
                                
                                Text(ingredienteCorrente.intestazione)
                                     .lineLimit(1)
                                     .foregroundStyle(Color.seaTurtle_4)

                                Image(systemName: "clock")
                                    .imageScale(.medium)
                                    .foregroundStyle(Color.seaTurtle_3)
                               
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
                        
                    ModuloST_RowSub(
                            dish:$dish,
                            idProductModified:$idProductModified,
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
                        self.descriptionCambioTemporaneo()
                    } disableConditions: {
                        self.disableCondition()
                       // (self.isDeactive,false,false)
                    } secondaryAction: {
                        self.resetAction()
                    } primaryDialogAction: {
                        self.saveButtonDialogView()
                        
                    }
                    .clipped()
                    
                    
            }
           
            .padding(.horizontal,20)
               
  
        }
       /* .onChange(of: self.idProductModified) { _ , newArray in

            self.isDeactive = newArray.count == 0
        }*/
        
        .onAppear {
          //  self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: ingredienteCorrente.id)
            self.compilaListaPiatti()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                HStack {
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .foregroundStyle(Color.seaTurtle_3)
                    
                    CSInfoAlertView(
                        imageScale: .large,
                        title: "Info",
                        message: .sostituzioneTemporaneaING)
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
                    self.saveActionTemporaneo()
                }
        }
        

    }
    
    // method
    
    private func disableCondition() -> (Bool,Bool,Bool) {
        
        let general = self.idProductModified.count == 0
        
        return (general,false,false)
        
    }
    
    private func compilaListaPiatti() {
        
        let productList = self.viewModel.dishFilteredByIngrediet(idIngredient: ingredienteCorrente.id)
        
        let updatedList: [ProductModel] = productList.compactMap { product in
            
            var updated = product
            updated.prepareForTemporarySubstitution(for: ingredienteCorrente.id)
            return updated
        }
            
        self.dishWithIngredient = updatedList
        
    }
    
    private func descriptionCambioTemporaneo() -> (breve:Text,estesa:Text) {
        
       let dishCount = self.dishWithIngredient.count
       let dishModified = self.idProductModified.count
        
        let string = csSwitchSingolarePlurale(checkNumber: dishModified, wordSingolare: "prodotto", wordPlurale: "prodotti")
        
        let infoEstesa = Text("Cambi Temporanei:\nDove è indicato un sostituto l'ingrediente \(self.ingredienteCorrente.intestazione) sarà automaticamente sostituito quando lo stato delle sue scorte sarà su 'esaurito'.\nBasterà riportarlo 'in stock' per ripristinarne la titolarità.")
        
        let infoBreve = Text("Cambi !! Temporanei !!\nModifiche in \(dishModified) \(string) su \(dishCount).")
        
        return (infoBreve,infoEstesa)
    }
        
    private func saveActionTemporaneo() {
        
        let productUpdated:[ProductModel] = self.dishWithIngredient.compactMap({
            if self.idProductModified.contains($0.id) { return $0 }
            else { return nil }
        })

        Task {
            
            do {
                
                self.viewModel.isLoading = true
                // Vedere di implementare un salvataggio in batch per singoli field
                try await self.viewModel.updateModelCollection(
                            items: productUpdated,
                            sub: .allMyDish,
                            merge: false,
                            destinationPath: self.destinationPath)
                
                
            } catch let error {
                
                self.viewModel.isLoading = nil
                self.viewModel.logMessage = error.localizedDescription
                
            }
            
        }
        
    }

    private func resetAction() {
 
        self.modelSostitutoGlobale = nil
     //   self.isPermamente = false
      //  self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: ingredienteCorrente.id)
        self.compilaListaPiatti()
        self.idProductModified = []
        
        // Spiegato il funzionamento in Nota Vocale il 10.08
    }
    
    private func checkSostitutoGlobale(currentDish: ProductModel) ->(idChecked:String?,nome:String?) {
        
        guard let modelSostitutoGlobale else { return (nil,nil) }
        
        // 01.09
        let idSostitutoGlobale = modelSostitutoGlobale.id
        let nameSostitutoGlobale = modelSostitutoGlobale.intestazione
        
        guard let offManager = currentDish.offManager else {
            return (idSostitutoGlobale,nameSostitutoGlobale)
        }
    
        guard offManager.elencoIngredientiOff[self.ingredienteCorrente.id] != idSostitutoGlobale else {return (idSostitutoGlobale,nameSostitutoGlobale) }
        // Vedi Nota 01.09
        // end 01.09
        
        let checkIn = currentDish.checkIngredientsIn(idIngrediente: idSostitutoGlobale)
        
        if checkIn { return (nil,nameSostitutoGlobale) }
        else { return (idSostitutoGlobale,nameSostitutoGlobale)}
        
    }
    
   /* private func checkSostitutoGlobale(currentDish: ProductModel) ->(idChecked:String?,nome:String?) {
        
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
        
    }*/ // updated
    
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
