//
//  BodyListe_Generic.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/11/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import MyFilterPackage

/*struct MapObject<M:Identifiable,C:Identifiable> {
  
    var mapProperties:[C]
    var kpPropertyInObject:KeyPath<M,String>
    
} */ // Trasformata in MapTree nel MyFilterPackage // 

struct BodyListe_Generic<M:MyProToolPack_L1,C:MyProEnumPack_L2>:View where M.VM == AccounterVM, M.RS == RowSize {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let container:[M]
    let mapTree:MapTree<M,C>?
    let navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>
 
    var body: some View {
        
        if mapTree == nil {
            
            vbPlainContainer(container: self.container)
             
        } else { vbMappedContainer() }
        
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
        
        ForEach(self.mapTree!.mapProperties) { category in
            
            let mappedContainer = self.container.filter({$0[keyPath: self.mapTree!.kpPropertyInObject] == category.id })
        
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
struct BodyListe_Generic<M:MyProToolPack_L1,C:MyProEnumPack_L2>:View where M.VM == AccounterVM, M.RS == RowSize {
    
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
            
          //  let modelStatusArchiviato = model.status.checkStatusTransition(check: .archiviato)
          /*  let value:(disableCustom:Bool,disableStatus:Bool,disableEdit:Bool,disableTrash:Bool,opacizzaAll:CGFloat) = {
                model.conditionToManageMenuInterattivo()
            }() */
            
            GenericItemModel_RowViewMask(model: model) {
                
                model.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath:navigationPath)
                  //  .disabled(value.disableCustom)
                    
                    vbMenuInterattivoModuloCambioStatus(myModel: model,viewModel: viewModel)
                  //  .disabled(value.disableStatus)
                
                    vbMenuInterattivoModuloEdit(currentModel: model, viewModel: viewModel, navPath: navigationPath)
                   // .disabled(value.disableEdit)
                
                    vbMenuInterattivoModuloTrash(currentModel: model, viewModel: viewModel)
                   // .disabled(value.disableTrash)
               
            }//.opacity(value.opacizzaAll)
            
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
} */ // deprecata 23.12 da cancellare

/*
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
    
} */ // Not Used da cancellare
