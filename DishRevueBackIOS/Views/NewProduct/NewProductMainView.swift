//
//  NewDishMAINView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/03/22.
//  Last deeper Modifing terminate 16.07

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct NewProductMainView: View {
   
    @EnvironmentObject var viewModel: AccounterVM
    @State private var newProduct: ProductModel
    
    let backgroundColorView: Color
    let destinationPath: DestinationPath
    
    @State private var disabilitaPicker:Bool = false
    
    init(newProduct: ProductModel, backgroundColorView: Color, destinationPath: DestinationPath) {
        
        self.newProduct = newProduct
        
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath

    }
    
    var body: some View {
        
        let viewTitle = self.viewTitle()
        let disabilita = self.disabilitaSwitch()
        
        CSZStackVB(
            title: viewTitle,
            backgroundColorView: backgroundColorView) {
            
            VStack {

                SwitchProductType(
                    percorsoItem: $newProduct.adress,
                    nascondiTesto: disabilita)
                    .csHpadding()
                    .disabled(disabilita)

                    vbPercorsoProdotto()
                        .id(newProduct.adress)

            }
           /* .onAppear {
                newProduct.prepareForEditing(viewModel: viewModel)
            }*/
            
        } // end ZStack Esterno
      
    }
    
    // Method
    private func viewTitle() -> String {
        
        let intestazione = self.newProduct.intestazione
        guard intestazione == "" else { return intestazione}
        
        let adress = self.newProduct.adress
        let genere:String = adress.genereCase()
        
        let viewTitle =  "\(genere) \(adress.simpleDescription())"
        return viewTitle
    }
        
  @ViewBuilder private func vbPercorsoProdotto() -> some View {
      
     NewProductIbridView(
        newDish: $newProduct,
        disabilitaPicker: $disabilitaPicker,
        backgroundColorView: .seaTurtle_1,
        destinationPath: destinationPath)
    }
    
    private func disabilitaSwitch() -> Bool {
        
       // let modelExist = self.viewModel.isTheModelAlreadyExist(modelID: self.newProduct.id, path: \.db.allMyDish)
        let conditionBasic = disabilitaThrowAdress()
        
        return conditionBasic || self.disabilitaPicker
       /* self.newProduct.status != .noStatus ||
        self.disabilitaPicker*/
        
    }
    
    private func disabilitaThrowAdress() -> Bool {
        
        let modelExist = self.viewModel.isTheModelAlreadyExist(modelID: self.newProduct.id, path: \.db.allMyDish)
        
        guard !modelExist else { return modelExist }
        
        switch self.newProduct.adress {
        case .preparazione,.composizione:
            return modelExist
        case .finito:
            
            if let rif = newProduct.rifIngredienteSottostante {
                    
               let rifExist = self.viewModel.isTheModelAlreadyExist(modelID: rif, path: \.db.allMyIngredients)
                
               return rifExist
                    
            } else {
                return true // in questo caso vi è un errore
            }

        }
        
    }
    
    
}

/*struct NewProductMainView: View {
    // 10.07.23 bug id esistente. vedi Nota
    @EnvironmentObject var viewModel: AccounterVM
   // let newDish: ProductModel
    @State private var newDish: ProductModel
    let backgroundColorView: Color
    let destinationPath: DestinationPath
    let saveDialogType:SaveDialogType
    
    @State private var disabilitaPicker:Bool = false
   // @State private var type:ProductModel.PercorsoProdotto // deprecato
    
    init(newDish: ProductModel, backgroundColorView: Color, destinationPath: DestinationPath,saveDialogType:SaveDialogType) {
        
       // self.newDish = newDish
        self.newDish = newDish
        
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
        self.saveDialogType = saveDialogType
      
        //self.type = newDish.percorsoProdotto
    }
    
    var body: some View {
        
        let percorsoNew = self.newDish.percorsoProdotto
        let genere:String = percorsoNew == .finito() ? "Nuovo" : "Nuova"
        let viewTitle = self.newDish.intestazione == "" ? "\(genere) \(percorsoNew.simpleDescription())" : self.newDish.intestazione
        
        CSZStackVB(
            title: viewTitle,
            backgroundColorView: backgroundColorView) {
            
            VStack {
                
                let disabilita = self.disabilitaSwitch()
                let value = Binding {
                    newDish.percorsoProdotto.returnTypeCase()
                } set: { new in
                    newDish.percorsoProdotto = new
                }

                //  CSDivider()
                SwitchProductType(
                    percorsoItem:value,
                    nascondiTesto: disabilita)
                    .csHpadding()
                    .disabled(disabilita)
  
                vbPercorsoProdotto()
                    .id(percorsoNew)

            }//.csHpadding()
            .onAppear() {
                self.viewModel.logMessage = "Controllare e verificare funzionalità saveDialog Ridotto"
            }
            
        } // end ZStack Esterno
      
    }
    
    // Method
    
    @ViewBuilder private func vbPercorsoProdotto() -> some View {
              
        switch self.newDish.percorsoProdotto {
            
        case .preparazione:
            
            NewProductIbridView(
               newDish: $newDish,
               sottostante: nil,
               disabilitaPicker: $disabilitaPicker,
               backgroundColorView: backgroundColorView,
               destinationPath: destinationPath,
               saveDialogType: saveDialogType)
            
        case .composizione(let ing):
            // l'ingrediente sottostante può essere modificato se trattasi di modifica del prodotto
            let ingredient:IngredientModel = {
                
                if let ing { return ing }
                else { return IngredientModel() }
            }()
            
            NewProductIbridView(
               newDish: $newDish,
               sottostante: ingredient,
               disabilitaPicker: $disabilitaPicker,
               backgroundColorView: backgroundColorView,
               destinationPath: destinationPath,
               saveDialogType: saveDialogType)
            
        case .finito(let rif):
            // se trattasi di modifica di un prodotto, le modifiche al sottostante devono essere bloccate
            let ingredient:(model:IngredientModel,lock:Bool) = {
                
                if let rif,
                let ing = self.viewModel.modelFromId(id: rif, modelPath: \.db.allMyIngredients) {
                   return (ing,true)
                }
                else { return (IngredientModel(),false) }
            }()
            
             NewProductIbridView(
                newDish: $newDish, 
                sottostante: ingredient.model,
                lockEditSottostante: ingredient.lock,
                disabilitaPicker: $disabilitaPicker,
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath,
                saveDialogType: saveDialogType)

            
        }
    }
    
    private func disabilitaSwitch() -> Bool {
        
        self.newDish.status != .noStatus ||
        self.disabilitaPicker
        
    }
    
}*/ // backUp_22_11_23

/*struct NewProductMainView_Previews: PreviewProvider {

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
    
    static let dishSample:ProductModel = {
       var dish = ProductModel()
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
        dish.percorsoProdotto = .preparazione
     
        dish.ingredientiPrincipali = []
        dish.ingredientiSecondari = [ingredientSample3.id,ingredientSample4.id]
        dish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample2.id]
        return dish
        
    }()
    
    @StateObject static var viewModel:AccounterVM = {
   
        let user = UserRoleModel()
        
        var viewM = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))
        viewM.db.allMyDish = [dishSample]
        viewM.db.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
        return viewM
    }()
    
    static var previews: some View {
        
        NavigationStack {
            
            NewProductMainView(newDish: ProductModel(), backgroundColorView: Color.seaTurtle_1, destinationPath: .dishList,saveDialogType: .completo)
            
        }.environmentObject(viewModel)
    }
}*/
