//
//  EditDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/02/22.
//

/* Passiamo a questa View la posizione d'indice dell'elemento DishModel contenuto nell'array DishList in dishVM che vogliamo modificare. Passiamo anche ovviamente il dishVM su cui stiamo lavorando. Le modifiche effettuate qui vengono aggiornate instantaneamente anche alle altre View. Problema simile avuto in Fantabid ma risolto qui con Maggiore EFFICIENZA !!! */

import SwiftUI

struct EditDishView: View {
    
   // @ObservedObject var dishVM: DishVM
   // @ObservedObject var propertyVM : PropertyVM
  //  let currentDishIndexPosition: Int
    @State var currentDish: DishModel
    
    var body: some View {
        
        VStack{
            
           
            Text("Edit --> \(currentDish.name)")
            
        //   Text("Edit -> \(dishVM.dishList[currentDishIndexPosition].name)")
    
            
         /*   TextField("Add Main Ingredient", text: $editableDish.ingredientiPrincipali[0]) */
            
            
            Button {
             
                currentDish.name = "Nome Cambiato con Successo"
                
           //     dishVM.dishList[currentDishIndexPosition].name = "NOME CAMBIATO CON SUCCESSO"
             
   
            } label: {
                Text("Salva Modifiche")
            }
            
          /*  List {
                
                ForEach(propertyVM.propertiesList) { property in
                    
                    Text(property.name).onTapGesture {
                        
                        dishVM.dishList[currentDishIndexPosition].restaurantWhereIsOnMenu.append(property)
                        
                    }
                    
                    
                    
                    
                }
                
                
            } */
            

        }
 
    }
}

/*struct EditDishView_Previews: PreviewProvider {
    static var previews: some View {
        EditDishView(dishVM: DishVM())
    }
} */
