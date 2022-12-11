//
//  GenericModelList.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct VistaIngredientiEspansa: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDish: DishModel
    let backgroundColorView: Color
    let allING:[String]
    @State private var container:[String]

    init(currentDish: DishModel, backgroundColorView: Color) {
        
        self.currentDish = currentDish
        self.backgroundColorView = backgroundColorView
        
        let all = currentDish.ingredientiPrincipali + currentDish.ingredientiSecondari
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
                        .foregroundColor(Color.blue)
                        .padding(5)
                        .background {
                            Color("SeaTurtlePalette_3").cornerRadius(5.0)
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
    
                            if let model = self.viewModel.modelFromId(id: rif, modelPath: \.allMyIngredients) {
                                
                                let isDisponibile = model.status.checkStatusTransition(check: .disponibile)
 
                                    TabView {
                                        IngredientModel_RowView(item: model)
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
            .padding(.horizontal)
            .animation(.default, value: container)
            
            
        }
    }
    
    // Method
    
    @ViewBuilder private func vbSostituto(rif:String) -> some View {
        
        if let sostituto = currentDish.elencoIngredientiOff[rif] {
           
            if let modelSostituto = self.viewModel.modelFromId(id: sostituto, modelPath: \.allMyIngredients) {
                
                let isActive = modelSostituto.status.checkStatusTransition(check: .disponibile)
                
                IngredientModel_RowView(item: modelSostituto)
                    .opacity(isActive ? 1.0 : 0.6)
                    .overlay(alignment: .leading) {
                        VStack {
                            Image(systemName: "arrowshape.forward")
                                .imageScale(.large)
                                .fontWeight(.black)
                                .foregroundColor(Color.red)
                            
                            Image(systemName: "arrowshape.backward.fill")
                                .imageScale(.large)
                                .fontWeight(.black)
                                .foregroundColor(Color.green)
                            
                        }
                        .offset(x: -30)
                    }
                
            }
            
            
            
        } else { EmptyView() }
        
    }
}

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
    
    @State static var dishItem3: DishModel = {
        
        var newDish = DishModel()
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
         
        var vm = AccounterVM()
         vm.allMyDish = [dishItem3]
         vm.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
         return vm
     }()
    static var previews: some View {
        NavigationStack {
          VistaIngredientiEspansa(currentDish: dishItem3, backgroundColorView: Color("SeaTurtlePalette_1"))
        }.environmentObject(viewModel)
    }
}
