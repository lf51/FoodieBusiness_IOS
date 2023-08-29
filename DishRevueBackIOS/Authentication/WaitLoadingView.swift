//
//  WaitLoadingView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/11/22.
//

import SwiftUI
/*
public enum LoadingVisualEffect {
    
    case zeroOpacity
    case maxOpacity
    case fixed(_:CGFloat)
    
   public func opacityValue() -> CGFloat {
        
        switch self {
        case .zeroOpacity:
            return 0.0
        case .maxOpacity:
            return 1.0
        case .fixed(let value):
            return value
        }
        
    }
    
}*/

struct WaitLoadingView<Info:View>: View {
    
    let backgroundColorView:Color
   // var loadingEffect:LoadingVisualEffect
    @ViewBuilder var loadingInfo:() -> Info
    
    init(
        backgroundColorView: Color,
        loadingInfo: @escaping () -> Info = { EmptyView() }) {
        self.backgroundColorView = backgroundColorView
       // self.loadingEffect = loadingEffect
        self.loadingInfo = loadingInfo
           
    }
    
    @State private var rotation:Double = 0.0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
    
        ZStack(alignment:.center) {
            
            Rectangle()
                .fill(backgroundColorView.gradient)
               // .opacity(loadingEffect.opacityValue())
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
           
            VStack(alignment:.leading,spacing:25) {
                
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.seaTurtle_2)
                    .frame(maxWidth:500)
                    .rotationEffect(.degrees(rotation))
                    
                loadingInfo()
                    
            }
            .padding(.horizontal)
            .zIndex(1)
            
        }
        .onReceive(timer, perform: { _ in
            self.rotation += 5.0
        })
       // .background(backgroundColorView.opacity(0.6))
    }
    
   
}

struct WaitLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitLoadingView(backgroundColorView: .seaTurtle_1)
    }
}
