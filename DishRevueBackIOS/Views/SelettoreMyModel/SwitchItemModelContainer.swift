//
//  SwitchListeIngredientiPiatto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct SwitchItemModelContainer<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    @Binding var itemModel: M1
    let itemModelList: [ModelList]
    @Binding var modelListCorrente: String
   
    var body: some View {
        
        VStack(alignment: .leading) {
                        
            vbShowContainersRow()
       
        }
        
    }
    
    // Method
    
    @ViewBuilder func vbShowContainersRow() -> some View {
        
        ForEach(itemModelList, id:\.self) { list in
            
            ContainerRowLabel<_,M2>(itemModel: $itemModel, itemModelSingleList: list, modelListCorrente: $modelListCorrente)
            
        }
    }
    
    
}

///Label di un Container composta da TextLabel + Count  Elementi Container + Button per vedere contenuto + ColorLabel
struct ContainerRowLabel<M1:MyModelProtocol, M2:MyModelProtocol>: View {
    
    @Binding var itemModel: M1
    let itemModelSingleList: ModelList
    @Binding var modelListCorrente: String
    
    let localListTitle:String
    let localListKeyPath:WritableKeyPath<M1,[M2]>?
    let localListColor: Color
    
    init(itemModel:Binding<M1>,itemModelSingleList:ModelList,modelListCorrente:Binding<String>) {
        
        _itemModel = itemModel
        self.itemModelSingleList = itemModelSingleList
        _modelListCorrente = modelListCorrente
        
        let kp:AnyKeyPath
        let containerType: ModelList.ContainerType
        (self.localListTitle, kp, containerType) = itemModelSingleList.returnAssociatedValue()

        self.localListKeyPath = kp as? WritableKeyPath<M1,[M2]>
        self.localListColor = containerType.returnAssociatedValue().0
        
    }
    
    var body: some View {
        
        HStack{
            
            Button {
                withAnimation(.easeOut) {
                    self.modelListCorrente = localListTitle
                }
                
            } label: {
                
                HStack {
                    
                    Text(localListTitle)
                          .fontWeight(modelListCorrente == localListTitle ? .bold : .light)
                          .foregroundColor(Color.black)
                          .lineLimit(1)
                         
                      Image(systemName: "arrow.up.forward.square")
                          .imageScale(.medium)
                          .foregroundColor(Color.blue)
                    
                }
                
            }

            
          /*  Text(localListTitle)
                .fontWeight(modelListCorrente == localListTitle ? .bold : .light)
                .foregroundColor(Color.black)
                .lineLimit(1)
                .onTapGesture {
                    modelListCorrente = localListTitle
                }
            
            Image(systemName: "arrow.up.forward.square")
                .imageScale(.medium)
                .foregroundColor(Color.blue) */
            
            Spacer()
            
            if localListKeyPath != nil {
                
                Text("(\(itemModel[keyPath: localListKeyPath!].count))")
                    .fontWeight(.light)
                    .padding(.horizontal)
                
            } else {Text("Ø").bold().foregroundColor(.red).padding(.horizontal)}
            
          /*  CSButton_image(
                activationBool: modelListCorrente == localListTitle,
                frontImage: "arrow.up.arrow.down.circle",
               
                imageScale: .large,
                backColor: Color.blue,
                frontColor: Color.gray) {
                    withAnimation {
                    
                    }
                }.shadow(radius: 1.0) */
                
            
         /*   CSButton_image(
                activationBool: modelListCorrente == localListTitle,
                frontImage: "eye.fill",
                backImage: "eye.slash.fill",
                imageScale: .medium,
                backColor: Color.blue,
                frontColor: Color.gray) {
                    withAnimation {
                        modelListCorrente = localListTitle
                    }
                } */
                      
            
            Image(systemName:"circle.fill")
                .imageScale(.large)
                .foregroundColor(localListColor)
            
        }._tightPadding()
    
    }

}


/*
struct SwitchListeIngredientiPiatto_Previews: PreviewProvider {
    static var previews: some View {
        SwitchListeIngredientiPiatto(newDish: DishModel(), listaDaMostrare: ElencoListeIngredienti.allFromCommunity)
    }
}
*/
