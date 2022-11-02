//
//  PuntoLampeggiante.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/10/22.
//

import SwiftUI

struct PuntoLampeggiante: View {

    let disableCondition:Bool
    var fontPunto: Font = .caption2
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var boldOn:Bool = true
    
    var body: some View {
             
        Image(systemName: "circle.fill")
            .font(fontPunto)
            .foregroundColor(!disableCondition ? Color.green : Color.gray)
            .opacity(boldOn ? 1.0 : 0.2)
            .onReceive(timer) { _ in
               
                if !disableCondition {
                    withAnimation {
                        boldOn.toggle()
                    }
                }
            }

    }
}

/*
struct PuntoLampeggiante: View {

    let disableCondition:Bool
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var valueAnimation:Double = 15.0

    
    var body: some View {
        
       ZStack {
            
            let color = disableCondition ? Color.red : Color.green
            
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: valueAnimation, height: valueAnimation)
                .foregroundColor(color)
               
            Image(systemName: "circle")
                .resizable()
                .frame(width: 15.0, height: 15.0)
                .foregroundColor(color)
            
                }
                 .onReceive(timer, perform: { _ in
                
                if !disableCondition {
                    withAnimation {
  
                        if valueAnimation == 15.0 { valueAnimation = 5.0 }
                        else { valueAnimation = 15.0 }
                    }
                }
            })
    }
} */ // 27.10 - Versione non usata - Era più un tentativo di pulser che di Punto Lampeggiante. Nuova versione è in effetti più simile a un punto che lampeggia
/*
struct PuntoLampeggiante_Previews: PreviewProvider {
    static var previews: some View {
        PuntoLampeggiante()
    }
} */
