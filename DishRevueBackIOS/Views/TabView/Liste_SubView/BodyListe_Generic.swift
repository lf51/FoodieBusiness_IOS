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
  
  //  var mapCategory:[C] = []
  //  var kpMapCategory:KeyPath<M,String>
    var mapObject:MapObject<M,C>? = nil
    
    let navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    var placeHolder:String = "Ricerca.."
    
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
        
    }
    
    // Method
    
    @ViewBuilder private func vbPlainContainer(container:[M]) -> some View {
        
        ForEach(container) { model in
            
            GenericItemModel_RowViewMask(model: model) {
                
                model.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath:navigationPath)
                    
                    vbMenuInterattivoModuloCambioStatus(myModel: model,viewModel: viewModel)
                    
                    vbMenuInterattivoModuloEdit(currentModel: model, viewModel: viewModel, navPath: navigationPath)
                    
                    vbMenuInterattivoModuloTrash(currentModel: model, viewModel: viewModel)
                    
               
            }
            
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
/*
struct BodyListe_Generic<M:MyProToolPack_L1>:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var filterString:String
    let container:[M]
   // let containerKP:WritableKeyPath<AccounterVM,[M]>
    let navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    var placeHolder:String = "Ricerca.."
    
    var body: some View {
        
        VStack {
            
            CSDivider()
            
            ScrollView(showsIndicators:false) {
                
                ScrollViewReader { proxy in
                    
                CSTextField_4(textFieldItem: $filterString, placeHolder: placeHolder, image: "text.magnifyingglass", showDelete: true).id(0)
                        .padding(.horizontal)
                
                CSDivider()
                    
               /* let container = self.viewModel.filtraERicerca(containerPath: containerKP, filterProperty: filterProperty) */
                    
                    ForEach(self.container) { model in
                        
                        GenericItemModel_RowViewMask(model: model) {
                            
                            model.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath:navigationPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: model,viewModel: viewModel)
                                
                                vbMenuInterattivoModuloEdit(currentModel: model, viewModel: viewModel, navPath: navigationPath)
                                
                                vbMenuInterattivoModuloTrash(currentModel: model, viewModel: viewModel)
                                
                           
                        }
                        
                    }
                    .id(1)
                    .onAppear {proxy.scrollTo(1, anchor: .top)}
                }
            }
            CSDivider()
        }
        
        
    }
    
}*/ // BackUp 08.11
