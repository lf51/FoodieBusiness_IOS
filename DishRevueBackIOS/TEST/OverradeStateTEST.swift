//
//  OverradeStateTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/08/22.
//

import SwiftUI

/*
 https://forums.swift.org/t/swiftui-state-init-wrappedvalue-vs-init-initialvalue-whats-the-difference/38904/4
 */

/// You can override @State value as long as you give it a new id!!
struct FooFooPicker: View {
    @State private var selection: Int

    init(_ val: Int) {
        _selection = State(wrappedValue: val)
    }

    var body: some View {
        VStack {
            Text("Selection: \(selection)")
            Picker("Numbers", selection: $selection) {
                ForEach(0...5, id: \.self) { number in
                    Text(verbatim: "\(number)").tag(number)
                }
            }
        }
    }
}


struct PickerDefaultSettable: View {
    @State var defaultOverride = 0
    @State var id = 0
    var body: some View {
        VStack {
            FooFooPicker(defaultOverride)
              //  .id(id)     // invalidate the view state
            Text("DefaultOverride: \(defaultOverride)")
            VStack {
                ForEach(0...5, id: \.self) { number in
                    Button("\(number)") {
                        defaultOverride = number
                        id += 1     // generate a new id
                    }
                }
            }
        }
    }
}

struct PickerDefaultSettable_Previews: PreviewProvider {
    static var previews: some View {
        PickerDefaultSettable()
    }
}
