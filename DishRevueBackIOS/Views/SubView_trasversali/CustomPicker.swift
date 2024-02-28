//
//  CustomPicker.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage

/// La variabile selezionata nel Picker è al livello Binding. Background/Opacity di Default -> Color.white/opacity(0.8) Di default il container sarà centrifugato, utile per eliminare duplicati fra i case enum - Bool inserito per essere disabilitato con le CategorieMenu
struct CS_Picker<E:MyProEnumPack_L1>: View {
    
    // passa da MyEnumProtocolMapConform a MyProEnumPackL0
    
    @Binding var selection: E
    let customLabel:String
    let dataContainer: [E]
    var cleanAndOrderContainer:Bool = true
    var backgroundColor: Color? = Color.white
    var opacity: CGFloat? = 0.8

    @State private var showCustomLabel: Bool = true
    
    var body: some View {
       
                Picker(selection:$selection) {
                             
                    if showCustomLabel {Text(customLabel).tag(E.defaultValue)}
                    
                    let container = cleanAndOrderContainer ? csCleanAndOrderArray(array: dataContainer) : dataContainer
                    
                    ForEach(container, id:\.self) {filter in

                            Text(filter.simpleDescription())
                                .tag(filter)
                        }
                              
                } label: {Text("")}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                         // .padding(.horizontal)
                          .background(
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(backgroundColor!.opacity(opacity!))
                            .shadow(radius: 1.0)
                    )
                    
                          .onChange(of: selection) {
                               self.showCustomLabel = false
                                    }


    }
    
}

/// Mantiene una label per il ritorno allo stato di default
struct CS_PickerWithDefault<E:MyProEnumPack_L1>: View {

    @Binding var selection: E
    let customLabel:String
    let dataContainer: [E]
    var backgroundColor: Color? = Color.white
    var opacity: CGFloat? = 0.8

    @State private var showCustomLabel: Bool = false
    
    var body: some View {
       
                Picker(selection:$selection) {
                             
                    Text(showCustomLabel ? "Non Specificato" : customLabel)
                        .tag(E.defaultValue)
                    
                        ForEach(dataContainer, id:\.self) {filter in

                            Text(filter.simpleDescription())
                                .tag(filter)
                                .lineLimit(1)
                            
                        }
                              
                } label: {Text("")}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                          
                         // .padding(.horizontal)
                          .background(
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(backgroundColor!.opacity(opacity!))
                            .shadow(radius: 1.0)
                    )
                    
                          .onChange(of: selection) {
                               
                              self.showCustomLabel = selection != .defaultValue
                              
                                    }

    }
    
}

/// La variabile selezionata nel Picker è al livello State
struct CS_PickerDoubleState<E:MyProEnumPack_L1>: View {
    
    // passa da MyEnumProtocolMapConform a MyProEnumPackL0
    
    @State var selection: E
    let customLabel:String
    let dataContainer: [E]
    let action: (_ category: E) -> Void
  
    var body: some View {
        
        CS_Picker(selection: $selection,customLabel: customLabel, dataContainer: dataContainer)
        .onChange(of: selection) { _, newValue in
            action(newValue)
        }
    }
}
