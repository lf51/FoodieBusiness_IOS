//
//  DataModelPickerView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI

/*

struct DataModelPickerView_SubView: View {
    
    @Binding var selectedMapCategory: MapCategoryContainer
    @State private var deepMapCategory: MapCategoryContainer
   // @Binding var filterMapCategory: E
    
  // @Binding var statusFilter: ModelStatus
    let dataContainer:[MapCategoryContainer]
    
    init (dataContainer:[MapCategoryContainer], mapCategory: Binding<MapCategoryContainer>) {
        
        self.dataContainer = dataContainer
        _selectedMapCategory = mapCategory
        deepMapCategory = dataContainer[1]
        
    }
    
    
    var body: some View {

        HStack {
            
            HStack {
                
              Image(systemName: "eye")
                
                Picker(selection:$selectedMapCategory) {
                              
                    ForEach(dataContainer, id:\.self) {filter in
           
                            Text(filter.simpleDescription())
             
                              }
                              
                          } label: {Text("")}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                          .padding(.horizontal)
                          .background(
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.white.opacity(0.8))
                            .shadow(radius: 1.0)
                    )
                    
            }
            .padding(.leading)
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke()
                    .fill(Color.white.opacity(0.5))
                    
            )
       // .padding(.bottom)
            
         //   Spacer()
     // Secondo Picker
            
            HStack {
                
              Image(systemName: "eye")
                
                Picker(selection:$deepMapCategory) {
                              
                    ForEach(dataContainer, id:\.self) {filter in
                        
                        if filter != selectedMapCategory {
                            
                            
                            vbCompilePicker(deepCategory: deepMapCategory, label: filter.simpleDescription())
                            
                            
                            
                        }
                        else {EmptyView()}
                        
                            
                              }
                              
                          } label: {Text("")}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                          .padding(.horizontal)
                          .background(
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.white.opacity(0.8))
                            .shadow(radius: 1.0)
                    )
                    
            }
            .padding(.leading)
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke()
                    .fill(Color.white.opacity(0.5))
                    
            )

           // Terzo Picker
            
         //  compilePicker(deepCategory: deepMapCategory)
        
        
        }
     
      //  .padding()
        .padding(.bottom)
    }
    

    
    
}

struct DataModelPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            DataModelPickerView_SubView(dataContainer: MapCategoryContainer.allIngredientMapCategory, mapCategory: .constant(.provenienza))
        }
    }
}


struct CS_Picker<E:MyEnumProtocolMapConform>: View {
    
    @State var selection: String = ""
    let dataContainer: [E]
    let label: String
    
    init(dataContainer:[E], label:String) {
        
        self.dataContainer = dataContainer
     //   _selection = Binding(dataContainer[0])
        self.label = label
    }
    
    var body: some View {
        
      //  HStack {
            
         // Image(systemName: "eye")
            
            Picker(selection:$selection) {
                          
                ForEach(dataContainer, id:\.self) {filter in
                           
                    Text(filter.simpleDescription())
                        
                          }
                          
            } label: {Text(label)}
            
        /*
                      .pickerStyle(MenuPickerStyle())
                      .accentColor(Color.black)
                      .padding(.horizontal)
                      .background(
                    
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.white.opacity(0.8))
                        .shadow(radius: 1.0)
                ) */
                
     //   }
      /*  .padding(.leading)
        .background(
            
            RoundedRectangle(cornerRadius: 5.0)
                .stroke()
                .fill(Color.white.opacity(0.5))
                
        ) */
        
        
    }
    
}

@ViewBuilder func vbCompilePicker(deepCategory:MapCategoryContainer, label:String ) -> some View {
    
    switch deepCategory {
        
    case .tipologiaMenu:
        CS_Picker(dataContainer: TipologiaMenu.allCases, label: label)
    case .giorniDelServizio:
        CS_Picker(dataContainer: GiorniDelServizio.allCases, label: label)
    case .statusMenu:
        CS_Picker(dataContainer: TipologiaMenu.allCases, label: label)
        
    case .conservazione:
        CS_Picker(dataContainer: ConservazioneIngrediente.allCases, label: label)
    case .produzione:
        CS_Picker(dataContainer: ProduzioneIngrediente.allCases, label: label)
    case .provenienza:
        CS_Picker(dataContainer: ProvenienzaIngrediente.allCases, label: label)
        
    case .categoria:
        CS_Picker(dataContainer: DishCategoria.allCases, label: label)
    case .base:
        CS_Picker(dataContainer: DishBase.allCases, label: label)
    case .tipologiaPiatto:
        CS_Picker(dataContainer: DishTipologia.allCases, label: label)
    case .statusPiatto:
        CS_Picker(dataContainer: DishCategoria.allCases, label: label)
        
    case .menuAz:
        CS_Picker(dataContainer: TipologiaMenu.allCases, label: label)
    case .ingredientAz:
        CS_Picker(dataContainer: ConservazioneIngrediente.allCases, label: label)
    case .dishAz:
        CS_Picker(dataContainer: DishCategoria.allCases, label: label)
    }
    
    
}


/*func compileContainer<E:MyEnumProtocolMapConform>(deepCategory: MapCategoryContainer, containerType: E.Type) -> some View {
    
    var dataContainer:[E] = []
     
    switch deepCategory {
        
    case .tipologiaMenu:
        dataContainer = TipologiaMenu.allCases as! [E]
    case .giorniDelServizio:
        dataContainer = GiorniDelServizio.allCases as! [E]
    case .statusMenu:
        dataContainer = []
        
    case .conservazione:
        dataContainer = ConservazioneIngrediente.allCases as! [E]
    case .produzione:
        dataContainer = ProduzioneIngrediente.allCases as! [E]
    case .provenienza:
        dataContainer = ProvenienzaIngrediente.allCases as! [E]
        
    case .categoria:
        dataContainer = DishCategoria.allCases as! [E]
    case .base:
        dataContainer = DishBase.allCases as! [E]
    case .tipologiaPiatto:
        dataContainer = DishTipologia.allCases as! [E]
    case .statusPiatto:
        dataContainer = []
        
    case .menuAz, .ingredientAz,.dishAz:
        dataContainer = []

    }

    return CS_Picker(dataContainer: dataContainer)
    
    
} */



*/
