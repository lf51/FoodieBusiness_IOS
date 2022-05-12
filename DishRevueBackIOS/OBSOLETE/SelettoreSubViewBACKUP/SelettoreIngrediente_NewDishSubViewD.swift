//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI


/* // BACKUP 10.05
///Main View creazione di un Selettore Generico di Model. M1 è l'oggetto principale. M2 è l'oggetto da associare.
struct SelettoreIngrediente_NewDishSubViewD<M1:MyModelProtocol, M2:MyModelProtocol>: View {
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height

    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M1

    @State private var elencoModelList: [ModelList] = []
    @State private var temporarySelectionIngredients: [String:[M2]] = [:]
    @State private var modelListCorrente: ModelList = .allFromCommunity

  /*  @State private var temporarySelectionIngredients: [String:[IngredientModel]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]] */

    
    init (itemModel: Binding<M1>, containerModel: M2.Type) {
        
        _itemModel = itemModel
        print("Numero KeySelection: \(temporarySelectionIngredients.keys.count)")
        initElencoListe(itemModel: self.itemModel)
        initTemporarySelectionDictionary(container: containerModel)
        
    }
    
    private func initElencoListe(itemModel:M1) {
        
     //   let item: M1
        
        switch itemModel {
            
       /*case is IngredientModel:*/
          //  let current = itemModel as! IngredientModel

        case is DishModel:
          //  let current = itemModel as! DishModel
            self.elencoModelList = ModelList.allMenuList
            self.modelListCorrente = .allMyMenu
            
   /*     case is MenuModel:
           // let current = itemModel as! MenuModel
            
        case is PropertyModel:
          //  let current = itemModel as! PropertyModel
    
            */
        default:
            self.elencoModelList = ModelList.allMenuList
            self.modelListCorrente = .allMyMenu
        }
        
        
    }
    
    private func initTemporarySelectionDictionary(container: M2.Type) {
        
      //  let emptyContainer:[M2]
        
        switch container {
            
        case is IngredientModel.Type:
            
          //  emptyContainer = [IngredientModel]() as! [M2]
         //   self.temporarySelectionIngredients["IngredientiPrincipali"] = [IngredientModel]()
          //  self.temporarySelectionIngredients = ["IngredientiPrincipali": emptyContainer, "IngredientiSecondari": emptyContainer]
            self.temporarySelectionIngredients = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]
           print("Model Associato -> IngredientModel")
            
            
        default:
            
            self.temporarySelectionIngredients = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]
            print("Model Associato -> Default")
            
        }
        
        print("Numero KeySelection: \(temporarySelectionIngredients.keys.count)")
   
    }
    
  /*  private var isAggiungiButtonDisabled: Bool {
        
        modelListCorrente == .ingredientiPrincipali || modelListCorrente == .ingredientiSecondari || (temporarySelectionIngredients["IngredientiPrincipali"]!.isEmpty && temporarySelectionIngredients["IngredientiSecondari"]!.isEmpty)
  
    } */
    
    var body: some View {

        VStack(alignment: .leading) {
            
            SwitchListeIngredientiPiatto(newDish: $itemModel, listaDaMostrare: $modelListCorrente)
                .padding(.horizontal)
                .padding(.top)
            
            SwitchListeIngredienti(listaDaMostrare: $modelListCorrente)
                .padding()
                .background(Color.cyan.opacity(0.5))

          /*  ListaIngredienti_ConditionalView(newDish: $newDish, listaDaMostrare: $listaDaMostrare, temporarySelectionIngredients: $temporarySelectionIngredients) */
            // .refreshable -> per aggiornare
            
            ListaIngredienti_ConditionalView(itemModel: $itemModel, listaDaMostrare: $modelListCorrente, temporarySelectionIngredients: $temporarySelectionIngredients)
            
            CSButton_large(title: "Aggiungi", accentColor: Color.white, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                self.aggiungiNewDishIngredients()
                
                }//.disabled(isAggiungiButtonDisabled)
        }
        .background(Color.white.cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
  
    }
    
    // Methodi & Oggetti
    
    private func aggiungiNewDishIngredients() {

       /* self.newDish.ingredientiPrincipali.append(contentsOf: self.temporarySelectionIngredients["IngredientiPrincipali"]!)
        
        self.newDish.ingredientiSecondari.append(contentsOf: self.temporarySelectionIngredients["IngredientiSecondari"]!) */
        
        print("Action AggiungiListe -> Al momento Svuota le Liste temporanee. Da configurare")
        
        self.temporarySelectionIngredients["IngredientiPrincipali"]! = []
        self.temporarySelectionIngredients["IngredientiSecondari"]! = []
      
    }
         
}

struct SelettoreIngrediente_NewDishSubViewD_Previews: PreviewProvider {
    
  //  static var propertyVM: PropertyVM = PropertyVM()
    static var viewModel: AccounterVM = AccounterVM()
    
    static var previews: some View {
        
        ZStack {
            Color.cyan.opacity(0.8)
            Group{
                VStack{
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                }
                .padding()
                .foregroundColor(Color.white)
        
            }
        
          //  SelettoreIngrediente_NewDishSubView(newDish: .constant(DishModel()))

        }.onTapGesture {
            SelettoreIngrediente_NewDishSubViewD_Previews.test()
        }
       
    }
    
    static func test() {
        
        for x in 1...20 {
            
        var ingrediente = IngredientModel()
            
            ingrediente.intestazione = "\(x.description)' ingredient"
            
            viewModel.allMyIngredients.append(ingrediente)
            
        }
        
    }
    
} */
