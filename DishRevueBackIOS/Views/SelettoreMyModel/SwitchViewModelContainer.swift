//
//  SwitchListeIngredienti_SelettoreIngredienteSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI
/*
struct SwitchViewModelContainer: View {
        
        let viewModelList: [ModelList]
        @Binding var modelListCorrente: String
        
        var body: some View {
            
            HStack {
                
                vbShowContainerPlainRow()
                
                Spacer()
 
            }
        }
    
    // Method
    
    @ViewBuilder func vbShowContainerPlainRow() -> some View {
        
        ForEach(viewModelList, id: \.self) { list in
            
            Spacer()
            
            ContainerRowLabel_Plain(viewModelSingleList: list, modelListCorrente: $modelListCorrente)
            
            }
        }
    
    }

///Label Container semplice. Testo con Tap per vedere contenuto
struct ContainerRowLabel_Plain:View {
    
    let viewModelSingleList: ModelList
    @Binding var modelListCorrente: String
    let listTitle: String
    
    init(viewModelSingleList: ModelList, modelListCorrente:Binding<String>) {
        
        self.viewModelSingleList = viewModelSingleList
        _modelListCorrente = modelListCorrente
        listTitle = viewModelSingleList.returnAssociatedValue().0
    }
    
    var body: some View {

        Button {
            withAnimation(.easeOut) {
                self.modelListCorrente = listTitle
            }
        } label: {
            
            HStack {
                
                Text(listTitle)
                    .fontWeight(modelListCorrente == listTitle ? .bold : .light)
                    .shadow(radius: modelListCorrente == listTitle ? 0.0 : 1.0)
                    .foregroundStyle(Color.black)
                  
                Image(systemName: modelListCorrente == listTitle ? "eye" : "eye.slash")
                      .imageScale(.medium)
                      .foregroundStyle(modelListCorrente == listTitle ? Color.blue : Color.gray)
                
            }
            
        }
        
        
        
        
    /*    Text(listTitle)
            .fontWeight(modelListCorrente == listTitle ? .bold : .light)
            .shadow(radius: modelListCorrente == listTitle ? 0.0 : 1.0)
            .onTapGesture {
                
                withAnimation(.easeOut) {
                    self.modelListCorrente = listTitle
                }
            }   */
    }
} */

/*
struct SwitchListeIngredienti_Previews: PreviewProvider {
    static var previews: some View {
        SwitchListeIngredienti()
    }
}
*/
