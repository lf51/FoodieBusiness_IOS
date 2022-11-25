//
//  BodyListe_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/11/22.
//

import SwiftUI

struct MapObject<M:MyProToolPack_L1,C:MyProEnumPack_L2> {
  
    var mapCategory:[C]
    var kpMapCategory:KeyPath<M,String>
}

struct BodyListe_Generic<M:MyProToolPack_L1,C:MyProEnumPack_L2>:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var filterString:String
    let container:[M]

    var mapObject:MapObject<M,C>? = nil
    
    let navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    var placeHolder:String = "Ricerca.."
    
    // Beta
    @State private var modelToAct:M?
    
    var body: some View {
        
        VStack {
            
            CSDivider()
            
            ScrollView(showsIndicators:false) {
                
                ScrollViewReader { proxy in
                    
                CSTextField_4(textFieldItem: $filterString, placeHolder: placeHolder, image: "text.magnifyingglass", showDelete: true).id(0)
    
                CSDivider()
                    
                    if mapObject == nil {
                        
                        vbPlainContainer(container: self.container)
                            .id(1)
                            .onAppear {proxy.scrollTo(1, anchor: .top)}
                        
                    } else {
                        
                        vbMappedContainer()
                            .id(1)
                            .onAppear {proxy.scrollTo(1, anchor: .top)}
                    }
                    
                }
            }
            
            
            CSDivider()
        }
        .padding(.horizontal)
        .popover(item: $modelToAct) { model in
             PopAction(backgroundColorView: Color("SeaTurtlePalette_1"),modelToAct: model)
                 .presentationDetents([.height(250)])
         }
      
        
    }
    
    // Method
    
    @ViewBuilder private func vbPlainContainer(container:[M]) -> some View {
        
        ForEach(container) { model in
            
            let modelStatusArchiviato = model.status.checkStatusTransition(check: .archiviato)
            
            GenericItemModel_RowViewMask(model: model) {
                
                model.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath:navigationPath)
                    .disabled(modelStatusArchiviato)
                    
                    vbMenuInterattivoModuloCambioStatus(myModel: model,viewModel: viewModel) 
                
                    vbMenuInterattivoModuloEdit(currentModel: model, viewModel: viewModel, navPath: navigationPath)
                    .disabled(modelStatusArchiviato)
                
                    vbMenuInterattivoModuloTrash(currentModel: model, viewModel: viewModel)
                    .disabled(!modelStatusArchiviato)
               
            }.opacity(modelStatusArchiviato ? 0.5 : 1.0)
            
        }
        
    }
    
    @ViewBuilder private func vbMappedContainer() -> some View {
        
        ForEach(self.mapObject!.mapCategory) { category in
            
            let mappedContainer = self.container.filter({$0[keyPath: self.mapObject!.kpMapCategory] == category.id })
        
        if !mappedContainer.isEmpty {
            
            Section {
                
                vbPlainContainer(container: mappedContainer)
 
                
            } header: {
                
                CSLabel_1Button(
                    placeHolder: category.simpleDescription(),
                    imageNameOrEmojy: category.imageAssociated(),
                    backgroundColor: Color("SeaTurtlePalette_3"),
                    backgroundOpacity: 0.6)
            }
            
        }
      }
    }
}

struct PopAction<M:MyProToolPack_L1>: View {
    
    let backgroundColorView:Color
    let modelToAct:M
    
    var body: some View {
        
        ZStack {

            Rectangle()
                .fill(backgroundColorView.gradient)
                .edgesIgnoringSafeArea(.top)
                .zIndex(0)
      
            VStack {
                
                Text("\(modelToAct.intestazione) option 1")
                Text("option 2")
                Text("option 3")
            }
            
            
        }
        .background(backgroundColorView.opacity(0.6))
  
    }
    
}
