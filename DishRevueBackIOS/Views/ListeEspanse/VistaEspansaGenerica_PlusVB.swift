//
//  VistaEspansaGenerica_PlusVB.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/07/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

/// Vista espansa  dish da Monitor con filtri execution
 struct VistaEspansaDish_MonitorServizio:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let container:[String]
    let label: String
    let backgroundColorView:Color

  // @State private var statusState:StatusTransition?
    @State private var coreFilter:CoreFilter<ProductModel> = CoreFilter()
    
    init(
        container: [String],
        label: String,
        backgroundColorView: Color) {
      
        self.container = container
        self.label = label
        self.backgroundColorView = backgroundColorView
      
    }
    
   public var body: some View {
        
        CSZStackVB(
            title: label,
            backgroundColorView: backgroundColorView) {
            
                let containerModel:[ProductModel] = {
                    
                    let model = self.viewModel.modelCollectionFromCollectionID(
                        collectionId: container,
                        modelPath: \.db.allMyDish)
                    let filteredModel = self.viewModel.filtraSpecificCollection(
                        ofModel: model,
                        coreFilter: coreFilter)
                    return filteredModel
                }()
               
                VStack {
                
               // vbMonitorFiltri(container: containerModel)
                    vbFiltriVisivi()
                    
                ScrollView(showsIndicators: false) {
                    
                    ForEach(containerModel) { mod in
                        
                     //  if let model = self.viewModel.modelFromId(id: rif, modelPath: \.allMyDish) {
                            
                            GenericItemModel_RowViewMask(model: mod) {
                                
                                mod.vbMenuInterattivoModuloCustom(viewModel: self.viewModel, navigationPath: \.homeViewPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: mod, viewModel: self.viewModel)
                                
                            }
                            
                      // }
                      
                    }
                    
                }
                CSDivider()
            } // end vStack Madre
        
        }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    let disable = self.coreFilter.countChange == 0
                    Button("Reset") {
                        withAnimation {
                            self.coreFilter = CoreFilter()
                        }
                    }
                    .foregroundStyle(disable ? Color.seaTurtle_1 : Color.seaTurtle_3)
                    .disabled(disable)
                }
            }
    }
    
    // Method
    
    
    @ViewBuilder private func vbFiltriVisivi() -> some View {

        let executiveInfo:(descr:String,color:Color) = {
            
            if let exe = coreFilter.filterProperties.executionState {
                
                return (exe.filterDescription(),exe.coloreAssociato())
            }
            else { return ("",.gray)}
        }()
        
        let statusInfo:(descr:String,color:Color) = {
            
            if let exe = coreFilter.filterProperties.status_singleChoice {
                
                return (exe.simpleDescription(),exe.colorAssociated())
            }
            else { return ("",.gray)}
        }()
        
        let stringInfo: String = {
            
            let emptyString = executiveInfo.descr == "" && statusInfo.descr == ""
            
            if emptyString { return "Nessun filtro applicato" }
            else if executiveInfo.descr == "" { return statusInfo.descr }
            else if statusInfo.descr == "" { return executiveInfo.descr }
            else { return executiveInfo.descr + " & " + statusInfo.descr }
            
        }()
        
        HStack(alignment:.center) {
            
           // Spacer()
            
            csCircleDashed(
                internalColor: statusInfo.color,
                dashedColor: executiveInfo.color)
            
            Text(stringInfo)
                .italic()
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundStyle(Color.black)
                .opacity(0.8)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button {
                withAnimation {
                    excutiveFilterAction()
                }
            } label: {
                Image(systemName: "circle.dashed")
                    .font(.custom("Large", size: 40))
                    .foregroundStyle(executiveInfo.color)
                    .shadow(radius: 5.0)
            }
            
            Button {
                withAnimation {
                    statusFilterAction()
                }
            } label: {
                Image(systemName: "circle.fill")
                    .font(.custom("Large", size: 40))
                    .foregroundStyle(statusInfo.color)
                    .shadow(radius: 5.0)
            }

        
        }
        .csHpadding()
    }
    
    private func excutiveFilterAction() {
        
        let allCases = ProductModel.ExecutionState.allCases
        let casesCount = allCases.count
        let currentState = coreFilter.filterProperties.executionState
        
        guard currentState != nil else {
            coreFilter.filterProperties.executionState = allCases[0]
            return
        }
        let nextIndex = ((allCases.firstIndex(of: currentState!) ?? 0) + 1) % casesCount
    
        coreFilter.filterProperties.executionState = allCases[nextIndex]
    }
    private func statusFilterAction() {
        
        let allCases = StatusTransition.allCases
        let casesCount = allCases.count
        let currentState = coreFilter.filterProperties.status_singleChoice
        
        guard currentState != nil else {
            coreFilter.filterProperties.status_singleChoice = allCases[0]
            return
        }
        
        let nextIndex = ((allCases.firstIndex(of: currentState!) ?? 0) + 1) % casesCount
    
        coreFilter.filterProperties.status_singleChoice = allCases[nextIndex]
        
    }
    
}
/// Vista espansa ingredienti da Monitor con filtri execution
 struct VistaEspansaIng_MonitorServizio:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @State private var coreFilter:CoreFilter<IngredientModel> = CoreFilter()
    
    let container:[String]
  //  var returnContainerPF:Bool = false
    let label: String
    let backgroundColorView:Color
    
    var body: some View {
        
        CSZStackVB(title: label, backgroundColorView: backgroundColorView) {
            
            
            let containerModel:[IngredientModel] = {

                    let model = self.viewModel.modelCollectionFromCollectionID(
                        collectionId: container,
                        modelPath: \.db.allMyIngredients)
                    let filteredModel = self.viewModel.filtraSpecificCollection(
                        ofModel: model,
                        coreFilter: coreFilter)
                    return filteredModel
                }()
                
            
            VStack {
                
                vbFiltriVisivi()
                
                ScrollView(showsIndicators: false) {
                    
                    ForEach(containerModel) { mod in

                            GenericItemModel_RowViewMask(model: mod) {
                                
                                mod.vbMenuInterattivoModuloCustom(viewModel: self.viewModel, navigationPath: \.homeViewPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel: mod, viewModel: self.viewModel)
                                
                            }

                      
                    }
                    
                }

                
                CSDivider()
            } // end Vstack
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                let disable = self.coreFilter.countChange == 0
                Button("Reset") {
                    withAnimation {
                        self.coreFilter = CoreFilter()
                    }
                }
                .foregroundStyle(disable ? Color.seaTurtle_1 : Color.seaTurtle_3)
                .disabled(disable)
            }
        }
    }

    // Method
            @ViewBuilder private func vbFiltriVisivi() -> some View {

                let executiveInfo:(descr:String,color:Color) = {
                    
                    if let exe = coreFilter.filterProperties.inventario_singleChoice {
                        
                        return (exe.simpleDescription(),exe.coloreAssociatoNotOpacity())
                    }
                    else { return ("",.gray)}
                }()
                
                let statusInfo:(descr:String,color:Color) = {
                    
                    if let exe = coreFilter.filterProperties.status_singleChoice {
                        
                        return (exe.simpleDescription(),exe.colorAssociated())
                    }
                    else { return ("",.gray)}
                }()
                
                let stringInfo: String = {
                    
                    let emptyString = executiveInfo.descr == "" && statusInfo.descr == ""
                    
                    if emptyString { return "Nessun filtro applicato" }
                    else if executiveInfo.descr == "" { return statusInfo.descr }
                    else if statusInfo.descr == "" { return executiveInfo.descr }
                    else { return executiveInfo.descr + " & " + statusInfo.descr }
                    
                }()
                
                HStack(alignment:.center) {
                    
                   // Spacer()
                    
                    csCircleDashed(
                        internalColor: statusInfo.color,
                        dashedColor: executiveInfo.color)
                    
                    Text(stringInfo)
                        .italic()
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            excutiveFilterAction()
                        }
                    } label: {
                        Image(systemName: "circle.dashed")
                            .font(.custom("Large", size: 40))
                            .foregroundStyle(executiveInfo.color)
                            .shadow(radius: 5.0)
                    }
                    
                    Button {
                        withAnimation {
                            statusFilterAction()
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                            .font(.custom("Large", size: 40))
                            .foregroundStyle(statusInfo.color)
                            .shadow(radius: 5.0)
                    }

                
                }
                .csHpadding()
            }
            
            private func excutiveFilterAction() {
                
                //let allCases = Inventario.TransitoScorte.allCases
                let allCases = StatoScorte.allCases
                let casesCount = allCases.count
                let currentState = coreFilter.filterProperties.inventario_singleChoice
                
                guard currentState != nil else {
                    coreFilter.filterProperties.inventario_singleChoice = allCases[0]
                    return
                }
                let nextIndex = ((allCases.firstIndex(of: currentState!) ?? 0) + 1) % casesCount
            
                coreFilter.filterProperties.inventario_singleChoice = allCases[nextIndex]
            }
            private func statusFilterAction() {
                
                let allCases = StatusTransition.allCases
                let casesCount = allCases.count
                let currentState = coreFilter.filterProperties.status_singleChoice
                
                guard currentState != nil else {
                    coreFilter.filterProperties.status_singleChoice = allCases[0]
                    return
                }
                
                let nextIndex = ((allCases.firstIndex(of: currentState!) ?? 0) + 1) % casesCount
            
                coreFilter.filterProperties.status_singleChoice = allCases[nextIndex]
                
            }
}

