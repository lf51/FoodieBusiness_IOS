//
//  GenericModelList.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

struct VistaIngredientiEspansa: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDish: ProductModel
    let backgroundColorView: Color
    let allING:[String]
    @State private var container:[String]

    init(currentDish: ProductModel, backgroundColorView: Color) {
        
        self.currentDish = currentDish
        self.backgroundColorView = backgroundColorView
        
        let all = (currentDish.ingredientiPrincipali ?? []) + (currentDish.ingredientiSecondari ?? [])
        self.allING = all
        _container = State(wrappedValue: all)
    }
    
    var body: some View {
        
        CSZStackVB(title: currentDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                
                HStack {
                    
                    Text("Count: \(self.container.count,format: .number)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.blue)
                        .padding(5)
                        .background {
                            Color.seaTurtle_3.cornerRadius(5.0)
                        }
                    Spacer()
                    
                    Picker("", selection: $container) {
                        
                        Text("Vedi Tutti")
                            .tag(self.allING)
                        Text("Solo Principali")
                            .tag(currentDish.ingredientiPrincipali)
                        Text("Solo Secondari")
                            .tag(currentDish.ingredientiSecondari)
                       
                    }
                    .accentColor(Color.black)
                    .background(
                      
                      RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.white.opacity(0.8))
                        .shadow(radius: 1.0)
                    )
                }
                
                ScrollView(showsIndicators:false) {
                    
                    VStack {
                        
                        ForEach(container,id:\.self) { rif in
    
                            if let model = self.viewModel.modelFromId(id: rif, modelPath: \.db.allMyIngredients) {
                                
                                let isDisponibile = model.statusTransition == .disponibile
 
                                    TabView {
                                        IngredientModel_RowView(item: model, rowSize: .normale())
                                            .opacity(isDisponibile ? 1.0 : 0.6)

                                        if !isDisponibile {
                                            vbSostituto(rif: rif)
                                                .padding(.leading,5)
                                        }
                                    }
                                    .frame(height:180)
                                    .tabViewStyle(PageTabViewStyle())

                            } // end optional Binding
                            
                        }
                    }
                }
                
                
                CSDivider()
                
            }
           // .padding(.horizontal)
            .csHpadding()
            .animation(.default, value: container)
            
            
        }
    }
    
    // Method
    
    @ViewBuilder private func vbSostituto(rif:String) -> some View {
        
        if let sostituto = currentDish.elencoIngredientiOff?[rif] {
           
            if let modelSostituto = self.viewModel.modelFromId(id: sostituto, modelPath: \.db.allMyIngredients) {
                
                let isActive = modelSostituto.statusTransition == .disponibile
                
                IngredientModel_RowView(item: modelSostituto, rowSize: .normale())
                    .opacity(isActive ? 1.0 : 0.6)
                    .overlay(alignment: .leading) {
                        VStack {
                            Image(systemName: "arrowshape.forward")
                                .imageScale(.large)
                                .fontWeight(.black)
                                .foregroundStyle(Color.red)
                            
                            Image(systemName: "arrowshape.backward.fill")
                                .imageScale(.large)
                                .fontWeight(.black)
                                .foregroundStyle(Color.green)
                            
                        }
                        .offset(x: -30)
                    }
                
            }
            
            
            
        } else { EmptyView() }
        
    }
}

