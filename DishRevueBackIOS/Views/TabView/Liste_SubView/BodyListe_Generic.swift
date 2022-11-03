//
//  BodyListe_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/11/22.
//

import SwiftUI

struct BodyListe_Generic<M:MyProToolPack_L1>:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var filterProperty:FilterPropertyModel
    let containerKP:WritableKeyPath<AccounterVM,[M]>
    let navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    
    var body: some View {
        
        VStack {
            
            CSDivider()
            
            ScrollView(showsIndicators:false) {
                
                ScrollViewReader { proxy in
                    
                CSTextField_4(textFieldItem: $filterProperty.stringaRicerca, placeHolder: "Ricerca..", image: "text.magnifyingglass", showDelete: true).id(0)
                        .padding(.horizontal)
                
                CSDivider()
                    
                let container = self.viewModel.filtraERicerca(containerPath: containerKP, filterProperty: filterProperty)
                    
                ForEach(container) { model in
                        
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
    
}
