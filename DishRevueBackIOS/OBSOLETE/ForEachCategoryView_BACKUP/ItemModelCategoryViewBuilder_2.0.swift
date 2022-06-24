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


/* // INIZIO BACKUP 18.06


struct ItemModelCategoryViewBuilder: View {
    
    @EnvironmentObject var viewModel: AccounterVM

    let dataContainer:[MapCategoryContainer]

    @State private var mapCategory: MapCategoryContainer
    @State private var filterCategory: MapCategoryContainer = .defaultValue // il resetValue
    @State private var stringSearch: String = ""
    
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
                
                vbModelList(mapCategory: mapCategory, filterCategory: filterCategory)
   
                Spacer()
        }
        .padding(.horizontal)
  
    }
    
    @ViewBuilder func vbModelList(mapCategory: MapCategoryContainer, filterCategory: MapCategoryContainer) -> some View {
    
        switch mapCategory {
            
        case .menuAz:
            
     
            
           DataModelAlphabeticViewTEST_Sub(stringSearch: self.$stringSearch, dataFiltering: $viewModel.allMyMenu)
          
         /*   DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyMenu, stringSearch: self.$stringSearch) {
                
                let dataFiltering = viewModel.allMyMenu.filter({ model in
                    
                    let firstBool = viewModel.deepFiltering(model: model, filterCategory: filterCategory)
                    let secondBool = viewModel.stringResearch(item: model, stringaRicerca: self.stringSearch)
                    
                    return firstBool && secondBool
                })
                return dataFiltering
            } */
            
        case .ingredientAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyIngredients, stringSearch: self.$stringSearch) {
                
                let dataFiltering = viewModel.allMyIngredients.filter({ model in
                    
                    let firstBool = viewModel.deepFiltering(model: model, filterCategory: filterCategory)
                    let secondBool = viewModel.stringResearch(item: model, stringaRicerca: self.stringSearch)
                    
                    return firstBool && secondBool
                })
                return dataFiltering
            }
        case .dishAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyDish, stringSearch: self.$stringSearch) {
                
                let dataFiltering = viewModel.allMyDish.filter({ model in
                    
                    let firstBool = viewModel.deepFiltering(model: model, filterCategory: filterCategory)
                    let secondBool = viewModel.stringResearch(item: model, stringaRicerca: self.stringSearch)
                    
                    return firstBool && secondBool
                })
                return dataFiltering
                
            }
            
        case .tipologiaMenu:
            let dataMapping = viewModel.allMyMenu.map({$0.tipologia})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            
            DataModelCategoryView_SubView<MenuModel, TipologiaMenu>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
       
                let dataFiltering = viewModel.allMyMenu.filter({ item in
                    let firstBool = item.tipologia.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .giorniDelServizio:
            let dataMapping = GiorniDelServizio.allCases
           // let dataMappingManipolato = myRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<MenuModel, GiorniDelServizio>(dataMapping: dataMapping, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyMenu.filter({ item in
                    let firstBool = item.giorniDelServizio.contains(element)
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .statusMenu:
            notListed()
            
        case .conservazione:
            let dataMapping = viewModel.allMyIngredients.map({$0.conservazione})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<IngredientModel, ConservazioneIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyIngredients.filter({ item in
                    let firstBool = item.conservazione.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .produzione:
            let dataMapping = viewModel.allMyIngredients.map({$0.produzione})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<IngredientModel, ProduzioneIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyIngredients.filter({ item in
                    let firstBool = item.produzione.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .provenienza:
            let dataMapping = viewModel.allMyIngredients.map({$0.provenienza})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<IngredientModel, ProvenienzaIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyIngredients.filter({ item in
                    let firstBool = item.provenienza.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
            
        case .categoria:
            
            let dataMapping = viewModel.allMyDish.map({$0.categoria})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<DishModel, DishCategoria>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyDish.filter({ item in
                    let firstBool = item.categoria.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .base:
            
            let dataMapping = viewModel.allMyDish.map({$0.aBaseDi})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<DishModel, OrigineIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyDish.filter({ item in
                    let firstBool = item.aBaseDi.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .tipologiaPiatto:
            
            let dataMapping = viewModel.allMyDish.map({$0.tipologia})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<DishModel, DishTipologia>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyDish.filter({ item in
                    let firstBool = item.tipologia.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .statusPiatto:
            notListed()
            
        case .reset:
            EmptyView() // Non viene mai letto, perchè il .reset non è inserito in nessun AllCases
        }
    }
    
    func notListed() -> some View {
        Text("Dentro ViewBuilder allCases - Case non settato")
    }
    
}



/*struct ItemModelCategoryViewBuilder: View {
    
    @EnvironmentObject var viewModel: AccounterVM

    let dataContainer:[MapCategoryContainer]

    @State private var mapCategory: MapCategoryContainer
    @State private var filterCategory: MapCategoryContainer = .defaultValue // il resetValue
    @State private var stringSearch: String = ""
    
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
                
                vbModelList(mapCategory: mapCategory, filterCategory: filterCategory)
   
                Spacer()
        }
        .padding(.horizontal)
  
    }
    
    @ViewBuilder func vbModelList(mapCategory: MapCategoryContainer, filterCategory: MapCategoryContainer) -> some View {
    
        switch mapCategory {
            
        case .menuAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyMenu, stringSearch: self.$stringSearch) {
                
                let dataFiltering = viewModel.allMyMenu.filter({ model in
                    
                    let firstBool = viewModel.deepFiltering(model: model, filterCategory: filterCategory)
                    let secondBool = viewModel.stringResearch(item: model, stringaRicerca: self.stringSearch)
                    
                    return firstBool && secondBool
                })
                return dataFiltering
            }
        case .ingredientAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyIngredients, stringSearch: self.$stringSearch) {
                
                let dataFiltering = viewModel.allMyIngredients.filter({ model in
                    
                    let firstBool = viewModel.deepFiltering(model: model, filterCategory: filterCategory)
                    let secondBool = viewModel.stringResearch(item: model, stringaRicerca: self.stringSearch)
                    
                    return firstBool && secondBool
                })
                return dataFiltering
            }
        case .dishAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyDish, stringSearch: self.$stringSearch) {
                
                let dataFiltering = viewModel.allMyDish.filter({ model in
                    
                    let firstBool = viewModel.deepFiltering(model: model, filterCategory: filterCategory)
                    let secondBool = viewModel.stringResearch(item: model, stringaRicerca: self.stringSearch)
                    
                    return firstBool && secondBool
                })
                return dataFiltering
                
            }
            
        case .tipologiaMenu:
            let dataMapping = viewModel.allMyMenu.map({$0.tipologia})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            
            DataModelCategoryView_SubView<MenuModel, TipologiaMenu>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
       
                let dataFiltering = viewModel.allMyMenu.filter({ item in
                    let firstBool = item.tipologia.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .giorniDelServizio:
            let dataMapping = GiorniDelServizio.allCases
           // let dataMappingManipolato = myRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<MenuModel, GiorniDelServizio>(dataMapping: dataMapping, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyMenu.filter({ item in
                    let firstBool = item.giorniDelServizio.contains(element)
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .statusMenu:
            notListed()
            
        case .conservazione:
            let dataMapping = viewModel.allMyIngredients.map({$0.conservazione})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<IngredientModel, ConservazioneIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyIngredients.filter({ item in
                    let firstBool = item.conservazione.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .produzione:
            let dataMapping = viewModel.allMyIngredients.map({$0.produzione})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<IngredientModel, ProduzioneIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyIngredients.filter({ item in
                    let firstBool = item.produzione.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .provenienza:
            let dataMapping = viewModel.allMyIngredients.map({$0.provenienza})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<IngredientModel, ProvenienzaIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyIngredients.filter({ item in
                    let firstBool = item.provenienza.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
            
        case .categoria:
            
            let dataMapping = viewModel.allMyDish.map({$0.categoria})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<DishModel, DishCategoria>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyDish.filter({ item in
                    let firstBool = item.categoria.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .base:
            
            let dataMapping = viewModel.allMyDish.map({$0.aBaseDi})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<DishModel, OrigineIngrediente>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyDish.filter({ item in
                    let firstBool = item.aBaseDi.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .tipologiaPiatto:
            
            let dataMapping = viewModel.allMyDish.map({$0.tipologia})
            let dataMappingManipolato = csRipulisciArray(array: dataMapping)
            DataModelCategoryView_SubView<DishModel, DishTipologia>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
                let dataFiltering = viewModel.allMyDish.filter({ item in
                    let firstBool = item.tipologia.returnTypeCase() == element
                    let secondBool = viewModel.deepFiltering(model: item, filterCategory: filterCategory)
                    let thirdBool = viewModel.stringResearch(item: item, stringaRicerca: self.stringSearch)
                    return firstBool && secondBool && thirdBool
                })
                return dataFiltering
            }
        case .statusPiatto:
            notListed()
            
        case .reset:
            EmptyView() // Non viene mai letto, perchè il .reset non è inserito in nessun AllCases
        }
    }
    
    func notListed() -> some View {
        Text("Dentro ViewBuilder allCases - Case non settato")
    }
    
}*/ //  BACKUP 17.06 -> Per Trasformazione da let a Binding dei Model nelle Row





struct Conferma_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allIngredientMapCategory).environmentObject(AccounterVM())
            
        }
        
    }
}



*/ // BACKUP 18.06
