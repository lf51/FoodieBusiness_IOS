//
//  Conferma.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import SwiftUI

/*
 
 Filtro e Mapping -> Abbiamo costruito un mapping filtrato in ordine alfabetico. Adesso stiamo valutando l'implementazione di un filtro a incrociare. Quindi potremmo avere un mapping per categoria principale (ritornado quindi indietro di un paio di settimane, quando avevamo una sola categoria che stabilivamo dal protocollo) che poi incrociamo con le altre categorie. Per cui, ad esempio, i piatti verrebbero tutti mappati per categoria (primo, secondo, ecc) e poi incrociati con altre richieste, tipo la base e la tipologia o lo status. Così se vogliamo sapere quali piatti abbiamo a base di pesce, o quali piatti abbiamo vegani, selezioniamo il filtro, e la lista viene sempre mappata per categoria ma filtrata per la seconda richiesta.
 
 
 */


/*
 
 15.04 --> SISTEMARE il Texfield di ricerca. Implementare la funzione di ricerca nel ViewModel
 --> Completare e Valutare di spostare tutte le funzioni di MAp e Ricerca nel viewMOdel
 
 
 */





struct ItemModelCategoryViewBuilder: View {
    
    @EnvironmentObject var viewModel: AccounterVM

    let dataContainer:[MapCategoryContainer]

    @State private var mapCategory: MapCategoryContainer
    @State private var filterCategory: MapCategoryContainer = .defaultValue // il resetValue
   // @State private var stringSearch: String = "" // deprecato -> Evitiamo di portarci la stringa di ricerca fra i vari picker di filtraggio
    
    init(dataContainer:[MapCategoryContainer]) {
       
        self.dataContainer = dataContainer
        mapCategory = dataContainer[0] // il default
        print("INIT -> ItemModelCategoryViewBuilder - Struct:View - type: \(mapCategory.simpleDescription())")
    }
    
    var body: some View {

        VStack(alignment:.leading) {

            HStack {
                
                DataModelPickerView_SubView(dataContainer: dataContainer, mapCategory: $mapCategory, filterCategory: $filterCategory)
            }
                
                vbModelList()
   
                Spacer()
        }
        .padding(.horizontal)
  
    }
    
    @ViewBuilder private func vbModelList() -> some View {
    // Abbiamo realizzato una versione generica che però fatica a funzionare. Non abbiamo voluto perderci tempo per farla funzionare, uno perchè non sapevamo come, e due perchè non volevamo perderci troppo tempo dato che questa versione funziona e non richiede tanto più linee di codice della generica
        switch self.mapCategory {
            
        case .menuAz:
   
            DataModelAlphabeticView_Sub(filterCategory: self.filterCategory, dataPath: \.allMyMenu)
          
        case .ingredientAz:
            
            DataModelAlphabeticView_Sub(filterCategory: self.filterCategory, dataPath: \.allMyIngredients)
   
        case .dishAz:
            
            DataModelAlphabeticView_Sub(filterCategory: self.filterCategory, dataPath: \.allMyDish)
            
        case .tipologiaMenu:
        
            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \MenuModel.tipologia, dataPath: \.allMyMenu)
            
        case .giorniDelServizio:
         
            DataModelCategoryView_SubView(dataMapping: GiorniDelServizio.allCases, filterCategory: self.filterCategory, collectionPath: \MenuModel.giorniDelServizio, dataPath: \.allMyMenu)
            
        case .statusMenu:
            notListed()
            
        case .conservazione:
            
            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \IngredientModel.conservazione, dataPath: \.allMyIngredients)

        case .produzione:

            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \IngredientModel.produzione, dataPath: \.allMyIngredients)

        case .provenienza:

            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \IngredientModel.provenienza, dataPath: \.allMyIngredients)

        case .categoria:
            
            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \DishModel.categoria, dataPath: \.allMyDish)
            
        case .base:

            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \DishModel.aBaseDi, dataPath: \.allMyDish)
            
        case .tipologiaPiatto:
 
            DataModelCategoryView_SubView(filterCategory: self.filterCategory, path: \DishModel.tipologia,  dataPath: \.allMyDish)

        case .statusPiatto:
            notListed()
            
        case .reset:
            EmptyView() // Non viene mai letto, perchè il .reset non è inserito in nessun AllCases
        }
    } // BACKUP 19.06
    
    func notListed() -> some View {
        Text("Dentro ViewBuilder allCases - Case non settato")
    }
    
}


struct Conferma_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allIngredientMapCategory).environmentObject(AccounterVM())
            
        }
        
    }
}




