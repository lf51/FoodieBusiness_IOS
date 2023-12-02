//
//  CloudImportIngredientsView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/10/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import Combine
import MyFilterPackage

struct CloudImportIngredientsView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    private(set) var ingredientsManager:IngredientManager = IngredientManager()
    @StateObject private var importVM:CloudImportGenericViewModel = CloudImportGenericViewModel<IngredientModel>()

    @State private var filterCore:CoreFilter<IngredientModel> = CoreFilter()
    @State private var openFilter:Bool = false
    let backgroundColor:Color
    
    var body: some View {
        
        CSZStackVB(title: "Libreria Ingredienti", backgroundColorView: backgroundColor) {
            
            VStack(alignment:.trailing) {
                
                let queryCount = self.importVM.queryCount ?? 0
                let resultCount = self.importVM.cloudContainer?.count ?? 0
                
                VStack(alignment:.trailing) {

                    HStack {

                        Text("selected:")
                            .italic()
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                        Text("\(self.importVM.selectedContainer?.count ?? 0)")
                            .bold()
                            .foregroundStyle(Color.seaTurtle_4)
                        
                        Spacer()
                        
                        CSButton_image(
                            frontImage: "slider.horizontal.3",
                            imageScale: .large,
                            frontColor: .seaTurtle_3) {
                            self.openFilter.toggle()
                        }
                        .padding(0)
                        .overlay(alignment: .topTrailing) {
                            
                            let filterCount = self.filterCore.countChange
                            
                            if filterCount != 0 {
                                
                                Text("\(filterCount)")
                                    .fontWeight(.bold)
                                    .font(.caption)
                                    .foregroundStyle(Color.white)
                                    .padding(4)
                                    .background {
                                        Color.seaTurtle_1
                                    }
                                    .clipShape(Circle())
                                    .offset(x: 2, y: -3)
                            }
                                
                        }

                        
                        Text("from:")
                            .italic()
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                        
                        Picker("", selection: $filterCore.stringaRicerca) {
                            
                            ForEach(csLanguageAlphabet(addValue: [""]),id:\.self) { letter in
                                
                                let value = letter == "" ? "n/d" : letter
                                
                                Text(value)
                                    
                            }
                            
                        }
                        .background {
                            Color.seaTurtle_4.opacity(0.1)
                                .clipShape(.buttonBorder)
                        }
                        
                        if openFilter {
                            
                            ProgressView()
                                .csHpadding()
     
                        } else {
                            Button("Cerca") {
                              // let string = searchLetter.lowercased()
                            
                                self.cercaNellaLibrary()
                                
                            }.disabled(filterCore.stringaRicerca == "")
                        }
                    }
                    
                    HStack {

                        Text("in libreria:")
                            .font(.caption)
                            .italic()
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                        
                        Text("\(self.importVM.libraryCount ?? 0)")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(Color.seaTurtle_4)
                        
                        Spacer()
                        
                        Text("risultati mostrati:")
                            .font(.caption)
                            .italic()
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                        
                        Text("\(resultCount)/\(queryCount)")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(Color.seaTurtle_4)
                    }
                }

                    ScrollView(showsIndicators:false) {
                        
                        VStack(alignment:.leading) {
                            
                            let disableCondition = resultCount == queryCount
                            
                            ForEach(self.importVM.cloudContainer ?? []) { item in
                                
                                VStack {
                                    
                                    ImportIngredientRow(importVM: self.importVM, ingredient: item)
                                    
                                    let last = self.importVM.cloudContainer?.last
                                    
                                    if item == last {
                                        Button {
                                            self.mostraAltri()
                                        } label: {
                                            Text("[+] Carica Altri")
                                                .foregroundStyle(Color.seaTurtle_2)
                                        }
                                        .opacity(disableCondition ? 0.6 : 1.0)
                                        .disabled(disableCondition)

                                    }
                                    
                                }

                            }
                        }
                        
                    }
                    
                Spacer()
                
                HStack(spacing:20) {
                    
                    Button("Reset",role: .destructive) {
                        self.importVM.selectedContainer = nil
                    }
                    .disabled(self.importVM.selectedContainer == nil)
               
                    Button {

                        Task {

                            try await self.importVM.importInSubCollection(subCollection:.allMyIngredients,viewModel:self.viewModel)
                                
                        }
                        
                    } label: {
                        Text("Importa")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.blue)
                    .disabled(self.importVM.selectedContainer == nil || self.importVM.selectedContainer?.isEmpty ?? true)
                 
                }

                CSDivider()
                
            }
            .csHpadding()
            .csOverlayMessage(self.$importVM.queryMessage)
         
          /*  if let message = self.importVM.queryMessage {
                
              Text(message)
                    .background {
                        Color.gray
                    }
                    .csHpadding()
                    .onTapGesture {
                        self.importVM.queryMessage = nil
                    }
                
                
            }*/
        }
        .popover(
            isPresented: $openFilter,
            attachmentAnchor: .point(.leading)) {
                
                let label = self.filterCore.tipologiaFiltro.simpleDescription()
                
                FilterAndSort_PopView(
                    backgroundColorView: backgroundColor,
                    label: label,
                    resetAction: {
                        self.resetAction()
                    },
                    content: {
                            vbFilterView()
                    })
                    .presentationDetents([.height(600)])
        }
  
            .onAppear {
                print("[ON_APPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                
                Task {
                    
                  /* let count = try await self.viewModel.ingredientsManager.libraryCount()*/
                    let count = try await self.ingredientsManager.libraryCount()
                    
                    self.importVM.libraryCount = count
                    
                   /* self.importVM.addCloudContainerSubscriber(to: self.viewModel.ingredientsManager.ingredientLibraryPublisher)*/
                    self.importVM.addCloudContainerSubscriber(to: self.ingredientsManager.ingredientLibraryPublisher)
                    
                   // self.importVM.addFilterCoreSubscriber(to: filterCore)
                    
                }
             //   self.filterCore.stringaRicerca = "A"
               /* self.importVM.addCloudCategoriesSubscriber(viewModel: self.viewModel)*/
               
            }
            .onDisappear {
                print("[ON_DISAPPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
               // self.viewModel.ingredientsManager.lastQuery = nil
                self.ingredientsManager.lastQuery = nil
               // self.importVM.cancellables.removeAll()
            }
    }
    
    // method
    
    private func cercaNellaLibrary() {
        
        self.importVM.lastSnap = nil
        
       /* self.viewModel
             .ingredientsManager
             .fetchFromSharedCollection(useCoreFilter: filterCore, startAfter: nil)*/
        self.ingredientsManager
             .fetchFromSharedCollection(useCoreFilter: filterCore, startAfter: nil)
    }
    
    private func mostraAltri() {
        
       /* self.viewModel
            .ingredientsManager
            .executiveFetchFromSharedCollection(startAfter: self.importVM.lastSnap, queryCount: nil)*/
        self.ingredientsManager
            .executiveFetchFromSharedCollection(startAfter: self.importVM.lastSnap, queryCount: nil)
    }
    
    private func resetAction() {
        
        guard self.filterCore.countChange != 0 else { return }
        
        self.filterCore = CoreFilter()
        
    }
    
    @ViewBuilder private func vbFilterView() -> some View {
        // la query può avere solo un array. Abbiamo tolto la conservazione ma va implementato meglio
        MyFilterRow(
            allCases: ProvenienzaIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.provenienzaING,
            selectionColor: Color.gray,
            imageOrEmoji: "globe.americas",
            label: "Provenienza") { _ in
                return 0
            }
        
        MyFilterRow(
            allCases: ProduzioneIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.produzioneING,
            selectionColor: Color.green,
            imageOrEmoji: "sun.min.fill",
            label: "Metodo di Produzione") { _ in
                return 0
            }
        
       /* MyFilterRow(
            allCases: ConservazioneIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.conservazioneING,
            selectionColor: Color.cyan,
            imageOrEmoji: "thermometer.snowflake",
            label: "Metodo di Conservazione") { _ in
                return 0
            }*/
        
        MyFilterRow(
            allCases: OrigineIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.origineING,
            selectionColor: Color.brown,
            imageOrEmoji: "leaf",
            label: "Origine") { _ in
                return 0
            }
        
        MyFilterRow(
            allCases: AllergeniIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.allergeniIn,
            selectionColor: Color.red.opacity(0.7),
            imageOrEmoji: "allergens",
            label: "Allergeni Contenuti") { _ in
                return 0
            }
        
    }

    
}


