//
//  CS_PickerMultiSelector.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/05/22.
//

import SwiftUI

// Importato da:
/* https://betterprogramming.pub/multi-selector-in-swiftui-52238dc2a690 */

/*
struct CS_PickerMultiSelector<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    var selected: Binding<Set<Selectable>>

    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0) })
    }

    var body: some View {
        NavigationLink(destination: multiSelectionView()) {
           
            HStack {
                label
                Spacer()
                Text(formattedSelectedListString)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
            }
           
        }
    }

    private func multiSelectionView() -> some View {
       // Text("TODO: add multi selection detail view here")
        MultiSelectionView(
            options: self.options,
            optionToString: self.optionToString,
            selected: self.selected)
        
    }
}

struct CS_PickerMultiSelector_Previews: PreviewProvider {
    
    @State static var ingredient: IngredientModel = IngredientModel(nome: "Guanciale")
    
    static var previews: some View {
        
        NavigationView {
            CS_PickerMultiSelector(
                label: Text("MultiSelect"),
                options: AllergeniIngrediente.allCases,
                optionToString: {$0.simpleDescription()},
                selected: $ingredient.allergeniBis)
        }
        
       
    }
}



struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String

    @Binding
    var selected: Set<Selectable>
    
    var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable)).foregroundColor(.black)

                        Spacer()

                        if selected.contains { $0.id == selectable.id } {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }.tag(selectable.id)
            }
        }.listStyle(InsetListStyle())
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
}

*/
