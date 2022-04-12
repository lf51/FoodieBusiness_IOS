//
//  DataModelAlphabeticView_Sub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/04/22.
//

import SwiftUI

struct DataModelAlphabeticView_Sub<T:MyModelProtocol>: View {
    
    let dataContainer: [T]
    var statusFilter: ModelStatus
    
    init (dataContainer:[T], statusFilter:ModelStatus) {
        
        self.dataContainer = dataContainer.sorted{$0.intestazione < $1.intestazione }
        self.statusFilter = statusFilter
        
    }
    
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                
                    ForEach(dataContainer) { item in
                        
                        switchModelDataRowView(item: item, statusFilter: statusFilter)
                 
                    }
            }
    }
}

struct DataModelAlphabeticView_Sub_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            DataModelAlphabeticView_Sub(dataContainer: [MenuModel()], statusFilter: .all)
        }
    }
}

