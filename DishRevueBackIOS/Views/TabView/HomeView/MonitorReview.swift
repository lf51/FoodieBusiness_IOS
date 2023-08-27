//
//  MonitorReview.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 19/10/22.
//

import SwiftUI
import MyPackView_L0

struct MonitorReview: View {
    
    @EnvironmentObject var viewModel:AccounterVM

    var body: some View {
        
        ReviewStatMonitor() {
            Group {
                Text("Recensioni")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundStyle(Color.seaTurtle_2)
                
                CSInfoAlertView(title: "Legenda", message: .monitorRecensioni)
                   Spacer()
            }
        } extraContent: { vbExtraStat() }
        
    }
    
    // Method
    
    @ViewBuilder private func vbExtraStat() -> some View {
        
        let(prepConRev,totPrep,negCount,posCount,topCount) = self.viewModel.monitorRecensioniMoreInfo()
        
        VStack(alignment:.leading) {
            
            Divider()
            
            let doubleTotPrep = Double(totPrep)
            
            let prepPercentValue = Double(prepConRev)/doubleTotPrep
            let stringPrepPercent = String(format:"%.1f%%",(prepPercentValue * 100))
            
            let negPercentValue = Double(negCount)/doubleTotPrep
            let stringNegPercent = String(format:"%.1f%%",(negPercentValue * 100))
            let posPercentValue = Double(posCount)/doubleTotPrep
            let stringPosPercent = String(format:"%.1f%%",(posPercentValue * 100))
            let topPercentValue = Double(topCount)/doubleTotPrep
            let stringTopPercent = String(format:"%.1f%%",(topPercentValue * 100))
            
                VStack {
                    Text("Preparazioni Recensite")
                    
                    HStack {
                        Text("\(prepConRev) su \(totPrep) (\(stringPrepPercent))")
                            .fontWeight(.bold)
                        
                        NavigationLink(value: DestinationPathView.vistaRecensioniEspansa) {
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundStyle(Color.seaTurtle_3)
                        }
                        
                    }
                    
                }
                .padding(.vertical,1)

                HStack {

                    VStack {
                        Text("Sotto(<6)")
                        
                        Text("\(negCount) (\(stringNegPercent))")
                            .fontWeight(.bold)
                        
                    }
                    
                    Spacer()
                    VStack {
                        Text("Sopra(>=6)")
                        
                        Text("\(posCount) (\(stringPosPercent))")
                            .fontWeight(.bold)
                        
                    }
                    Spacer()
                    VStack {
                        Text("Top(>=9)")
                        
                        Text("\(topCount) (\(stringTopPercent))")
                            .fontWeight(.bold)
                        
                    }
                    
                }
 
        }
        .foregroundStyle(Color.black)

        
        
    }
    
}

struct MonitorReview_Previews: PreviewProvider {
    static var previews: some View {
        CSZStackVB(title: "Monitor", backgroundColorView: Color.seaTurtle_1) {
            MonitorReview()
        }.environmentObject(testAccount)
    }
}
