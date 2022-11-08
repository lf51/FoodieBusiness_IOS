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
    let image: String?
    let label: String
    
    let count:(_:P) -> Int
    
    private let initType:InitType
    private let columns:[GridItem] = [GridItem(.adaptive(minimum: 180,maximum: 300),spacing: nil,alignment: .leading)]
    
    init(allCases:[P],filterProperty:Binding<P?>,selectionColor:Color,imageOrEmoji:String? = nil,label:String = "", count:@escaping (_:P) -> Int ) {
        
        self.initType = .single
        
        self.allCases = allCases.sorted(by: {$0.orderValue() < $1.orderValue()})
        _specificFilterProperty = filterProperty
        _specificFilterCollection = .constant([]) // valore di default
        self.color = selectionColor
        self.image = imageOrEmoji
        self.label = label
        
        self.count = count
    }
    
    init(allCases:[P],filterCollection:Binding<[P]>,selectionColor:Color,imageOrEmoji:String? = nil,label:String = "",count:@escaping (_:P) -> Int ) {
        
        self.initType = .collection
        
        self.allCases = allCases.sorted(by: {$0.orderValue() < $1.orderValue()})
        _specificFilterProperty = .constant(nil) // valore di default
        _specificFilterCollection = filterCollection
        self.color = selectionColor
        self.image = imageOrEmoji
        self.label = label
       // self.disableScroll = disableScroll
        
        self.count = count
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            if image != nil {
                
                CSLabel_1Button(placeHolder: label, imageNameOrEmojy: image, backgroundColor: Color.black,backgroundOpacity: 0.03)
                
            }

            LazyVGrid(columns:columns,alignment: .leading, spacing: 5) {
                
                ForEach(allCases,id:\.self) { value in
                    
                    let (condition,action) = boolAndAct(value: value)
                    let number = count(value)
                    
                    Text("\(value.simpleDescription().capitalized)(\(number))")
                        .bold(condition)
                        .font(.system(.subheadline, design: .monospaced, weight: .light))
                        .foregroundColor(Color.black)
                        .padding(.horizontal,2.0)
                        .padding(.vertical,5.0)
                        .frame(minWidth: 180)
                        .background(content: {
                            if condition {color.cornerRadius(5.0)}
                            else {
                                Color.white.cornerRadius(5.0)
                                .opacity(0.05) }
                           
                        })
                        .onTapGesture {
        
                            action(value)
                        
                        }

                }
            }

        }

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


/// Richiede un Array di Model e riempie un array di Stringhe
struct FilterRow_GenericForString:View { // 04.11 caduta in disuso
    
    let allCases:[String]
    @Binding var specificFilterCollection: [String]
    let color: Color
    var image: String = "circle.fill"
    
    init(allCases:[String],filterCollection:Binding<[String]>,selectionColor:Color,imageOrEmoji:String) {

        self.allCases = allCases.sorted(by: < )
        _specificFilterCollection = filterCollection
        self.color = selectionColor
        self.image = imageOrEmoji
        
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
                        
                        Text(value)
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
    
    private func boolAndAct(value:String) -> (condition:Bool,action:(_:String) -> Void) {

             let condition = specificFilterCollection.contains(value)
             return (condition,collectionAct)
         
     }
    
    private func collectionAct(value:String) {
        
        if let index = specificFilterCollection.firstIndex(of: value) {

            specificFilterCollection.remove(at: index)
            
        } else { specificFilterCollection.append(value) }
        
    }
    
    
} // Deprecata 04.11 -> Caduta in disuso dopo l'abbandono del filtro per ingredienti
