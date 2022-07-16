//
//  DataModelPickerView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI


struct DataModelPickerView_SubView: View {
    
    let dataContainer:[MapCategoryContainer]
    @Binding var mapCategory: MapCategoryContainer
  //  @Binding var stringSearch: String
    
    @Binding var filterCategory: MapCategoryContainer // richiede un valoreAssociato
    @State private var emptyFilterCategory: MapCategoryContainer = .defaultValue
    /*Empty e filterCategory sono due facce della stessa medaglia. La empty serve per il secondo picker, mentre la filter è la sua gemella e serve a portare su il valore associato. Nella versione precedente le due var coincidevano e questo generava un bug visivo nel picker */
    @State private var showFilter: Bool = false
    @State private var showFilterCategory: Bool = false
    
    var body: some View {

        VStack(alignment:.leading) {
            
            HStack {
                
                CS_Picker(selection: $mapCategory, customLabel: "Scegli..", dataContainer: updateContainer(element: filterCategory))
               // Spacer()
                
                CSButton_tight(title: self.showFilter ? "Reset" : "Filtri", fontWeight: .semibold, titleColor: Color.blue, fillColor: Color.clear) {
                    withAnimation {
                        if self.showFilter {
                            self.filterCategory = .defaultValue
                        }
                        self.showFilter.toggle()
                    }
                }

                Spacer()
                
            }
           // .padding()
   
            if showFilter {
            
                HStack {
                    
                    CS_Picker(selection: $emptyFilterCategory, customLabel: "Scegli..", dataContainer: updateContainer(element: mapCategory))
                        .onChange(of: emptyFilterCategory) { newValue in
                            let conditions:[MapCategoryContainer] = [.menuAz, .ingredientAz, .dishAz]
                            if conditions.contains(newValue) { self.filterCategory = newValue}
                            else { self.showFilterCategory = true }
                        }

                    if showFilterCategory{vbCompilePicker(emptyFilterCategory: emptyFilterCategory)}
                       
                    Spacer()
                    
                   // CSTextField_4(textFieldItem: $stringSearch, placeHolder: "Ricerca..", image: "text.magnifyingglass")
                }
            
            }

        }

       // .padding(.bottom)
        
    }
    
    // Method
    
    private func updateContainer(element: MapCategoryContainer) -> [MapCategoryContainer] {
        
        var container = self.dataContainer
        guard element != .reset else { return container }
        
        let plainElement = element.returnTypeCase()
        let index = container.firstIndex(of: plainElement)
        container.remove(at: index!)
        return container
    
    }
    
    @ViewBuilder func vbCompilePicker(emptyFilterCategory: MapCategoryContainer) -> some View {
        
        switch emptyFilterCategory {
            
        case .tipologiaMenu(_):
            CS_PickerDoubleState(selection: TipologiaMenu.defaultValue, customLabel: "Scegli..", dataContainer: TipologiaMenu.allCases) { category in
                self.filterCategory = .tipologiaMenu(filter: category)
            }
        case .giorniDelServizio(_):
            
            CS_PickerDoubleState(selection: GiorniDelServizio.defaultValue, customLabel: "Scegli..", dataContainer: GiorniDelServizio.allCases) { category in
                
                self.filterCategory = .giorniDelServizio(filter: category)
                
            }
        case .statusMenu:
            EmptyView()
            
        case .conservazione(_):
    
            CS_PickerDoubleState(selection: ConservazioneIngrediente.defaultValue, customLabel: "Scegli..", dataContainer: ConservazioneIngrediente.allCases) { category in
                self.filterCategory = .conservazione(filter: category)
            }
        case .produzione(_):
            CS_PickerDoubleState(selection: ProduzioneIngrediente.defaultValue, customLabel: "Scegli..", dataContainer: ProduzioneIngrediente.allCases) { category in
                self.filterCategory = .produzione(filter: category)
            }
        case .provenienza(_):
            CS_PickerDoubleState(selection: ProvenienzaIngrediente.defaultValue, customLabel: "Scegli..", dataContainer: ProvenienzaIngrediente.allCases) { category in
                self.filterCategory = .provenienza(filter: category)
            }
            
        case .categoria(_):
            
          /*  CS_PickerDoubleState(selection: DishCategoria.defaultValue, customLabel: "Scegli..", dataContainer: DishCategoria.allCases) { category in
                
                self.filterCategory = .categoria(filter: category) */
            CS_PickerDoubleState(selection: CategoriaMenu.defaultValue, customLabel: "Scegli..", dataContainer: CategoriaMenu.allCases) { category in
                  
                  self.filterCategory = .categoria(filter: category)
            }
        case .base(_):
            
            CS_PickerDoubleState(selection: OrigineIngrediente.defaultValue, customLabel: "Scegli..", dataContainer: OrigineIngrediente.allCases) { category in
                self.filterCategory = .base(filter: category)
            }
        case .tipologiaPiatto(_):
            
            CS_PickerDoubleState(selection: DishTipologia.defaultValue, customLabel: "Scegli..", dataContainer: DishTipologia.allCases) { category in
                
                self.filterCategory = .tipologiaPiatto(filter: category)
            }
        case .statusPiatto:
            EmptyView()
            
        case .menuAz:
           
           EmptyView()
        case .ingredientAz:
            
            EmptyView()
        case .dishAz:
           
            EmptyView()
            
        case .reset:
            EmptyView()
        }
    }
}

/*struct DataModelPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            DataModelPickerView_SubView(dataContainer: MapCategoryContainer.allIngredientMapCategory, mapCategory: .constant(.provenienza()), filterCategory: .constant(.produzione()))
        }
    }
} */


