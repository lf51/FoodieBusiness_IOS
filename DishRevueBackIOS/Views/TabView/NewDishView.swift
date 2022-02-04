//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct NewDishView: View {
    
    @ObservedObject var dishVM: DishVM
    var backGroundColorView: Color
    
    @State private var newDish: DishModel = DishModel()
    
    var body: some View {
        
        ZStack {
            
            backGroundColorView.edgesIgnoringSafeArea(.top)
            
            
            VStack { // il vstack Madre
                
                VStack { // info Dish
                    
                 //   Text(dishVM.newDish.images)
                    Text("Nome Piatto: \(newDish.name)")
                    Text("Ingredienti: \(newDish.ingredientiPrincipali[0])")
                    Text("Altri Ingredienti: \(newDish.ingredientiSecondari[0])")
                    Text(newDish.allergeni[0].rawValue)
                    Text(newDish.type[0].rawValue)
                    Text(newDish.category.rawValue)
                    Text("Quantità: \(newDish.quantità ?? 0.0)")
                    
                }
                
                
                Spacer()
                
                CSTextField_2(text: $newDish.name, placeholder: "Nome Piatto", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0)
                
          /*      CSTextField_2(text: <#T##Binding<String>#>, placeholder: "Ingredienti", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0)
                
                CSTextField_2(text: <#T##Binding<String>#>, placeholder: "Altri Ingredienti", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0)
                
                CSTextField_2(text: <#T##Binding<String>#>, placeholder: "Allergeni", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0)
                
                CSTextField_2(text: <#T##Binding<String>#>, placeholder: "Categoria", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0)
                
                CSTextField_2(text: <#T##Binding<String>#>, placeholder: "Tipo", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0)
                
                CSTextField_2(text: <#T##Binding<String>#>, placeholder: "Quantità", symbolName: "", accentColor: .white, backGroundColor: .gray, autoCap: .sentences, cornerRadius: 5.0) */
                
                Spacer()
                CSButton_2(title: "Create Dish", accentColor: .white, backgroundColor: .cyan, cornerRadius: 5.0) {
                    
                    dishVM.saveDish(dish: self.newDish)
                    self.newDish = DishModel()
                    
                }
                
                
                
                
            }
            
            
            
        } // end ZStack
        .background(backGroundColorView.opacity(0.4))
        
        
    }
}

struct NewDishView_Previews: PreviewProvider {
    static var previews: some View {
        NewDishView(dishVM: DishVM(), backGroundColorView: Color.cyan)
    }
}
