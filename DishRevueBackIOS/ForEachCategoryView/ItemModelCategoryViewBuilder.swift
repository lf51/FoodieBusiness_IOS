//
//  Conferma.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import SwiftUI


struct ItemModelCategoryViewBuilder: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var selectedMapCategory: MapCategoryContainer = .ingredientDefault
    let dataContainer:[MapCategoryContainer]
    
    var body: some View {

        DataModelPickerView_SubView(selectedMapCategory: $selectedMapCategory, dataContainer: dataContainer)
        
        allCases(filtro: selectedMapCategory)
        
    }
    
  @ViewBuilder func allCases (filtro: MapCategoryContainer) -> some View {
        
        switch filtro {
            
        case .tipologiaMenu:
            viewCategoryItemModel(mapElement: .tipologiaMenu, modelType: MenuModel.self, elementType: TipologiaMenu.self)
        case .giorniDelServizio:
            notListed()
        case .statusMenu:
            notListed()
            
        case .conservazione:
            viewCategoryItemModel(mapElement: .conservazione,modelType: IngredientModel.self, elementType: ConservazioneIngrediente.self)
        case .produzione:
            viewCategoryItemModel(mapElement: .produzione,modelType: IngredientModel.self, elementType: ProduzioneIngrediente.self)
        case .provenienza:
            viewCategoryItemModel(mapElement: .provenienza,modelType: IngredientModel.self, elementType: ProvenienzaIngrediente.self)
            
        case .categoria:
            viewCategoryItemModel(mapElement: .categoria, modelType: DishModel.self, elementType: DishCategoria.self)
        case .base:
            viewCategoryItemModel(mapElement: .base, modelType: DishModel.self, elementType: DishBase.self)
        case .tipologiaPiatto:
            viewCategoryItemModel(mapElement: .tipologiaPiatto, modelType: DishModel.self, elementType: DishTipologia.self)
        case .statusPiatto:
            notListed()
        }
    }
    
    func notListed() -> some View {
        Text("Dentro ViewBuilder - Case non settato")
    }
    
    
    private func viewCategoryItemModel<T:MyEnumProtocolMapConform, M:MyModelProtocol>(mapElement: MapCategoryContainer, modelType: M.Type, elementType: T.Type) -> some View {
         
        var dataModel:[M] = []
        var dataMapping:[T] = []

         switch mapElement {
         
         // DishModel
             
         case .categoria:
             dataModel = viewModel.allMyDish as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let dishModel = item as! DishModel
                 return dishModel.categoria as! T
                 
             })
             
         case .base:
             dataModel = viewModel.allMyDish as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let dishModel = item as! DishModel
                 return dishModel.aBaseDi as! T
                 
             })
             
         case .tipologiaPiatto:
             dataModel = viewModel.allMyDish as! [M]
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
             dataModel = viewModel.allMyMenu as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let menuModel = item as! MenuModel
                 return menuModel.tipologia as! T
                 
             })
             
       /*  case .giorniDelServizio:
             dataModel = viewModel.allMyMenu as! [M]
             step1 = dataModel.map({ item in
                 
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
             
             dataModel = viewModel.allMyIngredients as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let ingredientModel = item as! IngredientModel
                 return ingredientModel.conservazione as! T
                 
             })
            
         case .produzione:
             
             dataModel = viewModel.allMyIngredients as! [M]
             dataMapping = dataModel.map({ item in
                 
                 let ingredientModel = item as! IngredientModel
                 return ingredientModel.produzione as! T
                 
             })
             
         case .provenienza:
             
             dataModel = viewModel.allMyIngredients as! [M]
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
                    return menuModel.tipologia == element as! TipologiaMenu
                }) as! [M]
           /* case .giorniDelServizio:
                <#code#>
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
           
           return dataFiltering
           
       }

        
        let dataMappingUnique = Array(Set(dataMapping))
        
        return DataModelCategoryView_SubView(dataMapping: dataMappingUnique) { category in
            dataFiltering(element: category, data: dataModel)
        }
         
     }


}


struct Conferma_Previews: PreviewProvider {
    static var previews: some View {
        ItemModelCategoryViewBuilder(dataContainer: MapCategoryContainer.allIngredientMapCategory).environmentObject(AccounterVM())
    }
}

