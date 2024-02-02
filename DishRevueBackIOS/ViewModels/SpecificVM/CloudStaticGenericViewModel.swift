//
//  CloudStaticGenericViewModel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 31/12/23.
//

import Foundation
import MyFoodiePackage
import Combine

final class CloudStaticGenericViewModel<Item:MyProStarterPack_L0 & Decodable>:ObservableObject {

    @Published var cloudContainer:[Item]?

    var cancellables = Set<AnyCancellable>()
    let publisher = PassthroughSubject<[Item]?,Error>()
    
    public init() {

        addCloudContainerSubscriber()
        print("[INIT]_ArchivioBolleViewModel_cancellables:\(self.cancellables.count)")

    }
    
    deinit {
        
        print("[DEINIT]_ArchivioBolleViewModel_cancellables:\(self.cancellables.count)")
    }

    
    func addCloudContainerSubscriber() {
        
        self.publisher
            .sink { completion in
                //
            } receiveValue: { [weak self] items in
                
                guard let self else {
                    return
                }
                print("RECEIVE_ARCHIVIOBOLLE is EMPTY:\(items?.isEmpty ?? true)")
                DispatchQueue.main.async {
                    self.cloudContainer = items
                }
             
            }.store(in: &cancellables)

    }
    
}
