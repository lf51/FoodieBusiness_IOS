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
        
        CSZStackVB(title: self.newDish.intestazione == "" ? "\(genere) \(percorsoNew.simpleDescription())" : self.newDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                let disabilita = self.disabilitaSwitch()
                //  CSDivider()
                SwitchProductType(
                    percorsoItem:$newDish.percorsoProdotto,
                    nascondiTesto: disabilita)
                    .csHpadding()
                    .disabled(disabilita)
  
                vbPercorsoProdotto()
                    .id(percorsoNew)

            }
            
        } // end ZStack Esterno
      
    }
    
    // Method
    
    @ViewBuilder private func vbPercorsoProdotto() -> some View {
                
        switch self.newDish.percorsoProdotto {
            
       case .finito,.composizione:
            
             NewDishIbridView(
                newDish: $newDish,
                disabilitaPicker: $disabilitaPicker,
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath,
                observedVM: viewModel)
            
        default:
          
            NewDishMainView(
                newDish: $newDish,
                disabilitaPicker: $disabilitaPicker,
                backgroundColorView: backgroundColorView,
                destinationPath: destinationPath,
                saveDialogType: saveDialogType)
            
        }
    }
    
    private func disabilitaSwitch() -> Bool {
        
        self.newDish.status != .bozza() ||
        self.disabilitaPicker
        
    }
    
}

struct NewProductMainView_Previews: PreviewProvider {

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
}
