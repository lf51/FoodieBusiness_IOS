//
//  GenericItemModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/06/22.
//

import SwiftUI
import MyFoodiePackage

struct GenericItemModel_RowViewMask<M:MyProVisualPack_L0,Content:View>:View where M.RS == RowSize {

    @EnvironmentObject var viewModel:AccounterVM
    
    let model: M
    var pushImage: String = "gearshape"
    var rowSize: RowSize = .normale()
    
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
        
        let opacity = model.conditionToManageMenuInterattivo().opacizzaAll
        
        vbSwitchRowSize()
            .csOverlayModelChange(rifModel: model.id)
            .opacity(opacity)
    
    }
    
    // Method
    
    @ViewBuilder private func vbSwitchRowSize() -> some View {
        
        switch self.rowSize {
            
        case .sintetico:
            vbSizeRidotte(model: self.model)
        default:
            vbNormalSize(model: self.model)
        }
    }
    
    @ViewBuilder private func vbSizeRidotte(model:M) -> some View {
        
     //   model.returnModelRowView(rowSize: .sintetico)
         //  .overlay(alignment: .bottomTrailing) {
  
                Menu {
                    
                    interactiveMenuContent

                } label: {
                    model.returnModelRowView(rowSize: .sintetico)

                }
         //   }
    }
    
    @ViewBuilder private func vbNormalSize(model:M) -> some View {
        
        model.returnModelRowView(rowSize: .normale())
           .overlay(alignment: .bottomTrailing) {
  
                Menu {
                    interactiveMenuContent
                } label: {
                    Image(systemName:pushImage)
                        .imageScale(.large)
                        .foregroundStyle(Color.seaTurtle_3)
                        .padding(5)
                        .background {
                            Color.seaTurtle_2.opacity(0.5)
                                .clipShape(Circle())
                                .shadow(radius: 5.0)
                              //  .cornerRadius(5.0)
                        }

                }
            }
    }
}

struct GenericItemModel_RowViewMask_Previews: PreviewProvider {
    
    static var property:PropertyModel = property_Test
    @State static var ingredientSample =  ingredientSample_Test
    @State static var ingredientSample2 =  ingredientSample2_Test
    @State static var ingredientSample3 = ingredientSample3_Test
    @State static var ingredientSample4 =  ingredientSample4_Test
    @State static var ingredientSample6 =  ingredientSample6_Test
    @State static var ingredientSample7 =  ingredienteFinito
    @State static var dishItem3: ProductModel = dishItem3_Test
    static var dishItem4: ProductModel = dishItem4_Test
   @State static var dishItem5: ProductModel = prodottoFinito
   @State static var menuSample: MenuModel = menuSample_Test
   @State static var menuSample2: MenuModel = menuSample2_Test
    static var menuSample3: MenuModel = menuSample3_Test
    @State static var menuDelGiorno:MenuModel = menuDelGiorno_Test
    @State static var viewModel:AccounterVM = testAccount
    
