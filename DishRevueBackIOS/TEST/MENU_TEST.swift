//
//  MENU_TEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/05/22.
//

import SwiftUI

struct MENU_TEST: View {
    
    @StateObject var viewModel: AccounterVM = AccounterVM()
    @State private var ingredient:IngredientModel = IngredientModel()
    
    @State private var color:Color = Color.yellow
    @State private var closeButton:Bool = false
    
    
    var body: some View {

        
        VStack {
            
            Text(ingredient.conservazione.simpleDescription())
            Text(ingredient.origine.simpleDescription())
            ForEach(ingredient.allergeni) { allergene in
                
                Text(allergene.simpleDescription())
                
            }
            
           
            Menu {
   
                ForEach(AllergeniIngrediente.allCases, id:\.self) { allergene in
 
                        Button {
                            self.ingredient.allergeni.append(allergene)
                        } label: {
                            test(M: allergene)
                            
                           
                            
                        }

                        
                            
  
                    }
     
            } label: {
                Text("Editing Lento")
            }
 


            
        }
            
            
            
            

        
        
    }
    
    func testA(M:AllergeniIngrediente) -> (Color,String,Bool) {
        
        return (Color.red,"circle.fill", false)
    }
    
   @ViewBuilder func test(M: AllergeniIngrediente) -> some View {
        
        if self.ingredient.allergeni.contains(M) {
            
            HStack {
                Text(M.simpleDescription())
                Image(systemName: "circle.fill")
                    .foregroundColor(Color.red)
                
            }
           
                
            
        } else {
            
            HStack {
                Text(M.simpleDescription())
                Image(systemName: "circle")
                    .foregroundColor(Color.gray)
                
            }
        }
        
        
    }
    
}

struct MENU_TEST_Previews: PreviewProvider {
    static var previews: some View {
        MENU_TEST()
    }
}

struct TestRow:View {
    
    let allergene:AllergeniIngrediente
    
    var body: some View {
        
        HStack{
            
            Text(allergene.simpleDescription())
            Spacer()
            Image(systemName: "circle.fill")
            
        }
        
        
    }
    
    
}

/*
HStack {
    
    Menu {
            
        Picker(
            selection: $ingredient.origine) {
                ForEach(DishBase.allCases, id:\.self) { origine in
                    
                    Text(origine.simpleDescription())
                    
                    
                }
            } label: {
                Text("Origine")
            }.pickerStyle(MenuPickerStyle())
        
        Picker(
            selection: $ingredient.conservazione) {
                ForEach(ConservazioneIngrediente.allCases, id:\.self) { conservazione in
                    
                    Text(conservazione.simpleDescription())
                    
                    
                }
            } label: {
                Text("Conservazione")
            }.pickerStyle(MenuPickerStyle())
        
        
        
    } label: {
        Text("Edit..")
    }

}
*/
