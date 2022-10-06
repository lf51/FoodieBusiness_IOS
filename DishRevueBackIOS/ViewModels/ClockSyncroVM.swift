//
//  ClockSyncroVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/10/22.
//

import Foundation

class ClockSyncroVM: ObservableObject {
    
    static var globalInstance:ClockSyncroVM = ClockSyncroVM()
    
    let timer = Timer.publish(every: 60.0, on: .main, in:.common ).autoconnect()
   /* let t = Timer.scheduledTimer(timeInterval: 60, invocation: <#NSInvocation#>,repeats: false) */

    
}
