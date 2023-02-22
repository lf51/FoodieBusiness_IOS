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

/*extension VistaEspansaGenerica where TrailingView == EmptyView {
    
    init(
        container: [String],
        containerPath: KeyPath<FoodieViewModel, [M]>,
        label: String,
        backgroundColorView: Color) {
       
            self.init(
                container: container,
                containerPath: containerPath,
                label: label,
                backgroundColorView: backgroundColorView) {
                    EmptyView()
                }
    }
} */


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
    
    @ObservedObject var viewModel:AccounterVM
    
    let container:[String]
    let containerPath:KeyPath<FoodieViewModel,[MenuModel]>
    let label: String
    let destinationPath:DestinationPath
    let backgroundColorView:Color
    
    private let allDishModel:[DishModel]
        
    init(
        viewModel:AccounterVM,
        container: [String],
        containerPath: KeyPath<FoodieViewModel, [MenuModel]>,
        label: String,
        destinationPath:DestinationPath,
        backgroundColorView: Color) {
       
        self.viewModel = viewModel
        self.container = container
        self.containerPath = containerPath
        self.label = label
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
            
        self.allDishModel = {
                
            let allMenu = viewModel.modelCollectionFromCollectionID(
                collectionId: container,
                modelPath: containerPath)
                
            let allDish = allMenu.flatMap({$0.rifDishIn})
            let allModelDish = viewModel.modelCollectionFromCollectionID(collectionId: allDish, modelPath: \.allMyDish)
         
            return allModelDish
                
            }()

    }
    
    var body: some View {
        
      VistaEspansaGenerica(
        container: container,
        containerPath: containerPath,
        label: label,
        backgroundColorView: backgroundColorView)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               
                Button {
                    self.viewModel.addToThePath(
                        destinationPath: destinationPath,
                        destinationView: .anteprimaPiattiMenu(
                            containerMod: allDishModel,
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
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let container:[DishModel]
    let containerPath:KeyPath<FoodieViewModel,[DishModel]>
    let label: String
    let destinationPath:DestinationPath
    let backgroundColorView:Color
    
    init(
        container: [DishModel],
        containerPath: KeyPath<FoodieViewModel, [DishModel]>,
        label: String,
        destinationPath:DestinationPath,
        backgroundColorView: Color) {
      
        self.container = container
        self.containerPath = containerPath
        self.label = label
        self.destinationPath = destinationPath
        self.backgroundColorView = backgroundColorView
    }

    @State private var currentDishForRatingList:DishModel?
    @State private var editMode:Bool = false
    @State private var frames:[CGRect] = []
     
    //@State private var mapTree:MapTree // dobbiamo / possiamo dare all'utente la possibilità d scegliersi la categoria per il Map
     
    var body: some View {
        
        CSZStackVB(title: label, backgroundColorView: backgroundColorView) {
            // Nota 22.02.23
            let mapLabel = MapTree(
                mapProperties: self.viewModel.allMyCategories,
                kpPropertyInObject: \DishModel.categoriaMenu,
                labelColor: .seaTurtle_2,
                labelText: .seaTurtle_1,
                textSizeAsScreenPercentage: 0.125,
                labelOpacity: 0.8,
                extendedVersion: true)
            
            VStack {
                
                CSDivider()
                
                ScrollView(showsIndicators: false) {
                    
                    
                 //  FiltrableBodyContent_SubView // 21.02.23 Da testare/ occorre renderla public
                    
                    FiltrableBodyContent_SubView(
                        container: container,
                        mapTree: mapLabel,
                        frames: $frames,
                        coordinateSpace: "AnteprimaMainScroll") { model in
                            
                          //  VStack {
                              /* MapLabel(
                                    rowBoundReduction: 20,
                                    rowColor: .seaTurtle_3,
                                    shadowColor: .black,
                                    rowOpacity: 1.0) */
                                
                                DishModelRow_ClientVersion(
                                    viewModel: viewModel,
                                    item: model,
                                    rowColor: backgroundColorView,
                                    rowOpacity: 0.15,
                                    rowBoundReduction: 20,
                                    vistaEspansa: true) {
                                        self.currentDishForRatingList = model
                                    }
                                    .modifierIf(self.editMode) { view in
                                        
                                        view.overlay(alignment: .bottomTrailing) {
                                           
                                            Button {
                                                self.viewModel.addToThePath(
                                                    destinationPath: destinationPath,
                                                    destinationView: .piatto(model))
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
                          //  }
                        }
                    
                    /*ForEach(container,id:\.self) { rif in
                        
                        if let model = self.viewModel.modelFromId(id: rif, modelPath: containerPath) {
                            
                            DishModelRow_ClientVersion(
                                viewModel: viewModel,
                                item: model,
                                rowColor: backgroundColorView,
                                rowOpacity: 0.15,
                                rowBoundReduction: 20,
                                vistaEspansa: true) {
                                    self.currentDishForRatingList = model
                                }
                                .modifierIf(self.editMode) { view in
                                    view.overlay(alignment: .bottomTrailing) {
                                       
                                        Button {
                                            self.viewModel.addToThePath(
                                                destinationPath: destinationPath,
                                                destinationView: .piatto(model))
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
                      
                    }*/ // Chiusa ForEach
                    
                }
                .coordinateSpace(name: "AnteprimaMainScroll")
                .onPreferenceChange(FramePreference.self, perform: {
                                frames = $0.sorted(by: { $0.minY < $1.minY })
                            })
                // coordinateSpace
                //onChangePreferece
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
        .popover(item: $currentDishForRatingList, attachmentAnchor: .point(.trailing), arrowEdge: .trailing) { dish in
            DishRatingListView(
                dishItem: dish,
                backgroundColorView: backgroundColorView,
                readOnlyViewModel: self.viewModel)
            .presentationDetents([.large])
        }
    }
    
}
