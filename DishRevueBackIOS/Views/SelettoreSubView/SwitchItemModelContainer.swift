//
//  SwitchListeIngredientiPiatto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct SwitchItemModelContainer<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    @Binding var itemModel: M1
   // @Binding var listaDaMostrare: ModelList
    let itemModelList: [ModelList]
    @Binding var listaDaMostrare: String
   
    var body: some View {
        
        VStack(alignment: .leading) {
                        
            vbShowContainersRow()
       
        }
        
    }
    
    // Method
    
    @ViewBuilder func vbShowContainersRow() -> some View {
        
        ForEach(itemModelList, id:\.self) { list in
            
            ContainerRowLabel<_,M2>(itemModel: $itemModel, itemModelList: list, listaDaMostrare: $listaDaMostrare)
            
        }
    }
    
    
}


///Label di un Container composta da TextLabel + Count  Elementi Container + Button per vedere contenuto + ColorLabel
struct ContainerRowLabel<M1:MyModelProtocol, M2:MyModelProtocol>: View {
    
    @Binding var itemModel: M1
    let itemModelList: ModelList
    @Binding var listaDaMostrare: String
    
    let localListTitle:String
    let localListKeyPath:WritableKeyPath<M1,[M2]>?
    let localListColor: Color
    
    init(itemModel:Binding<M1>,itemModelList:ModelList,listaDaMostrare:Binding<String>) {
        
        _itemModel = itemModel
        self.itemModelList = itemModelList
        _listaDaMostrare = listaDaMostrare
        
        let kp:AnyKeyPath
        let containerType: ModelList.ContainerType
        (self.localListTitle, kp, containerType) = itemModelList.returnAssociatedValue()
        
      //  self.localListKeyPath = kp as! WritableKeyPath<M1,[M2]>
        self.localListKeyPath = kp as? WritableKeyPath<M1,[M2]>
        self.localListColor = containerType.returnAssociatedValue().0
        
       // self.localListKeyPath = itemModelList.returnAssociatedValue().1 as! WritableKeyPath<M1, [M2]>
        
    }
    
    var body: some View {
        
        HStack{
            
            Text(localListTitle)
                .fontWeight(listaDaMostrare == localListTitle ? .bold : .light)
                .lineLimit(1)
            
            Spacer()
            
            CSButton_image(
                activationBool: listaDaMostrare == localListTitle,
                frontImage: "eye.fill",
                backImage: "eye.slash.fill",
                imageScale: .medium,
                backColor: Color.blue,
                frontColor: Color.gray) {
                    withAnimation {
                        listaDaMostrare = localListTitle
                    }
                }
                      
            if localListKeyPath != nil {
                
                Text("\(itemModel[keyPath: localListKeyPath!].count)")
                    .fontWeight(.light)
                    .padding(.horizontal)
                
            } else {Text("Ø").bold().foregroundColor(.red).padding(.horizontal)}
         
            Image(systemName:"circle.fill")
                .imageScale(.large)
                .foregroundColor(localListColor)
            
        }._tightPadding()
        
        
        
    }
    
    // Method
    
    
}


/*
struct SwitchListeIngredientiPiatto_Previews: PreviewProvider {
    static var previews: some View {
        SwitchListeIngredientiPiatto(newDish: DishModel(), listaDaMostrare: ElencoListeIngredienti.allFromCommunity)
    }
}
*/
