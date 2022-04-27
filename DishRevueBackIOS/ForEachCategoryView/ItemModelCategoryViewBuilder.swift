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
    @State private var stringSearch: String = ""
    
    init(dataContainer:[MapCategoryContainer]) {
       
        self.dataContainer = dataContainer
        mapCategory = dataContainer[0] // il default
        print("INIT ITEM_MODEL_CATEGORY")
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
            DataModelCategoryView_SubView<DishModel, DishBase>(dataMapping: dataMappingManipolato, stringSearch: self.$stringSearch) { element in
                
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

 /*func deepFiltering<M:MyModelProtocol>(model:M, filterCategory:MapCategoryContainer) -> Bool {
    
    switch filterCategory {
        
    case .tipologiaMenu(let internalFilter):
        
        guard internalFilter != nil else { return true}
        let menuModel = model as! MenuModel
        return menuModel.tipologia.returnTypeCase() == internalFilter
        
    case .giorniDelServizio(let filter):
        
        guard filter != nil else { return true}
        let menuModel = model as! MenuModel
        return menuModel.giorniDelServizio.contains(filter!)
        
    case .statusMenu:
        print("Dentro statusMenu/deepFiltering - Da Settare")
        return true
        
    case .conservazione(let filter):
        
        guard filter != nil else { return true}
        let ingredientModel = model as! IngredientModel
        return ingredientModel.conservazione == filter
        
    case .produzione(let filter):
        
        guard filter != nil else { return true}
        let ingredientModel = model as! IngredientModel
        return ingredientModel.produzione == filter
        
    case .provenienza(let filter):
        
        guard filter != nil else { return true}
        let ingredientModel = model as! IngredientModel
        return ingredientModel.provenienza == filter
        
    case .categoria(let filter):
        
        guard filter != nil else { return true}
        let dishModel = model as! DishModel
        return dishModel.categoria == filter
        
    case .base(let filter):
        
        guard filter != nil else { return true}
        let dishModel = model as! DishModel
        return dishModel.aBaseDi == filter
        
    case .tipologiaPiatto(let filter):
        
        guard filter != nil else { return true}
        let dishModel = model as! DishModel
        return dishModel.tipologia == filter
        
    case .statusPiatto:
        print("Dentro statusPiatto/deepFiltering - Da Settare")
        return true
        
    case .menuAz, .ingredientAz,.dishAz, .reset:
        return true

    }
  
} */
  /*  @ViewBuilder func vbModelList (mapCategory: MapCategoryContainer, filterCategory: MapCategoryContainer) -> some View {
    
        switch mapCategory {
            
        case .menuAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyMenu, filterCategory: filterCategory)
        case .ingredientAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyIngredients, filterCategory: filterCategory)
        case .dishAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyDish, filterCategory: filterCategory)
            
        case .tipologiaMenu:
            modelMapping(mapElement: .tipologiaMenu(), modelType: viewModel.allMyMenu, elementType: TipologiaMenu.self, filterCategory: filterCategory)
        case .giorniDelServizio:
            modelMapping(mapElement: .giorniDelServizio(), modelType: viewModel.allMyMenu, elementType: GiorniDelServizio.self, filterCategory: filterCategory)
        case .statusMenu:
            notListed()
            
        case .conservazione:
            modelMapping(mapElement: .conservazione(), modelType: viewModel.allMyIngredients, elementType: ConservazioneIngrediente.self, filterCategory: filterCategory)
        case .produzione:
            modelMapping(mapElement: .produzione(), modelType: viewModel.allMyIngredients, elementType: ProduzioneIngrediente.self, filterCategory: filterCategory)
        case .provenienza:
            modelMapping(mapElement: .provenienza(), modelType: viewModel.allMyIngredients, elementType: ProvenienzaIngrediente.self, filterCategory: filterCategory)
            
        case .categoria:
            
            let dataMapping = viewModel.allMyDish.map({$0.categoria})
            let dataMappingCentrifugato = myRipulisciArray(array: dataMapping)
            modelMapping(mapElement: .categoria(), modelType: viewModel.allMyDish, elementType: DishCategoria.self, filterCategory: filterCategory)
        case .base:
            modelMapping(mapElement: .base(), modelType: viewModel.allMyDish, elementType: DishBase.self, filterCategory: filterCategory)
        case .tipologiaPiatto:
            modelMapping(mapElement: .tipologiaPiatto(), modelType: viewModel.allMyDish, elementType: DishTipologia.self, filterCategory: filterCategory)
        case .statusPiatto:
            notListed()
        }
    } */
    
   
    
    
  /*  private func modelMapping<T:MyEnumProtocolMapConform, M:MyModelProtocol>(mapElement: MapCategoryContainer, modelType: [M], elementType: T.Type, filterCategory:MapCategoryContainer) -> some View {
         
        var dataModel:[M] = modelType
        var dataMapping:[T] = []

         switch mapElement {
         
         // DishModel
             
   
        
         case .base:
            // dataModel = viewModel.allMyDish as! [M]
            
             
         case .tipologiaPiatto:
            // dataModel = viewModel.allMyDish as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let dishModel = item as! DishModel
                 return dishModel.tipologia as! T
                 
             })
             
            /*     case .statusPiatto
             dataModel = viewModel.allMyDish as! [M]
             step1 = dataModel.map({ item in
                 
                 let dishModel = item as! DishModel
                 return dishModel.categoria as! T
                 
             }) */ // manca la proprietà
             
             
             // MenuModel
         case .tipologiaMenu:
           //  dataModel = viewModel.allMyMenu as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let menuModel = item as! MenuModel
                 return menuModel.tipologia as! T
                 
             })
             
         case .giorniDelServizio:
            // dataModel = viewModel.allMyMenu as! [M]
             dataMapping = GiorniDelServizio.allCases as! [T]
            /* dataMapping = dataModel.map({ item in
                 
                 let menuModel = item as! MenuModel
                 return menuModel.giorniDelServizio as! T
                 
             }) */ // i giorni del servizio sono un Array
             
        /* case .statusMenu:
             dataModel = viewModel.allMyMenu as! [M]
             step1 = dataModel.map({ item in
                 
                 let menuModel = item as! MenuModel
                 return menuModel.status as! T
                 
             }) */ // Manca ancora la proprietà
             
         // IngredientModel
         case .conservazione:
             
            // dataModel = viewModel.allMyIngredients as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let ingredientModel = item as! IngredientModel
                 return ingredientModel.conservazione as! T
                 
             })
            
         case .produzione:
             
            // dataModel = viewModel.allMyIngredients as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let ingredientModel = item as! IngredientModel
                 return ingredientModel.produzione as! T
                 
             })
             
         case .provenienza:
             
            // dataModel = viewModel.allMyIngredients as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let ingredientModel = item as! IngredientModel
                 return ingredientModel.provenienza as! T
                 
             })
             
         default:
             dataModel = []
             dataMapping = []
        
         }
       
        let dataMappingCentrifugato = myRipulisciArray(array: dataMapping)
        let dataMappingSet = Array(Set(dataMappingCentrifugato))
        let dataMappingArray = dataMappingSet.sorted{$0.orderValue() < $1.orderValue()}
        
        return DataModelCategoryView_SubView(dataMapping: dataMappingArray) { category in
            dataFiltering(mapElement:mapElement, element: category, dataModel: dataModel, filterCategory: filterCategory)
        }
         
     } */

   /* func dataFiltering<G:MyEnumProtocolMapConform, M:MyModelProtocol>(mapElement:MapCategoryContainer, element: G, dataModel: [M], filterCategory:MapCategoryContainer) -> [M] {
       
       var dataFiltering:[M] = dataModel
       
        switch mapElement {
          // MenuModel
        case .tipologiaMenu:
            
            dataFiltering = dataModel.filter({ item in
                let menuModel = item as! MenuModel
                let firstBool = menuModel.tipologia.returnTypeCase() == element as! TipologiaMenu
                return firstBool && deepFiltering(model: menuModel, filterCategory: filterCategory)
            })
            
        case .giorniDelServizio:
            
            dataFiltering = dataModel.filter({ item in
               let menuModel = item as! MenuModel
               let firstBool = menuModel.giorniDelServizio.contains(element as! GiorniDelServizio)
               return firstBool && deepFiltering(model: menuModel, filterCategory: filterCategory)
            })
        /*
        case .statusMenu:
            <#code#>
            */
         // IngredientModel
        case .conservazione:
            
            dataFiltering = dataModel.filter({ item in
                let ingredientModel = item as! IngredientModel
                let firstBool = ingredientModel.conservazione == element as! ConservazioneIngrediente
                return firstBool && deepFiltering(model: ingredientModel, filterCategory: filterCategory)
            })
            
        case .produzione:
            
            dataFiltering = dataModel.filter({ item in
                let ingredientModel = item as! IngredientModel
                let firstBool = ingredientModel.produzione == element as! ProduzioneIngrediente
                return firstBool && deepFiltering(model: ingredientModel, filterCategory: filterCategory)
            })
            
        case .provenienza:
            
            dataFiltering = dataModel.filter({ item in
                let ingredientModel = item as! IngredientModel
                let firstBool = ingredientModel.provenienza == element as! ProvenienzaIngrediente
                return firstBool && deepFiltering(model: ingredientModel, filterCategory: filterCategory)
            })
            
       // DishModel
        case .categoria:
            
            dataFiltering = dataModel.filter({ item in
                let dishModel = item as! DishModel
                let firstBool = dishModel.categoria == element as! DishCategoria
                return firstBool && deepFiltering(model: dishModel, filterCategory: filterCategory)
            })
            
        case .base:
            
            dataFiltering = dataModel.filter({ item in
                let dishModel = item as! DishModel
                let firstBool = dishModel.aBaseDi == element as! DishBase
                return firstBool && deepFiltering(model: dishModel, filterCategory: filterCategory)
            })
            
        case .tipologiaPiatto:
            
            dataFiltering = dataModel.filter({ item in
                let dishModel = item as! DishModel
                let firstBool = dishModel.tipologia == element as! DishTipologia
                return firstBool && deepFiltering(model: dishModel, filterCategory: filterCategory)
            })
       /* case .statusPiatto:
            <#code#> */
            
        default:
            dataFiltering = []
        }
       
        return dataFiltering.sorted { $0.intestazione < $1.intestazione }
       
   } */



struct Conferma_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allIngredientMapCategory).environmentObject(AccounterVM())
            
        }
        
    }
}
