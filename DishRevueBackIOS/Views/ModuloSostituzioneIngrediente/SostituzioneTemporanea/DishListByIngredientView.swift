//
//  DishListByIngredient.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 06/08/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct DishListByIngredientView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let nomeIngredienteCorrente: String
    let idIngredienteCorrente: String
    let isPermamente: Bool
    let destinationPath: DestinationPath
    let backgroundColorView: Color

    @State private var modelSostitutoGlobale: IngredientModel? = nil
    @State private var dishWithIngredient:[ProductModel] = []
    @State private var isDeactive: Bool = true
    
    init(ingredientModelCorrente: IngredientModel, isPermanente:Bool, destinationPath:DestinationPath, backgroundColorView: Color) {
        
        self.nomeIngredienteCorrente = ingredientModelCorrente.intestazione
        self.idIngredienteCorrente = ingredientModelCorrente.id
        self.isPermamente = isPermanente
        
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
     
    }
 
   // @State private var isPermamente: Bool = false
    
    var body: some View {
        
        let value:(title:String,image:String,imageColor:Color,message:SystemMessage) = {
            
            if self.isPermamente {
                
                return ("Cambio Permanente","exclamationmark.circle",.red,.sostituzionePermanenteING)
            } else {
                return ("Cambio Temporaneo","clock",Color.seaTurtle_3,.sostituzioneTemporaneaING)
            }
            
        }()
        
        
        CSZStackVB(title: value.title, backgroundColorView: backgroundColorView) {
 
                VStack(alignment:.leading) {
                   

                let mapArray = self.viewModel.ingredientListFilteredBy(idIngredient: idIngredienteCorrente, ingredientStatus: .disponibile)
   
                    CSLabel_conVB(
                        placeHolder: "Sostituire",
                        imageNameOrEmojy: "arrowshape.backward",
                        backgroundColor: Color.black) {
                    
                            HStack {
                              
                                Text(nomeIngredienteCorrente)
                                     .lineLimit(1)
                                     .foregroundStyle(Color.seaTurtle_4)

                                Image(systemName: value.image)
                                    .imageScale(.medium)
                                    .foregroundStyle(value.imageColor)
                               
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
                        
                    DishChangingIngredient_RowSubView(
                            dish:$dish,
                            isDeactive: $isDeactive,
                            isPermanente: isPermamente,
                            nomeIngredienteCorrente: self.nomeIngredienteCorrente,
                            idSostitutoGlobale: idSostitutoGlobaleChecked,
                            nomeSostitutoGlobale: nomeSostitutoGlobale,
                            idIngredienteCorrente: self.idIngredienteCorrente,
                            mapArray: mapArray)
                                .id(modelSostitutoGlobale)

                    }
                }
       
             Spacer()

                    BottomDialogView {
                        self.switchDescription()
                    } disableConditions: {
                        (self.isDeactive,false,false)
                    } secondaryAction: {
                        self.resetAction()
                    } primaryDialogAction: {
                        self.saveButtonDialogView()
                    }
                    .clipped()
                    
                    
            }
           
            .padding(.horizontal,20)
               
  
        }
        .onChange(of: self.dishWithIngredient) { _ , newArray in
            
            var allCheck:Bool = true
            
            for dish in newArray {
                
                if dish.elencoIngredientiOff?[self.idIngredienteCorrente] != nil {
                    allCheck = false
                    break
                }
            }
            self.isDeactive = allCheck
        }
        .onAppear {
            self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: idIngredienteCorrente)
          //  self.count = CountView()
          
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                HStack {
                    Image(systemName: value.image)
                        .imageScale(.large)
                        .foregroundStyle(value.imageColor)
                    
                    CSInfoAlertView(
                        imageScale: .large,
                        title: "Info",
                        message: value.message)
                }//.padding(.horizontal)

            }
        }

        
        
    }
    
    // viewBuilder
    
    @ViewBuilder private func saveButtonDialogView() -> some View {
 
        csBuilderDialogButton {
            
            DialogButtonElement(
                label: .saveEsc) {
                    self.switchAction()
                }
        }
        

    }
    
    
    // method
    
    private func switchDescription() -> (breve:Text,estesa:Text) {
        
        if isPermamente { return descriptionCambioPermanente() }
        else { return descriptionCambioTemporaneo() }
    }
 
    private func descriptionCambioTemporaneo() -> (breve:Text,estesa:Text) {
        
       let dishCount = self.dishWithIngredient.count
       var dishModified = 0
        
        for dish in self.dishWithIngredient {
            
            let off = dish.elencoIngredientiOff ?? [:]
            
            if off.keys.contains(self.idIngredienteCorrente) { dishModified += 1 }
  
        }
        
        let string = csSwitchSingolarePlurale(checkNumber: dishModified, wordSingolare: "piatto", wordPlurale: "piatti")
        let string1 = "L'ingrediente \(nomeIngredienteCorrente) sarà posto nello stato di 'in Pausa'."
        let string2 = dishModified == dishCount ? string1 : "\(string1)\nDove non indicato un sostituto, l'ingrediente sarà quindi mostrato 'reciso'. "
        
       let infoEstesa = Text("Cambi Provvisori:\nPer l'ingrediente \(self.nomeIngredienteCorrente) è stato indicato un sostituto in \(dishModified) \(string) su \(dishCount).\n\(string2)")
        
        let infoBreve = Text("Cambi !! Provvisori !!\nSostituzioni in \(dishModified) \(string) su \(dishCount).")
        
        return (infoBreve,infoEstesa)
    }
        
    private func descriptionCambioPermanente() -> (breve:Text,estesa:Text) {
        
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
            
            else if off.keys.contains(self.idIngredienteCorrente) { dishModified += 1 }
            
            else { dishWhreRemoved += 1}
  
        }
        
        let string1 = csSwitchSingolarePlurale(checkNumber: dishModified, wordSingolare: "piatto", wordPlurale: "piatti")
        let string2 = csSwitchSingolarePlurale(checkNumber: dishLeavedActive, wordSingolare: "piatto", wordPlurale: "piatti")
        let string3 = csSwitchSingolarePlurale(checkNumber: dishWhreRemoved, wordSingolare: "piatto", wordPlurale: "piatti")
       let string4 = dishLeavedActive == 0 ? "L'ingrediente \(nomeIngredienteCorrente) sarà posto nello stato di 'archiviato.'" : "Lo stato dell'ingrediente \(nomeIngredienteCorrente) non sarà mutato."
        
        let infoEstesa = Text("Cambi Permanenti:\nL'ingrediente \(self.nomeIngredienteCorrente) sarà rimosso e sostituito in \(dishModified) \(string1) su \(dishCount).\nSarà soltanto rimosso in \(dishWhreRemoved) \(string3) su \(dishCount).\nRimarrà attivo in \(dishLeavedActive) \(string2) su \(dishCount).\n\(string4)")
        
        let infoBreve = Text("Cambi !! Permanenti !!\nSolo Rimozione: \(dishWhreRemoved) su \(dishCount).\nRimozione e Sostituzione: \(dishModified) su \(dishCount).\nLasciato Attivo in \(dishLeavedActive) \(string2) su \(dishCount).")
        
        return (infoBreve,infoEstesa)
    }
    
    private func switchAction() {
        
        if isPermamente { saveActionPermanente() }
        else { saveActionTemporaneo() }
        
    }
    
    private func saveActionTemporaneo() {
        
        var productUpdated:[ProductModel] = []
        
        for dish in self.dishWithIngredient {
            
            let cleanDish = {
                var cleanCopy = dish
                cleanCopy.idIngredienteDaSostituire = nil
                return cleanCopy
            }()
            
            productUpdated.append(cleanDish)
            
        }
        
      if let currentIngredientModel = self.viewModel.modelFromId(id: self.idIngredienteCorrente, modelPath: \.db.allMyIngredients) /*{
          
          let current = self.viewModel.modelFromId(id: self.idIngredienteCorrente, modelPath: \.db.allMyIngredients)
          return current
       /*   var cleanCopy = current
          cleanCopy?.status = current?.status.changeStatusTransition(changeIn: .inPausa) ?? .bozza()
         
        return cleanCopy*/
      }()*/ {
         /* self.viewModel.alertItem = AlertModel(
              title: "DA SVILUPPARE",
              message: "SVILUPPARE SALVATAGGIO IN BATCH")*/
         // self.viewModel.updateItemModel(itemModel: currentIngredientModel, destinationPath: self.destinationPath) // 31_10_23 Da Sviluppare per salvataggi in batch
          // salviamo l'ingrediente
       //   self.viewModel.updateModel(itemModel: currentIngredientModel)
          self.viewModel.manageCambioStatusModel(model: currentIngredientModel, nuovoStatus: .inPausa)
          
          self.viewModel.updateModelCollection(
            items: productUpdated,
            sub: .allMyDish,
            destinationPath: self.destinationPath)
          
      } else {
            self.viewModel.alertItem = AlertModel(
                title: "Errore",
                message: "L'ingrediente corrente non esiste come modello nel viewModel.")
        }
        
    }
    
    private func saveActionPermanente() {
        
        var dishUpdated:[ProductModel] = []
        var dishThatNotChange = 0
        
        for dish in dishWithIngredient {
        
            if dish.idIngredienteDaSostituire == nil {
                dishThatNotChange += 1
                continue }
            
            let (path,posizione) = dish.individuaPathIngrediente(idIngrediente: self.idIngredienteCorrente)
            
            let cleanDish = {
                var cleanCopy = dish
                cleanCopy.idIngredienteDaSostituire = nil
                
                if let sostituto = cleanCopy.elencoIngredientiOff?[self.idIngredienteCorrente] {
                    
                    cleanCopy[keyPath:path!]![posizione!] = sostituto
                    cleanCopy.elencoIngredientiOff?[self.idIngredienteCorrente] = nil
                    
                } else { cleanCopy[keyPath:path!]!.remove(at: posizione!) }

                return cleanCopy
            }()
            
            dishUpdated.append(cleanDish)
          /* self.viewModel.alertItem = AlertModel(
                title: "DA SVILUPPARE",
                message: "SVILUPPARE SALVATAGGIO IN BATCH")*/
          //  self.viewModel.updateItemModel(itemModel: cleanDish) // 31_10_23 Da Sviluppare per salvataggi in batch
        }
        
        guard dishThatNotChange == 0 else { 
            
            self.viewModel.updateModelCollection(
                items: dishUpdated,
                sub: .allMyDish,
                destinationPath: self.destinationPath)
            
            return }
        
        if let currentIngredientModel = self.viewModel.modelFromId(id: self.idIngredienteCorrente, modelPath: \.db.allMyIngredients) /*{
            
            let current = self.viewModel.modelFromId(id: self.idIngredienteCorrente, modelPath: \.db.allMyIngredients)
            var cleanCopy = current
            cleanCopy?.status = current?.status.changeStatusTransition(changeIn: .archiviato) ?? .bozza()
            return cleanCopy
            
        }()*/ {
           
          //  self.viewModel.updateItemModel(itemModel: currentIngredientModel, destinationPath: self.destinationPath) // 31_10_23 Da Sviluppare per salvataggi in batch
          //  self.viewModel.updateModel(
              //  itemModel: currentIngredientModel)
            
            self.viewModel.manageCambioStatusModel(model: currentIngredientModel, nuovoStatus: .archiviato)
            
            self.viewModel.updateModelCollection(
                items: dishUpdated,
                sub: .allMyDish,
                destinationPath: self.destinationPath)
            
        } else {
              self.viewModel.alertItem = AlertModel(
                  title: "Errore",
                  message: "L'ingrediente corrente non esiste come modello nel viewModel.")
          }
        
        
    }
    
    
    private func resetAction() {
 
        self.modelSostitutoGlobale = nil
     //   self.isPermamente = false
        self.dishWithIngredient = self.viewModel.dishFilteredByIngrediet(idIngredient: idIngredienteCorrente)
        
        // Spiegato il funzionamento in Nota Vocale il 10.08
    }
    
    private func checkSostitutoGlobale(currentDish: ProductModel) ->(idChecked:String?,nome:String?) {
        
        guard self.modelSostitutoGlobale != nil else { return (nil,nil) }
        
        // 01.09
        let idSostitutoGlobale = self.modelSostitutoGlobale!.id
        let nameSostitutoGlobale = self.modelSostitutoGlobale!.intestazione
        
        guard let off = currentDish.elencoIngredientiOff else {
            return (idSostitutoGlobale,nameSostitutoGlobale)
        }
       guard off[self.idIngredienteCorrente] != idSostitutoGlobale else {return (idSostitutoGlobale,nameSostitutoGlobale) }
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
