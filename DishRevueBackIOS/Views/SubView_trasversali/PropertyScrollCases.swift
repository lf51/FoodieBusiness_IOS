//
//  EnumScrollCases.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/// Differisce dalla ProprertyAllCases per passaggio di riferimenti e non più di oggetti
struct PropertyScrollCases_Rif<T:MyProEnumPack_L2>: View {

    // 15.09 Passa da T:MyEnumProtocol a T:MyProEnumPack_L1
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var newDishSingleProperty: String
    @Binding var newDishCollectionProperty: [T]
    var enumCases: [T]
    let colorSelection: Color
    
    private var checkInit: InitType // ci serve a riconoscere quale init abbiamo utilizzato per creare la view, e questa scelta è utile nel metodo checkSelectionOrContainer() per applicare i modifier e per la tapAction
    
    init(cases:[T], dishSingleProperty: Binding<String>, colorSelection: Color) {
        
        self.checkInit = .single
        
        self.enumCases = cases
        _newDishSingleProperty = dishSingleProperty
        _newDishCollectionProperty = .constant([]) // qui a differenza di giù, si è fatto presto passando un arrayVuoto
        self.colorSelection = colorSelection
       
    }
    
    init(cases:[T], dishCollectionProperty: Binding<[T]>, colorSelection: Color) {
        
        self.checkInit = .collection
        
        self.enumCases = cases
        _newDishSingleProperty = .constant("") // abbiamo creato un valore di default per chi adotta il nostroProtocollo
        _newDishCollectionProperty = dishCollectionProperty
        self.colorSelection = colorSelection

    }
  
    var body: some View {
        
        VStack(alignment:.leading) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack {
                    
                    ForEach(enumCases) { type in
                        
                        let isSelected = self.checkSelectionOrContainer(type: type)
                        
                        CSText_tightRectangleVisual(fontWeight:.semibold,textColor: Color.white, strokeColor: isSelected ? Color.white : Color.seaTurtle_3, fillColor: isSelected ? colorSelection : Color.clear) {
                            
                            HStack {
                                
                                csVbSwitchImageText(string: type.imageAssociated(), size: .large)
                                Text(type.simpleDescription())
                                
                            }
                        }
                        .opacity(isSelected ? 1.0 : 0.65)
                        .onTapGesture {self.addingValueTo(newValue: type)}
                    }
                }
            }

         //   if let extendedDescription = newDishSingleProperty.extendedDescription() {
            
           /* if let model = self.viewModel.myEnumFromId(id: newDishSingleProperty, modelPath: \.categoriaMenuAllCases){*/
            if let model = self.viewModel.modelFromId(id: newDishSingleProperty, modelPath: \.db.allMyCategories)  {
                Text(model.extendedDescription())
                    .font(.caption)
                    .fontWeight(.light)
                    .italic()
                    .foregroundStyle(Color.black)
            }
            
                      
                        
             //   }
        }
    }
    
    
    private func checkSelectionOrContainer(type: T) -> Bool {
        
        switch checkInit {
            
        case .single:
            return self.newDishSingleProperty == type.id
        case .collection:
            return self.newDishCollectionProperty.contains(type)
        }
           
    }
     
    private func addingValueTo(newValue: T) {
        
        if self.checkInit == .single {
            
            withAnimation(.default) {
                
                self.newDishSingleProperty = self.newDishSingleProperty == newValue.id ? "" : newValue.id

            }
            
        }
        
        else if self.checkInit == .collection {
            
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

struct PropertyScrollCases<T:MyProEnumPack_L2>: View {

    // 15.09 Passa da T:MyEnumProtocol a T:MyProEnumPack_L2
    
    @Binding var newDishSingleProperty: T
    @Binding var newDishCollectionProperty: [T]
    var enumCases: [T]
    let colorSelection: Color
    
    private var checkInit: InitType  // ci serve a riconoscere quale init abbiamo utilizzato per creare la view, e questa scelta è utile nel metodo checkSelectionOrContainer() per applicare i modifier e per la tapAction
    
    init(cases:[T], dishSingleProperty: Binding<T>, colorSelection: Color) {
        
        self.checkInit = .single
        
        self.enumCases = cases
        _newDishSingleProperty = dishSingleProperty
        _newDishCollectionProperty = .constant([]) // qui a differenza di giù, si è fatto presto passando un arrayVuoto
        self.colorSelection = colorSelection
       
    }
    
    init(cases:[T], dishCollectionProperty: Binding<[T]>, colorSelection: Color) {
        
        self.checkInit = .collection
        
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
                        
                        CSText_tightRectangleVisual(fontWeight:.semibold,textColor: Color.white, strokeColor: isSelected ? Color.white : Color.seaTurtle_3, fillColor: isSelected ? colorSelection : Color.clear) {
                            
                            HStack {
                                
                                csVbSwitchImageText(string: type.imageAssociated(), size: .large)
                                Text(type.simpleDescription())
                              /*  if let ex = type as? ConservazioneIngrediente {
                                    Text(ex.test)
                                } */ // !! NOTA !! vedi nota 16.09 in - enum ConservazioneIngrediente -
                                
                            }
                        }
                        .opacity(isSelected ? 1.0 : 0.65)
                        .onTapGesture {self.addingValueTo(newValue: type)}
                    }
                }
            }

         //   if let extendedDescription = newDishSingleProperty.extendedDescription() {
                    
                        Text(newDishSingleProperty.extendedDescription())
                            .font(.caption)
                            .fontWeight(.light)
                            .italic()
                            .foregroundStyle(Color.black)
                        
             //   }
        }
    }
    
    
    private func checkSelectionOrContainer(type: T) -> Bool {
        
        
        switch checkInit {
            
        case .single:
            return self.newDishSingleProperty == type
        case .collection:
            return self.newDishCollectionProperty.contains(type)
        }
           
    }
     
    private func addingValueTo(newValue: T) {
        
        if self.checkInit == .single {
            
            withAnimation(.default) {
                
                self.newDishSingleProperty = self.newDishSingleProperty == newValue ? T.defaultValue : newValue
                print("Dentro AddingValue - oldValue: \(self.newDishSingleProperty.simpleDescription()) - NewValue:\(newValue.simpleDescription())")
            }
            
        }
        
        else if self.checkInit == .collection {
            
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

    
    
    
} // deprecata in futuro per trasformazione da "passaggio di modello" a "passaggio di riferimento"

/* struct EnumScrollCases_Previews: PreviewProvider {
    static var previews: some View {
        EnumScrollCases(newDish: .constant(DishModel()))
    }
} */