struct VistaIngredientiEspansa_Selectable: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding private var currentDish: ProductModel
    let backgroundColorView: Color
    let rowViewSize:RowSize
    let destinationPath:DestinationPath
    
    @State private var filterCore:CoreFilter<IngredientModel> = CoreFilter()
    
    init(
        currentDish: Binding<ProductModel>,
        backgroundColorView: Color,
        rowViewSize:RowSize,
        destinationPath: DestinationPath) {
        
        _currentDish = currentDish
        self.backgroundColorView = backgroundColorView
        self.rowViewSize = rowViewSize
        self.destinationPath = destinationPath
    }
   
    var body: some View {
        
        CSZStackVB(
            title: "Seleziona Ingredienti",
            titlePosition: .bodyEmbed([.horizontal,.top],15),
            backgroundColorView: backgroundColorView) {
        
                VStack(alignment:.leading) {
                    
                    let container = self.viewModel.ricercaFiltra(containerPath: \.db.allMyIngredients, coreFilter: filterCore)
                   // let container = container_0.filter({$0.status != .bozza()})
                    
                    HStack {
                        
                        Grid(alignment:.leading,verticalSpacing: 5) {
                            
                            GridRow(alignment:.lastTextBaseline) {
                                
                                Image(systemName: "leaf.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(Color.seaTurtle_3)
                                Text("Principali:")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                Text("\(self.currentDish.ingredientiPrincipali?.count ?? 0)")
                                    .monospaced()
                                
                            }
                            
                            GridRow(alignment:.lastTextBaseline)  {
                                Image(systemName: "leaf.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(Color.orange)
                                Text("Secondari:")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                Text("\(self.currentDish.ingredientiSecondari?.count ?? 0)")
                                    .monospaced()
                                
                            }
                        }

                    Spacer()
                        
                    CSTextField_4(
                        textFieldItem: $filterCore.stringaRicerca,
                        placeHolder: "Nome/Allergene",
                        image: "text.magnifyingglass",
                        imageBasicColor: .gray,
                        imageActiveColor: .black,
                        imageScale: .medium,
                        showDelete: true)
                        
                    }

                    vbFilterView(container: container)
                    
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(container) { ing in
                            
                            let valuePath = self.currentDish.individuaPathIngrediente(idIngrediente: ing.id)
                            let valueRow = self.checkSelection(rifIng: ing.id, path: valuePath.path)
                            
                            ing.returnModelRowView(rowSize: rowViewSize)
                                .opacity(valuePath.path != nil ? 1.0 : 0.4)
                                .overlay(alignment: .bottomTrailing) {
                                    
                                    CSButton_image(
                                        frontImage: valueRow.image,
                                        imageScale: .large,
                                        frontColor: valueRow.colore) {
                                            withAnimation {
                                                selectDeselectAction(rif: ing.id, valuePath: valuePath)
                                            }
                                        }
                                        .padding(.trailing,10)
                                        .padding(.bottom,5)
                                        .shadow(radius: 5.0)
                                }
  
                        }
  
                    }
                    
                    CSDivider()
                }
         
    
            } // chiusa CSZStack
   
    }
    
    //Method
    
    @ViewBuilder private func vbFilterView(container:[IngredientModel]) -> some View {
        
                MyFilterRow(
                    allCases: [StatoScorte.inStock],
                    filterCollection: $filterCore.filterProperties.inventario,
                    selectionColor: Color.teal.opacity(0.6)) { value in
                        container.filter({
                            
                            $0.statusScorte() == value 
                            
                           /* self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id) == value*/
                        }).count
                    }

                MyFilterRow(
                    allCases: OrigineIngrediente.allCases,
                    filterProperty: $filterCore.filterProperties.origineING,
                    selectionColor: Color.brown) { value in
                        container.filter({$0.origine == value}).count
                    }
 
        }
    
    private func checkSelection(rifIng:String,path:WritableKeyPath<ProductModel,[String]?>?) -> (colore:Color,image:String) {
        
        guard path != nil else { return (.gray,"leaf") }
        
        if path == \.ingredientiPrincipali { return (.seaTurtle_3,"leaf.fill")}
        else if path == \.ingredientiSecondari { return (.orange,"leaf.fill")}
        else { return (.black,"leaf")}
        
    }
    
    private func selectDeselectAction(rif:String,valuePath:(path:WritableKeyPath<ProductModel,[String]?>?,index:Int?)) {
        
        guard let currentPath = valuePath.path,
              let currentIndex = valuePath.index else {
       
            var principali = self.currentDish.ingredientiPrincipali ?? []
            principali.append(rif)
            
            self.currentDish.ingredientiPrincipali = principali
            
            return }
        
        
        if currentPath == \.ingredientiPrincipali {
            self.currentDish.ingredientiPrincipali?.remove(at: currentIndex)
            var secondari = self.currentDish.ingredientiSecondari ?? []
            
            secondari.append(rif)
            self.currentDish.ingredientiSecondari = secondari
        }
        else {
            
            self.currentDish.ingredientiSecondari?.remove(at: currentIndex)
        }
    
    }
    
    
 
    
}
/*
struct VistaIngredientiEspansa_Previews: PreviewProvider {
    
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .defaultValue,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.disponibile)
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .biologico,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .animale,
        status: .bozza(.disponibile)
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .bozza(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza(.inPausa)
    )
    
    @State static var dishItem3: ProductModel = {
        
        var newDish = ProductModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample3.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample.id]
        let price:DishFormat = {
            var pr = DishFormat(type: .mandatory)
            pr.label = "Porzione"
            pr.price = "22.5"
            return pr
        }()
        let price1:DishFormat = {
            var pr = DishFormat(type: .opzionale)
            pr.label = "1/2 Porzione"
            pr.price = "10.5"
            return pr
        }()
        newDish.pricingPiatto = [price,price1]
        
        return newDish
    }()
    
    @State static var viewModel: AccounterVM = {
         let user = UserRoleModel()
        var vm = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))
         vm.db.allMyDish = [dishItem3]
         vm.db.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
         return vm
     }()
    static var previews: some View {
        NavigationStack {
          VistaIngredientiEspansa(currentDish: dishItem3, backgroundColorView: Color.seaTurtle_1)
        }.environmentObject(viewModel)
    }
}*/
