//
//  CustomPicker.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/05/22.
//

import Foundation
import SwiftUI


/// La variabile selezionata nel Picker è al livello Binding. Background/Opacity di Default -> Color.white/opacity(0.8)
struct CS_Picker<E:MyEnumProtocolMapConform>: View {
    
    @Binding var selection: E
    let customLabel:String
    let dataContainer: [E]
    var backgroundColor: Color? = Color.white
    var opacity: CGFloat? = 0.8

    @State private var showCustomLabel: Bool = true
    
    var body: some View {
       
                Picker(selection:$selection) {
                             
                    if showCustomLabel {Text(customLabel)}
                    
                        ForEach(dataContainer, id:\.self) {filter in

                            Text(filter.simpleDescription()) }
                              
                } label: {Text("")}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                          .padding(.horizontal)
                          .background(
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(backgroundColor!.opacity(opacity!))
                            .shadow(radius: 1.0)
                    )
                    
                        .onChange(of: selection) { _ in
                               self.showCustomLabel = false
                                    }


    }
    
}

/// La variabile selezionata nel Picker è al livello State
struct CS_PickerDoubleState<E:MyEnumProtocolMapConform>: View {
    
    @State var selection: E
    let customLabel:String
    let dataContainer: [E]
    let action: (_ category: E) -> Void
  
    var body: some View {
        
        CS_Picker(selection: $selection,customLabel: customLabel, dataContainer: dataContainer)
        .onChange(of: selection) { newValue in
            action(newValue)
        }
    }
}
