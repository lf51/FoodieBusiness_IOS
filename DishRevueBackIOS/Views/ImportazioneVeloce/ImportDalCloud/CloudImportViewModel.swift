//
//  CloudImportViewModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/10/23.
//

import Foundation
import Combine
import SwiftUI
import MyFoodiePackage

/// per gesire gli import di categorie e ingredienti dal web, dando persistenza in caso di switch del pickerView
/*final class CloudImportViewModel:ObservableObject { // deprecato in futuro
    
    let viewModel:AccounterVM
    
    @Published var cloudIngredients:[IngredientModel]?
    @Published var selectedIngredient:[IngredientModel]?
    
    @Published var cloudCategories:[CategoriaMenu]?
    @Published var selectedCategory:[CategoriaMenu]?
    var cancellables = Set<AnyCancellable>()

    public init(viewModel:AccounterVM) {
        
        self.viewModel = viewModel
        print("[INIT]_CloudImportCategoriesViewModel_cancellables:\(self.cancellables.count)")
        addCloudCategoriesSubscriber()
        addCloudIngredientsSubscriber()
    }
    
    deinit {
        
        print("[DEINIT]_CloudImportCategoriesViewModel_cancellables:\(self.cancellables.count)")
    }
    
    func addCloudIngredientsSubscriber() {
        
        self.viewModel
            .ingredientsManager
            .ingredientLibraryPublisher
            .sink { completion in
                //
            } receiveValue: { [weak self] ingredients in
                
                guard let self,
                      let ingredients,
                      !ingredients.isEmpty else {
                    return
                }
                print("[SINK]_addCloudIngredientsSubscriber_thread:\(Thread.current)")
                self.cloudIngredients = ingredients
                
            }.store(in: &cancellables)

    }
    
    func addCloudCategoriesSubscriber() {
        
     //  GlobalDataManager
       //     .shared
        self.viewModel
            .categoriesManager
            .sharedCategoriesPublisher
            .sink { error in
                //
            } receiveValue: { [weak self] categories in
                
                guard let self,
                      let categories,
                      !categories.isEmpty else {
                    return
                }
                // sincro
                print("[SINK]_addCloudCategoriesSubscriber_thread:\(Thread.current)")
                
                self.cloudCategories = categories
                
            }.store(in: &cancellables)

    }
    
    func importInSubCollection<Item:MyProStarterPack_L0 & Codable>(selectedPath:ReferenceWritableKeyPath<CloudImportViewModel,[Item]?>,subCollection:CloudDataStore.SubCollectionKey) async throws {
        // chiamata da una task means che siamo su un backThread
        let selectedContainer = self[keyPath: selectedPath]
    
        guard let selectedContainer else { return}
        
       // let rigeneratedCategories = updateListIndex(items: selectedCategory)

        try await self.viewModel
                      .subCollectionManager
                      .publishSubCollection(
                        sub: subCollection,
                        as: selectedContainer)
                      // su un backThread
        
        
        DispatchQueue.main.async {
            self[keyPath: selectedPath] = nil
        }// torniamo sul main
        
        
    }
    
     func updateCategoriesListIndex() {

        guard let selectedCategory else { return }
         
        let remoteCacheCount = self.viewModel.db.allMyCategories.count
        var rigeneratedCategories:[CategoriaMenu] = []
        
         for (index,item) in selectedCategory.enumerated() {
            
            var rigenerata = item
            rigenerata.listIndex = remoteCacheCount + index
            rigeneratedCategories.append(rigenerata)
            
        }

         self.selectedCategory = rigeneratedCategories

    }
    
    
    
    func publishSubCollection() async throws {
        // chiamata da una task means che siamo su un backThread
        guard let selectedCategory else { return}
        
        let rigeneratedCategories = updateListIndex(items: selectedCategory)

        try await self.viewModel
                      .subCollectionManager
                      .publishSubCollection(
                        sub: .allMyCategories,
                        as: rigeneratedCategories)
                      // su un backThread
        
        
        DispatchQueue.main.async {
            self.selectedCategory = nil
        }// torniamo sul main
        
        
    } // deprecata
    
    private func updateListIndex(items:[CategoriaMenu]) -> [CategoriaMenu] {

        let remoteCacheCount = self.viewModel.db.allMyCategories.count
        var rigeneratedCategories:[CategoriaMenu] = []
        
        for (index,item) in items.enumerated() {
            
            var rigenerata = item
            rigenerata.listIndex = remoteCacheCount + index
            rigeneratedCategories.append(rigenerata)
            
        }

        return rigeneratedCategories

    } // deprecata
    
}*/

import Firebase
import MyFilterPackage

final class CloudImportGenericViewModel<Item:MyProStarterPack_L0 & Codable>:ObservableObject {

    @Published var cloudContainer:[Item]?
    @Published var selectedContainer:[Item]?

    var cancellables = Set<AnyCancellable>()
    
    @Published var libraryCount:Int?
    @Published var lastSnap:QueryDocumentSnapshot?
    @Published var queryMessage:String?
    @Published var queryCount:Int?
    
    public init() {

        print("[INIT]_CloudImportGenericViewModel_cancellables:\(self.cancellables.count)")

    }
    
    deinit {
        
        print("[DEINIT]_CloudImportGenericViewModel_cancellables:\(self.cancellables.count)")
    }

    
    func addCloudContainerSubscriber(to publisher:PassthroughSubject<([Item]?,QueryDocumentSnapshot?,Int?),Error>) {
        
        publisher
            .sink { completion in
                //
            } receiveValue: { [weak self] items,queryDoc,queryCount in
                
                guard let self,
                      let items,
                      !items.isEmpty else {
                    
                    DispatchQueue.main.async {
                        
                        self?.queryMessage = "La ricerca non ha prodotto nuovi risultati. Cambiare parametri e riprovare."
                    }
                    
                    return
                }
                print("[SINK]_addCloudIngredientsSubscriber_thread:\(Thread.current)")
                if lastSnap != nil {
                    withAnimation {
                        self.cloudContainer?.append(contentsOf: items)
                    }
                } else {
                    self.cloudContainer = items
                    self.queryCount = queryCount
                }
                self.lastSnap = queryDoc
                
            }.store(in: &cancellables)

    }
        
    func importInSubCollection(subCollection:CloudDataStore.SubCollectionKey,viewModel:AccounterVM) async throws {
        // chiamata da una task means che siamo su un backThread

        guard let selectedContainer else { return}
        
       // let rigeneratedCategories = updateListIndex(items: selectedCategory)

        try await viewModel
                      .subCollectionManager
                      .publishSubCollection(
                        sub: subCollection,
                        as: selectedContainer)
                      // su un backThread
        
        
        DispatchQueue.main.async {
            self.selectedContainer = nil
        }// torniamo sul main
        
        
    }
    
    func selectingLogic(isAlreadySelect:Bool,selected item:Item) {
        
        if isAlreadySelect { self.deSelectAction(selected: item) }
        else { self.selectAction(selected: item) }
        
    }
    
    private func deSelectAction(selected item:Item) {

        guard var selectedContainer = self.selectedContainer else { return }
        
        selectedContainer.removeAll{ $0 == item }
        
        if selectedContainer.isEmpty { self.selectedContainer = nil }
        else { self.selectedContainer = selectedContainer }

    }
    
    private func selectAction(selected item:Item) {
        
        if self.selectedContainer == nil {
            
            self.selectedContainer = [item]
            
        } else {
            
            self.selectedContainer!.append(item)
        }
    }

    
}
