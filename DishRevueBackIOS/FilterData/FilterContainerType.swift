//
//  FilterContainerType.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 04/11/22.
//

import Foundation

// Creata e Deprecata 04.11
struct FilterContainerType<M:MyProStarterPack_L0,P:MyProEnumPack_L0> {
    
    let containerFiltered:[M]
    let kpPropertyDaConfrontare:KeyPath<M,P>?
    let kpCollectionDaConfrontare:KeyPath<M,[P]>?
    let kpCollectionFromMethod:KeyPath<M,()->[P]>?
    let kpPropertyFromMethod:KeyPath<M,()->P>?
    
    let initType:InitType.ExpandedPack
    
    init(containerFiltrato:[M],kpPropertyDaConfrontare:KeyPath<M,P>){
        self.containerFiltered = containerFiltrato
        self.kpPropertyDaConfrontare = kpPropertyDaConfrontare
        self.kpCollectionDaConfrontare = nil
        self.kpCollectionFromMethod = nil
        self.kpPropertyFromMethod = nil
        
        self.initType = .single
    }
    
    init(containerFiltrato:[M],kpCollectionDaConfrontare:KeyPath<M,[P]>){
        self.containerFiltered = containerFiltrato
        self.kpCollectionDaConfrontare = kpCollectionDaConfrontare
        self.kpPropertyDaConfrontare = nil
        self.kpCollectionFromMethod = nil
        self.kpPropertyFromMethod = nil
        
        self.initType = .collection
    }
    
    init(containerFiltrato:[M],kpCollectionFromMethod:KeyPath<M,()->[P]>){
        self.containerFiltered = containerFiltrato
        self.kpCollectionDaConfrontare = nil
        self.kpPropertyDaConfrontare = nil
        self.kpCollectionFromMethod = kpCollectionFromMethod
        self.kpPropertyFromMethod = nil
        
        self.initType = .collectionFromMethod
    }
    
    init(containerFiltrato:[M],kpPropertyFromMethod:KeyPath<M,()->P>){
        self.containerFiltered = containerFiltrato
        self.kpCollectionDaConfrontare = nil
        self.kpPropertyDaConfrontare = nil
        self.kpCollectionFromMethod = nil
        self.kpPropertyFromMethod = kpPropertyFromMethod
        
        self.initType = .singleFromMethod
    }
    
    
    func calcoloContoResiduo(value:P) -> Int {
        
        switch self.initType {
            
        case .single:
            return contoResiduoSingle(value: value)
        case .collection:
            return contoResiduoCollect(value: value)
        case .singleFromMethod:
            return contoResiduoSingleFromMethod(value: value)
        case .collectionFromMethod:
            return contoResiduoCollectionFromMethod(value: value)
    
        }
        
    }
    
    private func contoResiduoSingleFromMethod(value:P) -> Int {
        
        guard let kp = self.kpPropertyFromMethod else { return 0 }
    
        let container = self.containerFiltered.filter({$0[keyPath: kp]() == value})
        return container.count
        
    }
    
    private func contoResiduoSingle(value:P) -> Int {
        
        guard let kp = self.kpPropertyDaConfrontare else { return 0 }
    
        let container = self.containerFiltered.filter({$0[keyPath: kp] == value})
        return container.count
        
    }
    
    private func contoResiduoCollect(value:P) -> Int {
        
        guard let kp = self.kpCollectionDaConfrontare else { return 0 }
    
        let container = self.containerFiltered.filter({$0[keyPath: kp].contains(value)})
        return container.count
        
    }
    
    private func contoResiduoCollectionFromMethod(value:P) -> Int {
        
        guard let kp = self.kpCollectionFromMethod else { return 0 }
        
        let container = self.containerFiltered.filter({$0[keyPath: kp]().contains(value)})
        return container.count
    }
    
}
