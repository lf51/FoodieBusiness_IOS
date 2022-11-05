//
//  TestGrid.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/11/22.
//

import SwiftUI

struct TestGrid: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    let backgroundColorView: Color
    var body: some View {
        
        FilterRowContainer(backgroundColorView: backgroundColorView) {
         
                self.filterProperty = FilterPropertyModel()
            
        } content: {

          //  VStack {
                
                let container = self.viewModel.filtraERicerca(containerPath: \.allMyIngredients, filterProperty: filterProperty)
                
                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), imageOrEmoji: "circle.dashed"){ value in
                    container.filter({$0.status.checkStatusTransition(check: value)}).count
                }
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor:Color.teal.opacity(0.6), imageOrEmoji: "cart"){ value in
                    container.filter({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == value}).count
                }
                    
                FilterRow_Generic(allCases: ProvenienzaIngrediente.allCases, filterProperty: $filterProperty.provenienzaING, selectionColor: Color.gray,imageOrEmoji:"globe.americas"){ value in
                    container.filter({$0.provenienza == value}).count
                }
                
                FilterRow_Generic(allCases: ProduzioneIngrediente.allCases, filterProperty: $filterProperty.produzioneING, selectionColor: Color.green,imageOrEmoji: "sun.min.fill"){ value in
                    container.filter({$0.produzione == value}).count
                }

                FilterRow_Generic(allCases: ConservazioneIngrediente.allCases, filterCollection: $filterProperty.conservazioneING, selectionColor: Color.cyan,imageOrEmoji:"thermometer.snowflake"){ value in
                    container.filter({$0.conservazione == value}).count
                }
                
                FilterRow_Generic(allCases: OrigineIngrediente.allCases, filterProperty: $filterProperty.origineING, selectionColor: Color.brown,imageOrEmoji:"leaf"){ value in
                    container.filter({$0.origine == value}).count
                }
                
                FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), imageOrEmoji: "allergens"){ value in
                    container.filter({$0.allergeni.contains(value)}).count
                }
                
          //  }
        
        }
    }
}

struct TestGrid_Previews: PreviewProvider {
    static var previews: some View {
        TestGrid(backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}
