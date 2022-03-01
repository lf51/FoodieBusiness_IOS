//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
// Ultima pulizia codice 01.03.2022

struct SelectionPropertyDish_NewDishSubView: View {
    
    @Binding var newDish: DishModel
    
    @State private var creaNuovaTipologia:Bool? = false
    @State private var nuovaTipologia: String = ""
    
    @State private var creaNuovaCottura: Bool? = false
    @State private var nuovaCottura: String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Group {
                
                CSLabel_1Button(placeHolder: "Tipologia", imageName: "list.bullet.below.rectangle", backgroundColor: Color.black, toggleBottone: $creaNuovaTipologia)
                
                    if !(creaNuovaTipologia ?? false) {
                        
                        EnumScrollCases(cases: DishType.allCases, dishSingleProperty: self.$newDish.type, colorSelection: Color.green.opacity(0.8))
                    }
                    
                else {
                    
                    CSTextField_3(textFieldItem: $nuovaTipologia, placeHolder: "Aggiungi Tipologia") {

                        DishType.allCases.insert(.tipologiaCustom(nuovaTipologia), at: 0)
                        self.nuovaTipologia = ""
                        self.creaNuovaTipologia = false
                        }
                    }
                
                
                CSLabel_1Button(placeHolder: "A base di", imageName: "lanyardcard", backgroundColor: Color.black, toggleBottone: nil)
                
                EnumScrollCases(cases: DishBase.allCases, dishSingleProperty: self.$newDish.aBaseDi, colorSelection: Color.indigo.opacity(0.8))
                
     
                CSLabel_1Button(placeHolder: "Metodo di cottura", imageName: "flame", backgroundColor: Color.black, toggleBottone: $creaNuovaCottura)
                
                    if !(creaNuovaCottura ?? false) {
                        
                        EnumScrollCases(cases: DishCookingMethod.allCases, dishSingleProperty: self.$newDish.metodoCottura, colorSelection: Color.orange.opacity(0.8))
                    
                    } else {
                        
                        CSTextField_3(textFieldItem: $nuovaCottura, placeHolder: "Aggiungi Metodo di Cottura") {
                            
                            DishCookingMethod.allCases.insert(.metodoCustom(nuovaCottura), at: 1) // 1 per tenere sempre il Crudo come Prima Scelta
                            self.nuovaCottura = ""
                            self.creaNuovaCottura = false
                            
                        }
                    }
            }
            
            Group {
                
                CSLabel_1Button(placeHolder: "Categoria", imageName: "person.fill", backgroundColor: Color.black, toggleBottone: nil)
                
                VStack(alignment:.leading) {
                    EnumScrollCases(cases: DishCategory.allCases, dishSingleProperty: self.$newDish.category, colorSelection: Color.green.opacity(0.8))
                    Text(self.newDish.category.extendedDescription())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .italic()
                        .foregroundColor(Color.black)
                }
                
            
                CSLabel_1Button(placeHolder: "Adattabile alla dieta", imageName: "person.fill.checkmark", backgroundColor: Color.black, toggleBottone: nil)
                
                EnumScrollCases(cases: DishAvaibleFor.allCases, dishCollectionProperty: self.$newDish.avaibleFor, colorSelection: Color.blue.opacity(0.8))
         
                
                CSLabel_1Button(placeHolder: "Allergeni Presenti", imageName: "exclamationmark.triangle", backgroundColor: Color.black, toggleBottone: nil)
                
                EnumScrollCases(cases: Allergeni.allCases, dishCollectionProperty: self.$newDish.allergeni, colorSelection: Color.red.opacity(0.8))
                
            }
           
            
        }
       
        
    }
}

/* struct SelectionMenu_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMenu_NewDishSubView()
    }
} */