    static var previews: some View {
       
        ZStack {
            
            Color.seaTurtle_1.ignoresSafeArea()
            
            ScrollView(showsIndicators:false) {
                
                VStack {
                    
                    GenericItemModel_RowViewMask(model: property) {
                        property.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.homeViewPath)
                    }
                    
                 /*   GenericItemModel_RowViewMask(model: menuSample) {
                        
                        menuSample.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.menuListPath)
                        
                        if !menuSample.tipologia.isDiSistema() {
                            vbMenuInterattivoModuloCambioStatus(myModel: $menuSample)
                            
                            vbMenuInterattivoModuloEdit(currentModel: menuSample, viewModel: viewModel, navPath: \.menuListPath)
                        }
                       
                        vbMenuInterattivoModuloTrash(currentModel: menuSample, viewModel: viewModel)
                       
                        
                        
                    }
                   
                    GenericItemModel_RowViewMask(model: menuDelGiorno) {
                        
                        menuSample.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.menuListPath)
                        
                        if !menuDelGiorno.tipologia.isDiSistema() {
                            
                            vbMenuInterattivoModuloCambioStatus(myModel: $menuDelGiorno)
                            
                            vbMenuInterattivoModuloEdit(currentModel: menuDelGiorno, viewModel: viewModel, navPath: \.menuListPath)
                        }
                      
                       
                        vbMenuInterattivoModuloTrash(currentModel: menuDelGiorno, viewModel: viewModel)
                        
                        
                        
                    } */
                   /* MenuModel_RowView(menuItem: menuSample, rowSize: .normale) */
                    GenericItemModel_RowViewMask(model: menuSample) {
                        Text("Ciao")
                    }
                    MenuModel_RowView(menuItem: menuSample2, rowSize: .normale())
                    MenuModel_RowView(menuItem: menuDelGiorno, rowSize: .normale())
                    MenuModel_RowView(menuItem: menuDelGiorno, rowSize: .sintetico)
                    MenuModel_RowView(menuItem: menuSample, rowSize: .sintetico)
                    ProductModel_RowView(item: dishItem3, rowSize:.sintetico)
                 /*  GenericItemModel_RowViewMask(model: dishItem5) {
                        
                        vbMenuInterattivoModuloCambioStatus(myModel: dishItem5,viewModel: viewModel)
                        
                        dishItem5.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.dishListPath)
                       
                    
                        vbMenuInterattivoModuloEdit(currentModel: dishItem5, viewModel: viewModel, navPath: \.dishListPath)
                        
                        vbMenuInterattivoModuloTrash(currentModel: dishItem5, viewModel: viewModel)
                    } */
                    
                   /* ProductModel_RowView(item: dishItem5, rowSize: .ridotto)
                    ProductModel_RowView(item: dishItem5, rowSize: .sintetico)
                 
                    
                    GenericItemModel_RowViewMask(model: ingredientSample7) {
      
                        if ingredientSample7.status != .bozza() {
                            
                            vbMenuInterattivoModuloCambioStatus(myModel: $ingredientSample7)
                           
                           ingredientSample7.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.ingredientListPath)
                           
                            vbMenuInterattivoModuloEdit(currentModel: ingredientSample7, viewModel: viewModel, navPath: \.ingredientListPath)
                            
                           vbMenuInterattivoModuloTrash(currentModel: ingredientSample7, viewModel: viewModel)
                            }
                        else {
                            Text("Vai al Prodotto Finito")
                        }
                            
                        }*/
                    
                    ProductModel_RowView(item: dishItem3, rowSize:.normale())
                    ProductModel_RowView(item: dishItem3, rowSize:.ridotto)
                   
                    
                 /*   GenericItemModel_RowViewMask(model: ingredientSample6) {
   
                         vbMenuInterattivoModuloCambioStatus(myModel: $ingredientSample6)
                        
                        ingredientSample6.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.ingredientListPath)
                        
                         vbMenuInterattivoModuloEdit(currentModel: ingredientSample6, viewModel: viewModel, navPath: \.ingredientListPath)
                         
                        vbMenuInterattivoModuloTrash(currentModel: ingredientSample6, viewModel: viewModel)
                         
                     }
                 
                    GenericItemModel_RowViewMask(model: ingredientSample2) {
   
                         vbMenuInterattivoModuloCambioStatus(myModel: $ingredientSample2)
                        
                        ingredientSample2.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.ingredientListPath)
                        
                         vbMenuInterattivoModuloEdit(currentModel: ingredientSample2, viewModel: viewModel, navPath: \.ingredientListPath)
                         
                        vbMenuInterattivoModuloTrash(currentModel: ingredientSample2, viewModel: viewModel)
                         
                     }
                    
                   GenericItemModel_RowViewMask(model: ingredientSample) {
  
                        vbMenuInterattivoModuloCambioStatus(myModel: $ingredientSample)
                       
                       ingredientSample.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.ingredientListPath)
                       
                        vbMenuInterattivoModuloEdit(currentModel: ingredientSample, viewModel: viewModel, navPath: \.ingredientListPath)
                        
                       vbMenuInterattivoModuloTrash(currentModel: ingredientSample, viewModel: viewModel)
                        
                    }
                    
                    IngredientModel_SmallRowView(model: ingredientSample, sostituto: nil)
                    */
                    
                   
                }
                
                
                
            }
            
            
            
            
        }//.environmentObject(AccounterVM())
        .environmentObject(testAccount)
    }
}
