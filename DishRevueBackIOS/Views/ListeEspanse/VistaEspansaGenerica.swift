//
//  VistaEspansaGenerica.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/10/22.
//

import SwiftUI

struct VistaEspansaGenerica<M:MyProToolPack_L0>: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let container:[String]
    let containerPath:KeyPath<AccounterVM,[M]>
    let label: String
    let backgroundColorView:Color

    var body: some View {
        
        CSZStackVB(title: label, backgroundColorView: backgroundColorView) {
            
            VStack {
                
                CSDivider()
                
                ScrollView(showsIndicators: false) {
                    
                    ForEach(container,id:\.self) { rif in
                        
                        if let model = self.viewModel.modelFromId(id: rif, modelPath: containerPath) {
                            
                            GenericItemModel_RowViewMask(model: model) {
                                
                                model.vbMenuInterattivoModuloCustom(viewModel: self.viewModel, navigationPath: \.homeViewPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: model, viewModel: self.viewModel)                                
                            }
                            
                        }
                      
                    }
                    
                }
      
            } // end vStack Madre
        
        }
    }
}


/*
struct VistaEspansaGenerica_Previews: PreviewProvider {
    static var previews: some View {
        VistaEspansaGenerica()
    }
}
*/
