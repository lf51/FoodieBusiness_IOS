//
//  GenericItemModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/06/22.
//

import SwiftUI

struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var model: M
    let backgroundColorView: Color
    @ViewBuilder var interactiveMenuContent: Content
   
  
    
    var body: some View {
                
        Menu {
               interactiveMenuContent
            Text("Linea TEST")
        
        } label: {

      csVbSwitchModelRowView(itemModel: $model)
           
        }
    }

}

/*
struct GenericItemModel_RowViewMask_Previews: PreviewProvider {
    static var previews: some View {
        GenericItemModel_RowViewMask()
    }
} */

/// ViewBuilder - Modifica lo Status di un Model Generico, passando da completo(.pubblico) a completo(.inPausa) e viceversa
@ViewBuilder func vbStatusButton<M:MyModelStatusConformity>(model:Binding<M>) -> some View {
    
    let localModel = model.wrappedValue
    
    if localModel.status == .completo(.pubblico) {
        
        Button {
            model.wrappedValue.status = .completo(.inPausa)
        } label: {
            HStack {
                Text("Metti in Pausa")
                Image(systemName: "pause.circle")
            }.foregroundColor(Color.black)
        }
        
    } else if localModel.status == .completo(.inPausa) {
        
        Button {
            model.wrappedValue.status = .completo(.pubblico)
        } label: {
            HStack {
                Text("Pubblica")
                Image(systemName: "play.circle")
            
            }.foregroundColor(Color.black)
        }
        
        
    }
    
    
    
    
    
}
