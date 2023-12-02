//
//  CloudImportCategoriesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 08/09/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0
import Combine

struct CloudImportCategoriesView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @StateObject private var importVM:CloudImportGenericViewModel = CloudImportGenericViewModel<CategoriaMenu>()
        
    private(set) var categoriesManager:CategoriesManager = CategoriesManager()
    @State private var searchLetter:String = ""
    @State private var productType:ProductType = .noValue
    let backgroundColor:Color

    var body: some View {
        
        CSZStackVB(title: "Libreria Categorie", backgroundColorView: backgroundColor) {
            
        VStack(alignment:.trailing) {
            
            let queryCount = self.importVM.queryCount ?? 0
            let resultCount = self.importVM.cloudContainer?.count ?? 0
            
            VStack(alignment:.trailing) {
                
                HStack {
                    
                  /*  Text("selected:")
                        .italic()
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                    Text("\(importVM.selectedContainer?.count ?? 0)")
                        .bold()
                        .foregroundStyle(Color.seaTurtle_4)*/
                    
                   // Spacer()
                    Text("Type:")
                        .italic()
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                    
                    Picker("", selection: $productType) {
                        
                        ForEach(ProductType.allCases,id:\.self) { type in
                            
                            let value = type == .noValue ? "n/d" : type.rawValue
                            
                            Text(value)
                            
                        }
                        
                    }
                    .background {
                        Color.seaTurtle_4.opacity(0.1)
                            .clipShape(.buttonBorder)
                    }
                    
                    Spacer()
                    
                    Text("from:")
                        .italic()
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                    
                    Picker("", selection: $searchLetter) {
                        
                        ForEach(csLanguageAlphabet(addValue: [""]),id:\.self) { letter in
                            
                            let value = letter == "" ? "n/d" : letter
                            
                            Text(value)
                            
                        }
                        
                    }
                    .background {
                        Color.seaTurtle_4.opacity(0.1)
                            .clipShape(.buttonBorder)
                    }
                    
                    let disabilitaRicerca:Bool = { 
                        searchLetter == "" ||
                        productType == .noValue
                    }()
                    
                    Button("Cerca") {

                        self.cercaNellaLibrary()
                        
                    }.disabled(disabilitaRicerca)
                    
                    
                }
                
                HStack {

                    Text("selected:")
                        .font(.subheadline)
                        .italic()
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                    Text("\(importVM.selectedContainer?.count ?? 0)")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(Color.seaTurtle_4)
                    
                    Spacer()
                    
                    Text("in libreria:")
                        .font(.caption)
                        .italic()
                        .foregroundStyle(Color.black)
                        .opacity(0.8)
                    
                    Text("\(self.importVM.libraryCount ?? 0)")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(Color.seaTurtle_4)
                    

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
                    
                    ForEach(importVM.cloudContainer ?? []) { category in
                        
                        VStack {
                            
                            ImportCategoryRow(
                                importVM: importVM,
                                category: category)
                            
                            let last = self.importVM.cloudContainer?.last
                            
                            if category == last {
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

                        self.updateCategoriesListIndex()

                        try await self.importVM.importInSubCollection(subCollection: .allMyCategories, viewModel: self.viewModel)
                        
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

                }
                .onAppear {
                    print("[ON_APPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                    
                    Task {
                      /*  let count = try await self.viewModel.categoriesManager.libraryCount()*/
                        let count = try await self.categoriesManager.libraryCount()
                        
                        self.importVM.libraryCount = count
                        
                       /* self.importVM.addCloudContainerSubscriber(to: self.viewModel.categoriesManager.sharedCategoriesPublisher)*/
                        self.importVM.addCloudContainerSubscriber(to: self.categoriesManager.sharedCategoriesPublisher)
                    }
                   /* self.importVM.addCloudCategoriesSubscriber(viewModel: self.viewModel)*/
                   
                }
                .onDisappear {
                    print("[ON_DISAPPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                    
                   // self.viewModel.categoriesManager.lastQuery = nil
                    self.categoriesManager.lastQuery = nil
                   // self.importVM.cancellables.removeAll()
                }
    }
    
    // method
    
   private func cercaNellaLibrary() {
        
        self.importVM.lastSnap = nil
        
       /* self.viewModel
            .categoriesManager
            .fetchFromSharedCollection(
                filterBy: self.searchLetter,productType,
                startAfter: nil) */
       self.categoriesManager
           .fetchFromSharedCollection(
               filterBy: self.searchLetter,productType,
               startAfter: nil)
    }
    
    private func mostraAltri() {
        
       /* self.viewModel
            .categoriesManager
            .executiveFetchFromSharedCollection(startAfter: self.importVM.lastSnap, queryCount: nil)*/
        self.categoriesManager
            .executiveFetchFromSharedCollection(startAfter: self.importVM.lastSnap, queryCount: nil)
    }
    
   private func updateCategoriesListIndex() {

        guard let selectedCategory = self.importVM.selectedContainer else { return }
         
        let remoteCacheCount = self.viewModel.db.allMyCategories.count
       
        var rigeneratedCategories:[CategoriaMenu] = []
        
         for (index,item) in selectedCategory.enumerated() {
            
            var rigenerata = item
            rigenerata.listIndex = remoteCacheCount + index
            rigeneratedCategories.append(rigenerata)
            
        }

        self.importVM.selectedContainer = rigeneratedCategories

    }
    
    
   /* private func selectingLogic(isAlreadySelect:Bool,selected categoria:CategoriaMenu) {
        
        if isAlreadySelect { self.deSelectCategory(selected: categoria) }
        else { self.selectCategory(selected: categoria) }
        
    }
    
    private func deSelectCategory(selected categoria:CategoriaMenu) {

        guard var selectedCategory = self.importVM.selectedCategory else { return }
        
        selectedCategory.removeAll{ $0 == categoria }
        
        if selectedCategory.isEmpty { self.importVM.selectedCategory = nil }
        else { self.importVM.selectedCategory = selectedCategory }

    }
    
    private func selectCategory(selected categoria:CategoriaMenu) {
        
        if self.importVM.selectedCategory == nil {
            
            self.importVM.selectedCategory = [categoria]
            
        } else {
            
            self.importVM.selectedCategory!.append(categoria)
        }
    }*/
    
}

/*
#Preview {
    CloudImportCategoriesView(importVM: CloudImportViewModel(viewModel: AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))), backgroundColor: .seaTurtle_1)
        .environmentObject(AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID")))
}*/
