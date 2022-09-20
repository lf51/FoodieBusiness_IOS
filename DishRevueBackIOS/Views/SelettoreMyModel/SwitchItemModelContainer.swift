//
//  SwitchListeIngredientiPiatto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/03/22.
//

import SwiftUI

struct SwitchItemModelContainer<M1:MyProStarterPack_L1,M2:MyProStarterPack_L1>: View {
    
    // M1 passa da MyModelProtocol a MyProStarterPackL0
    // M2 passa da MyModelProtocol a MyProStarterPackL1
    
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
struct ContainerRowLabel<M1:MyProStarterPack_L1, M2:MyProStarterPack_L1>: View {
    
    // M1 passa da MyModelProtocol a MyProStarterPackL0
    // M2 passa da MyModelProtocol a MyProStarterPackL1
    
   // @Binding var itemModel: M1 // inutile
  //  let itemModelSingleList: ModelList // inutile
    @Binding var modelListCorrente: String
    
    let localListTitle:String
    let listCount: Int
    let localListColor: Color
  
    // add end remove 25.08
    //  let localListKeyPath:WritableKeyPath<M1,[M2]>?
   // let localListPathString: WritableKeyPath<M1,[String]>?
    //

    init(itemModel:Binding<M1>,itemModelSingleList:ModelList,modelListCorrente:Binding<String>) {
        // NON DEVE NECESSARIAMENTE PASSARE UN BINDING
        
       // _itemModel = itemModel
      //  self.itemModelSingleList = itemModelSingleList
        _modelListCorrente = modelListCorrente
        
        let kp:AnyKeyPath
        let containerType: ModelList.ContainerType
        (self.localListTitle, kp, containerType) = itemModelSingleList.returnAssociatedValue()

        if let keyP = kp as? WritableKeyPath<M1,[M2]> {
            let itemWrap = itemModel.wrappedValue
            self.listCount = itemWrap[keyPath: keyP].count
            
        } else if let keyP = kp as? WritableKeyPath<M1,[String]> {
            let itemWrap = itemModel.wrappedValue
            self.listCount = itemWrap[keyPath: keyP].count
        }
        else { listCount = 0 }
 
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
                         
                    Image(systemName: modelListCorrente == localListTitle ? "eye" : "eye.slash")
                          .imageScale(.medium)
                          .foregroundColor(modelListCorrente == localListTitle ? Color.blue : Color.gray)
                    
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
            
            // Remove and Add 25.08
            
          /*  if localListKeyPath != nil {
                
                Text("(\(itemModel[keyPath: localListKeyPath!].count))")
                    .fontWeight(.light)
                    .padding(.horizontal)
                
            } else {Text("Ø").bold().foregroundColor(.red).padding(.horizontal)}
            
            if localListPath != nil {
                
                Text("(\(itemModel[keyPath: localListPath!].count))")
                    .fontWeight(.light)
                    .padding(.horizontal)
                
            } else {Text("Ø").bold().foregroundColor(.red).padding(.horizontal)} */
            
            Text("(\(listCount))")
                .fontWeight(.light)
                .padding(.horizontal)
            
            // End 25.08
            
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
