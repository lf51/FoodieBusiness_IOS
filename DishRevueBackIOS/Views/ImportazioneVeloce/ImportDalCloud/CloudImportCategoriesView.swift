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

/// per gesire gli import di categorie e ingredienti dal web, dando persistenza in caso di switch del pickerView
final class CloudImportViewModel:ObservableObject {
    
    let viewModel:AccounterVM
    
    @Published var cloudCategories:[CategoriaMenu]?
    @Published var selectedCategory:[CategoriaMenu]?
    var cancellables = Set<AnyCancellable>()

    public init(viewModel:AccounterVM) {
        
        self.viewModel = viewModel
        print("[INIT]_CloudImportCategoriesViewModel_cancellables:\(self.cancellables.count)")
        addCloudCategoriesSubscriber()
    }
    
    deinit {
        
        print("[DEINIT]_CloudImportCategoriesViewModel_cancellables:\(self.cancellables.count)")
    }
    
    func addCloudCategoriesSubscriber() {
        
     //  GlobalDataManager
       //     .shared
        self.viewModel
            .cloudDataManager
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
    
    func publishSubCollection(propertyID:String) async throws {
        
        guard let selectedCategory else { return }
        
        try await self.viewModel
                      .cloudDataManager
                      .publishSubCollection(
                        forPropID: propertyID,
                        sub: .allMyCategories,
                        as: selectedCategory)
        
    }
    
}


struct CloudImportCategoriesView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @ObservedObject var importVM:CloudImportViewModel
        
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
                        Text("\(importVM.selectedCategory?.count ?? 0)")
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
                                .cloudDataManager
                                .categoriesManager
                                .publishCategoriesFromSharedCollection(filterBy: string)
                        }
                        

                    }

                        ScrollView(showsIndicators:false) {
                            
                            VStack(alignment:.leading) {
                                
                                ForEach(importVM.cloudCategories ?? []) { category in
 
                                    ImportCategoryRow(
                                        importVM: importVM,
                                        category: category) { isSelected in
                                            
                                            withAnimation {
                                                self.selectingLogic(isAlreadySelect: isSelected, selected: category)
                                            }
                                            
                                        }

                                }
                            }
                            
                        }
                        
                    Spacer()
                    
                    HStack(spacing:20) {
                        
                        Button("Reset",role: .destructive) {
                            self.importVM.selectedCategory = nil
                        }
                        .disabled(self.importVM.selectedCategory == nil)
                   
                        Button {
                            
                            Task {
                                if let propertyID = self.viewModel.currentProperty.info?.id {
                                    
                                   try await self.importVM.publishSubCollection(propertyID: propertyID)
                                    
                                } else {
                                    
                                    self.viewModel.alertItem = AlertModel(title: "Errore", message: "Ref alla proprietà corrotto. Riprovare")
                                }
                            }
                            
                           
                        } label: {
                            Text("Importa")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.blue)
                        .disabled(self.importVM.selectedCategory == nil || self.importVM.selectedCategory?.isEmpty ?? true)
                     
                    }

                    
                    
                }
                .csHpadding()
                .onAppear {
                    print("[ON_APPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                    
                   /* self.importVM.addCloudCategoriesSubscriber(viewModel: self.viewModel)*/
                   
                }
                .onDisappear {
                    print("[ON_DISAPPEAR]_cloudImportCategoriesView_publisher:\(self.importVM.cancellables.count)")
                   // self.importVM.cancellables.removeAll()
                }
    }
    
    // method
    
    private func selectingLogic(isAlreadySelect:Bool,selected categoria:CategoriaMenu) {
        
        if isAlreadySelect { self.deSelectCategory(selected: categoria) }
        else { self.selectCategory(selected: categoria) }
        
    }
    
    private func deSelectCategory(selected categoria:CategoriaMenu) {

        self.importVM.selectedCategory?.removeAll{ $0 == categoria }

    }
    
    private func selectCategory(selected categoria:CategoriaMenu) {
        
        if self.importVM.selectedCategory == nil {
            
            self.importVM.selectedCategory = [categoria]
            
        } else {
            
            self.importVM.selectedCategory!.append(categoria)
        }
    }
    
}


#Preview {
    CloudImportCategoriesView(importVM: CloudImportViewModel(viewModel: AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))), backgroundColor: .seaTurtle_1)
        .environmentObject(AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID")))
}
