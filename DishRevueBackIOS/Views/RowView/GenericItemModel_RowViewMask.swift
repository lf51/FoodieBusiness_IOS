//
//  GenericItemModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/06/22.
//

import SwiftUI

/// Lasciando il valore di default (nil) nel navigationPath, il contenuto custom del modello non verrà visualizzato.
struct GenericItemModel_RowViewMask<M:MyProVisualPack_L0,Content:View>:View {
    
    // passa da MyModelProtocol a MyProVisualPackL0
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    var pushImage: String = "gearshape"
   // var navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>? = nil
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
        
        model.returnModelRowView()
           .overlay(alignment: .bottomTrailing) {
                // l'overlay crea un zStack implicito
            /*   Circle()
                   .frame(width: 35, height: 35)
                   .foregroundColor(Color("SeaTurtlePalette_1")) */
               
                Menu {
                    
                    interactiveMenuContent
                  /*  if navigationPath != nil {
                        model.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: navigationPath!)
                    } */
                    
                } label: {
                    Image(systemName:pushImage)
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        .padding(5)
                        .background {
                            Color("SeaTurtlePalette_2").opacity(0.5)
                                .clipShape(Circle())
                                .shadow(radius: 5.0)
                              //  .cornerRadius(5.0)
                        }
                       /* .background(content: {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("SeaTurtlePalette_1"))
                        }) */
                }
             //   .offset(x:3,y:0)
          
            }
        /* Nota 22.08 - Vedere Note vocali 21.08 : Siamo tornati alla configurazione originale, che non ci piace perchè l'overlay non sta "fermo" al suo posto, ma può cambiare posizione e anche di tanto a seconda della grandezza dello schermo. Se lo schermo è difatti inferiore alla grandezza passata alla schedine (di default 400), la schedina sarà ridotta alla larghezza dello schermo minus 20, questo però non è recepito dall'overlay che andrà a posizionarsi sulla larghezza passata alla View. Per risolvere il problema apriamo una finestra nel CSZStackVB_Framed di tipo optional, e passiamo quando serve una view che andrà a posizionarsi in overlay nel bottomTrailing. In questo modo il posizionamente viene sempre rispettato e abbiamo anche il vantaggio di poter dare al "bottone" una grandezza dinamica. Lo svantaggio è che dobbiamo andare ad intervenire su diverse view, e allora, dato che dovremo intervenire in modo massiccio sulle liste (per altri motivi), attendiamo di tornare ad intervenire sulle liste e con la situazione chiara apportiamo anche queste eventuali modifiche, che fatte ora rischiano di dover essere sovrascritte, come tante volte già capitato in questi 8 mesi di lavoro.*/
        
    }
}

/*
/// Lasciando il valore di default (nil) nel navigationPath, il contenuto custom del modello non verrà visualizzato.
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    var pushImage: String = "square.and.pencil"
    var navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>? = nil
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
        
        model.returnModelRowView()
            
           .overlay(alignment: .bottomTrailing) {
                
                Menu {
                    
                    interactiveMenuContent
                    if navigationPath != nil {
                        model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath!)
                    }
                    
                } label: {
                    Image(systemName:pushImage)
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                        .background(content: {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("SeaTurtlePalette_1"))
                        })
                }
             //   .offset(x:3,y:0)
          
            }
    }
} */ //BackUP 21.08 -> il posizionamento dell'overlay varia in base alla grandezza della ZStack Madre. Quando lo schermo riduce, entra in gioco il maxWidth del CSZStackVB_Framed e allora l'overlay cambia posizione perchè si orienta al valore del width passato e non a quello effettivo


/*
/// Lasciando il valore di default (nil) nel navigationPath, il contenuto custom del modello non verrà visualizzato.
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    var imageToPush: String = "square.and.pencil"
    var navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>? = nil
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
             
        model.returnModelRowView()
            .overlay(alignment: .bottomTrailing) {
                
                Menu {
                    
                    interactiveMenuContent
                    
                    if navigationPath != nil {
                        model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath!)
                    }
                    
                } label: {
                    Image(systemName: imageToPush)
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                    
                }.offset(x:10,y:15)
                
            }
    }
} */ // Deprecata 17.08 -> Ritorno ad un Menu con Label la row, ma con un'azione primaria, di modo che il menu si apra su un long press


/*
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    let navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
                
        Menu {
            
            interactiveMenuContent
            model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath )
 
        } label: {

            //csVbSwitchModelRowView(item: model)
            model.returnModelRowView()
           
        }
    }

} */// deprecata 17.08 -> Sostituita con un Menu messo in Overlay


/*
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

} */ // Deprecata 28.06 per trasformazione da Binding<M> a M


struct GenericItemModel_RowViewMask_Previews: PreviewProvider {
    
    static var property:PropertyModel = property_Test
    @State static var ingredientSample =  ingredientSample_Test
    @State static var ingredientSample2 =  ingredientSample2_Test
    @State static var ingredientSample3 = ingredientSample3_Test
    @State static var ingredientSample4 =  ingredientSample4_Test
    @State static var ingredientSample6 =  ingredientSample6_Test
    @State static var dishItem3: DishModel = dishItem3_Test
    static var dishItem4: DishModel = dishItem4_Test
   @State static var menuSample: MenuModel = menuSample_Test
    static var menuSample2: MenuModel = menuSample2_Test
    static var menuSample3: MenuModel = menuSample3_Test
    @State static var menuDelGiorno:MenuModel = menuDelGiorno_Test
    @State static var viewModel:AccounterVM = testAccount
    
    static var previews: some View {
       
        ZStack {
            
            Color("SeaTurtlePalette_1").ignoresSafeArea()
            
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
                    
                 /*   GenericItemModel_RowViewMask(model: dishItem3 ) {
                        
                        vbMenuInterattivoModuloCambioStatus(myModel: $dishItem3)
                        
                        dishItem3.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.dishListPath)
                       
                        
                        
                        vbMenuInterattivoModuloEdit(currentModel: dishItem3, viewModel: viewModel, navPath: \.dishListPath)
                        
                        vbMenuInterattivoModuloTrash(currentModel: dishItem3, viewModel: viewModel)
                    } */
                /*
                    DishModel_RowView(item: dishItem3, rowSize:.ridotto)
                    DishModel_RowView(item: dishItem3, rowSize:.sintetico)*/
                    
                    GenericItemModel_RowViewMask(model: ingredientSample6) {
   
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
                    
                    
                   
                }
                
                
                
            }
            
            
            
            
        }//.environmentObject(AccounterVM())
        .environmentObject(testAccount)
    }
}


/*
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
            }
        }
        
    } else if localModel.status == .completo(.inPausa) {
        
        Button {
            model.wrappedValue.status = .completo(.pubblico)
        } label: {
            HStack {
                Text("Pubblica")
                Image(systemName: "play.circle")
            
            }
        }
        
        
    }
    
    
    
    
    
} */ // 28.06 Deprecata


