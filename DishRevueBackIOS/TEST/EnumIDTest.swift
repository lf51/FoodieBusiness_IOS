//
//  EnumIDTest.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 13/09/22.
//

import SwiftUI
import MyFoodiePackage

enum IDTest:String,MyProStarterPack_L0 {

  //  let id = UUID().uuidString
    var id: String { UUID().uuidString }
    
    case one
    case two
    case three
    
    case noValue
}


struct EnumIDTest: View {
    
    @State private var idTestCase: IDTest = .one
    @State private var fromRawValue: IDTest = .one
    
    var body: some View {
        
        VStack {
            
            Text("\(idTestCase.rawValue)")
            Text("\(idTestCase.id)")
            
            Divider()
            
            Text("\(fromRawValue.rawValue)")
            Text("\(fromRawValue.id)")
            
            Button("Change") {
                convertRawValue(value: idTestCase.rawValue)
            }
        }
    }
    
    func convertRawValue(value:String) {
        
        if let new:IDTest = IDTest(rawValue: value) {
            fromRawValue = new
        }
    
    }
}

struct EnumIDTest_Previews: PreviewProvider {
    static var previews: some View {
        EnumIDTest()
    }
}