/// Quasi identica a quella degli ing, sarebbe richiesto un accorpamento creando una logica interna, un viewbuilder generico che permette di switchare fra un container di ProductModel e uno di IngredientModel. 10.07.23 al momento lo teniamo così
struct VistaEspansaPF_MonitorServizio:View {
   
   @EnvironmentObject var viewModel:AccounterVM
   
   let container:[String]
   let label: String
   let backgroundColorView:Color

 // @State private var statusState:StatusTransition?
   @State private var coreFilterING:CoreFilter<IngredientModel> = CoreFilter()
   @State private var coreFilterDish:CoreFilter<ProductModel> = CoreFilter()
    
   init(
       container: [String],
       label: String,
       backgroundColorView: Color) {
     
       self.container = container
       self.label = label
       self.backgroundColorView = backgroundColorView
     
   }
   
  public var body: some View {
       
       CSZStackVB(
           title: label,
           backgroundColorView: backgroundColorView) {
           
               let containerModel:[ProductModel] = {
                   
                   let ingModel = self.viewModel.modelCollectionFromCollectionID(
                       collectionId: container,
                       modelPath: \.db.allMyIngredients) // i pf hanno un ingrediente con stesso id
                   print("pfContainer_ing in:\(ingModel.count)")
                   let filteredModel = self.viewModel.filtraSpecificCollection(
                       ofModel: ingModel,
                       coreFilter: coreFilterING)
                   print("pfContainer_filteres in:\(filteredModel.count)")
                   let filteredId = filteredModel.map({$0.id})
                   let ProductModel = self.viewModel.modelCollectionFromCollectionID(collectionId: filteredId, modelPath: \.db.allMyDish)
                   let dishFiltered = self.viewModel.filtraSpecificCollection(ofModel: ProductModel, coreFilter: coreFilterDish)
                   print("pfContainer_dish in:\(dishFiltered.count)")
                   return dishFiltered
               }()
              
               VStack {
               
              // vbMonitorFiltri(container: containerModel)
                   vbFiltriVisivi()
                   
               ScrollView(showsIndicators: false) {
                   
                   ForEach(containerModel) { mod in
                       
                    //  if let model = self.viewModel.modelFromId(id: rif, modelPath: \.allMyDish) {
                           
                           GenericItemModel_RowViewMask(model: mod) {
                               
                               mod.vbMenuInterattivoModuloCustom(viewModel: self.viewModel, navigationPath: \.homeViewPath)
                               
                               vbMenuInterattivoModuloCambioStatus(myModel: mod, viewModel: self.viewModel)
                               
                           }
                           
                     // }
                     
                   }
                   
               }
               CSDivider()
           } // end vStack Madre
       
       }
           .toolbar {
               ToolbarItem(placement: .topBarTrailing) {
                   let disable = (self.coreFilterING.countChange == 0) &&
                   (self.coreFilterDish.countChange == 0)
                   Button("Reset") {
                       withAnimation {
                           self.coreFilterING = CoreFilter()
                           self.coreFilterDish = CoreFilter()
                       }
                   }
                   .foregroundStyle(disable ? Color.seaTurtle_1 : Color.seaTurtle_3)
                   .disabled(disable)
               }
           }
   }
   
