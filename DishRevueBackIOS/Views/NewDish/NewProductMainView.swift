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
    
    let newDish: DishModel
    let backgroundColorView: Color
    let destinationPath: DestinationPath
    
    @State private var type:DishModel.PercorsoProdotto
    
    init(newDish: DishModel, backgroundColorView: Color, destinationPath: DestinationPath) {
        
        self.newDish = newDish
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
      
       /* if newDish.ingredientiPrincipali.contains(newDish.id) {
            self.type = .prodottoFinito
        } else { self.type = .preparazioneFood } */ // Modifica 25.10
        self.type = newDish.percorsoProdotto
    }
    
    var body: some View {
        
        CSZStackVB(title: self.newDish.intestazione == "" ? "Nuovo \(self.type.simpleDescription())" : self.newDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                let disabilita = self.disabilitaSwitch()
                //  CSDivider()
                SwitchProductType(type:$type,nascondiTesto: disabilita)
                    .padding(.horizontal)
                    .disabled(disabilita)
                
                vbPercorsoProdotto()
                    .id(type) // serve ad aggiornare, altrimenti nel passaggio da food a beverage il valore non cambia in quanto usa la stessa View

                
            }
            
        } // end ZStack Esterno
    }
    
    // Method
    
    @ViewBuilder private func vbPercorsoProdotto() -> some View {
        
        switch self.type {
            
        case .prodottoFinito:
            NewDishIbridView(newDish: newDish, percorso: type, backgroundColorView: backgroundColorView, destinationPath: destinationPath, observedVM: viewModel)
        default:
            NewDishMainView(newDish: newDish, percorso: type, backgroundColorView: backgroundColorView, destinationPath: destinationPath)
            
        }
    }
    
    private func disabilitaSwitch() -> Bool {
        
        self.newDish.status != .bozza()
        
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
        dish.percorsoProdotto = .preparazioneBeverage
     
        dish.ingredientiPrincipali = []
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
            
            NewProductMainView(newDish: DishModel(), backgroundColorView: Color("SeaTurtlePalette_1"), destinationPath: .dishList)
            
        }.environmentObject(viewModel)
    }
}


