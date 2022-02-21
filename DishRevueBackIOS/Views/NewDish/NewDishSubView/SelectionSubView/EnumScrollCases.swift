//
//  EnumScrollCases.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct EnumScrollCases<T:MyEnumProtocol>: View {

    @Binding var newDishSingleProperty: T
    @Binding var newDishCollectionProperty: [T]
    var enumCases: [T]
    let colorSelection: Color
    
    private var checkInit: String = "" // ci serve a riconoscere quale init abbiamo utilizzato per creare la view, e questa scelta è utile nel metodo checkSelectionOrContainer() per applicare i modifier e per la tapAction
    
    init(cases:[T], dishSingleProperty: Binding<T>, colorSelection: Color) {
        
        self.checkInit = "Single"
        
        self.enumCases = cases
        _newDishSingleProperty = dishSingleProperty
        _newDishCollectionProperty = .constant([]) // qui a differenza di giù, si è fatto presto passando un arrayVuoto
        self.colorSelection = colorSelection
    
    }
    
    init(cases:[T], dishCollectionProperty: Binding<[T]>, colorSelection: Color) {
        
        self.checkInit = "Collection"
        
        self.enumCases = cases
        _newDishSingleProperty = .constant(T.defaultValue) // abbiamo creato un valore di default per chi adotta il nostroProtocollo
        _newDishCollectionProperty = dishCollectionProperty
        self.colorSelection = colorSelection

    }
  
    var body: some View {
        
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack {
                
                ForEach(enumCases) { type in
                    
                    CSText_bigRectangle(testo: type.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: self.checkSelectionOrContainer(type: type) ? Color.clear : Color.blue, fillColor: self.checkSelectionOrContainer(type: type) ? colorSelection : Color.clear)
                        .onTapGesture {self.addingValueTo(newValue: type)}
                }
            }
        }
    }
    
    func checkSelectionOrContainer(type: T) -> Bool {
        
        if checkInit == "Single" {
            
        return self.newDishSingleProperty == type
            
        }

        else if checkInit == "Collection" { }
        
        return self.newDishCollectionProperty.contains(type)
        
    }
     
    func addingValueTo(newValue: T) {
        
        if self.checkInit == "Single" {
            
            withAnimation(.default) {
                
                self.newDishSingleProperty = self.newDishSingleProperty == newValue ? T.defaultValue : newValue
            }
            
        }
        
        else if self.checkInit == "Collection" {
            
            withAnimation(.default) {
              
                if !self.newDishCollectionProperty.contains(newValue) {
                    
                    self.newDishCollectionProperty.append(newValue)
                    
                } else {
                    
                    let indexValue = self.newDishCollectionProperty.firstIndex(of: newValue)
                    self.newDishCollectionProperty.remove(at: indexValue!)
                    
                }
                
                print("Lista of generic T-Type: \(self.newDishCollectionProperty.description)")
           
            }
        }
      
    }

    
    
    
}

/* struct EnumScrollCases_Previews: PreviewProvider {
    static var previews: some View {
        EnumScrollCases(newDish: .constant(DishModel()))
    }
} */
