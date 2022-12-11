//
//  VistaEspansaGenerica.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/10/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct VistaEspansaGenerica<M:MyProToolPack_L1>: View where M.VM == AccounterVM, M.RS == RowSize {
    
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
                CSDivider()
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
