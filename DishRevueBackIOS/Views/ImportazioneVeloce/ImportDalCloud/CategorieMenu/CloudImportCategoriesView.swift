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
        
    @State private var searchLetter:String = "A"
    let backgroundColor:Color

    var body: some View {
        
                VStack(alignment:.trailing) {
                    
                    // barra di ricerca
                    
                    HStack {
 
                        Text("selected:")
                            .italic()
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                        Text("\(importVM.selectedContainer?.count ?? 0)")
                            .bold()
                            .foregroundStyle(Color.seaTurtle_4)
                        
                        Spacer()
                        
                        Text("from:")
                            .italic()
                            .foregroundStyle(Color.black)
                            .opacity(0.8)
                        
                        Picker("", selection: $searchLetter) {
                            
                            ForEach(csLanguageAlphabet(),id:\.self) { letter in
                                
                                Text(letter)
                                
                            }
                            
                        }
                        .background {
                            Color.seaTurtle_4.opacity(0.1)
                                .clipShape(.buttonBorder)
                        }
                        
                        Button("Cerca") {
                            let string = searchLetter.lowercased()
                          //  GlobalDataManager
                            //    .shared
                            self.viewModel
                                .categoriesManager
                                .publishCategoriesFromSharedCollection(filterBy: string)
                        }
                        

                    }

                        ScrollView(showsIndicators:false) {
                            
                            VStack(alignment:.leading) {
                                
                                ForEach(importVM.cloudContainer ?? []) { category in
 
                                    ImportCategoryRow(
                                        importVM: importVM,
                                        category: category)/* { isSelected in
                                            
                                            withAnimation {
                                                self.selectingLogic(isAlreadySelect: isSelected, selected: category)
                                            }
                                            
                                        }*/

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
                
                           // try await self.importVM.publishSubCollection()
                               // self.importVM.updateCategoriesListIndex()
                                self.updateCategoriesListIndex()
                                
                               /* try await self.importVM.importInSubCollection(selectedPath: \.selectedCategory, subCollection: .allMyCategories)*/
                                try await self.importVM.importInSubCollection(subCollection: .allMyCategories, viewModel: self.viewModel)
                                    
                            }
                            
                        } label: {
                            Text("Importa")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.blue)
                        .disabled(self.importVM.selectedContainer == nil || self.importVM.selectedContainer?.isEmpty ?? true)
                     
                    }

                    
                    
                }
                .csHpadding()
                .onAppear {
                    print("[ON_APPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                    self.importVM.addCloudContainerSubscriber(to: self.viewModel.categoriesManager.sharedCategoriesPublisher)
                   /* self.importVM.addCloudCategoriesSubscriber(viewModel: self.viewModel)*/
                   
                }
                .onDisappear {
                    print("[ON_DISAPPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                   // self.importVM.cancellables.removeAll()
                }
    }
    
    // method
    
    func updateCategoriesListIndex() {

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
