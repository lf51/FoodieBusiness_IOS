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

class CloudImportCategoriesViewModel:ObservableObject {
    
    @Published var cloudCategories:[CategoriaMenu]?
    var cancellables = Set<AnyCancellable>()
    
    public init() {
        
        addCloudCategoriesSubscriber()
    }
    
    deinit {
        
        print("[DEINIT]_CloudImportCategoriesViewModel")
    }
    
   private func addCloudCategoriesSubscriber() {
        
        GlobalDataManager
            .shared
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
}


struct CloudImportCategoriesView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    @StateObject var specificVM:CloudImportCategoriesViewModel = CloudImportCategoriesViewModel()
    let backgroundColor:Color

    var body: some View {
        
        CSZStackVB(
            title: "Import Categories",
            backgroundColorView: backgroundColor) {
            
                LazyVStack(alignment:.trailing) {
                    
                    // barra di ricerca
                    
                    HStack {
                      Spacer()
                        
                        Button("Cerca") {
                            
                            GlobalDataManager
                                .shared
                                .categoriesManager
                                .retrieveCategoriesFromSharedCollection(filterBy: nil)
                        }
                        
                        
                    }.padding(.trailing)

                        
                        ScrollView(showsIndicators:false) {
                            
                            VStack(alignment:.leading) {
                                
                                ForEach(specificVM.cloudCategories ?? []) { category in
                                    
                                    HStack {
                                        
                                        Text(category.image)
                                        Text(category.intestazione)
                                    }
                                    
                                }
                            }
                            
                        }
                    
                    
                    Spacer()
                    
                    
                }
                
        }
        
        
    }
}


#Preview {
    CloudImportCategoriesView(backgroundColor: .seaTurtle_1)
        .environmentObject(AccounterVM(userAuthUID: "USER_TEST_UID"))
}
