//
//  EnumScrollCases.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct PropertyScrollCases<T:MyEnumProtocol>: View {

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
        
        VStack(alignment:.leading) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(enumCases) { type in
                        
                        let isSelected = self.checkSelectionOrContainer(type: type)
                        
                        CSText_bigRectangle(testo: type.simpleDescription(), fontWeight: .bold, textColor: Color.white, strokeColor: isSelected ? Color.blue : Color.red, fillColor: isSelected ? colorSelection : Color.clear)
                            .overlay(content: {
                                Rectangle()
                                    .padding(.horizontal)
                                    .frame(height: 1.0)
                                    .foregroundColor(isSelected ? Color.clear : Color.red)
                                  
                            })
                            .onTapGesture {self.addingValueTo(newValue: type)}
                    }
                }
            }
            
            if let extendedDescription = newDishSingleProperty.extendedDescription() {
                
                Text(extendedDescription)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .italic()
                    .foregroundColor(Color.black)
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
                print("Dentro AddingValue - oldValue: \(self.newDishSingleProperty.simpleDescription()) - NewValue:\(newValue.simpleDescription())")
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