   // Method
   
   
   @ViewBuilder private func vbFiltriVisivi() -> some View {

       let executiveInfo:(descr:String,color:Color) = {
           
           if let exe = coreFilterING.filterProperties.inventario_singleChoice {
               
               return (exe.simpleDescription(),exe.coloreAssociatoNotOpacity())
           }
           else { return ("",.gray)}
       }()
       
       let statusInfo:(descr:String,color:Color) = {
           
           if let exe = coreFilterDish.filterProperties.status_singleChoice {
               
               return (exe.simpleDescription(),exe.colorAssociated())
           }
           else { return ("",.gray)}
       }()
       
       let stringInfo: String = {
           
           let emptyString = executiveInfo.descr == "" && statusInfo.descr == ""
           
           if emptyString { return "Nessun filtro applicato" }
           else if executiveInfo.descr == "" { return statusInfo.descr }
           else if statusInfo.descr == "" { return executiveInfo.descr }
           else { return executiveInfo.descr + " & " + statusInfo.descr }
           
       }()
       
       HStack(alignment:.center) {
           
          // Spacer()
           
           csCircleDashed(
               internalColor: statusInfo.color,
               dashedColor: executiveInfo.color)
           
           Text(stringInfo)
               .italic()
               .fontWeight(.semibold)
               .font(.subheadline)
               .foregroundStyle(Color.black)
               .opacity(0.8)
               .multilineTextAlignment(.leading)
           
           Spacer()
           
           Button {
               withAnimation {
                   excutiveFilterAction()
               }
           } label: {
               Image(systemName: "circle.dashed")
                   .font(.custom("Large", size: 40))
                   .foregroundStyle(executiveInfo.color)
                   .shadow(radius: 5.0)
           }
           
           Button {
               withAnimation {
                   statusFilterAction()
               }
           } label: {
               Image(systemName: "circle.fill")
                   .font(.custom("Large", size: 40))
                   .foregroundStyle(statusInfo.color)
                   .shadow(radius: 5.0)
           }

       
       }
       .csHpadding()
   }
   
   private func excutiveFilterAction() {
       
       /*let allCases = Inventario.TransitoScorte.allCases*/
       let allCases = StatoScorte.allCases
       let casesCount = allCases.count
       let currentState = coreFilterING.filterProperties.inventario_singleChoice
       
       guard currentState != nil else {
           coreFilterING.filterProperties.inventario_singleChoice = allCases[0]
           return
       }
       let nextIndex = ((allCases.firstIndex(of: currentState!) ?? 0) + 1) % casesCount
   
       coreFilterING.filterProperties.inventario_singleChoice = allCases[nextIndex]
   }
   private func statusFilterAction() {
       
       let allCases = StatusTransition.allCases
       let casesCount = allCases.count
       let currentState = coreFilterDish.filterProperties.status_singleChoice
       
       guard currentState != nil else {
           coreFilterDish.filterProperties.status_singleChoice = allCases[0]
           return
       }
       
       let nextIndex = ((allCases.firstIndex(of: currentState!) ?? 0) + 1) % casesCount
   
       coreFilterDish.filterProperties.status_singleChoice = allCases[nextIndex]
       
   }
   
}


