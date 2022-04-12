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





struct ItemModelCategoryViewBuilder: View {
    
    @EnvironmentObject var viewModel: AccounterVM

    let dataContainer:[MapCategoryContainer]
    @State private var selectedMapCategory: MapCategoryContainer
    @State private var statusFilter: ModelStatus = .defaultValue
    
    init(dataContainer:[MapCategoryContainer]) {
       
        self.dataContainer = dataContainer
        selectedMapCategory = dataContainer[0] // il default A..Z
        
    }
    
    var body: some View {

        VStack(alignment:.leading) {
                
            DataModelPickerView_SubView(selectedMapCategory: $selectedMapCategory, statusFilter: $statusFilter, dataContainer: dataContainer)

            HStack {
                
                allCases(filtro: selectedMapCategory)
                
                Spacer()
            }
            
            
                Spacer()
        }
        .padding(.horizontal)
        
    }
    
  @ViewBuilder func allCases (filtro: MapCategoryContainer) -> some View {
        
        switch filtro {
            
        case .menuAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyMenu, statusFilter: statusFilter)
        case .ingredientAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyIngredients, statusFilter: statusFilter)
        case .dishAz:
            DataModelAlphabeticView_Sub(dataContainer: viewModel.allMyDish, statusFilter: statusFilter)
            
        case .tipologiaMenu:
            viewCategoryItemModel(mapElement: .tipologiaMenu, modelType: viewModel.allMyMenu, elementType: TipologiaMenu.self)
        case .giorniDelServizio:
            viewCategoryItemModel(mapElement: .giorniDelServizio, modelType: viewModel.allMyMenu, elementType: GiorniDelServizio.self)
        case .statusMenu:
            notListed()
            
        case .conservazione:
            viewCategoryItemModel(mapElement: .conservazione, modelType: viewModel.allMyIngredients, elementType: ConservazioneIngrediente.self)
        case .produzione:
            viewCategoryItemModel(mapElement: .produzione,modelType: viewModel.allMyIngredients, elementType: ProduzioneIngrediente.self)
        case .provenienza:
            viewCategoryItemModel(mapElement: .provenienza,modelType: viewModel.allMyIngredients, elementType: ProvenienzaIngrediente.self)
            
        case .categoria:
            viewCategoryItemModel(mapElement: .categoria, modelType: viewModel.allMyDish, elementType: DishCategoria.self)
        case .base:
            viewCategoryItemModel(mapElement: .base, modelType: viewModel.allMyDish, elementType: DishBase.self)
        case .tipologiaPiatto:
            viewCategoryItemModel(mapElement: .tipologiaPiatto, modelType: viewModel.allMyDish, elementType: DishTipologia.self)
        case .statusPiatto:
            notListed()
        }
    }
    
    func notListed() -> some View {
        Text("Dentro ViewBuilder allCases - Case non settato")
    }
    
    
    private func viewCategoryItemModel<T:MyEnumProtocolMapConform, M:MyModelProtocol>(mapElement: MapCategoryContainer, modelType: [M], elementType: T.Type) -> some View {
         
        var dataModel:[M] = modelType
        var dataMapping:[T] = []

         switch mapElement {
         
         // DishModel
             
         case .categoria:
             //dataModel = viewModel.allMyDish as! [M]

             dataMapping = dataModel.map({ item in
                 
                 let dishModel = item as! DishModel
                 return dishModel.categoria as! T
          
             })
        
         case .base:
            // dataModel = viewModel.allMyDish as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let dishModel = item as! DishModel
                 return dishModel.aBaseDi as! T
                 
             })
             
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
       
        func dataFiltering<G:MyEnumProtocolMapConform, M:MyModelProtocol>(element: G, data: [M]) -> [M] {
           
           var dataFiltering:[M] = data
           
            switch mapElement {
              // MenuModel
            case .tipologiaMenu:
                dataFiltering = dataModel.filter({ item in
                    let menuModel = item as! MenuModel
                    return menuModel.tipologia.returnTypeCase() == element as! TipologiaMenu
                }) as! [M]
                
            case .giorniDelServizio:
                dataFiltering = dataModel.filter({ item in
                   let menuModel = item as! MenuModel
                    return menuModel.giorniDelServizio.contains(element as! GiorniDelServizio)
                }) as! [M]
            /*
            case .statusMenu:
                <#code#>
                */
             // IngredientModel
            case .conservazione:
                dataFiltering = dataModel.filter({ item in
                    let ingredientModel = item as! IngredientModel
                    return ingredientModel.conservazione == element as! ConservazioneIngrediente
                }) as! [M]
                
            case .produzione:
                dataFiltering = dataModel.filter({ item in
                    let ingredientModel = item as! IngredientModel
                    return ingredientModel.produzione == element as! ProduzioneIngrediente
                }) as! [M]
                
            case .provenienza:
                dataFiltering = dataModel.filter({ item in
                    let ingredientModel = item as! IngredientModel
                    return ingredientModel.provenienza == element as! ProvenienzaIngrediente
                }) as! [M]
                
           // DishModel
            case .categoria:
                dataFiltering = dataModel.filter({ item in
                    let dishModel = item as! DishModel
                    return dishModel.categoria == element as! DishCategoria
                }) as! [M]
            case .base:
                dataFiltering = dataModel.filter({ item in
                    let dishModel = item as! DishModel
                    return dishModel.aBaseDi == element as! DishBase
                }) as! [M]
            case .tipologiaPiatto:
                dataFiltering = dataModel.filter({ item in
                    let dishModel = item as! DishModel
                    return dishModel.tipologia == element as! DishTipologia
                }) as! [M]
           /* case .statusPiatto:
                <#code#> */
                
            default:
                dataFiltering = []
            }
           
            return dataFiltering.sorted { $0.intestazione < $1.intestazione }
           
       }

        
        let dataMappingCentrifugato = myCentrifugaEnumTypeArray(array: dataMapping)
        let dataMappingSet = Array(Set(dataMappingCentrifugato))
        let dataMappingArray = dataMappingSet.sorted{$0.orderValue() < $1.orderValue()}
        
        return DataModelCategoryView_SubView(dataMapping: dataMappingArray) { category in
            dataFiltering(element: category, data: dataModel)
        }
         
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
