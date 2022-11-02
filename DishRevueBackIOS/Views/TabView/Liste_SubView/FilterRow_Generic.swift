//
//  FilterRow_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/11/22.
//

import SwiftUI

struct FilterRow_Generic<P:MyProEnumPack_L0>:View {
    
    let allCases:[P]
    @Binding var specificFilterProperty: P?
    @Binding var specificFilterCollection: [P]
    let color: Color
    var image: String = "circle.fill"
    
    private let initType:InitType
    
    init(allCases:[P],filterProperty:Binding<P?>,selectionColor:Color,image:String) {
        
        self.initType = .single
        
        self.allCases = allCases
        _specificFilterProperty = filterProperty
        _specificFilterCollection = .constant([]) // valore di default
        self.color = selectionColor
        self.image = image
        
    }
    
    init(allCases:[P],filterCollection:Binding<[P]>,selectionColor:Color,image:String) {
        
        self.initType = .collection
        
        self.allCases = allCases
        _specificFilterProperty = .constant(nil) // valore di default
        _specificFilterCollection = filterCollection
        self.color = selectionColor
        self.image = image
        
    }
    
    var body: some View {
        
        HStack(spacing:5) {
            
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(Color.black)

                ScrollView(.horizontal,showsIndicators: false) {
                    
                  HStack {
                    
                    ForEach(allCases,id:\.self) { value in
                        
                        let (condition,action) = boolAndAct(value: value)
                        
                        Text(value.simpleDescription().capitalized)
                            .bold(condition)
                            .font(.system(.subheadline, design: .monospaced, weight: .light))
                            .foregroundColor(Color.black)
                            .padding(.horizontal,5.0)
                            .padding(.vertical,2.0)
                            .background(content: {
                                if condition {color.cornerRadius(5.0)}
                                else {
                                    Color.white.cornerRadius(5.0)
                                    .opacity(0.05) }
                               
                            })
                            .onTapGesture {
                             //   withAnimation {
                                  //  specificFilterProperty = condition ? nil : value
                                action(value)
                               // }
                            }
                        
                        Text("-")
                            .foregroundColor(Color.black)
                    }
                }
            }
        
        }
    
       // .padding(.vertical)
    }
    
    // Method
    private func boolAndAct(value:P) -> (condition:Bool,action:(_:P) -> Void) {
        
        switch initType {
            
        case .single:
            let condition = specificFilterProperty == value
            return (condition,singleAction)
            
        case .collection:
            let condition = specificFilterCollection.contains(value)
            return (condition,collectionAct)
        }
    }
    
    private func singleAction(value:P) {
        
        let condition = specificFilterProperty == value
        
        self.specificFilterProperty = condition ? nil : value
        
    }
    
    private func collectionAct(value:P) {
        
        if let index = specificFilterCollection.firstIndex(of: value) {

            specificFilterCollection.remove(at: index)
            
        } else { specificFilterCollection.append(value) }
        
    }
    
    
}
