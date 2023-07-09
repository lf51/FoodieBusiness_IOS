//
//  VistaEspansaGenerica.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/10/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage


struct VistaEspansaGenerica<M:MyProToolPack_L1>: View where M.VM == AccounterVM, M.RS == RowSize {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let container:[String]
  //  let containerPath:KeyPath<AccounterVM,[M]>
    let containerPath:KeyPath<FoodieViewModel,[M]>
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

struct VistaEspansaMenuPerAnteprima: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let rifMenuOn:[String]
    let rifDishOn:[String]
   // let containerPath:KeyPath<FoodieViewModel,[MenuModel]>
    let label: String
    let destinationPath:DestinationPath
    let backgroundColorView:Color
    
   // private let allDishesRif:[String]
        
    init(
       // viewModel:AccounterVM,
        rifMenuOn: [String],
        rifDishOn:[String],
       // containerPath: KeyPath<FoodieViewModel, [MenuModel]>,
        label: String,
        destinationPath:DestinationPath,
        backgroundColorView: Color) {
       
      //  self.viewModel = viewModel
        self.rifMenuOn = rifMenuOn
        self.rifDishOn = rifDishOn
      //  self.containerPath = containerPath
        self.label = label
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
            
       /* self.allDishesRif = {
                
            let allMenu = viewModel.modelCollectionFromCollectionID(
                collectionId: container,
                modelPath: containerPath)
                
            let allDish = allMenu.flatMap({$0.rifDishIn})
           // let allModelDish = viewModel.modelCollectionFromCollectionID(collectionId: allDish, modelPath: \.allMyDish)
         
            return allDish
                
            }() */

    }
    
    var body: some View {
        
      VistaEspansaGenerica(
        container: rifMenuOn,
        containerPath: \.allMyMenu,
        label: label,
        backgroundColorView: backgroundColorView)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               
                Button {
                    self.viewModel.addToThePath(
                        destinationPath: destinationPath,
                        destinationView: .anteprimaPiattiMenu(
                            rifDishes: rifDishOn,
                            label: "Anteprima al Cliente")
                    )
                } label: {
                    Text("Anteprima")
                        .fontWeight(.semibold)
                        .foregroundColor(.seaTurtle_3)
                }


            }
        }
    }
    
    // Method
    
    
}

 struct AnteprimaPiattiMenu: View {
    // 01.03.23 Questa è la view gemella di quella che sarà visualizzata al cliente. Ne creiamo due perchè questa avrà delle chiare modifiche per permettere al ristoratore di fare modifiche
    @EnvironmentObject var viewModel:AccounterVM
    
    let rifDishes:[String]
   // let containerPath:KeyPath<FoodieViewModel,[DishModel]>
    let label: String
    let destinationPath:DestinationPath
    let backgroundColorView:Color
    
    init(
        rifDishes: [String],
        label: String,
        destinationPath:DestinationPath,
        backgroundColorView: Color) {
      
        self.rifDishes = rifDishes
      //  self.containerPath = containerPath
        self.label = label
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
    }

    @State private var currentDishForRatingList:DishModel?
    @State private var editMode:Bool = false
    @State private var frames:[CGRect] = []

    var body: some View {
        
        CSZStackVB(title: label, backgroundColorView: backgroundColorView) {
            // Nota 22.02.23
            let mapLabel = MapTree(
                mapProperties: self.viewModel.allMyCategories,
                kpPropertyInObject: \DishModel.categoriaMenu,
                labelColor: .black,
                labelText: .white,
                textSizeAsScreenPercentage: 0.1,
                labelOpacity: 0.35,
                extendedVersion: true)
            
            let container = self.viewModel.modelCollectionFromCollectionID(collectionId: rifDishes, modelPath: \.allMyDish).sorted(by: {$0.intestazione < $1.intestazione})
            
            VStack {
                
                CSDivider()
                
                ScrollView(showsIndicators: false) {
                    
                FiltrableBodyContent_SubView(
                    container: container,
                    mapTree: mapLabel,
                    frames: $frames,
                    coordinateSpace: "AnteprimaMainScroll") { labelProperty in
                        
                    MapLabel_MenuVistaCliente(
                        label: labelProperty.simpleDescription(),
                        imageName: labelProperty.imageAssociated(),
                        rowBoundReduction: 20,
                        textSizeAsScreenPercentage: mapLabel.textSizeAsScreenPercentage,
                        rowColor: mapLabel.labelColor,
                        textColor: mapLabel.labelTextColor,
                        shadowColor: mapLabel.shadowColor,
                        rowOpacity: mapLabel.opacity)
                        
                    } elementView: { model in
                        
                        DishModelRow_ClientVersion(
                            viewModel: viewModel,
                            item: model,
                            rowColor: backgroundColorView,
                            rowOpacity: 0.15,
                            rowBoundReduction: 20,
                            vistaEspansa: true) {
                                self.currentDishForRatingList = model
                            }
                            .csModifier(self.editMode) { view in
                                
                                view.overlay(alignment: .bottomTrailing) {
                                   
                                    Button {
                                        self.viewModel.addToThePath(
                                            destinationPath: destinationPath,
                                            destinationView: .piatto(model,.ridotto))
                                    } label: {
                                        Image(systemName:"gearshape")
                                            .imageScale(.large)
                                            .foregroundColor(.seaTurtle_3)
                                            .padding(5)
                                            .background {
                                                Color.seaTurtle_2.opacity(0.2)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 5.0)
                                                  //  .cornerRadius(5.0)
                                            }
                                    }
                                }
                            }
                    }
                }
                .csCornerRadius(10, corners: [.topLeft,.topRight])
                .coordinateSpace(name: "AnteprimaMainScroll")
                .onPreferenceChange(FramePreference.self, perform: {
                                frames = $0.sorted(by: { $0.minY < $1.minY })
                            })
                CSDivider()
            } // end vStack Madre
            .padding(.horizontal,10)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
               
                        self.editMode.toggle()
                    
                } label: {
                    let value:(label:String,color:Color) = {
                       
                        if self.editMode { return ("Chiudi Edit",.red.opacity(0.75)) }
                        else { return ("Edit Mode",.seaTurtle_3) }
                    }()
                    
                    Text(value.label)
                        .fontWeight(.semibold)
                        .foregroundColor(value.color)
                }
            }
        }
        .popover(item: $currentDishForRatingList, attachmentAnchor: .point(.top), arrowEdge: .bottom) { dish in
            DishRatingListView(
                dishItem: dish,
                backgroundColorView: backgroundColorView,
                readOnlyViewModel: self.viewModel)
            .presentationDetents([.large])
        }
    }
    
}


